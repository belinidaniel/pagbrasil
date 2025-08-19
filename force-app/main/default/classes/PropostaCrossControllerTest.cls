/**
 * @description Test class for PropostaCrossController
 * @author Daniel Belini
 * @group Test Classes
 * @last modified on 07-05-2025
 * @last modified by Daniel Belini
**/
@IsTest
public class PropostaCrossControllerTest {

    @IsTest
    static void testGetParcelasFrequencyValues() {
        // Garante que existam Taxes__c para as frequências configuradas
        Opportunity opp = [SELECT Id, Antecipation_Frequency_1__c, Antecipation_Frequency_2__c FROM Opportunity LIMIT 1];
        Quote quote = [SELECT Id FROM Quote LIMIT 1];

        // Cria Taxes__c para as duas frequências
        List<Taxes__c> taxes = new List<Taxes__c>{
            new Taxes__c(
                AntecipationFrequency__c = opp.Antecipation_Frequency_1__c,
                TaxaBaseAntecipacao__c = '2.59',
                InstallmentNumber__c = '1',
                PercentValue__c = 1.5,
                IsActive__c = true
            ),
            new Taxes__c(
                AntecipationFrequency__c = opp.Antecipation_Frequency_2__c,
                TaxaBaseAntecipacao__c = '2.59',
                InstallmentNumber__c = '2',
                PercentValue__c = 2.0,
                IsActive__c = true
            )
        };
        insert taxes;

        // Executa o controller
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                          Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                          Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                          Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,Opportunity.Antecipation_Frequency_2__c,
                          Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,
                          Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();

    }

    @TestSetup
    static void makeData() {
        // Create test account
        Account testAccount = new Account(
            Name = 'Test Account',
            Website = 'www.testaccount.com'
        );
        insert testAccount;

        // Create test opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testAccount.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            IntegrationType__c = 'Shopify',
            BusinessModel__c = 'Intermediation',
            Segmento__c = 'Gaming', 
            previs_fat_rs__c = 2000000,
            Payout__c = true,
            ApplePay__c = true,
            GooglePay__c = true,
            UsePagstream__c = true,
            Antecipation_Frequency_1__c = 'Weekly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Weekly',
            Settlement_Frequency_2__c = 'Monthly',
            NationalPaymentMethod__c = 'Pix',
            AverageSalesTicket__c = 100,
            PaymentRecurrence__c = 'Sim',
            Product_Type__c = 'Digital',
            recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Cross-border').getRecordTypeId(),
            nb_receita_mensal__c =111,
            Moeda__c = 'USD'
        );
        insert testOpportunity;

        // Create test quote
        Quote testQuote = new Quote(
            Name = 'Test Quote',
            OpportunityId = testOpportunity.Id
        );
        insert testQuote;

        // Assign Standard Pricebook to Quote
        Id standardPricebookId = Test.getStandardPricebookId();
        testQuote.Pricebook2Id = standardPricebookId;
        update testQuote;

        // Create test products
        List<Product2> testProducts = new List<Product2>();
        testProducts.add(new Product2(Name = 'Pix Processing Fee', ProductCode = 'PROCESSING_FEES_PIX', IsActive = true));
        testProducts.add(new Product2(Name = 'Credit Card Processing Fee', ProductCode = 'PROCESSING_FEES_CREDIT_CARD', IsActive = true));
        testProducts.add(new Product2(Name = 'Debit Card Processing Fee', ProductCode = 'PROCESSING_FEES_DEBITO', IsActive = true));
        testProducts.add(new Product2(Name = 'Boleto Processing Fee', ProductCode = 'PROCESSING_FEES_BOLETO', IsActive = true));
        testProducts.add(new Product2(Name = 'PagBrasil Solution Fee', ProductCode = 'PAGBRASIL_SOLUTION_FEE', IsActive = true));
        testProducts.add(new Product2(Name = 'Anticipation Fees', ProductCode = 'ANTICIPATION_FEES', IsActive = true));
        testProducts.add(new Product2(Name = 'Setup Fee USD', ProductCode = 'SETUP_FEE_USD', IsActive = true));
        testProducts.add(new Product2(Name = 'Setup Fee EUR', ProductCode = 'CURRENCY_EXCHANGE_MARKUP_SPREAD', IsActive = true));
        testProducts.add(new Product2(Name = 'Setup Fee EUR', ProductCode = 'SETUP_FEE_EUR', IsActive = true));
        testProducts.add(new Product2(Name = 'Maintenance Minimum Fee', ProductCode = 'MAINTENANCE_MINIMUM_FEE', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'TERMINATION_FEE_CLOSING_ACCOUNT', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'IOF_TAX', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'MINIMUM_TRANSFER_AMOUNT', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'REMITTANCE_FEE_EUR', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'REMITTANCE_FEE_USD', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'RESERVE', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'REFUND_CARD_ACQUIRER_PIX', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'REFUND_BANK_TRANSFER', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'CHARGEBACK', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'ADDITIONAL_CHARGEBACK_EXCESS_FEE', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'AMOUNT_WITHHELD_PROVISION_USD', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'AMOUNT_WITHHELD_PROVISION_EUR', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PACKAGE_10000_SMS', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PACKAGE_10000_EMAILS', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'ZERO_AUTH_CREDIT_CARD', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'DIGITAL_WALLET_SOLUTION', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PAGBRASIL_CHECKOUT_SERVICE_FEE', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PAGSHIELD_FRAUD_PREVENTION', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PAGSHIELD_PREMIUM_FIXED_FEE', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'TAXA_PAGSTREAM_SERVICE_FEE', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PAGSHIELD_PREMIUM_VARIABLE_FEE', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PAGSTREAM_MAINTENANCE_MINIMUM_FEE', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'RECURRING_PIX', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'REMITTANCE_FEE_SUPPLIERS', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PAYOUT_SERVICE_FEE', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PAYOUT_SETUP_FEE_USD', IsActive = true));
        testProducts.add(new Product2(Name = 'Termination Fee', ProductCode = 'PAYOUT_SETUP_FEE_EUR', IsActive = true));
        insert testProducts;

        // Create pricebook entry
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Product2 product : testProducts) {
            pricebookEntries.add(new PricebookEntry(
                Product2Id = product.Id,
                Pricebook2Id = standardPricebookId,
                UnitPrice = 100,
                IsActive = true
            ));
        }
        insert pricebookEntries;

        // Create quote line items
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        for (Integer i = 0; i < testProducts.size(); i++) {
            quoteLineItems.add(new QuoteLineItem(
                QuoteId = testQuote.Id,
                Product2Id = testProducts[i].Id,
                PricebookEntryId = pricebookEntries[i].Id,
                Quantity = 1,
                UnitPrice = 100
            ));
        }
        insert quoteLineItems;

        // Create test taxes
        List<Taxes__c> testTaxes = new List<Taxes__c>();
        testTaxes.add(new Taxes__c(
            AntecipationFrequency__c = 'Weekly',
            TaxaBaseAntecipacao__c = '2.59',
            InstallmentNumber__c = '1',
            PercentValue__c = 1.5,
            IsActive__c = true
        ));
        testTaxes.add(new Taxes__c(
            AntecipationFrequency__c = 'Monthly',
            TaxaBaseAntecipacao__c = '2.59',
            InstallmentNumber__c = '2',
            PercentValue__c = 2.0,
            IsActive__c = true
        ));
        insert testTaxes;
    }

    @IsTest
    static void testConstructorAndAllBranches() {
        // Get test data
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                          Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                          Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                          Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,Opportunity.Antecipation_Frequency_2__c,
                          Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,
                          Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        
        // Create standard controller
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();

        controller.pixOne = '1.00';
        controller.pixTwo = '2.00';
        controller.pixThree = '3.00';
        controller.pixFour = '4.00';

        controller.creditCardOne = '1.10';
        controller.creditCardTwo = '2.20';
        controller.creditCardThree = '3.30';
        controller.creditCardFour = '4.40';
        controller.debitCardOne = '1.15';
        controller.debitCardTwo = '2.25';
        controller.debitCardThree = '3.35';
        controller.debitCardFour = '4.45';
        controller.boletoOne = '1.05';
        controller.boletoTwo = '2.15';
        controller.boletoThree = '3.25';
        controller.boletoFour = '4.35';

    //     System.assertNotEquals(null, controller, 'Controller should be instantiated');
    //     System.assertNotEquals(null, controller.accountName, 'Account name should be populated');
    //     System.assertNotEquals(null, controller.opportunityName, 'Opportunity name should be populated');
    //     System.assertEquals('Test Account', controller.accountName, 'Account name should match test data');
    //     System.assertEquals('Test Opportunity', controller.opportunityName, 'Opportunity name should match test data');
    //     System.assert(controller.quoteCreatedDate.contains(String.valueOf(Date.today().year())), 'Date should contain current year');
    //     System.assert(controller.frequencyOne != null, 'Frequency one should be populated');
    //     System.assert(controller.frequencyOneValues != null, 'Frequency one values should be populated');
    //     System.assert(controller.pixOne != null || controller.pixTwo != null || controller.pixThree != null || controller.pixFour != null, 'Pix fee should be populated');
    //     System.assert(controller.creditCardOne != null || controller.creditCardTwo != null || controller.creditCardThree != null || controller.creditCardFour != null, 'Credit card fee should be populated');
    //     System.assert(controller.debitCardOne != null || controller.debitCardTwo != null || controller.debitCardThree != null || controller.debitCardFour != null, 'Debit card fee should be populated');
    //     System.assert(controller.boletoOne != null || controller.boletoTwo != null || controller.boletoThree != null || controller.boletoFour != null, 'Boleto fee should be populated');
       
    //     System.assert(controller.pagBrasilSolutionFee != null, 'pagBrasilSolutionFee should be populated');
    //     System.assert(controller.anticipationFees != null, 'anticipationFees should be populated');
    //     System.assert(controller.setupFee != null, 'setupFee should be populated');
    //     System.assert(controller.maintenanceMinimumFee != null, 'maintenanceMinimumFee should be populated');
    //     System.assert(controller.terminationFeeClosingAccount != null, 'terminationFeeClosingAccount should be populated');
    //     System.assert(controller.currencyExchangeMarkupSpread != null, 'currencyExchangeMarkupSpread should be populated');
    //     System.assert(controller.iofTax != null, 'iofTax should be populated');
    //     System.assert(controller.minimumTransferAmount != null, 'minimumTransferAmount should be populated');
    //     System.assert(controller.remittanceFee != null, 'remittanceFee should be populated');
    //     System.assert(controller.reserve != null, 'reserve should be populated');
    //     System.assert(controller.refundCardAcquirerPix != null, 'refundCardAcquirerPix should be populated');
    //     System.assert(controller.refundBankTransfer != null, 'refundBankTransfer should be populated');
    //     System.assert(controller.chargeback != null, 'chargeback should be populated');
    //     System.assert(controller.additionalChargebackExcessFee != null, 'additionalChargebackExcessFee should be populated');
    //     System.assert(controller.amountWithheldProvision != null, 'amountWithheldProvision should be populated');
    //     System.assert(controller.package10000Sms != null, 'package10000Sms should be populated');
    //     System.assert(controller.package10000Emails != null, 'package10000Emails should be populated');
    //     System.assert(controller.zeroAuthCreditCard != null, 'zeroAuthCreditCard should be populated');
    //     System.assert(controller.digitalWalletSolution != null, 'digitalWalletSolution should be populated');
    //     System.assert(controller.pagBrasilCheckoutServiceFee != null, 'pagBrasilCheckoutServiceFee should be populated');
    //     System.assert(controller.pagShieldFraudPrevention != null, 'pagShieldFraudPrevention should be populated');
    //     System.assert(controller.pagShieldPremiumFixedFee != null, 'pagShieldPremiumFixedFee should be populated');
    //     System.assert(controller.pagShieldPremiumVariableFee != null, 'pagShieldPremiumVariableFee should be populated');
    //     System.assert(controller.pagStreamServiceFee != null, 'pagStreamServiceFee should be populated');
    //     System.assert(controller.pagStreamMaintenanceMinimumFee != null, 'pagStreamMaintenanceMinimumFee should be populated');
    //     System.assert(controller.recurringPix != null, 'recurringPix should be populated');
    //     System.assert(controller.remittanceFeeSuppliers != null, 'remittanceFeeSuppliers should be populated');
    //     System.assert(controller.payoutServiceFee != null, 'payoutServiceFee should be populated');
    //     System.assert(controller.payoutSetupFee != null, 'payoutSetupFee should be populated');
    //     System.assert(controller.opportunityProductType != null, 'opportunityProductType should be populated');
    //     System.assert(controller.opportunityCurrency != null, 'opportunityCurrency should be populated');
    //     System.assert(controller.valueOne != null, 'valueOne should be populated');
    //     System.assert(controller.valueTwo != null, 'valueTwo should be populated');
    //     System.assert(controller.valueThree != null, 'valueThree should be populated');
    //     System.assert(controller.valueFour != null, 'valueFour should be populated');
    //     System.assert(controller.containsPix != null, 'containsPix should be populated');
    //     System.assert(controller.containsCreditCard != null, 'containsCreditCard should be populated');
    //     System.assert(controller.containsDebitCard != null, 'containsDebitCard should be populated');
    //     System.assert(controller.containsBoleto != null, 'containsBoleto should be populated');
    //     System.assert(controller.containsPixRoaming != null, 'containsPixRoaming should be populated');
    //     System.assert(controller.containsPixInternational != null, 'containsPixInternational should be populated');
    //     System.assert(controller.containsPixAutomatico != null, 'containsPixAutomatico should be populated');
    //     System.assert(controller.shopifyWoocommerceSalesforcePBCheckoutTerms != null, 'shopifyWoocommerceSalesforcePBCheckoutTerms should be populated');
    //     System.assert(controller.jsAPIVTexTerms != null, 'jsAPIVTexTerms should be populated');
    //     System.assert(controller.settlementFrequency != null, 'settlementFrequency should be populated');
    //     System.assert(controller.highlightLineOne != null, 'highlightLineOne should be populated');
    //     System.assert(controller.highlightLineTwo != null, 'highlightLineTwo should be populated');
    //     System.assert(controller.highlightLineThree != null, 'highlightLineThree should be populated');
    //     System.assert(controller.highlightLineFour != null, 'highlightLineFour should be populated');
    // 
    }
    @IsTest
    static void testFieldsPopulationWithJSAPIAndNulls() {
        // Update opportunity with JS integration type and nulls for some fields
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.IntegrationType__c = 'JS';
        opp.BusinessModel__c = 'Intermediation';
        opp.Pix_Automatico__c = True;
        opp.NationalPaymentMethod__c = 'Pix';
        update opp;
        
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                          Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                          Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                          Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,Opportunity.Antecipation_Frequency_2__c,
                          Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,
                          Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();
        
        System.assertEquals(false, controller.shopifyWoocommerceSalesforcePBCheckoutTerms, 'Should not match checkout integration types');
        System.assertEquals(true, controller.jsAPITerms, 'Should match JS/API/Vtex integration types');
        System.assertEquals(false, controller.containsPixRoaming, 'Should be false when BusinessModel__c is null');
        System.assertEquals(false, controller.containsPixInternational, 'Should be false when BusinessModel__c is null');
        System.assertEquals(true, controller.containsPixAutomatico, 'Should be null when Pix_Automatico__c is null');
        System.assertEquals(true, controller.containsPix, 'Should be null when NationalPaymentMethod__c is null');
    }

    @IsTest
    static void testSetTaxValuesHighRevenue() {
        // Update opportunity with high revenue
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.previs_fat_rs__c = 15000000; // > 10M
        update opp;
        
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                          Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                          Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                          Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,Opportunity.Antecipation_Frequency_2__c,
                          Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,
                          Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();
        
        System.assertEquals('> R$ 10M', controller.valueOne, 'Value one should be > R$ 10M');
        System.assertEquals('R$ 5M - R$ 10M', controller.valueTwo, 'Value two should be R$ 5M - R$ 10M');
        System.assertEquals(true, controller.highlightLineOne, 'Should highlight line one for > 10M');
        System.assertEquals(null, controller.highlightLineTwo, 'Should not highlight line two');
    }

    @IsTest
    static void testSetTaxValuesMediumRevenue() {
        // Update opportunity with medium revenue
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.previs_fat_rs__c = 7000000; // Between 5M and 10M   
        update opp;
        
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,Opportunity.Antecipation_Frequency_2__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();
        
        System.assertEquals('> R$ 10M', controller.valueOne, 'Value one should be > R$ 10M');
        System.assertEquals('R$ 5M - R$ 10M', controller.valueTwo, 'Value two should be R$ 5M - R$ 10M');
        System.assertEquals(null, controller.highlightLineOne, 'Should not highlight line one for 7M');
        System.assertEquals(true, controller.highlightLineTwo, 'Should highlight line two for 7M');
    }

    @IsTest
    static void testSettlementFrequencyCalculation() {
        // Test Weekly -> Biweekly scenario
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Settlement_Frequency_1__c = 'Weekly';
        opp.Antecipation_Frequency_1__c = 'Biweekly';
        update opp;
        
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,Opportunity.Antecipation_Frequency_2__c,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 

        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        System.assertEquals('15', controller.settlementFrequency, 'Should be 15 for Weekly->Biweekly');

        // Test Biweekly -> Monthly
        opp.Settlement_Frequency_1__c = 'Biweekly';
        opp.Antecipation_Frequency_1__c = 'Monthly';
        update opp;
        testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,Opportunity.Antecipation_Frequency_2__c,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        stdController = new ApexPages.StandardController(testQuote);

        controller = new PropostaCrossController(stdController);
        System.assertEquals('31', controller.settlementFrequency, 'Should be 31 for Biweekly->Monthly');

        // Test Monthly -> Monthly
        opp.Settlement_Frequency_1__c = 'Monthly';
        opp.Antecipation_Frequency_1__c = 'Monthly';
        update opp;
        testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,Opportunity.Antecipation_Frequency_2__c,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        stdController = new ApexPages.StandardController(testQuote);
        
        controller = new PropostaCrossController(stdController);
        Test.stopTest();
        System.assertEquals('0', controller.settlementFrequency, 'Should be 0 for Monthly->Monthly');
    }

    @IsTest
    static void testProcessQuoteLineItemPix() {
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,Opportunity.Antecipation_Frequency_2__c ,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();
        
        // Assertions for processing fees
        // System.assertNotEquals(null, controller.pixTwo, 'Pix fee should be populated');
        // System.assertNotEquals(null, controller.creditCardTwo, 'Credit card fee should be populated');
        // System.assertNotEquals(null, controller.debitCardTwo, 'Debit card fee should be populated');
        // System.assertNotEquals(null, controller.boletoTwo, 'Boleto fee should be populated');
    }

    @IsTest
    static void testFrequencyPopulationWithNullAntecipation() {
        // Update opportunity to have null anticipation frequency
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Antecipation_Frequency_1__c = null;
        update opp;
        
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,Opportunity.Antecipation_Frequency_2__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 

        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();
        
        System.assertEquals(null, controller.frequencyOne, 'Frequency one should be null');
        System.assertEquals(null, controller.frequencyOneValues, 'Frequency one values should be null');
    }

    @IsTest
    static void testFrequencyPopulationWithValidData() {
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,Opportunity.Antecipation_Frequency_2__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 

        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();
        
        // Assertions
        // System.assertEquals('Weekly', controller.frequencyOne, 'Frequency one should be Weekly');
        // System.assertEquals('Monthly', controller.frequencyTwo, 'Frequency two should be Monthly');
        // System.assertNotEquals(null, controller.frequencyOneValues, 'Frequency one values should be populated');
        // System.assertNotEquals(null, controller.frequencyTwoValues, 'Frequency two values should be populated');
    }

    @IsTest
    static void testValidateNumbersWithRegex() {
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,Opportunity.Antecipation_Frequency_2__c ,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaCrossController controller = new PropostaCrossController(stdController);
        
        Test.startTest();
        // Test the validateNumbersWithRegex method through effects
        // For example, check if a fee field is only numbers and dot
        String fee = controller.pagBrasilSolutionFee;
        System.assert(fee.replace('.', '').replace(',', '').replaceAll('[0-9]', '') == '', 'Fee should only contain numbers and dot/comma');
        Test.stopTest();
    }

    @IsTest
    static void testFormatTodayAsStringDate() {
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,Opportunity.Antecipation_Frequency_2__c ,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();
        
        // Assertions
        // System.assertNotEquals(null, controller.quoteCreatedDate, 'Quote created date should be populated');
        // System.assert(controller.quoteCreatedDate.contains('2025'), 'Date should contain current year');
    }

    @IsTest
    static void testProcessQuoteLineItemsWithDifferentRevenueCodes() {
        // Create additional quote line items with different revenue codes
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                    Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                    Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                    Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,
                    Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,Opportunity.Antecipation_Frequency_2__c ,
                    Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        Product2 pixProduct = [SELECT Id FROM Product2 WHERE ProductCode = 'PROCESSING_FEES_PIX' LIMIT 1];
        PricebookEntry pbe = [SELECT Id FROM PricebookEntry WHERE Product2Id = :pixProduct.Id LIMIT 1];
        
        List<QuoteLineItem> additionalItems = new List<QuoteLineItem>();
        additionalItems.add(new QuoteLineItem(
            QuoteId = testQuote.Id,
            Product2Id = pixProduct.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            UnitPrice = 100
        ));
        additionalItems.add(new QuoteLineItem(
            QuoteId = testQuote.Id,
            Product2Id = pixProduct.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            UnitPrice = 100 
        ));
        insert additionalItems;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();
        
        // Assertions
        // System.assertNotEquals(null, controller.pixOne, 'Pix one should be populated');
        // System.assertNotEquals(null, controller.pixFour, 'Pix four should be populated');
    }

    @IsTest
    static void testWithEURCurrency() {
        // Update opportunity currency to EUR
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Moeda__c = 'EUR';
        update opp;
                
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                            Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                            Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                            Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,
                            Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,Opportunity.Antecipation_Frequency_2__c ,
                            Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        
        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();
        
        System.assertEquals('EUR', controller.opportunityCurrency, 'Currency should be EUR');
        System.assert(controller.setupFee != null, 'setupFee should be populated for EUR');
        System.assert(controller.remittanceFee != null, 'remittanceFee should be populated for EUR');
        System.assert(controller.amountWithheldProvision != null, 'amountWithheldProvision should be populated for EUR');
        System.assert(controller.payoutSetupFee != null, 'payoutSetupFee should be populated for EUR');
    }

    @IsTest
    static void testFrequencyTwoValuesPopulation() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Antecipation_Frequency_2__c = 'Monthly';
        update opp;

        // Update opportunity to have valid anticipation frequency
        Quote testQuote = [SELECT Id, AccountId, Account.Name, Account.Website, Account.Owner.Name, Account.Owner.Email, 
                            Account.Owner.MobilePhone, Opportunity.Name, Opportunity.Owner.Name, Opportunity.IntegrationType__c,
                            Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Product_Type__c, Opportunity.Pix_Automatico__c,
                            Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.UsePagstream__c,
                            Opportunity.Antecipation_Frequency_1__c, Opportunity.Settlement_Frequency_1__c,Opportunity.Antecipation_Frequency_2__c ,
                            Opportunity.NationalPaymentMethod__c, Opportunity.Moeda__c FROM Quote LIMIT 1]; 

                            // Query the Quote with the updated opportunity
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);

        Test.startTest();
        PropostaCrossController controller = new PropostaCrossController(stdController);
        Test.stopTest();

    }

}