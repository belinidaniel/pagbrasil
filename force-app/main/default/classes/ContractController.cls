/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-03-03
 * @last modified by  : Guilherme Schuquel Borges
**/
public class ContractController {

    public Quote quote { get; set; }

    public List<QuoteLineItem> items { get; set; }

    public List<Contact> contacts { get; set; }

    public Id oppId { get; set; }

    public Opportunity opportunity { get; set; }

    public Boolean isGateway { get; set; }
    public Boolean isFluxoMedio { get; set; }
    public Boolean isPayout { get; set; }

    public Boolean containsPagBrasilDefinition { get; set; }
    public Boolean containsPix { get; set; }
    public Boolean containsBoleto { get; set; }
    public Boolean containsCartao { get; set; }
    public Boolean containsDebito { get; set; }

    public Boolean lowRange { get; set; }
    public String firstRange { get; set; }
    public String secondRange { get; set; }
    public String thirdRange { get; set; }
    public String fourthRange { get; set; }

    public String pixOne { get; set; }
    public String pixTwo { get; set; }
    public String pixThree { get; set; }
    public String pixFour { get; set; }
    public String pixGateway { get; set; }

    public String creditCardOne { get; set; }
    public String creditCardTwo { get; set; }
    public String creditCardThree { get; set; }
    public String creditCardFour { get; set; }
    public String creditCardGateway { get; set; }

    public String debitCardOne { get; set; }
    public String debitCardTwo { get; set; }
    public String debitCardThree { get; set; }
    public String debitCardFour { get; set; }
    public String debitCardGateway { get; set; }

    public String boletoOne { get; set; }
    public String boletoTwo { get; set; }
    public String boletoThree { get; set; }
    public String boletoFour { get; set; }
    public String boletoGateway { get; set; }

    public String pagBrasilOne { get; set; }
    public String pagBrasilTwo { get; set; }
    public String pagBrasilThree { get; set; }

    public String taxaToken { get; set; }
    public String taxaAntecipacao { get; set; }
    public String adherenceFee { get; set; }
    public String minimumMaintenanceFee { get; set; }
    public String cardIntegrationFee { get; set; }
    public String closeTax { get; set; }
    public String repass { get; set; }
    public String trasferFee { get; set; }
    public String reserve { get; set; }
    public String pagstreamfee { get; set; }
    public String payoutFee { get; set; }
    public String supplierFee { get; set; }

    public String frequencyPageOneValueOne { get; set; }
    public String frequencyPageOneValueTwo { get; set; }
    public String frequencyPageOneValueThree { get; set; }
    public String frequencyPageOneValueFour { get; set; }
    public String frequencyPageOneValueFive { get; set; }
    public String frequencyPageOneValueSix { get; set; }
    public String frequencyPageOneValueSeven { get; set; }
    public String frequencyPageOneValueEight { get; set; }
    public String frequencyPageOneValueNine { get; set; }
    public String frequencyPageOneValueTen { get; set; }
    public String frequencyPageOneValueEleven { get; set; }
    public String frequencyPageOneValueTwelve { get; set; }

    public String settlementFrequency { get; set; }

    public String rangeLabel { get; set; }

    public String months { get; set; }
    public String contractDate { get; set; }
    public String link { get; set; }
    public String maintenanceDate { get; set; }

    public Integer startNumber { get; set; }

    Boolean isCrossborder = false;

    public ContractController(ApexPages.StandardController stdController) {

        if(!Test.isRunningTest()){
            stdController.addFields(new List<String>{ 'Id', 'Name', 'Integracao__c', 'BusinessModel__c', 'previs_fat_rs__c', 'AntecipationFrequency__c',
                'Settlement_Frequency_Test__c', 'Account.CNPJ__c', 'AccountId', 'Account.Nome_Empresarial__c', 'NationalPaymentMethod__c', 'Payout__c',
                'Antecipation_Frequency_1__c', 'Settlement_Frequency_1__c', 'RecordType.DeveloperName', 'IntegrationType__c' });
        }

        Opportunity opp = (Opportunity) stdController.getRecord();

        this.link = String.isBlank(ApexPages.currentPage().getParameters().get('link')) ? 'Link não fornecido' : ApexPages.currentPage().getParameters().get('link');
        this.opportunity = opp;

        if(String.isNotBlank(opp.RecordType.DeveloperName) && opp.RecordType.DeveloperName.contains('Crossborder')){
            this.isCrossborder = true;
        }

        this.maintenanceDate = formatDate(ApexPages.currentPage().getParameters().get('maintenanceDate'), isCrossborder);
        this.months = ApexPages.currentPage().getParameters().get('month');
        this.contractDate = formatDate(ApexPages.currentPage().getParameters().get('contractDate'), isCrossborder);


        if(String.isNotBlank(opp.BusinessModel__c) && opp.BusinessModel__c.contains('Gateway'))
            this.isGateway = true;

        this.containsPagBrasilDefinition = String.isNotBlank(opp.IntegrationType__c) && new List<String> {
            'Shopify',
            'Shopify with Buda',
            'Shopify with Yampi',
            'Shopify with Cart Panda',
            'Woocommerce',
            'Vtex',
            'Salesforce CC'
        }.contains(opp.IntegrationType__c);


        this.isFluxoMedio = String.isNotBlank(opp.Antecipation_Frequency_1__c) && opp.Antecipation_Frequency_1__c.contains('Fluxo Médio');
        try {
            this.quote = [SELECT Id,Name,Status,QuoteNumber, (SELECT Id, Price__c, MonthlyRevenue__c, InitialMonthlyRevenue__c, FinalMonthlyRevenue__c, Product2.ProductCode, PercentValue__c FROM QuoteLineItems ORDER BY Order__c) FROM Quote WHERE OpportunityId = :opp.Id ORDER BY CreatedDate DESC LIMIT 1];
        } catch(QueryException e) {
            throw new QueryException('Nenhuma Quote encontrada para esta oportunidade.');
        }

        System.debug('quote --> ' + this.quote);

        this.isPayout = this.opportunity.Payout__c;
        this.items = quote.QuoteLineItems;

        if (!String.isEmpty(this.opportunity.NationalPaymentMethod__c)) {
            this.containsPix = this.opportunity.NationalPaymentMethod__c.contains('Pix');
            this.containsBoleto = this.opportunity.NationalPaymentMethod__c.contains('Boleto');
            this.containsCartao = this.opportunity.NationalPaymentMethod__c.contains('Cartão');
            this.containsDebito = this.opportunity.NationalPaymentMethod__c.contains('Débito');
        }

        this.lowRange = this.opportunity.previs_fat_rs__c <= 5000000;
        this.firstRange = this.lowRange ? '> 1M' : '> 10M';
        this.secondRange = this.lowRange ? '500K - 1M' : '5M - 10M';
        this.thirdRange = this.lowRange ? '100K - 500K' : '1M - 5M';
        this.fourthRange = this.lowRange ? '< 100K' : '500K - 1M';

        System.debug('data enviada: ' + formatDate(ApexPages.currentPage().getParameters().get('contractDate'), isCrossborder));
        System.debug('valor do iscrossborder: ' + iscrossborder);
        System.debug('RecordType DeveloperName: [' + this.opportunity.RecordType.DeveloperName + ']');


        if (this.lowRange) {
            if (this.opportunity.previs_fat_rs__c < 100000)
                this.rangeLabel = '4ª faixa';

            if (this.opportunity.previs_fat_rs__c < 100000 && this.opportunity.RecordType.DeveloperName =='Crossborder')
                this.rangeLabel = '4ˢᵗ tier';

            if (this.opportunity.previs_fat_rs__c >= 100000 && this.opportunity.previs_fat_rs__c < 500000)
                this.rangeLabel = '3ª faixa';

            if (this.opportunity.previs_fat_rs__c >= 100000 && this.opportunity.previs_fat_rs__c < 500000 && this.opportunity.RecordType.DeveloperName =='Crossborder')
                this.rangeLabel = '3ˢᵗ tier';

            if (this.opportunity.previs_fat_rs__c >= 500000 && this.opportunity.previs_fat_rs__c < 1000000)
                this.rangeLabel = '2ª faixa';

            if (this.opportunity.previs_fat_rs__c >= 500000 && this.opportunity.previs_fat_rs__c < 1000000 && this.opportunity.RecordType.DeveloperName =='Crossborder')
                this.rangeLabel = '2ˢᵗ tier';

            if (this.opportunity.previs_fat_rs__c >= 1000000)
                this.rangeLabel = '1ª faixa';

            if (this.opportunity.previs_fat_rs__c >= 1000000 && this.opportunity.RecordType.DeveloperName =='Crossborder')
                this.rangeLabel = '1ˢᵗ tier';

        } else {
            if (this.opportunity.previs_fat_rs__c >= 500000 && this.opportunity.previs_fat_rs__c < 1000000)
                this.rangeLabel = '4ª faixa';

            if (this.opportunity.previs_fat_rs__c >= 500000 && this.opportunity.previs_fat_rs__c < 1000000 && this.opportunity.RecordType.DeveloperName =='Crossborder')
                this.rangeLabel = '4ˢᵗ tier';

            if (this.opportunity.previs_fat_rs__c >= 1000000 && this.opportunity.previs_fat_rs__c < 5000000)
                this.rangeLabel = '3ª faixa';

            if (this.opportunity.previs_fat_rs__c >= 1000000 && this.opportunity.previs_fat_rs__c < 5000000 && this.opportunity.RecordType.DeveloperName =='Crossborder')
                this.rangeLabel = '3ˢᵗ tier';

            if (this.opportunity.previs_fat_rs__c >= 5000000 && this.opportunity.previs_fat_rs__c < 10000000)
                this.rangeLabel = '2ª faixa';

            if (this.opportunity.previs_fat_rs__c >= 5000000 && this.opportunity.previs_fat_rs__c < 10000000 && this.opportunity.RecordType.DeveloperName =='Crossborder')
                this.rangeLabel = '2ˢᵗ tier';

            if (this.opportunity.previs_fat_rs__c >= 10000000)
                this.rangeLabel = '1ª faixa';

            if (this.opportunity.previs_fat_rs__c >= 10000000 && this.opportunity.RecordType.DeveloperName =='Crossborder')
                this.rangeLabel = '1ˢᵗ tier';
        }

        for(QuoteLineItem quoteLineItem : items){
            String price = quoteLineItem.Price__c.replace('R$', '') ?? quoteLineItem.Price__c;
            if(isCrossBorder){
                switch on quoteLineItem.Product2.ProductCode {
                    when 'PAYOUT_SERVICE_FEE' {
                        this.payoutFee = price;
                    }
                    when 'REMITTANCE_FEE_SUPPLIERS' {
                        this.supplierFee = price;
                    }
                    when 'TAXA_PAGSTREAM_SERVICE_FEE' {
                        this.pagstreamfee = price;
                    }
                    when 'RESERVE' {
                        this.reserve = price;
                    }
                    when 'REMITTANCE_FEE_USD' {
                        this.trasferFee = price;
                    }
                    when 'MINIMUM_TRANSFER_AMOUNT' {
                        this.repass = price;
                    }
                    when 'TERMINATION_FEE_CLOSING_ACCOUNT' {
                        this.closeTax = price;
                    }
                    when 'TAXA_INT_CARTAO' {
                        this.cardIntegrationFee = price;
                    }
                    when 'TAXA_INSTALACAO_SF' {
                        this.adherenceFee = price;
                    }
                    when 'SETUP_FEE_USD' {
                        this.adherenceFee = price;
                    }
                    when 'SETUP_FEE_EUR'{
                        this.adherenceFee = price;
                    }
                    when 'TAXA_MIN_MANUTENCAO_SF' {
                        this.minimumMaintenanceFee = price;
                    }
                    when 'MAINTENANCE_MINIMUM_FEE' {
                        this.minimumMaintenanceFee = price;
                    }
                    when 'ANTICIPATION_FEES' {
                        this.taxaAntecipacao = String.valueOf(quoteLineItem.PercentValue__c);
                    }
                    when 'TAXA_TOKENIZACAO' {
                        this.taxaToken = price;
                    }
                    when 'TAXA_GATEWAY_PIX' {
                        this.pixGateway = price;
                    }
                    when 'PROCESSING_FEES_PIX' {
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.pixFour = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.pixThree = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.pixTwo = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 1000000,00 ~ R$ 4999999,99') this.pixOne = price;
                    }
                    when 'TAXA_GATEWAY_CREDITO' {
                        this.creditCardGateway = price;
                    }
                    when 'PROCESSING_FEES_CREDIT_CARD' {
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.creditCardFour = price;
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.creditCardThree = price;
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.creditCardTwo = price;
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 1000000,00 ~ R$ 4999999,99') this.creditCardOne = price;

                    }
                    when 'PAGBRASIL_SOLUTION_FEE' {
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.pagBrasilThree = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.pagBrasilTwo = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.pagBrasilOne = String.valueOf(quoteLineItem.PercentValue__c) + '%';

                    }
                    when 'TAXA_GATEWAY_DEBITO' {
                        this.debitCardGateway = price;
                    }
                    when 'PROCESSING_FEES_DEBITO' {
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.debitCardFour = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.debitCardThree = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.debitCardTwo = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 1000000,00 ~ R$ 4999999,99') this.debitCardOne = price;
                    }
                    when 'TAXA_GATEWAY_BOLETO' {
                        this.boletoGateway = price;
                    }
                    when 'PROCESSING_FEES_BOLETO' {
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.boletoFour = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.boletoThree = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.boletoTwo = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 1000000,00 ~ R$ 4999999,99') this.boletoOne = price;
                    }
                }
            } else{
                switch on quoteLineItem.Product2.ProductCode {
                    when 'TAXA_PAYOUT' {
                        this.payoutFee = price;
                    }
                    when 'TAXA_TRANSFER_FORNEC' {
                        this.supplierFee = price;
                    }
                    when 'TAXA_PAGSTREAM' {
                        this.pagstreamfee = price;
                    }
                    when 'RESERVA_GIRATORIA' {
                        this.reserve = price;
                    }
                    when 'TAXA_TRANSFERENCIA' {
                        this.trasferFee = price;
                    }
                    when 'VALOR_MIN_REPASSE' {
                        this.repass = price;
                    }
                    when 'TAXA_ENCERRAMENTO' {
                        this.closeTax = price;
                    }
                    when 'TAXA_INT_CARTAO' {
                        this.cardIntegrationFee = price;
                    }
                    when 'TAXA_INSTALACAO_SF' {
                        this.adherenceFee = price;
                    }
                    when 'TAXA_INSTALACAO' {
                        this.adherenceFee = price;
                    }
                    when 'TAXA_MIN_MANUTENCAO_SF' {
                        this.minimumMaintenanceFee = price;
                    }
                    when 'TAXA_MIN_MANUTENCAO' {
                        this.minimumMaintenanceFee = price;
                    }
                    when 'TAXA_ANTECIPACAO' {
                        this.taxaAntecipacao = String.valueOf(quoteLineItem.PercentValue__c);
                    }
                    when 'TAXA_TOKENIZACAO' {
                        this.taxaToken = price;
                    }
                    when 'TAXA_GATEWAY_PIX' {
                        this.pixGateway = price;
                    }
                    when 'TAXA_PROCESS_PIX' {
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.pixFour = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.pixThree = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.pixTwo = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 1000000,00 ~ R$ 4999999,99') this.pixOne = price;
                    }
                    when 'TAXA_GATEWAY_CREDITO' {
                        this.creditCardGateway = price;
                    }
                    when 'TAXA_PROCESS_CREDITO' {
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.creditCardFour = price;
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.creditCardThree = price;
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.creditCardTwo = price;
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 1000000,00 ~ R$ 4999999,99') this.creditCardOne = price;

                    }
                    when 'TAXA_PAGBRASIL' {
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.pagBrasilThree = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.pagBrasilTwo = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.pagBrasilOne = String.valueOf(quoteLineItem.PercentValue__c) + '%';

                    }
                    when 'TAXA_GATEWAY_DEBITO' {
                        this.debitCardGateway = price;
                    }
                    when 'TAXA_PROCESS_DEBITO' {
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.debitCardFour = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.debitCardThree = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.debitCardTwo = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 1000000,00 ~ R$ 4999999,99') this.debitCardOne = price;
                    }
                    when 'TAXA_GATEWAY_BOLETO' {
                        this.boletoGateway = price;
                    }
                    when 'TAXA_PROCESS_BOLETO' {
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 0,00 ~ R$ 99999,99') this.boletoFour = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 100000,00 ~ R$ 499999,99') this.boletoThree = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 500000,00 ~ R$ 999999,99') this.boletoTwo = price;
                        if( quoteLineItem.MonthlyRevenue__c == 'R$ 1000000,00 ~ R$ 4999999,99') this.boletoOne = price;
                    }
                }
            }
        }

        this.settlementFrequency = '0';

        if(String.isNotBlank(this.opportunity.Antecipation_Frequency_1__c) && String.isNotBlank(this.opportunity.Settlement_Frequency_1__c)) {
            if (this.opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Daily')) {
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Daily')) this.settlementFrequency = '0';
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Weekly')) this.settlementFrequency = '7';
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Biweekly')) this.settlementFrequency = '15';
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Monthly')) this.settlementFrequency = '31';
            }

            if (this.opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Weekly')) {
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Weekly')) this.settlementFrequency = '0';
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Biweekly')) this.settlementFrequency = '15';
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Monthly')) this.settlementFrequency = '31';
            }

            if (this.opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Biweekly')) {
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Biweekly')) this.settlementFrequency = '0';
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Monthly')) this.settlementFrequency = '31';
            }

            if (this.opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Monthly')) {
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Monthly')) this.settlementFrequency = '0';
            }
        }


        List<Taxes__c> taxes = [SELECT InstallmentNumber__c,PercentValue__c FROM Taxes__c WHERE AntecipationFrequency__c =: this.opportunity.Antecipation_Frequency_1__c AND TaxaBaseAntecipacao__c =: this.taxaAntecipacao AND IsActive__c = true];

        List<Contact> contactsRepresentative = [SELECT Id, Name, Type__c, Title FROM Contact WHERE Type__c INCLUDES ('Representante Legal') AND AccountId =: opp.AccountId ORDER BY CreatedDate DESC];
        this.contacts = contactsRepresentative;
        System.debug('contactsRepresentative ' + contactsRepresentative);
        System.debug('taxes -> ' + taxes);
        System.debug('Frequencia -> ' + this.opportunity.Antecipation_Frequency_1__c);
        System.debug('Antecipacao -> ' + this.taxaAntecipacao);

        for(Taxes__c tax : taxes){
            String percentage = String.valueOf(tax.PercentValue__c).contains('.') ? String.valueOf(tax.PercentValue__c).replace('.', ',') + '%' : String.valueOf(tax.PercentValue__c);

            switch on tax.InstallmentNumber__c{
                when '1' {
                    this.frequencyPageOneValueOne = percentage;
                }
                when '2' {
                    this.frequencyPageOneValueTwo = percentage;
                }
                when '3' {
                    this.frequencyPageOneValueThree = percentage;
                }
                when '4' {
                    this.frequencyPageOneValueFour = percentage;
                }
                when '5' {
                    this.frequencyPageOneValueFive = percentage;
                }
                when '6' {
                    this.frequencyPageOneValueSix = percentage;
                }
                when '7' {
                    this.frequencyPageOneValueSeven = percentage;
                }
                when '8' {
                    this.frequencyPageOneValueEight = percentage;
                }
                when '9' {
                    this.frequencyPageOneValueNine = percentage;
                }
                when '10' {
                    this.frequencyPageOneValueTen = percentage;
                }
                when '11' {
                    this.frequencyPageOneValueEleven = percentage;
                }
                when '12' {
                    this.frequencyPageOneValueTwelve = percentage;
                }
            }
        }
    }

    @AuraEnabled
    public static String generateAndSavePDF(Id opportunityId, String month, String contractDate, String link, String maintenanceDate) {
        try {
            PageReference pdfPage;
            Opportunity opp = [SELECT Id, Name, RecordType.Name FROM Opportunity WHERE Id =: opportunityId];

            Boolean isCrossBorder = opp.RecordType.Name == 'Cross-border';

            String attachBaseName = isCrossBorder ? 'Service Provision Contract ' + opp.Name : 'Contrato Prestação Serviço ' + opp.Name;
            String attachShortName = isCrossBorder ? 'SP Contract ' + opp.Name : 'Contrato PS ' + opp.Name;

            List<ContentVersion> cvs = [
                SELECT Id, Title
                FROM ContentVersion
                WHERE FirstPublishLocationId = :opportunityId
                AND (
                    Title LIKE 'Contrato Prestação Serviço%'
                    OR Title LIKE 'Contrato PS%'
                    OR Title LIKE 'Service Provision Contract%'
                    OR Title LIKE 'SP Contract%'
                )
                ORDER BY CreatedDate DESC
            ];

            Integer maxVersion = cvs.size();
            String newAttachName = attachBaseName + ' v' + (maxVersion + 1);

            if (newAttachName.length() > 44)
                newAttachName = newAttachName.replace(isCrossBorder ? 'Service Provision Contract' : 'Contrato Prestação Serviço', isCrossBorder ? 'SP Contract' : 'Contrato PS');

            pdfPage = isCrossBorder ? Page.ContractCrossborderPage : Page.ContractNacionalPage;

            pdfPage.getParameters().put('Id', opportunityId);
            pdfPage.getParameters().put('month', month);
            pdfPage.getParameters().put('contractDate', contractDate);
            pdfPage.getParameters().put('link', link);
            pdfPage.getParameters().put('maintenanceDate', maintenanceDate);

            Blob pdfBlob = Test.isRunningTest() ? Blob.valueof('teste') : pdfPage.getContentAsPDF();

            ContentVersion cv = new ContentVersion(
                Title = newAttachName,
                PathOnClient = (isCrossBorder ? 'ServiceProvisionContract_' : 'Contrato_') + opportunityId + '.pdf',
                VersionData = pdfBlob,
                FirstPublishLocationId = opportunityId
            );
            insert cv;

            return 'PDF gerado e salvo com sucesso!';
        } catch (Exception e) {
            throw new AuraHandledException('Erro ao gerar ou salvar PDF: ' + e.getMessage());
        }
    }


    private String formatDate(String contractDateParam, Boolean isCrossborder) {
        if (String.isBlank(contractDateParam)) {
            return isCrossborder ? 'Date not provided' : 'Data não fornecida';
        }

        try {
            Date contractDate = Date.valueOf(contractDateParam);

            List<String> monthsPT = new List<String>{
                'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
                'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
            };

            List<String> monthsEN = new List<String>{
                'January', 'February', 'March', 'April', 'May', 'June',
                'July', 'August', 'September', 'October', 'November', 'December'
            };

            List<String> months = isCrossborder ? monthsEN : monthsPT;

            Integer day = contractDate.day();
            String month = months[contractDate.month() - 1];
            Integer year = contractDate.year();

            return isCrossborder
                ? month + ' ' + day + ', ' + year
                : day + ' de ' + month + ' de ' + year;

        } catch (Exception e) {
            return isCrossborder ? 'Invalid date format' : 'Formato de data inválido';
        }
    }
}