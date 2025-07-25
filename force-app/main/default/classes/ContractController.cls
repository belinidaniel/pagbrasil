/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 07-24-2025
 * @last modified by  : Daniel Belini
**/
public class ContractController {

    public Quote quote { get; set; }

    public List<QuoteLineItem> items { get; set; }

    public List<Contact> contacts { get; set; }

    public Id oppId { get; set; }

    public Opportunity opportunity { get; set; }

    public Boolean isGateway { get; set; }
    public Boolean isIntermediation { get; set; }
    public Boolean isFrequency { get; set; }
    public Boolean isFluxoMedio { get; set; }
    public Boolean isPayout { get; set; }
    public Boolean isPhysical { get; set; }
    public Boolean isPluginAndPbChekout { get; set; }
    public Boolean pixGatewayBelowMinimum { get; set; }
    public String antecipationFrequency { get; set; }
    public Boolean containsPagBrasilDefinition { get; set; }
    public Boolean containsPix { get; set; }
    public Boolean containsBoleto { get; set; }
    public Boolean containsCartao { get; set; }
    public Boolean containsDebito { get; set; }
    public String remittanceFee { get; set; }

    public Boolean containsCartaoAndIsIntermediation { get; set; } 

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
    public String pagBrasilFour { get; set; }

    public string pagBrasilGatewayOne { get; set; }
    public String pagBrasilGatewayTwo { get; set; }
    public String pagBrasilGatewayThree { get; set; }
    public String pagBrasilGatewayFour { get; set; }

    public Boolean hasPagShield { get; set; }
    public Boolean hasPagShieldPremium { get; set; }
    public Boolean hasZeroAuth { get; set; }
    
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
    public String pagstreamMin { get; set; }
    public String payoutFee { get; set; }
    public String supplierFee { get; set; }
    public String pagShield { get; set; }
    public String pagShieldFee { get; set; }
    public String pagShieldFeePercent { get; set; }
    public String pixAuto { get; set; }
    public String zeroAuthCard { get; set; }
    public String sms500 { get; set; }
    public String sms1000 { get; set; }
    public String sms10000 { get; set; }
    public String emails1000 { get; set; }
    public String emails10000 { get; set; }
    public String emails100000 { get; set; }
    public String pix { get; set; }
    public String refundTransfer { get; set; }
    public String chargeback { get; set; }
    public String isChargeback { get; set; }
    public String excessChargeback { get; set; }
    public String currencyExchangeMarkup { get; set; }
    public String iofTax { get; set; }

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

    public string oneClickFeeVariable{get;set;}
    public string oneClickFeeFixed{get;set;}

    public string pagShieldOndemandFee{ get; set;}
    public string pagShieldOndemandFeePercent{ get; set;}

    public String frequencyOne { get; set; }
    public String frequencyTwo { get; set; }

    public String settlementFrequency { get; set; }

    public String rangeLabel { get; set; }

    public String months { get; set; }
    public String contractDate { get; set; }
    public String link { get; set; }
    public String maintenanceDate { get; set; }

    public Integer startNumber { get; set; }

    Boolean isCrossborder = false;

    public Boolean isGatewayAndIntermediation { get; set; }

    public String termClauses { get; set; }
    public String termClausesTitle { get; set; }
    public String legalName { get; set; }


    public ContractController(ApexPages.StandardController stdController) {

        if(!Test.isRunningTest()){
            stdController.addFields(new List<String>{ 'Id', 'Name', 'Integracao__c','Other_Payments_Settlement_Frequency_1__c', 'RequestChangeClause__c', 'BusinessModel__c', 'previs_fat_rs__c', 'AntecipationFrequency__c',
                'Settlement_Frequency_Test__c', 'Account.CNPJ__c', 'AccountId', 'Account.Nome_Empresarial__c', 'NationalPaymentMethod__c', 'Payout__c', 
                'Antecipation_Frequency_1__c', 'Antecipation_Frequency_2__c', 'Settlement_Frequency_1__c','Settlement_Frequency_2__c', 'Selected_Credit_Frequency__c', 'RecordType.DeveloperName', 'Selected_Credit_Frequency__c', 'Selected_Others_Frequency__c', 'IntegrationType__c', 'Product_Type__c' });
        }

        Opportunity opp = (Opportunity) stdController.getRecord();

        this.isGatewayAndIntermediation = opp.BusinessModel__c != null ? opp.BusinessModel__c.contains('Gateway') && opp.BusinessModel__c.contains('Intermediation') : false;
        this.isGateway = opp.BusinessModel__c != null ? opp.BusinessModel__c.contains('Gateway') : false;
        this.isIntermediation = opp.BusinessModel__c != null ? opp.BusinessModel__c.contains('Intermediation') : false;

        this.pixAuto = '1,90';
        if(String.isNotBlank(opp.RecordType.DeveloperName) && opp.RecordType.DeveloperName.contains('Crossborder')){
            this.isCrossborder = true;
        }


        getTermClauses(opp.Id, opp.RequestChangeClause__c);

        this.link = String.isBlank(ApexPages.currentPage().getParameters().get('link')) ? 'Link não fornecido' : ApexPages.currentPage().getParameters().get('link');
        this.opportunity = opp;

        this.isPluginAndPbChekout = isPluginAndPbChekout(opp.IntegrationType__c);

        if (!this.isCrossBorder){
            KYC__c kyc = [SELECT Id, Legal_Name__c FROM KYC__c WHERE Opportunity__c =: opp.Id LIMIT 1];
            this.legalName = kyc.Legal_Name__c;
        }

        if (this.isCrossBorder) {
            KYC_XB__c kycXB = [SELECT Id, Legal_Name__c FROM KYC_XB__c WHERE Opportunity__c =: opp.Id LIMIT 1];
            this.legalName = kycXB.Legal_Name__c;
        }

        this.maintenanceDate = formatDate(ApexPages.currentPage().getParameters().get('maintenanceDate'), isCrossborder);
        this.months = ApexPages.currentPage().getParameters().get('month');
        this.contractDate = formatDate(ApexPages.currentPage().getParameters().get('contractDate'), isCrossborder);


        this.containsPagBrasilDefinition = String.isNotBlank(opp.IntegrationType__c) && new List<String> {
            'Shopify',
            'Shopify with Buda',
            'Shopify with Yampi',
            'Shopify with Cart Panda',
            'Vtex',
            'Salesforce'
        }.contains(opp.IntegrationType__c);
        

        this.isFluxoMedio = String.isNotBlank(opp.Antecipation_Frequency_1__c) && opp.Antecipation_Frequency_1__c.contains('Fluxo Médio');
        try {
            this.quote = [SELECT Id,Name,Status,QuoteNumber, (SELECT Id, Price__c, MonthlyRevenue__c, MonthlyRevenueCode__c, InitialMonthlyRevenue__c, FinalMonthlyRevenue__c, Product2.ProductCode,UnitPrice, PercentValue__c FROM QuoteLineItems ORDER BY Order__c) FROM Quote WHERE OpportunityId = :opp.Id ORDER BY CreatedDate DESC LIMIT 1];
        } catch(QueryException e) {
            throw new QueryException('Nenhuma Quote encontrada para esta oportunidade.');
        }

        System.debug('quote --> ' + this.quote);

        this.isPayout = this.opportunity.Payout__c;
        this.items = quote.QuoteLineItems;
        this.isPhysical = this.opportunity.Product_Type__c == 'Physical';

        if (!String.isEmpty(this.opportunity.NationalPaymentMethod__c)) {
            this.containsPix = this.opportunity.NationalPaymentMethod__c.contains('Pix');
            this.containsBoleto = this.opportunity.NationalPaymentMethod__c.contains('Boleto');
            this.containsCartao = this.opportunity.NationalPaymentMethod__c.contains('Cartão');
            this.containsDebito = this.opportunity.NationalPaymentMethod__c.contains('Débito');
        }
        this.containsCartaoAndIsIntermediation = this.containsCartao && this.opportunity.BusinessModel__c == 'Intermediation';

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

        // Initialize flags
        this.hasPagShield = false;
        this.hasPagShieldPremium = false;
        this.hasZeroAuth = false;

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
                    when 'REMITTANCE_FEE_EUR' {
                        this.remittanceFee = price;
                    }
                    when 'REMITTANCE_FEE_USD' {
                        this.remittanceFee = price;
                    }
                    when 'RESERVE' {
                        this.reserve = price;
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
                    when 'TAXA_PAGSTREAM' {
                        this.pagstreamfee = price;
                    }
                    when 'TAXA_MIN_PAGSTREAM' {
                        this.pagstreamMin = price;
                        System.debug('Pagstream Min: ' + this.pagstreamMin);
                    }
                    when 'CUSTO_PAGSHIELD_CROSS'{
                        this.pagShield = price;
                        this.hasPagShield = true;
                    }
                    when 'PIX_AUTO'{
                        this.pixAuto = price;
                    }
                    when 'ZERO_AUTH_CREDIT_CARD' {
                        this.zeroAuthCard = price;
                        this.hasZeroAuth = true;
                    }
                    when 'PACKAGE_500_SMS' {//ja tem
                        this.sms500 = price;
                    }
                    when 'PACKAGE_1000_SMS' {//ja tem
                        this.sms1000 = price;
                    }
                    when 'PACKAGE_10000_SMS' { //ja tem
                        this.sms10000 = price;
                    }
                    when 'EMAIL_PACKAGE_1000' {//ja tem
                        this.emails1000 = price;
                    }
                    when 'PACKAGE_10000_EMAILS' { //ta tem
                        this.emails10000 = price;
                    }
                    when 'EMAIL_PACKAGE_100000' {
                        this.emails100000 = price;
                    }
                    when 'REFUND_CARD_ACQUIRER_PIX' {
                        this.pix = price;
                    }
                    when 'REFUND_BANK_TRANSFER' {
                        this.refundTransfer = price;
                    }
                    when 'CHARGEBACK_FEE' {
                        this.chargeback = price;
                    }
                    when 'ADDITIONAL_CHARGEBACK_EXCESS_FEE' {
                        this.excessChargeback = price;
                    }
                    when 'TAXA_CHARGEBACK' {
                        this.chargeback = price;
                    }
                    when 'CURRENCY_EXCHANGE_MARKUP_SPREAD'{
                        this.currencyExchangeMarkup = price;
                    }
                    when 'IOF_TAX'{
                        this.iofTax = price;
                    }
                    when 'ONE_PIX_VARIABLE_FEE' {
                        this.oneClickFeeVariable = price;
                    }
                    when 'ONE_PIX_FIXED_FEE'{
                        this.oneClickFeeFixed = price;
                    }
                    when 'TAXA_FIXA_PAGSHIELD_ON_DEMAND'{
                        this.pagShieldOndemandFee = price;
                    }
                    when 'TAXA_VARIAVEL_PAGSHIELD_ON_DEMAND'{
                        this.pagShieldOndemandFeePercent = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                    }
                    when 'PAGSHIELD_PREMIUM_FIXED_FEE' {
                        this.pagShieldFee = price;
                        this.hasPagShieldPremium = true;
                    }
                    when 'PAGSHIELD_PREMIUM_VARIABLE_FEE' {
                        this.pagShieldFeePercent = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        this.hasPagShieldPremium = true;
                    }
                    when 'TAXA_GATEWAY_PIX' {
                        this.pixGateway = price;
                    }
                    when 'PROCESSING_FEES_PIX' {
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.pixFour = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.pixThree = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.pixTwo = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.pixOne = price;
                    }
                    when 'TAXA_GATEWAY_CREDITO' {
                        this.creditCardGateway = price;
                    }
                    when 'PROCESSING_FEES_CREDIT_CARD' {
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.creditCardFour = price;
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.creditCardThree = price;
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.creditCardTwo = price;
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.creditCardOne = price;

                    }
                    when 'PAGBRASIL_SOLUTION_FEE' {
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.pagBrasilFour = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.pagBrasilThree = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.pagBrasilTwo = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.pagBrasilOne = String.valueOf(quoteLineItem.PercentValue__c) + '%';

                    }
                    when 'TAXA_GATEWAY_DEBITO' {
                        this.debitCardGateway = price;
                    }
                    when 'PROCESSING_FEES_DEBITO' {
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.debitCardFour = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.debitCardThree = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.debitCardTwo = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.debitCardOne = price;
                    }
                    when 'TAXA_GATEWAY_BOLETO' {
                        this.boletoGateway = price;
                    }
                    when 'PROCESSING_FEES_BOLETO' {
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.boletoFour = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.boletoThree = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.boletoTwo = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.boletoOne = price;
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
                    when 'CUSTO_PAGSHIELD'{
                        this.pagShield = price;
                        this.hasPagShield = true;
                    }
                    when 'TAXA_FIX_PAGSHIELD'{
                        this.pagShieldFee = price;
                        this.hasPagShieldPremium = true;
                    }
                    when 'TAXA_VAR_PAGSHIELD'{
                        this.pagShieldFeePercent = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        this.hasPagShieldPremium = true;
                    }
                    when 'TAXA_FIXA_PAGSHIELD_ON_DEMAND'{
                        this.pagShieldOndemandFee = price;
                    }
                    when 'TAXA_VARIAVEL_PAGSHIELD_ON_DEMAND'{
                        this.pagShieldOndemandFeePercent = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                    }
                    when 'PIX_AUTO'{
                        this.pixAuto = price;
                    }
                    when 'ZERO_AUTH_CARTAO'{
                        this.zeroAuthCard = price;
                        this.hasZeroAuth = true;
                    }
                    when 'PACOTE_500_SMS' {
                        this.sms500 = price;
                    }
                    when 'PACOTE_1000_SMS' {
                        this.sms1000 = price;
                    }
                    when 'PACOTE_10000_SMS' {
                        this.sms10000 = price;
                    }
                    when 'PACOTE_1000_EMAILS' {
                        this.emails1000 = price;
                    }
                    when 'PACOTE_10000_EMAILS' {
                        this.emails10000 = price;
                    }
                    when 'PACOTE_100000_EMAILS' { //ja tem
                        this.emails100000 = price;
                    }
                    when 'TAXA_REEMBOLSO_PIX' {
                        this.pix = price;
                    }
                    when 'TAXA_MIN_PAGSTREAM' {
                        this.pagstreamMin = price;
                        System.debug('Pagstream Min: ' + this.pagstreamMin);
                    }
                    when 'TAXA_REEMBOLSO_TRANSF' {
                        this.refundTransfer = price;
                    }
                    when 'TAXA_CHARGEBACK' {
                        this.chargeback = price;
                    }
                    when 'TAXA_EXCESSO_CHARGEBACK' {
                        this.excessChargeback = price;
                    }
                    when 'ONE_PIX_VARIABLE_FEE' {
                        this.oneClickFeeVariable = price;
                    }
                    when 'ONE_PIX_FIXED_FEE'{
                        this.oneClickFeeFixed = price;
                    }
                    when 'TAXA_GATEWAY_PIX' {
                        this.pixGateway = price;
                    }
                    when 'TAXA_PROCESS_PIX' {
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.pixFour = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.pixThree = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.pixTwo = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.pixOne = price;
                    }
                    when 'TAXA_GATEWAY_CREDITO' {
                        this.creditCardGateway = price;
                    }
                    when 'TAXA_PROCESS_CREDITO' {
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.creditCardFour = price;
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.creditCardThree = price;
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.creditCardTwo = price;
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.creditCardOne = price;

                    }
                    when 'TAXA_PAGBRASIL' {
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.pagBrasilFour = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.pagBrasilThree = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.pagBrasilTwo = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.pagBrasilOne = String.valueOf(quoteLineItem.PercentValue__c) + '%';
                    }
                    when 'TAXA_PAGBRASIL_GATEWAY' {
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.pagBrasilGatewayFour = price;
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.pagBrasilGatewayThree = price;
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.pagBrasilGatewayTwo = price;
                        if(quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.pagBrasilGatewayOne = price;
                    }
                    when 'TAXA_GATEWAY_DEBITO' {
                        this.debitCardGateway = price;
                    }
                    when 'TAXA_PROCESS_DEBITO' {
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.debitCardFour = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.debitCardThree = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.debitCardTwo = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.debitCardOne = price;
                    }
                    when 'TAXA_GATEWAY_BOLETO' {
                        this.boletoGateway = price;
                    }
                    when 'TAXA_PROCESS_BOLETO' {
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.boletoFour = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.boletoThree = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.boletoTwo = price;
                        if( quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.boletoOne = price;
                    }
                }
            }
        }

        // If not present in quote, ensure values are empty so VF page does not display them
        this.settlementFrequency = '0';
        this.settlementFrequency = '0';
        this.antecipationFrequency = '0';

        if(this.opportunity.Selected_Others_Frequency__c == '1'){ 
            if(String.isNotBlank(this.opportunity.Antecipation_Frequency_1__c) && String.isNotBlank(this.opportunity.Antecipation_Frequency_1__c)) {
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Daily')) this.antecipationFrequency = '0';
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Weekly')) this.antecipationFrequency = '7';
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Biweekly')) this.antecipationFrequency = '15';
                if (this.opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Monthly')) this.antecipationFrequency = '31';
            }
        }

        if(this.opportunity.Selected_Others_Frequency__c == '2'){ 
            if(String.isNotBlank(this.opportunity.Antecipation_Frequency_2__c) && String.isNotBlank(this.opportunity.Antecipation_Frequency_2__c)) {
                if (this.opportunity.Antecipation_Frequency_2__c.equalsIgnoreCase('Daily')) this.antecipationFrequency = '0';
                if (this.opportunity.Antecipation_Frequency_2__c.equalsIgnoreCase('Weekly')) this.antecipationFrequency = '7';
                if (this.opportunity.Antecipation_Frequency_2__c.equalsIgnoreCase('Biweekly')) this.antecipationFrequency = '15';
                if (this.opportunity.Antecipation_Frequency_2__c.equalsIgnoreCase('Monthly')) this.antecipationFrequency = '31';
            }
        }

        
        if(this.opportunity.Selected_Credit_Frequency__c == '1'){
            if(settlementFrequency == '0' && String.isNotBlank(this.opportunity.Settlement_Frequency_1__c)) {
                    if (this.opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Daily')) this.settlementFrequency = '0';
                    if (this.opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Weekly')) this.settlementFrequency = '7';
                    if (this.opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Biweekly')) this.settlementFrequency = '15';
                    if (this.opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Monthly')) this.settlementFrequency = '31';
            }
        }
        if(this.opportunity.Selected_Credit_Frequency__c == '2'){
            if(settlementFrequency == '0' && String.isNotBlank(this.opportunity.Settlement_Frequency_2__c)) {
                    if (this.opportunity.Settlement_Frequency_2__c.equalsIgnoreCase('Daily')) this.settlementFrequency = '0';
                    if (this.opportunity.Settlement_Frequency_2__c.equalsIgnoreCase('Weekly')) this.settlementFrequency = '7';
                    if (this.opportunity.Settlement_Frequency_2__c.equalsIgnoreCase('Biweekly')) this.settlementFrequency = '15';
                    if (this.opportunity.Settlement_Frequency_2__c.equalsIgnoreCase('Monthly')) this.settlementFrequency = '31';
            }
        }
        List<Taxes__c> taxes = [SELECT InstallmentNumber__c,PercentValue__c FROM Taxes__c WHERE AntecipationFrequency__c =: this.opportunity.Antecipation_Frequency_1__c AND TaxaBaseAntecipacao__c =: this.taxaAntecipacao AND IsActive__c = true];

        List<Contact> contactsRepresentative = [SELECT Id, Name, Type__c, Title FROM Contact WHERE Type__c INCLUDES ('Representante Legal') AND AccountId =: opp.AccountId ORDER BY CreatedDate DESC];
        this.contacts = contactsRepresentative;
        System.debug('contactsRepresentative ' + contactsRepresentative);
        System.debug('taxes -> ' + taxes);
        System.debug('Frequencia -> ' + this.opportunity.Antecipation_Frequency_1__c);
        System.debug('Antecipacao -> ' + this.taxaAntecipacao);
        if(taxes.isEmpty()){
            this.isFrequency = false;
        }
        else{
            this.isFrequency = true;
        }
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

        if(this.containsPix){
            verifyOnePixFee(items);
        }
    }

    @AuraEnabled
    public static Id generateAndSavePDF(Id opportunityId, String month, String contractDate, String link, String maintenanceDate) {
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

            cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

            Opportunity oppToUpdate = new Opportunity(
                Id = opportunityId,
                Was_Contract_PDF_Generated__c = true,
                Contract_Start_Fee_Date__c = maintenanceDate
            );
            update oppToUpdate;

            return cv.ContentDocumentId;
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


    private void getTermClauses(Id opportunityId,Boolean requestChangeClause) {
        System.debug('getTermClauses called with opportunityId: ' + opportunityId + ' and isCrossborder: ' + this.isCrossborder);
        if(requestChangeClause){
            List<ClausesOpportunity__c> requestChangeClausesList = [SELECT Id,ClauseName__c,ClauseText__c FROM ClausesOpportunity__c WHERE Opportunity__c = :opportunityId AND ClauseName__c in ('Termos e Condições:','Terms and Conditions:')];
            this.termClauses = requestChangeClausesList[0].ClauseText__c;
            this.termClausesTitle = requestChangeClausesList[0].ClauseName__c;
        }else{
            if(!this.isCrossborder){
                List<Clauses__c> termClausesList = [SELECT Id,Name,ClauseText__c,ContractType__c FROM Clauses__c WHERE ContractType__c =:  'National' ];
                this.termClauses = termClausesList[0].ClauseText__c;
                this.termClausesTitle = termClausesList[0].Name;     
            }
            else{
                List<Clauses__c> termClausesList = [SELECT Id,Name,ClauseText__c,ContractType__c FROM Clauses__c WHERE ContractType__c =: 'Cross'];
                this.termClauses = termClausesList[0].ClauseText__c;
                this.termClausesTitle = termClausesList[0].Name;     
            }
        }
      
    }

    public void verifyOnePixFee(List<QuoteLineItem> quotelineItens){
        Decimal pixGatewayValue = 0;
        for(QuoteLineItem item : quotelineItens){
            if(item.Product2.ProductCode == 'TAXA_GATEWAY_PIX'){
                pixGatewayValue = item.UnitPrice;
            }
        }
        system.debug('verifyOnePixFee = pixGatewayValue: ' + pixGatewayValue);
        Decimal minValue = this.isCrossborder ? 1.90 : 1.49;
        System.debug('verifyOnePixFee = minValue: ' + minValue);
        Decimal oneClickFee = 0;
        if(pixGatewayValue < minValue){
            oneClickFee = minValue - pixGatewayValue;
        }
        System.debug('verifyOnePixFee = oneClickFee: ' + oneClickFee);

        // Only set if > 0
        this.oneClickFeeFixed = (oneClickFee > 0) ? String.valueOf(oneClickFee.setScale(2)) : '';
    }

    @AuraEnabled
    public static String attachContractToRecord(Id recordId, Blob pdfBody, String fileName) {
        ContentVersion cv = new ContentVersion(
            VersionData = pdfBody,
            Title = fileName,
            PathOnClient = fileName
        );
        insert cv;

        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = recordId,
            ShareType = 'V'
        );
        insert cdl;

        return cv.ContentDocumentId;
    }

    public static Boolean isPluginAndPbChekout(String integrationType) {
        if (String.isBlank(integrationType)) return false;
        List<String> pluginTypes = new List<String>{
            'Vtex',
            'Shopify',
            'Shopify with Buda',
            'Shopify with Yampi',
            'Shopify with Cart Panda',
            'Salesforce',
            'PB Checkout'
        };
        for (String type : pluginTypes) {
            if (integrationType.contains(type)) {
                return true;
            }
        }
        return false;
    }

    public String monthYear {
        get {
            if (String.isBlank(this.contractDate)) return '';
            try {
                Date contractDateObj = Date.valueOf(this.contractDate);
                List<String> monthsEN = new List<String>{
                    'January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'
                };
                String month = monthsEN[contractDateObj.month() - 1];
                Integer year = contractDateObj.year();
                return month + ', ' + String.valueOf(year);
            } catch (Exception e) {
                return '';
            }
        }
    }
}