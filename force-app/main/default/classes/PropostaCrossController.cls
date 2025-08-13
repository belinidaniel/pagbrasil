/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :

 * @last modified on  : 08-13-2025
 * @last modified by  : Daniel Belini
**/
public class PropostaCrossController {

    public String accountName { get; set; }
    public String accountWebsite { get; set; }
    public String accountOwnerName { get; set; }
    public String accountOwnerEmail { get; set; }
    public String accountOwnerMobilePhone { get; set; }
	public String opportunityOwnerName { get; set; }
    public String opportunityName { get; set; }
    public String quoteCreatedDate { get; set; }
    public Boolean containsPayout { get; set; }
    public Boolean containsApplePay { get; set; }
    public Boolean containsGooglePay { get; set; }
    public Boolean containsPagStream { get; set; }
    public Boolean shopifyWoocommerceSalesforcePBCheckoutTerms { get; set; }
    public String currentIntegrationTypeInCheckoutList { get; set; }
    public Boolean jsAPIVTexTerms { get; set; }

    public String frequencyOne { get; set; }
    public String frequencyTwo { get; set; }
    public List<String> frequencyOneValues { get; set; }
    public List<String> frequencyTwoValues { get; set; }

    public Boolean containsPix { get; set; }
    public Boolean containsCreditCard { get; set; }
    public Boolean containsDebitCard { get; set; }
    public Boolean containsBoleto { get; set; }

    public Boolean containsPixRoaming { get; set; }
    public Boolean containsPixInternational { get; set; }
    public Boolean containsPixAutomatico { get; set; }

    public String tablePaymentValue { get; set; }

    public Boolean highlightLineOne { get; set; }
    public Boolean highlightLineTwo { get; set; }
    public Boolean highlightLineThree { get; set; }
    public Boolean highlightLineFour { get; set; }

    // PRODUCTS AND FEES
    public String pixOne { get; set; }
    public String pixTwo { get; set; }
    public String pixThree { get; set; }
    public String pixFour { get; set; }

    public String creditCardOne { get; set; }
    public String creditCardTwo { get; set; }
    public String creditCardThree { get; set; }
    public String creditCardFour { get; set; }

    public String debitCardOne { get; set; }
    public String debitCardTwo { get; set; }
    public String debitCardThree { get; set; }
    public String debitCardFour { get; set; }
    public String settlementFrequency {get; set;}

    public String boletoOne { get; set; }
    public String boletoTwo { get; set; }
    public String boletoThree { get; set; }
    public String boletoFour { get; set; }

    public String pagBrasilSolutionFee { get; set; }
    public String anticipationFees { get; set; }
    public String setupFee { get; set; }
    public String maintenanceMinimumFee { get; set; }
    public String terminationFeeClosingAccount { get; set; }
    public String currencyExchangeMarkupSpread { get; set; }
    public String iofTax { get; set; }
    public String minimumTransferAmount { get; set; }
    public String remittanceFee { get; set; }
    public String reserve { get; set; }
    public String refundCardAcquirerPix { get; set; }
    public String refundBankTransfer { get; set; }
    public String chargeback { get; set; }
    public String additionalChargebackExcessFee { get; set; }
    public String amountWithheldProvision { get; set; }
    public String package10000Sms { get; set; }
    public String package10000Emails { get; set; }
    public String zeroAuthCreditCard { get; set; }
    public String digitalWalletSolution { get; set; }
    public String pagBrasilCheckoutServiceFee { get; set; }
    public String pagShieldFraudPrevention { get; set; }
    public String pagShieldPremiumFixedFee { get; set; }
    public String pagShieldPremiumVariableFee { get; set; }
    public String pagStreamServiceFee { get; set; }
    public String pagStreamMaintenanceMinimumFee { get; set; }
    public String recurringPix { get; set; }
    public String remittanceFeeSuppliers { get; set; }
    public String payoutServiceFee { get; set; }
    public String payoutSetupFee { get; set; }
    public String opportunityProductType { get; set; }
    public String custoPagshieldCross{ get;set;}
    public String threeDSCreditCard { get; set; }
    public String opportunityCurrency { get; set; }

    // BILLING FORECAST
    public String valueOne { get; set; }
    public String valueTwo { get; set; }
    public String valueThree { get; set; }
    public String valueFour { get; set; }

    public String pixGateway { get; set; }
    public String creditCardGateway { get; set; }
    public String debitCardGateway { get; set; }
    public String boletoGateway { get; set; }

    public List<String> integrationTypeShopifyWoocommerceSalesforcePBCheckoutList = new List<String>{'Shopify','Woocommerce','Salesforce','PB Checkout'};
    public List<String> integrationTypeJSAPIVTex = new List<String>{'JS','API','Vtex'};

    public PropostaCrossController(ApexPages.StandardController stdController) {

        if(!Test.isRunningTest()){
            stdController.addFields(new List<String>{
                'Account.Name', 'Account.Website','Opportunity.Name','Opportunity.Owner.Name', 'Opportunity.IntegrationType__c', 'Opportunity.BusinessModel__c', 'Opportunity.previs_fat_rs__c', 'Opportunity.Settlement_Frequency_Test__c',
                'Opportunity.Product_Type__c', 'Opportunity.Payout__c', 'Opportunity.ApplePay__c', 'Opportunity.GooglePay__c', 'Opportunity.Antecipation_Frequency_1__c', 'Opportunity.Antecipation_Frequency_2__c',
                'Opportunity.Settlement_Frequency_1__c', 'Opportunity.Settlement_Frequency_2__c', 'Opportunity.NationalPaymentMethod__c', 'Opportunity.TaxaBaseDeAntecipacao__c', 'Opportunity.UsePagstream__c', 'Opportunity.Pix_Automatico__c',
                'Opportunity.Moeda__c', 'Account.Owner.Name', 'Account.Owner.Email', 'Account.Owner.MobilePhone' });
        }

        Quote quote = (Quote) stdController.getRecord();

        fieldsPopulation(quote);
        productsPopulation(quote);
        frequencyPopulation(quote);
    }

    private void frequencyPopulation(Quote quote) {

        if (quote.Opportunity.Antecipation_Frequency_1__c == null)
            return;

        this.frequencyOne = quote.Opportunity.Antecipation_Frequency_1__c;
        this.frequencyTwo = quote.Opportunity.Antecipation_Frequency_2__c;

        getParcelas(quote,'One');

        if (frequencyTwo != '')
            getParcelas(quote,'Two');
    }

    private void productsPopulation(Quote quote) {

        List<QuoteLineItem> quoteLineItems = [SELECT Id,Description,PercentValue__c,IsMain__c,Product2.Family,Product2.Name,Product2.IsActive,Price__c,Product2.ProductCode,MonthlyRevenue__c,MonthlyRevenueCode__c FROM QuoteLineItem WHERE QuoteId = :quote.Id];

        for(QuoteLineItem quoteLineItem : quoteLineItems)
            processQuoteLineItem(quoteLineItem);
    }

    @TestVisible private void fieldsPopulation(Quote quote) {

        this.accountName = quote.Account.Name;
        this.accountWebsite = quote.Account.Website;
        this.accountOwnerName = quote.Account.Owner.Name;
        this.accountOwnerEmail = quote.Account.Owner.Email;
        this.accountOwnerMobilePhone = quote.Account.Owner.MobilePhone;

        this.opportunityName = quote.Opportunity.Name;
		this.opportunityOwnerName = quote.Opportunity.Owner.Name;
        this.opportunityCurrency = quote.Opportunity.Moeda__c;
        this.opportunityProductType = quote.Opportunity.Product_Type__c;

        this.containsPayout = quote.Opportunity.Payout__c;
        this.containsApplePay = quote.Opportunity.ApplePay__c;
        this.containsGooglePay = quote.Opportunity.GooglePay__c;
        this.containsPagStream = quote.Opportunity.UsePagstream__c;

        this.containsPixRoaming = quote.Opportunity.BusinessModel__c != null ? quote.Opportunity.BusinessModel__c.contains('Pix Roaming') : false;
        this.containsPixInternational = quote.Opportunity.BusinessModel__c != null ? quote.Opportunity.BusinessModel__c.contains('Pix International') : false;
        this.containsPixAutomatico = quote.Opportunity.Pix_Automatico__c;

        this.shopifyWoocommerceSalesforcePBCheckoutTerms = quote.Opportunity.IntegrationType__c != null ? this.integrationTypeShopifyWoocommerceSalesforcePBCheckoutList.contains(quote.Opportunity.IntegrationType__c) : false;
        this.currentIntegrationTypeInCheckoutList = this.shopifyWoocommerceSalesforcePBCheckoutTerms ? quote.Opportunity.IntegrationType__c : null;
        this.jsAPIVTexTerms = quote.Opportunity.IntegrationType__c != null ? this.integrationTypeJSAPIVTex.contains(quote.Opportunity.IntegrationType__c) : false;

        this.settlementFrequency = '0';

        if(String.isNotBlank(quote.Opportunity.Antecipation_Frequency_1__c) && String.isNotBlank(quote.Opportunity.Settlement_Frequency_1__c)) {

            if (quote.Opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Weekly')) {
                if (quote.Opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Weekly')) this.settlementFrequency = '0';
                if (quote.Opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Biweekly')) this.settlementFrequency = '15';
                if (quote.Opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Monthly')) this.settlementFrequency = '31';
            }

            if (quote.Opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Biweekly')) {
                if (quote.Opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Biweekly')) this.settlementFrequency = '0';
                if (quote.Opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Monthly')) this.settlementFrequency = '31';
            }

            if (quote.Opportunity.Settlement_Frequency_1__c.equalsIgnoreCase('Monthly')) {
                if (quote.Opportunity.Antecipation_Frequency_1__c.equalsIgnoreCase('Monthly')) this.settlementFrequency = '0';
            }
        }

        this.quoteCreatedDate = formatTodayAsStringDate();
        setTaxValues(quote);
        setPaymentMethods(quote);
    }


    @TestVisible private void setTaxValues(Quote quote) {

        if (quote.Opportunity.previs_fat_rs__c != null && quote.Opportunity.previs_fat_rs__c >= 5000000) {

            this.valueOne = '> R$ 10M';
            this.valueTwo = 'R$ 5M - R$ 10M';
            this.valueThree = 'R$ 1M - R$ 5M';
            this.valueFour = 'R$ 500K - R$ 1M';

            if (quote.Opportunity.previs_fat_rs__c >= 10000000)
                this.highlightLineOne = true;
            else
                this.highlightLineTwo = true;

        } else {

            this.valueOne = '> R$ 1M';
            this.valueTwo = 'R$ 500K - R$ 1M';
            this.valueThree = 'R$ 100K - R$ 500K';
            this.valueFour = '< R$ 100K';

            if (quote.Opportunity.previs_fat_rs__c >= 1000000) this.highlightLineOne = true;
            else if (quote.Opportunity.previs_fat_rs__c >= 500000) this.highlightLineTwo = true;
            else if (quote.Opportunity.previs_fat_rs__c >= 100000) this.highlightLineThree = true;
            else this.highlightLineFour = true;
        }
    }

    private void setPaymentMethods(Quote quote) {
        if (quote.Opportunity.NationalPaymentMethod__c != null) {
            List<String> paymentMethods = quote.Opportunity.NationalPaymentMethod__c.split(';');
            this.containsCreditCard = paymentMethods.contains('Cartão de Crédito');
            this.containsDebitCard = paymentMethods.contains('Débito Flash');
            this.containsBoleto = paymentMethods.contains('Boleto Flash');
            this.containsPix = paymentMethods.contains('Pix');
        }
    }

    private void processQuoteLineItem(QuoteLineItem quoteLineItem) {
        switch on quoteLineItem.Product2.ProductCode {
            when 'PROCESSING_FEES_PIX' {
                processPix(quoteLineItem);
            }
            when 'PROCESSING_FEES_CREDIT_CARD' {
                processCreditCard(quoteLineItem);
            }
            when 'PROCESSING_FEES_DEBITO' {
                processDebitCard(quoteLineItem);
            }
            when 'PROCESSING_FEES_BOLETO' {
                processBoleto(quoteLineItem);
            }
            when 'PAGBRASIL_SOLUTION_FEE' {
                this.pagBrasilSolutionFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'ANTICIPATION_FEES' {
                if(quoteLineItem.IsMain__c){
                    this.anticipationFees = String.valueOf(quoteLineItem.PercentValue__c);
                }
            }
            when 'SETUP_FEE_USD' {
                if (this.opportunityCurrency == 'USD')
                    this.setupFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'SETUP_FEE_EUR' {
                if (this.opportunityCurrency == 'EUR')
                    this.setupFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'MAINTENANCE_MINIMUM_FEE' {
                this.maintenanceMinimumFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TERMINATION_FEE_CLOSING_ACCOUNT' {
                this.terminationFeeClosingAccount = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'CURRENCY_EXCHANGE_MARKUP_SPREAD' {
                this.currencyExchangeMarkupSpread = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'IOF_TAX' {
                this.iofTax = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'MINIMUM_TRANSFER_AMOUNT' {
                this.minimumTransferAmount = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'REMITTANCE_FEE_EUR' {
                if (this.opportunityCurrency == 'EUR')
                    this.remittanceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'REMITTANCE_FEE_USD' {
                if (this.opportunityCurrency == 'USD')
                    this.remittanceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'RESERVE' {
                this.reserve = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'REFUND_CARD_ACQUIRER_PIX' {
                this.refundCardAcquirerPix = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'REFUND_BANK_TRANSFER' {
                this.refundBankTransfer = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_CHARGEBACK' {
                this.chargeback = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'ADDITIONAL_CHARGEBACK_EXCESS_FEE' {
                this.additionalChargebackExcessFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'AMOUNT_WITHHELD_PROVISION_USD' {
                if (this.opportunityCurrency == 'USD')
                    this.amountWithheldProvision = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'AMOUNT_WITHHELD_PROVISION_EUR' {
                if (this.opportunityCurrency == 'EUR')
                    this.amountWithheldProvision = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PACKAGE_10000_SMS' {
                this.package10000Sms = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PACKAGE_10000_EMAILS' {
                this.package10000Emails = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'ZERO_AUTH_CREDIT_CARD' {
                this.zeroAuthCreditCard = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'DIGITAL_WALLET_SOLUTION' {
                this.digitalWalletSolution = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PAGBRASIL_CHECKOUT_SERVICE_FEE' {
                this.pagBrasilCheckoutServiceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PAGSHIELD_FRAUD_PREVENTION' {
                this.pagShieldFraudPrevention = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'CUSTO_PAGSHIELD_CROSS'{
                this.custoPagshieldCross = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PAGSHIELD_PREMIUM_FIXED_FEE' {
                this.pagShieldPremiumFixedFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PAGSHIELD_PREMIUM_VARIABLE_FEE' {
                this.pagShieldPremiumVariableFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_PAGSTREAM_SERVICE_FEE' {
                this.pagStreamServiceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PAGSTREAM_MAINTENANCE_MINIMUM_FEE' {
                this.pagStreamMaintenanceMinimumFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'RECURRING_PIX' {
                this.recurringPix = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'REMITTANCE_FEE_SUPPLIERS' {
                this.remittanceFeeSuppliers = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PAYOUT_SERVICE_FEE' {
                this.payoutServiceFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PAYOUT_SETUP_FEE_USD' {
                if (this.opportunityCurrency == 'USD')
                    this.payoutSetupFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'PAYOUT_SETUP_FEE_EUR' {
                if (this.opportunityCurrency == 'EUR')
                    this.payoutSetupFee = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_GATEWAY_PIX'{
                this.pixGateway = validateNumbersWithRegex(quoteLineItem.Price__c);
            }

            when 'TAXA_GATEWAY_CREDITO' {
                this.creditCardGateway = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_GATEWAY_DEBITO' {
                this.debitCardGateway = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when 'TAXA_GATEWAY_BOLETO' {
                this.boletoGateway = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
            when '3DS_CREDIT_CARD' {
                this.threeDSCreditCard = validateNumbersWithRegex(quoteLineItem.Price__c);
            }
        }
    }

    private void processPix(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.pixOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.pixTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.pixThree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.pixFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private void processCreditCard(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.creditCardOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.creditCardTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.creditCardThree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.creditCardFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private void processDebitCard(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.debitCardOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.debitCardTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.debitCardThree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.debitCardFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private void processBoleto(QuoteLineItem quoteLineItem) {
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 1000000,00 ~ R$ 5000000,00') this.boletoOne = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 500000,00 ~ R$ 1000000,00') this.boletoTwo = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 100000,00 ~ R$ 500000,00') this.boletoThree = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
        if (quoteLineItem.MonthlyRevenueCode__c == 'R$ 0,00 ~ R$ 100000,00') this.boletoFour = validateNumbersWithRegex(quoteLineItem.Price__c) + '%';
    }

    private String validateNumbersWithRegex(String value) {
        return value.replace(',', '.').replaceAll('[^0-9.,]', '');
    }

    @TestVisible private void getParcelas(Quote quote, String page) {

        if (page == 'One') {
            this.frequencyOneValues = new List<String>();
            String antecipation = quote.Opportunity.Antecipation_Frequency_1__c;

            List<Taxes__c> taxes = [SELECT InstallmentNumber__c,PercentValue__c FROM Taxes__c WHERE AntecipationFrequency__c = :antecipation AND TaxaBaseAntecipacao__c = :this.anticipationFees AND IsActive__c = true AND  Type__c = 'crossborder'];
            for(Taxes__c tax : taxes) {
                switch on tax.InstallmentNumber__c{
                    when '1' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '2' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '3' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '4' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '5' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '6' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '7' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '8' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '9' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '10' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '11' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                    when '12' {
                        this.frequencyOneValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c) + '%') + '%');
                    }
                }
            }
        }

        if (page == 'Two') {
            this.frequencyTwoValues = new List<String>();
            String antecipation = quote.Opportunity.Antecipation_Frequency_2__c;
            List<Taxes__c> taxes = [SELECT InstallmentNumber__c,PercentValue__c FROM Taxes__c WHERE AntecipationFrequency__c = :antecipation AND TaxaBaseAntecipacao__c = :this.anticipationFees AND IsActive__c = true
            AND  Type__c = 'crossborder'];

            for(Taxes__c tax : taxes) {
                switch on tax.InstallmentNumber__c{
                    when '1' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '2' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '3' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '4' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '5' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '6' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '7' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '8' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '9' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '10' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '11' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                    when '12' {
                        this.frequencyTwoValues.add(validateNumbersWithRegex(String.valueOf(tax.PercentValue__c)) + '%');
                    }
                }
            }
        }
    }

    private static String formatTodayAsStringDate() {

        Date today = Date.today();
        DateTime dataHora = DateTime.newInstance(today.year(), today.month(), today.day());
        String day = dataHora.format('dd');
        String month = dataHora.format('MMMM', 'pt_BR');
        String year = dataHora.format('yyyy');

        return month + ' ' + day + ', ' + year;
    }
}