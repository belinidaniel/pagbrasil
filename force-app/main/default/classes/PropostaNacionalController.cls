/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 07-17-2025
 * @last modified by  : Daniel Belini
**/
public class PropostaNacionalController {

    public Boolean testeNew { get; set; }

    public String opportunityName { get; set; }
    public String accountOwnerName { get; set; }
    public String accountOwnerEmail { get; set; }
    public String accountOwnerMobilePhone { get; set; }
    public Boolean containsShopify { get; set; }
    public Boolean containsGateway { get; set; }
    public Boolean containsCreditCard { get; set; }
    public Boolean isPagShield { get; set; }
    public Boolean isSalesforce { get; set; }
    public Boolean isGateway { get; set; }
    public Boolean isIntermediation { get; set; }
    public Boolean isPayout { get; set; }
    public Boolean isVisibleSettlementFrequency { get; set; }
    public Boolean isVisibleAnticipationFrequency { get; set; }
    public Boolean isGatewayAndIntermediation { get; set; }
    public Boolean isPagStream { get; set; }
    public String page09 { get; set; }
    public String page10 { get; set; }
    public Boolean viewPage6 { get; set; }
    public Boolean viewPage11 { get; set; }
    public Boolean shopifyWoocommerceSalesforcePBCheckoutTerms { get; set; }
    public Boolean jSAPIVTexTerms { get; set; }
    public Boolean containsVTEX { get; set; }
    public Boolean show { get; set; }
    public Boolean first { get; set; }
    public string reserve {get;set;}
    public String pagBrasilSolutionFeeRange{get;set;}
    public Boolean showZeroReserveOption { get; set; }
    public Boolean isGoogleOrApplePay { get; set; }

    //Taxes
    public String valueOne { get; set; }
    public String valueTwo{ get; set; }
    public String valueThree{ get; set; }
    public String valueFour{ get; set; }
    public Boolean highlightedLineOne { get; set; }
    public Boolean highlightedLineTwo { get; set; }
    public Boolean highlightedLineThree { get; set; }
    public Boolean highlightedLineFour { get; set; }
    public String tablePaymentValue { get; set; }

    //Taxes values
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

    public String additionalInstallmentFee2To6 { get; set; }
    public String additionalInstallmentFee7To12 { get; set; }

    public Boolean showOne { get; set; }
    public Boolean showTwo { get; set; }
    public Boolean showThree { get; set; }
    public Boolean showFour { get; set; }

    public String valueOneFirstOption { get; set; }
    public String valueTwoFirstOption { get; set; }
    public String valueThreeFirstOption { get; set; }
    public String valueFourFirstOption { get; set; }
    public String valueGatewayFirstOption { get; set; }

    public String valueOneSecondOption { get; set; }
    public String valueTwoSecondOption { get; set; }
    public String valueThreeSecondOption { get; set; }
    public String valueFourSecondOption { get; set; }
    public String valueGatewaySecondOption { get; set; }

    public String valueOneThirdOption { get; set; }
    public String valueTwoThirdOption { get; set; }
    public String valueThreeThirdOption { get; set; }
    public String valueFourThirdOption { get; set; }
    public String valueGatewayThirdOption { get; set; }


    //Frequency
    public Boolean showTwoOptions { get; set; }
    public String antecipationFrequencyPageOne { get; set; }
    public String antecipationFrequencyPageTwo { get; set; }
    public String frequencyCardEligebleDatePageOne { get; set; }
    public String frequencyCardEligebleDatePageTwo { get; set; }
    public String frequencyPixBoletoDebitoFlashEligebleDatePageOne { get; set; }
    public String frequencyPixBoletoDebitoFlashEligebleDatePageTwo { get; set; }
    public String frequencyPage11 { get; set; }

    //Frequency values
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

    public String frequencyPageTwoValueOne { get; set; }
    public String frequencyPageTwoValueTwo { get; set; }
    public String frequencyPageTwoValueThree { get; set; }
    public String frequencyPageTwoValueFour { get; set; }
    public String frequencyPageTwoValueFive { get; set; }
    public String frequencyPageTwoValueSix { get; set; }
    public String frequencyPageTwoValueSeven { get; set; }
    public String frequencyPageTwoValueEight { get; set; }
    public String frequencyPageTwoValueNine { get; set; }
    public String frequencyPageTwoValueTen { get; set; }
    public String frequencyPageTwoValueEleven { get; set; }
    public String frequencyPageTwoValueTwelve { get; set; }
    public String smsGratuito {get;set;}

    //Date
    public String stringDate { get; set; }

    //Fields
    public String taxaPagStream { get; set; }
    public String taxaMinPagStream { get; set; }
    public String pagShield { get; set; }
    public String pagShieldPremium { get; set; }
    public String pagShieldPremiumPercent { get; set; }
    public String transferFee { get; set; }
    public String pagBrasilSolutionFee { get; set; }
    public String refundCardOrPixAcquirer { get; set; }
    public String refundTransfer { get; set; }
    public String chargebackTax { get; set; }
    public String adherenceFee { get; set; }
    public String minimumMaintenanceFee { get; set; }
    public String creditCardIntegrationFee { get; set; }
    public String taxaAntecipacao { get; set; }
    public String payoutServiceFee { get; set; }
    public String payoutTransferFee { get; set; }

    public string TaxaBrasilOne { get; set; }
    public string TaxaBrasilTwo { get; set; }
    public string TaxaBrasilThree { get; set; }
    public string TaxaBrasilFour { get; set; }

    public static List<String> integrationTypeShopifyWoocommerceSalesforcePBCheckoutList = new List<String>{'Shopify','Woocommerce','Salesforce','PB Checkout'};
    public static List<String> integrationTypeJSAPIVTex = new List<String>{'JS','API','Vtex'};
    public static List<String> integrationTypeVTEX = new List<String>{'Vtex'};

    public Boolean containsPix { get; set; }
    public Boolean containsBoleto { get; set; }
    public Boolean containsDebitCard { get; set; }
    public Boolean containsPagBrasilSolution { get; set; }

    public string getewayOne { get; set; }
    public string getewayTwo { get; set; }
    public string getewaythree { get; set; }
    public string getewayFour { get; set; }

    public List<String> pacotesSms { get; set; }
    public List<String> pacotesEmails { get; set; }


    public PropostaNacionalController(ApexPages.StandardController stdController) {

        if(!Test.isRunningTest()){
            stdController.addFields(new List<String>{
                'Opportunity.Name', 'Opportunity.IntegrationType__c', 'Opportunity.BusinessModel__c', 'Opportunity.previs_fat_rs__c',
                'Opportunity.Settlement_Frequency_Test__c', 'Opportunity.Payout__c', 'Opportunity.Antecipation_Frequency_1__c',
                'Opportunity.Antecipation_Frequency_2__c', 'Opportunity.Settlement_Frequency_1__c', 'Opportunity.Settlement_Frequency_2__c',
                'Opportunity.NationalPaymentMethod__c', 'Opportunity.TaxaBaseDeAntecipacao__c', 'Opportunity.UsePagstream__c', 'Opportunity.PagShield__c',
                'Account.Owner.Name', 'Account.Owner.Email', 'Account.Owner.MobilePhone', 'Opportunity.GooglePay__c', 'Opportunity.ApplePay__c', 'Opportunity.Visible_Settlement_Frequency__c', 'Opportunity.Visible_Anticipation_Frequency__c' });
        }

        Quote quote = (Quote) stdController.getRecord();

        this.show = false;

        productsPopulation(quote);
        fieldsPopulation(quote);
        frequencyPopulation(quote);

        showZeroReserveOption = this.containsGateway;

        this.viewPage6 = true;
        this.viewPage11 = false;
        this.shopifyWoocommerceSalesforcePBCheckoutTerms = quote.Opportunity.IntegrationType__c != null && this.isIntermediation ? validateIntegrationTypeShopifyWoocommerceSalesforcePBCheckoutList(quote.Opportunity.IntegrationType__c) : false;
        this.smsGratuito = isPlugin(quote.Opportunity.IntegrationType__c) ? 'Gratuito' : 'Consultar valores';
        this.jSAPIVTexTerms = quote.Opportunity.IntegrationType__c != null && this.isIntermediation ? validateIntegrationTypeJSAPIVTex(quote.Opportunity.IntegrationType__c) : false;
        this.containsVTEX = quote.Opportunity.IntegrationType__c != null && this.isIntermediation ? validateIntegrationTypeVTEX(quote.Opportunity.IntegrationType__c) : false;

        this.page09 = '';
        this.page10 = '';
        this.page09 = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina09DD';
        this.page10 = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina10DF';

        this.stringDate = formatStringDate();
    }

    private String validateNumbersWithRegex(String value) {
        String temp = value;
        if (value.contains('%'))
            temp = temp.replace('.', ',');

        return temp.replaceAll('[^0-9.,]', '');
    }

    

    private void fieldsPopulation(Quote quote) {
        this.opportunityName = quote.Opportunity.Name;
        this.accountOwnerName = quote.Account.Owner.Name;
        this.accountOwnerEmail = quote.Account.Owner.Email;
        this.accountOwnerMobilePhone = quote.Account.Owner.MobilePhone;
        this.isPagShield = quote.Opportunity.PagShield__c;
        this.isGoogleOrApplePay = quote.opportunity.GooglePay__c  || quote.opportunity.ApplePay__c ? true: false;
        System.debug('isGoogleOrApplePay: ' + this.isGoogleOrApplePay);
        this.containsShopify = quote.Opportunity.IntegrationType__c != null ? quote.Opportunity.IntegrationType__c.contains('Shopify') : false;
        this.containsGateway = quote.Opportunity.BusinessModel__c != null ? quote.Opportunity.BusinessModel__c.contains('Gateway') : false;
        this.isSalesforce = quote.Opportunity.IntegrationType__c != null ? quote.Opportunity.IntegrationType__c == 'Salesforce' : false;
        this.isGateway = quote.Opportunity.BusinessModel__c != null ? quote.Opportunity.BusinessModel__c == 'Gateway' : false;
        this.isIntermediation = quote.Opportunity.BusinessModel__c != null ? quote.Opportunity.BusinessModel__c == 'Intermediation' : false;
        this.isGatewayAndIntermediation = quote.Opportunity.BusinessModel__c != null ? quote.Opportunity.BusinessModel__c.contains('Gateway') && quote.Opportunity.BusinessModel__c.contains('Intermediation') : false;
        this.isPayout = quote.Opportunity.Payout__c;
        this.isPagStream = quote.Opportunity.UsePagstream__c;
        this.isVisibleAnticipationFrequency = quote.Opportunity.Visible_Anticipation_Frequency__c;
        this.isVisibleSettlementFrequency = quote.Opportunity.Visible_Settlement_Frequency__c;
        tableTaxPaymentPopulation(quote);
    }

    private void tableTaxPaymentPopulation(Quote quote) {
        setTaxValues(quote);
        setPaymentMethods(quote);
    }

    private void setTaxValues(Quote quote ) {
        if (quote.Opportunity.previs_fat_rs__c != null && quote.Opportunity.previs_fat_rs__c < 5000000) {
            this.valueOne = '> R$ 1M';
            this.valueTwo = 'R$ 500k - R$ 1M';
            this.valueThree = 'R$ 100k - R$ 500k';
            this.valueFour = '< R$ 100k';

            if (quote.Opportunity.previs_fat_rs__c != null) {
                Decimal revenue = quote.Opportunity.previs_fat_rs__c;
                if (revenue >= 1000000) {
                    this.highlightedLineOne = true;
                } else if (revenue >= 500000) {
                    this.highlightedLineTwo = true;
                } else if (revenue >= 100000) {
                    this.highlightedLineThree = true;
                } else if (revenue < 100000) {
                    this.highlightedLineFour = true;
                } // If you want to handle < 500K, you can add another flag
            }
        }else if (quote.Opportunity.previs_fat_rs__c != null && quote.Opportunity.previs_fat_rs__c >= 5000000) {
            this.valueOne = '> R$ 10M';
            this.valueTwo = 'R$ 5M - R$ 10M';
            this.valueThree = 'R$ 1M - R$ 5M';
            this.valueFour = 'R$ 500K - R$ 1M';

            if (quote.Opportunity.previs_fat_rs__c != null) {
                Decimal revenue = quote.Opportunity.previs_fat_rs__c;
                if (revenue >= 10000000) {
                    this.highlightedLineOne = true;
                } else if (revenue >= 5000000) {
                    this.highlightedLineTwo = true;
                } else if (revenue >= 1000000) {
                    this.highlightedLineThree = true;
                } else if (revenue >= 500000) {
                    this.highlightedLineFour = true;
                } // If you want to handle < 500K, you can add another flag
            }
        } 
    }

    private void setPaymentMethods(Quote quote) {
        if (quote.Opportunity.NationalPaymentMethod__c != null) {
            List<String> paymentMethods = quote.Opportunity.NationalPaymentMethod__c.split(';');
            Boolean containsCreditCard = paymentMethods.contains('Cartão de Crédito');
            Boolean containsDebitCard = paymentMethods.contains('Débito Flash');
            Boolean containsBoleto = paymentMethods.contains('Boleto Flash');
            Boolean containsPix = paymentMethods.contains('Pix');

            if (containsGateway) {
                containsCreditCard = false;
            }

            this.containsCreditCard = containsCreditCard;

            if (containsPix && containsDebitCard && containsCreditCard && containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7PCDB';
                this.showFour = true;
            } else if (containsPix && !containsDebitCard && !containsCreditCard && !containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7P';
                this.showOne = true;
                populateOptionsController('Pix',null,null);
            } else if (containsPix && containsDebitCard && !containsCreditCard && !containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7PD';
                this.showTwo = true;
                populateOptionsController('Pix','DebitCard',null);
            } else if (containsPix && containsDebitCard && containsCreditCard && !containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7PCD';
                this.showThree = true;
                populateOptionsController('Pix','DebitCard','CreditCard');
            } else if (containsPix && containsDebitCard && !containsCreditCard && containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7PBD';
                this.showThree = true;
                populateOptionsController('Pix', 'Boleto','DebitCard');
            } else if (containsPix && !containsDebitCard && containsCreditCard && containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7PCB';
                this.showThree = true;
                populateOptionsController('Pix','CreditCard','Boleto');
            } else if (containsPix && !containsDebitCard && containsCreditCard && !containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7PC';
                this.showTwo = true;
                populateOptionsController('Pix','CreditCard',null);
            } else if (containsPix && !containsDebitCard && !containsCreditCard && containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7PB';
                this.showTwo = true;
                populateOptionsController('Pix','Boleto',null);
            } else if (containsCreditCard && !containsDebitCard && !containsPix && !containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7C';
                this.showOne = true;
                populateOptionsController('CreditCard',null,null);
            } else if (containsCreditCard && containsDebitCard && !containsPix && !containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7CD';
                this.showTwo = true;
                populateOptionsController('CreditCard','DebitCard',null);
            } else if (containsCreditCard && !containsDebitCard && !containsPix && containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7CB';
                this.showTwo = true;
                populateOptionsController('CreditCard','Boleto',null);
            } else if (containsCreditCard && containsDebitCard && !containsPix && containsBoleto) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7CBD';
                this.showThree = true;
                populateOptionsController('CreditCard','DebitCard','Boleto');
            } else if (containsBoleto && !containsDebitCard && !containsPix && !containsCreditCard) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7B';
                this.showOne = true;
                populateOptionsController('Boleto',null,null);
            } else if (containsBoleto && containsDebitCard && !containsPix && !containsCreditCard) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7BD';
                this.showTwo = true;
                populateOptionsController('Boleto','DebitCard',null);
            } else if (containsDebitCard && !containsBoleto && !containsPix && !containsCreditCard) {
                this.tablePaymentValue = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina7D';
                this.showOne = true;
                populateOptionsController('DebitCard',null,null);
            }
        }
    }

    private void productsPopulation(Quote quote) {
        pacotesSms = new List<String>();
        pacotesEmails = new List<String>();
        
        List<QuoteLineItem> quoteLineItems = [SELECT Id,quoteLineItem.quote.opportunity.BusinessModel__c,Description,PercentValue__c,Product2.Family,Product2.Name,Product2.IsActive,Price__c,Product2.ProductCode,MonthlyRevenue__c,MonthlyRevenueCode__c FROM QuoteLineItem WHERE QuoteId = :quote.Id];
        for(QuoteLineItem quoteLineItem : quoteLineItems) {
            if(quoteLineItem.Product2.ProductCode == 'PACOTE_1000_SMS' || quoteLineItem.Product2.ProductCode == 'PACOTE_10000_SMS' || quoteLineItem.Product2.ProductCode == 'PACOTE_500_SMS') {
                pacotesSms.add(quoteLineItem.Product2.Name + ': R$ ' + String.valueOf(quoteLineItem.Price__c).replace('.',','));
            }
            if(quoteLineItem.Product2.ProductCode == 'PACOTE_1000_EMAILS' || quoteLineItem.Product2.ProductCode == 'PACOTE_10000_EMAILS' || quoteLineItem.Product2.ProductCode == 'PACOTE_100000_EMAILS') {
                pacotesEmails.add(quoteLineItem.Product2.Name + ': R$ ' + String.valueOf(quoteLineItem.Price__c).replace('.',','));
            }
            processQuoteLineItem(quoteLineItem);
        }
    }

    private void processQuoteLineItem(QuoteLineItem quoteLineItem) {
        switch on quoteLineItem.Product2.ProductCode {
            when 'TAXA_ANTECIPACAO' {
                this.taxaAntecipacao = String.valueof(quoteLineItem.PercentValue__c);
            }
            when 'TAXA_PAGSTREAM' {
                this.taxaPagStream = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
            }
            when 'TAXA_MIN_PAGSTREAM' {
                this.taxaMinPagStream = 'R$' + validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'CUSTO_PAGSHIELD' {
                this.pagShield = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_FIX_PAGSHIELD' {
                this.pagShieldPremium = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_VAR_PAGSHIELD' {
                this.pagShieldPremiumPercent = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_TRANSFERENCIA' {
                this.transferFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_PAGBRASIL' {
                processTaxaPagBrasil(quoteLineItem);
            }
            when 'TAXA_PAYOUT' {
                this.payoutServiceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_TRANSFER_FORNEC' {
                this.payoutTransferFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_REEMBOLSO_PIX' {
                this.refundCardOrPixAcquirer = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_REEMBOLSO_TRANSF' {
                this.refundTransfer = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_CHARGEBACK' {
                this.chargebackTax = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_INSTALACAO_SF' {
                this.adherenceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_INSTALACAO' {
                this.adherenceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_MIN_MANUTENCAO_SF' {
                this.minimumMaintenanceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_MIN_MANUTENCAO' {
                this.minimumMaintenanceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_INT_CARTAO' {
                this.creditCardIntegrationFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_GATEWAY_PIX' {
                this.pixGateway = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_PROCESS_PIX' {
                processPix(quoteLineItem);
            }
            when 'TAXA_GATEWAY_CREDITO' {
                this.creditCardGateway = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_PROCESS_CREDITO' {
                processCreditCard(quoteLineItem);
            }
            when 'TAXA_GATEWAY_DEBITO' {
                this.debitCardGateway = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_PROCESS_DEBITO' {
                processDebitCard(quoteLineItem);
            }
            when 'TAXA_GATEWAY_BOLETO' {
                this.boletoGateway = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_PROCESS_BOLETO' {
                processBoleto(quoteLineItem);
            }
            when 'TAXA_PARC_2A6' {
                this.additionalInstallmentFee2To6 = '2 a 6 parcelas: +' + validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
            }
            when 'TAXA_PARC_7A12' {
                this.additionalInstallmentFee7To12 = '7 a 12 parcelas: +' + validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
            }
            when 'TAXA_PAGBRASIL_GATEWAY' {
                processTaxaPagBrasilGateway(quoteLineItem);
            }
        }
    }

    private void processPix(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.pixOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.pixTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.pixThree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.pixFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private void processCreditCard(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.creditCardOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.creditCardTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.creditCardThree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.creditCardFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private void processDebitCard(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.debitCardOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.debitCardTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.debitCardThree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.debitCardFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private void processBoleto(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.boletoOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.boletoTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.boletoThree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.boletoFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private void processTaxaPagBrasil(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.TaxaBrasilOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.TaxaBrasilTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.TaxaBrasilThree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.TaxaBrasilFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private void processTaxaPagBrasilGateway(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.getewayOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.getewayTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.getewaythree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.getewayFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private void frequencyPopulation(Quote quote) {

        if (quote.Opportunity.Antecipation_Frequency_1__c == null || quote.Opportunity.Settlement_Frequency_1__c == null)
            return;

        if (this.isGatewayAndIntermediation) {
            switch on quote.Opportunity.Antecipation_Frequency_1__c {
                when 'Daily' {
                    this.frequencyPage11 = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina11D';
                }
                when 'Weekly' {
                    this.frequencyPage11 = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina11S';
                }
                when 'Bimonthly' {
                    this.frequencyPage11 = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina11B';
                }
                when 'Monthly' {
                    this.frequencyPage11 = URL.getOrgDomainUrl().toExternalForm() + '/resource/PNPagina11M';
                }
            }
        }

        String antecipationOne = quote.Opportunity.Antecipation_Frequency_1__c;
        String antecipationTwo = quote.Opportunity.Antecipation_Frequency_2__c;

        String settlementOne = quote.Opportunity.Settlement_Frequency_1__c;
        String settlementTwo = quote.Opportunity.Settlement_Frequency_2__c;

        validationFrequencyPage(settlementOne, antecipationOne, 'One');
        getParcelas(quote,'One');

        if (antecipationTwo != '' && settlementTwo != '') {
            validationFrequencyPage(settlementTwo, antecipationTwo, 'Two');
            getParcelas(quote,'Two');
        }

        if (this.antecipationFrequencyPageOne != null && this.antecipationFrequencyPageTwo != null) this.showTwoOptions = true;
    }

    private void validationFrequencyPage(String settlement, String antecipation, String page) {
        if (page == 'One') {
            setFrequencyPageOne(settlement, antecipation);
        } else if (page == 'Two') {
            setFrequencyPageTwo(settlement, antecipation);
        }
    }

    private void setFrequencyPageOne(String settlement, String antecipation) {
        if (settlement == 'Daily') {
            setDailyFrequencyPageOne(antecipation);
        } else if (settlement == 'Weekly') {
            setWeeklyFrequencyPageOne(antecipation);
        } else if (settlement == 'Bimonthly') {
            setBimonthlyFrequencyPageOne(antecipation);
        } else if (settlement == 'Monthly') {
            setMonthlyFrequencyPageOne(antecipation);
        }

        if (antecipation == 'Fluxo Médio') {
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'fluxo médio';
        }
    }

    private void setFrequencyPageTwo(String settlement, String antecipation) {
        if (settlement == 'Daily') setDailyFrequencyPageTwo(antecipation);
        else if (settlement == 'Weekly') setWeeklyFrequencyPageTwo(antecipation);
        else if (settlement == 'Bimonthly') setBimonthlyFrequencyPageTwo(antecipation);
        else if (settlement == 'Monthly') setMonthlyFrequencyPageTwo(antecipation);

        if (antecipation == 'Fluxo Médio') {
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'fluxo médio';
        }
    }

    @TestVisible private void setDailyFrequencyPageOne(String antecipation) {
        if (antecipation == 'Daily') {
            this.frequencyCardEligebleDatePageOne = 'D+0';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'diária';
        } else if (antecipation == 'Weekly') {
            this.frequencyCardEligebleDatePageOne = 'D+7';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'semanal';
        } else if (antecipation == 'Bimonthly') {
            this.frequencyCardEligebleDatePageOne = 'D+15';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'quinzenal';
        } else if (antecipation == 'Monthly') {
            this.frequencyCardEligebleDatePageOne = 'D+31';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'mensal';
        }
    }

    @TestVisible private void setWeeklyFrequencyPageOne(String antecipation) {
        if (antecipation == 'Weekly') {
            this.frequencyCardEligebleDatePageOne = 'D+0';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'semanal';
        } else if (antecipation == 'Bimonthly') {
            this.frequencyCardEligebleDatePageOne = 'D+15';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'quinzenal';
        } else if (antecipation == 'Monthly') {
            this.frequencyCardEligebleDatePageOne = 'D+31';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'mensal';
        }
    }

    private void setBimonthlyFrequencyPageOne(String antecipation) {
        if (antecipation == 'Bimonthly') {
            this.frequencyCardEligebleDatePageOne = 'D+0';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'quinzenal';
        } else if (antecipation == 'Monthly') {
            this.frequencyCardEligebleDatePageOne = 'D+31';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'mensal';
        }
    }

    private void setMonthlyFrequencyPageOne(String antecipation) {
        if (antecipation == 'Monthly') {
            this.frequencyCardEligebleDatePageOne = 'D+0';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageOne = 'D+0';
            this.antecipationFrequencyPageOne = 'mensal';
        }
    }

    @TestVisible private void setDailyFrequencyPageTwo(String antecipation) {
        if (antecipation == 'Daily') {
            this.frequencyCardEligebleDatePageTwo = 'D+0';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'diária';
        } else if (antecipation == 'Weekly') {
            this.frequencyCardEligebleDatePageTwo = 'D+7';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'semanal';
        } else if (antecipation == 'Bimonthly') {
            this.frequencyCardEligebleDatePageTwo = 'D+15';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'quinzenal';
        } else if (antecipation == 'Monthly') {
            this.frequencyCardEligebleDatePageTwo = 'D+31';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'mensal';
        }
    }

    @TestVisible private void setWeeklyFrequencyPageTwo(String antecipation) {
        if (antecipation == 'Weekly') {
            this.frequencyCardEligebleDatePageTwo = 'D+0';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'semanal';
        } else if (antecipation == 'Bimonthly') {
            this.frequencyCardEligebleDatePageTwo = 'D+15';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'quinzenal';
        } else if (antecipation == 'Monthly') {
            this.frequencyCardEligebleDatePageTwo = 'D+31';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'mensal';
        }
    }

    @TestVisible private void setBimonthlyFrequencyPageTwo(String antecipation) {
        if (antecipation == 'Bimonthly') {
            this.frequencyCardEligebleDatePageTwo = 'D+0';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'quinzenal';
        } else if (antecipation == 'Monthly') {
            this.frequencyCardEligebleDatePageTwo = 'D+31';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'mensal';
        }
    }

    @TestVisible private void setMonthlyFrequencyPageTwo(String antecipation) {
        if (antecipation == 'Monthly') {
            this.frequencyCardEligebleDatePageTwo = 'D+0';
            this.frequencyPixBoletoDebitoFlashEligebleDatePageTwo = 'D+0';
            this.antecipationFrequencyPageTwo = 'mensal';
        }
    }

    @TestVisible private void populateOptionsController(String paymentMethodOne, String paymentMethodTwo, String paymentMethodThree) {

        switch on paymentMethodOne {
            when 'Pix' {
                populateFirstOptions(paymentMethodOne);
            }
            when 'CreditCard' {
                populateFirstOptions(paymentMethodOne);
            }
            when 'DebitCard' {
                populateFirstOptions(paymentMethodOne);
            }
            when 'Boleto' {
                populateFirstOptions(paymentMethodOne);
            }
        }

        if (paymentMethodTwo != null) {
            switch on paymentMethodTwo {
                when 'Pix' {
                    populateSecondOptions(paymentMethodTwo);
                }
                when 'CreditCard' {
                    populateSecondOptions(paymentMethodTwo);
                }
                when 'DebitCard' {
                    populateSecondOptions(paymentMethodTwo);
                }
                when 'Boleto' {
                    populateSecondOptions(paymentMethodTwo);
                }
            }
        }

        if (paymentMethodThree != null) {
            switch on paymentMethodThree {
                when 'Pix' {
                    populateThirdOptions(paymentMethodThree);
                }
                when 'CreditCard' {
                    populateThirdOptions(paymentMethodThree);
                }
                when 'DebitCard' {
                    populateThirdOptions(paymentMethodThree);
                }
                when 'Boleto' {
                    populateThirdOptions(paymentMethodThree);
                }
            }
        }
    }

    private void populateFirstOptions(String paymentMethod) {
        switch on paymentMethod {
            when 'Pix' {
                this.valueOneFirstOption = this.pixOne;
                this.valueTwoFirstOption = this.pixTwo;
                this.valueThreeFirstOption = this.pixThree;
                this.valueFourFirstOption = this.pixFour;
                this.valueGatewayFirstOption = this.pixGateway;
            }
            when 'CreditCard' {
                this.valueOneFirstOption = this.creditCardOne;
                this.valueTwoFirstOption = this.creditCardTwo;
                this.valueThreeFirstOption = this.creditCardThree;
                this.valueFourFirstOption = this.creditCardFour;
                this.valueGatewayFirstOption = this.creditCardGateway;
            }
            when 'DebitCard' {
                this.valueOneFirstOption = this.debitCardOne;
                this.valueTwoFirstOption = this.debitCardTwo;
                this.valueThreeFirstOption = this.debitCardThree;
                this.valueFourFirstOption = this.debitCardFour;
                this.valueGatewayFirstOption = this.debitCardGateway;
            }
            when 'Boleto' {
                this.valueOneFirstOption = this.boletoOne;
                this.valueTwoFirstOption = this.boletoTwo;
                this.valueThreeFirstOption = this.boletoThree;
                this.valueFourFirstOption = this.boletoFour;
                this.valueGatewayFirstOption = this.boletoGateway;
            }
        }
    }

    private void populateSecondOptions(String paymentMethod) {
        switch on paymentMethod {
            when 'Pix' {
                this.valueOneSecondOption = this.pixOne;
                this.valueTwoSecondOption = this.pixTwo;
                this.valueThreeSecondOption = this.pixThree;
                this.valueFourSecondOption = this.pixFour;
                this.valueGatewaySecondOption = this.pixGateway;
            }
            when 'CreditCard' {
                this.valueOneSecondOption = this.creditCardOne;
                this.valueTwoSecondOption = this.creditCardTwo;
                this.valueThreeSecondOption = this.creditCardThree;
                this.valueFourSecondOption = this.creditCardFour;
                this.valueGatewaySecondOption = this.creditCardGateway;
            }
            when 'DebitCard' {
                this.valueOneSecondOption = this.debitCardOne;
                this.valueTwoSecondOption = this.debitCardTwo;
                this.valueThreeSecondOption = this.debitCardThree;
                this.valueFourSecondOption = this.debitCardFour;
                this.valueGatewaySecondOption = this.debitCardGateway;
            }
            when 'Boleto' {
                this.valueOneSecondOption = this.boletoOne;
                this.valueTwoSecondOption = this.boletoTwo;
                this.valueThreeSecondOption = this.boletoThree;
                this.valueFourSecondOption = this.boletoFour;
                this.valueGatewaySecondOption = this.boletoGateway;
            }
        }
    }

    private void populateThirdOptions(String paymentMethod) {
        switch on paymentMethod {
            when 'Pix' {
                this.valueOneThirdOption = this.pixOne;
                this.valueTwoThirdOption = this.pixTwo;
                this.valueThreeThirdOption = this.pixThree;
                this.valueFourThirdOption = this.pixFour;
                this.valueGatewayThirdOption = this.pixGateway;
            }
            when 'CreditCard' {
                this.valueOneThirdOption = this.creditCardOne;
                this.valueTwoThirdOption = this.creditCardTwo;
                this.valueThreeThirdOption = this.creditCardThree;
                this.valueFourThirdOption = this.creditCardFour;
                this.valueGatewayThirdOption = this.creditCardGateway;
            }
            when 'DebitCard' {
                this.valueOneThirdOption = this.debitCardOne;
                this.valueTwoThirdOption = this.debitCardTwo;
                this.valueThreeThirdOption = this.debitCardThree;
                this.valueFourThirdOption = this.debitCardFour;
                this.valueGatewayThirdOption = this.debitCardGateway;
            }
            when 'Boleto' {
                this.valueOneThirdOption = this.boletoOne;
                this.valueTwoThirdOption = this.boletoTwo;
                this.valueThreeThirdOption = this.boletoThree;
                this.valueFourThirdOption = this.boletoFour;
                this.valueGatewayThirdOption = this.boletoGateway;
            }
        }
    }

    private static String formatStringDate() {

        String monthPtBR = '';
        Date today = Date.today();
        DateTime dataHora = DateTime.newInstance(today.year(), today.month(), today.day());
        String day = dataHora.format('dd');
        String month = dataHora.format('MMMM', 'pt_BR');
        String year = dataHora.format('yyyy');

        switch on month {
            when 'January' {
                monthPtBR = 'Janeiro';
            }
            when 'February' {
                monthPtBR = 'Fevereiro';
            }
            when 'March' {
                monthPtBR = 'Março';
            }
            when 'April' {
                monthPtBR = 'Abril';
            }
            when 'May' {
                monthPtBR = 'Maio';
            }
            when 'June' {
                monthPtBR = 'Junho';
            }
            when 'July' {
                monthPtBR = 'Julho';
            }
            when 'August' {
                monthPtBR = 'Agosto';
            }
            when 'September' {
                monthPtBR = 'Setembro';
            }
            when 'October' {
                monthPtBR = 'Outubro';
            }
            when 'November' {
                monthPtBR = 'Novembro';
            }
            when 'December' {
                monthPtBR = 'Dezembro';
            }
        }

        return day + ' de ' + monthPtBR + ' de ' + year;

    }

    private static Boolean validateIntegrationTypeJSAPIVTex(String integracao) {
        for(String integration : integrationTypeJSAPIVTex)
            if (integracao.contains(integration))
                return true;
        return false;
    }

    private static Boolean validateIntegrationTypeShopifyWoocommerceSalesforcePBCheckoutList(String integracao) {
        for(String integration : integrationTypeShopifyWoocommerceSalesforcePBCheckoutList)
            if (integracao.contains(integration))
                return true;
        return false;
    }

    private static Boolean validateIntegrationTypeVTEX(String integracao) {
        for(String integration : integrationTypeVTEX)
            if (integracao.contains(integration))
                return true;
        return false;
    }
    
    // Returns true if the integrationType is considered a plugin
    private static Boolean isPlugin(String integrationType) {
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
    private void getParcelas(Quote quote, String page) {

        if (page == 'One') {
            System.debug('getParcelas page: ' + this.taxaAntecipacao);
            String antecipation = quote.Opportunity.Antecipation_Frequency_1__c;
            System.debug('getParcelas antecipation: ' + antecipation);
            List<Taxes__c> taxes = [SELECT InstallmentNumber__c,PercentValue__c FROM Taxes__c WHERE AntecipationFrequency__c = :antecipation AND TaxaBaseAntecipacao__c = :this.taxaAntecipacao AND IsActive__c = true];
            System.debug('taxes.   ' + taxes);
            for(Taxes__c tax : taxes) {
                System.debug('tax.InstallmentNumber__c: ' + tax.InstallmentNumber__c);
                switch on tax.InstallmentNumber__c{
                    when '1' {
                        this.frequencyPageOneValueOne = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '2' {
                        this.frequencyPageOneValueTwo = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '3' {
                        this.frequencyPageOneValueThree = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '4' {
                        this.frequencyPageOneValueFour = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '5' {
                        this.frequencyPageOneValueFive = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '6' {
                        this.frequencyPageOneValueSix = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '7' {
                        this.frequencyPageOneValueSeven = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '8' {
                        this.frequencyPageOneValueEight = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '9' {
                        this.frequencyPageOneValueNine = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '10' {
                        this.frequencyPageOneValueTen = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '11' {
                        this.frequencyPageOneValueEleven = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                    when '12' {
                        this.frequencyPageOneValueTwelve = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%';
                    }
                }
            }
        }

        if (page == 'Two') {
            String antecipation = quote.Opportunity.Antecipation_Frequency_2__c;
            List<Taxes__c> taxes = [SELECT InstallmentNumber__c,PercentValue__c FROM Taxes__c WHERE AntecipationFrequency__c = :antecipation AND TaxaBaseAntecipacao__c = :this.taxaAntecipacao AND IsActive__c = true];

            for(Taxes__c tax : taxes) {
                switch on tax.InstallmentNumber__c{
                    when '1' {
                        this.frequencyPageTwoValueOne = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '2' {
                        this.frequencyPageTwoValueTwo = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '3' {
                        this.frequencyPageTwoValueThree = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '4' {
                        this.frequencyPageTwoValueFour = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '5' {
                        this.frequencyPageTwoValueFive = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '6' {
                        this.frequencyPageTwoValueSix = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '7' {
                        this.frequencyPageTwoValueSeven = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '8' {
                        this.frequencyPageTwoValueEight = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '9' {
                        this.frequencyPageTwoValueNine = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '10' {
                        this.frequencyPageTwoValueTen = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '11' {
                        this.frequencyPageTwoValueEleven = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                    when '12' {
                        this.frequencyPageTwoValueTwelve = validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%';
                    }
                }
            }
        }
    }
}