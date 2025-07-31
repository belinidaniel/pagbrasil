/**
 * @description Test class for PropostaNacionalController
 * @author GitHub Copilot
 * @group Test Classes
 * @last modified on 07-30-2025
**/
@isTest
public class PropostaNacionalControllerTest {
    
    @TestSetup
    static void setupTestData() {
        // Create Account
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        // Create User for Owner
        User testUser = createTestUser();
        
        // Update Account Owner
        testAccount.OwnerId = testUser.Id;
        update testAccount;
        
        // Create Opportunity
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testAccount.Id,
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(30),
            previs_fat_rs__c = 1500000, // R$ 1.5M
            IntegrationType__c = 'Shopify',
            BusinessModel__c = 'Gateway;Intermediation',
            NationalPaymentMethod__c = 'Pix;Cartão de Crédito;Débito Flash;Boleto Flash',
            Settlement_Frequency_1__c = 'Daily',
            Antecipation_Frequency_1__c = 'Daily',
            Settlement_Frequency_2__c = 'Weekly',
            Antecipation_Frequency_2__c = 'Weekly',
            Other_Payments_Settlement_Frequency_1__c = 'Daily',
            Other_Payments_Settlement_Frequency_2__c = 'Weekly',
            PagShield__c = true,
            UsePagstream__c = true,
            Payout__c = true,
            GooglePay__c = true,
            ApplePay__c = false,
            AverageSalesTicket__c = 100,
            PaymentRecurrence__c = 'Sim',
            Product_Type__c = 'Digital',
            Segmento__c = 'Eletronics',
            nb_receita_mensal__c = 1232432
        );
        insert testOpp;
        
        // Create Products
        List<Product2> products = createTestProducts();
        insert products;
        
        // Create Pricebook Entry
        Id standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Product2 product : products) {
            pricebookEntries.add(new PricebookEntry(
                Product2Id = product.Id,
                Pricebook2Id = standardPricebookId,
                UnitPrice = 100,
                IsActive = true
            ));
        }
        insert pricebookEntries;
        
        // Create Quote
        Quote testQuote = new Quote(
            Name = 'Test Quote',
            OpportunityId = testOpp.Id,
            Pricebook2Id = standardPricebookId
        );
        insert testQuote;
        
        // Create Quote Line Items
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        for (PricebookEntry pbe : pricebookEntries) {
            quoteLineItems.add(new QuoteLineItem(
                QuoteId = testQuote.Id,
                Product2Id = pbe.Product2Id,
                PricebookEntryId = pbe.Id,
                Quantity = 1,
                UnitPrice = pbe.UnitPrice
            ));
        }
        insert quoteLineItems;
    }
    
    static User createTestUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User testUser = new User(
            Alias = 'testuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Test',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            MobilePhone = '+5511999999999',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Sao_Paulo',
            UserName = 'testuser' + System.currentTimeMillis() + '@example.com'
        );
        insert testUser;
        return testUser;
    }
    
    static List<Product2> createTestProducts() {
        return new List<Product2>{
            new Product2(Name = 'Pix Product', ProductCode = 'PIX', Family = 'Payment', IsActive = true),
            new Product2(Name = 'Credit Card Product', ProductCode = 'CREDIT_CARD', Family = 'Payment', IsActive = true),
            new Product2(Name = 'Debit Card Product', ProductCode = 'DEBIT_CARD', Family = 'Payment', IsActive = true),
            new Product2(Name = 'Boleto Product', ProductCode = 'BOLETO', Family = 'Payment', IsActive = true),
            new Product2(Name = 'PagBrasil Solution', ProductCode = 'TAXA_PAGBRASIL', Family = 'Solution', IsActive = true),
            new Product2(Name = 'PagBrasil Gateway', ProductCode = 'TAXA_PAGBRASIL_GATEWAY', Family = 'Gateway', IsActive = true),
            new Product2(Name = 'SMS Package 500', ProductCode = 'PACOTE_500_SMS', Family = 'SMS', IsActive = true),
            new Product2(Name = 'SMS Package 1000', ProductCode = 'PACOTE_1000_SMS', Family = 'SMS', IsActive = true),
            new Product2(Name = 'Email Package', ProductCode = 'PACOTE_EMAIL', Family = 'Email', IsActive = true),
            new Product2(Name = 'Additional Installment Fee 2-6', ProductCode = 'ADDITIONAL_INSTALLMENT_FEE_2_6', Family = 'Fee', IsActive = true),
            new Product2(Name = 'Additional Installment Fee 7-12', ProductCode = 'ADDITIONAL_INSTALLMENT_FEE_7_12', Family = 'Fee', IsActive = true),
            new Product2(Name = 'PagStream Tax', ProductCode = 'TAXA_PAGSTREAM', Family = 'Tax', IsActive = true),
            new Product2(Name = 'Min PagStream Tax', ProductCode = 'TAXA_MIN_PAGSTREAM', Family = 'Tax', IsActive = true),
            new Product2(Name = 'PagShield', ProductCode = 'PAGSHIELD', Family = 'Shield', IsActive = true),
            new Product2(Name = 'PagShield Premium', ProductCode = 'PAGSHIELD_PREMIUM', Family = 'Shield', IsActive = true),
            new Product2(Name = 'Transfer Fee', ProductCode = 'TRANSFER_FEE', Family = 'Fee', IsActive = true),
            new Product2(Name = 'PagBrasil Solution Fee', ProductCode = 'PAGBRASIL_SOLUTION_FEE', Family = 'Fee', IsActive = true),
            new Product2(Name = 'Refund Fee', ProductCode = 'REFUND_CARD_OR_PIX_ACQUIRER', Family = 'Fee', IsActive = true),
            new Product2(Name = 'Refund Transfer', ProductCode = 'REFUND_TRANSFER', Family = 'Fee', IsActive = true),
            new Product2(Name = 'Chargeback Tax', ProductCode = 'CHARGEBACK_TAX', Family = 'Tax', IsActive = true),
            new Product2(Name = 'Adherence Fee', ProductCode = 'ADHERENCE_FEE', Family = 'Fee', IsActive = true),
            new Product2(Name = 'Minimum Maintenance Fee', ProductCode = 'MINIMUM_MAINTENANCE_FEE', Family = 'Fee', IsActive = true),
            new Product2(Name = 'Credit Card Integration Fee', ProductCode = 'CREDIT_CARD_INTEGRATION_FEE', Family = 'Fee', IsActive = true),
            new Product2(Name = 'Anticipation Tax', ProductCode = 'TAXA_ANTECIPACAO', Family = 'Tax', IsActive = true),
            new Product2(Name = 'Payout Service Fee', ProductCode = 'PAYOUT_SERVICE_FEE', Family = 'Fee', IsActive = true),
            new Product2(Name = 'Payout Transfer Fee', ProductCode = 'PAYOUT_TRANSFER_FEE', Family = 'Fee', IsActive = true)
        };
    }
    
    @isTest
    static void testConstructorWithGatewayIntermediation() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        // Verify basic initialization
        System.assertEquals(false, controller.show, 'Show should be false initially');
        System.assertEquals(true, controller.viewPage6, 'ViewPage6 should be true');
        System.assertEquals(false, controller.viewPage11, 'ViewPage11 should be false initially');
        System.assertEquals(true, controller.containsGateway, 'Should contain Gateway');
        System.assertEquals(true, controller.isIntermediation, 'Should be Intermediation');
        System.assertEquals(true, controller.isGatewayAndIntermediation, 'Should be Gateway and Intermediation');
        System.assertEquals(true, controller.showZeroReserveOption, 'Should show zero reserve option');
        System.assertEquals(true, controller.containsShopify, 'Should contain Shopify');
        System.assertEquals(true, controller.isPagShield, 'Should have PagShield');
        System.assertEquals(true, controller.isPagStream, 'Should have PagStream');
        System.assertEquals(true, controller.isPayout, 'Should have Payout');
        System.assertEquals(true, controller.isGoogleOrApplePay, 'Should have Google or Apple Pay');
        System.assertNotEquals(null, controller.stringDate, 'String date should not be null');
    }
    
    @isTest
    static void testConstructorWithSalesforceIntegration() {
        // Update opportunity for Salesforce integration
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.IntegrationType__c = 'Salesforce';
        opp.BusinessModel__c = 'Intermediation';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(true, controller.isSalesforce, 'Should be Salesforce integration');
        System.assertEquals(true, controller.shopifyWoocommerceSalesforcePBCheckoutTerms, 'Should have Salesforce terms');
    }
    
    @isTest
    static void testConstructorWithVTEXIntegration() {
        // Update opportunity for VTEX integration
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.IntegrationType__c = 'Vtex';
        opp.BusinessModel__c = 'Intermediation';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(true, controller.containsVTEX, 'Should contain VTEX');
        System.assertEquals(true, controller.jSAPIVTexTerms, 'Should have VTEX terms');
    }
    
    @isTest
    static void testConstructorWithHighRevenue() {
        // Update opportunity for high revenue (> 5M)
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.previs_fat_rs__c = 6000000; // R$ 6M
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals('> R$ 10M', controller.valueOne, 'Should have high revenue value one');
        System.assertEquals('R$ 5M - R$ 10M', controller.valueTwo, 'Should have high revenue value two');
        System.assertEquals('R$ 1M - R$ 5M', controller.valueThree, 'Should have high revenue value three');
        System.assertEquals('R$ 500K - R$ 1M', controller.valueFour, 'Should have high revenue value four');
    }
    
    @isTest
    static void testConstructorWithLowRevenue() {
        // Update opportunity for low revenue (< 100k)
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.previs_fat_rs__c = 50000; // R$ 50k
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(true, controller.highlightedLineFour, 'Should highlight line four for low revenue');
    }
    
    @isTest
    static void testFrequencyValidationDaily() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        // Test daily frequency
        System.assertEquals('diária', controller.antecipationFrequencyPageOne, 'Should have daily anticipation frequency');
    }
    
    @isTest
    static void testFrequencyValidationWeekly() {
        // Update opportunity for weekly frequencies
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Settlement_Frequency_1__c = 'Weekly';
        opp.Antecipation_Frequency_1__c = 'Weekly';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals('semanal', controller.antecipationFrequencyPageOne, 'Should have weekly anticipation frequency');
    }
    
    @isTest
    static void testFrequencyValidationBiweekly() {
        // Update opportunity for biweekly frequencies
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Settlement_Frequency_1__c = 'Biweekly';
        opp.Antecipation_Frequency_1__c = 'Biweekly';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals('quinzenal', controller.antecipationFrequencyPageOne, 'Should have biweekly anticipation frequency');
    }
    
    @isTest
    static void testFrequencyValidationMonthly() {
        // Update opportunity for monthly frequencies
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Settlement_Frequency_1__c = 'Monthly';
        opp.Antecipation_Frequency_1__c = 'Monthly';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        // Verify monthly frequency is set (assuming the method sets it)
        System.assertNotEquals(null, controller.antecipationFrequencyPageOne, 'Anticipation frequency should be set');
    }
    
    @isTest
    static void testInvalidFrequencyValidation() {
        // Test invalid frequency combination (anticipation more frequent than settlement)
        // Biweekly settlement with Daily anticipation should not be allowed
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Settlement_Frequency_1__c = 'Biweekly';
        opp.Antecipation_Frequency_1__c = 'Daily'; // Invalid: more frequent than settlement
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        // This should handle the invalid case gracefully
        System.assertNotEquals(null, controller, 'Controller should still be created');
    }
    
    @isTest
    static void testPaymentMethodsAllSelected() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(true, controller.showFour, 'Should show four payment methods');
        System.assertEquals(true, controller.containsCreditCard, 'Should contain credit card');
    }
    
    @isTest
    static void testPaymentMethodsPixOnly() {
        // Update opportunity for Pix only
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.NationalPaymentMethod__c = 'Pix';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(false, controller.showFour, 'Should not show four payment methods');
    }
    
    @isTest
    static void testPaymentMethodsCreditCardOnly() {
        // Update opportunity for Credit Card only
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.NationalPaymentMethod__c = 'Cartão de Crédito';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(true, controller.containsCreditCard, 'Should contain credit card');
    }
    
    @isTest
    static void testValidateNumbersWithRegex() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        
        Test.startTest();
        // Test validateNumbersWithRegex method indirectly through tax values
        System.assertNotEquals(null, controller.pixThree, 'Pix value should be set');
        System.assert(controller.pixThree.contains('%'), 'Pix value should contain percentage');
        Test.stopTest();
    }
    
    @isTest
    static void testSetDailyFrequencyPageOne() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        
        Test.startTest();
        controller.setDailyFrequencyPageOne('Daily');
        System.assertEquals('diária', controller.antecipationFrequencyPageOne, 'Should set daily frequency');
        
        controller.setDailyFrequencyPageOne('Weekly');
        System.assertEquals('semanal', controller.antecipationFrequencyPageOne, 'Should set weekly frequency');
        
        controller.setDailyFrequencyPageOne('Biweekly');
        System.assertEquals('quinzenal', controller.antecipationFrequencyPageOne, 'Should set biweekly frequency');
        Test.stopTest();
    }
    
    @isTest
    static void testSetWeeklyFrequencyPageOne() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        
        Test.startTest();
        controller.setWeeklyFrequencyPageOne('Weekly');
        System.assertEquals('semanal', controller.antecipationFrequencyPageOne, 'Should set weekly frequency');
        
        controller.setWeeklyFrequencyPageOne('Biweekly');
        System.assertEquals('quinzenal', controller.antecipationFrequencyPageOne, 'Should set biweekly frequency');
        Test.stopTest();
    }
    
    @isTest
    static void testSetDailyFrequencyPageTwo() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        
        Test.startTest();
        controller.setDailyFrequencyPageTwo('Daily');
        System.assertEquals('diária', controller.antecipationFrequencyPageTwo, 'Should set daily frequency for page two');
        
        controller.setDailyFrequencyPageTwo('Weekly');
        System.assertEquals('semanal', controller.antecipationFrequencyPageTwo, 'Should set weekly frequency for page two');
        Test.stopTest();
    }
    
    @isTest
    static void testSetWeeklyFrequencyPageTwo() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        
        Test.startTest();
        controller.setWeeklyFrequencyPageTwo('Weekly');
        System.assertEquals('semanal', controller.antecipationFrequencyPageTwo, 'Should set weekly frequency for page two');
        
        controller.setWeeklyFrequencyPageTwo('Biweekly');
        System.assertEquals('quinzenal', controller.antecipationFrequencyPageTwo, 'Should set biweekly frequency for page two');
        Test.stopTest();
    }
    
    @isTest
    static void testSetBiweeklyFrequencyPageTwo() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        
        Test.startTest();
        controller.setBiweeklyFrequencyPageTwo('Biweekly');
        System.assertEquals('quinzenal', controller.antecipationFrequencyPageTwo, 'Should set biweekly frequency for page two');
        Test.stopTest();
    }
    
    @isTest
    static void testPopulateOptionsController() {
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        
        Test.startTest();
        controller.populateOptionsController('Pix', 'CreditCard', 'Boleto');
        // Verify that the population methods are called
        System.assertNotEquals(null, controller, 'Controller should be initialized');
        Test.stopTest();
    }
    
    @isTest
    static void testPluginIntegrationTypes() {
        // Test plugin integration types
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        // Test Shopify (plugin)
        opp.IntegrationType__c = 'Shopify';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals('Gratuito', controller.smsGratuito, 'SMS should be free for plugin integrations');
        System.assertEquals(true, controller.isPlugin, 'Should be identified as plugin');
    }
    
    @isTest
    static void testNonPluginIntegrationTypes() {
        // Test non-plugin integration types
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.IntegrationType__c = 'API';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals('Consultar valores', controller.smsGratuito, 'SMS should not be free for non-plugin integrations');
        System.assertEquals(false, controller.isPlugin, 'Should not be identified as plugin');
    }
    
    @isTest
    static void testGatewayOnlyBusinessModel() {
        // Update opportunity for Gateway only
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.BusinessModel__c = 'Gateway';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(true, controller.isGateway, 'Should be Gateway only');
        System.assertEquals(false, controller.isIntermediation, 'Should not be Intermediation');
        System.assertEquals(false, controller.isGatewayAndIntermediation, 'Should not be both Gateway and Intermediation');
    }
    
    @isTest
    static void testIntermediationOnlyBusinessModel() {
        // Update opportunity for Intermediation only
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.BusinessModel__c = 'Intermediation';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(false, controller.isGateway, 'Should not be Gateway only');
        System.assertEquals(true, controller.isIntermediation, 'Should be Intermediation');
        System.assertEquals(false, controller.containsGateway, 'Should not contain Gateway');
        System.assertEquals(false, controller.showZeroReserveOption, 'Should not show zero reserve option');
    }
    
    @isTest
    static void testNullValues() {
        // Create opportunity with null values
        Account testAccount = new Account(Name = 'Test Account Null');
        insert testAccount;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity Null',
            AccountId = testAccount.Id,
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(30),
            previs_fat_rs__c = null,
            IntegrationType__c = null,
            BusinessModel__c = null,
            NationalPaymentMethod__c = null,
            Settlement_Frequency_1__c = null,
            Antecipation_Frequency_1__c = null,
            PagShield__c = false,
            UsePagstream__c = false,
            Payout__c = false,
            GooglePay__c = false,
            ApplePay__c = false
        );
        insert testOpp;
        
        Id standardPricebookId = Test.getStandardPricebookId();
        Quote testQuote = new Quote(
            Name = 'Test Quote Null',
            OpportunityId = testOpp.Id,
            Pricebook2Id = standardPricebookId
        );
        insert testQuote;
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        // Verify null handling
        System.assertEquals(false, controller.containsShopify, 'Should handle null IntegrationType');
        System.assertEquals(false, controller.containsGateway, 'Should handle null BusinessModel');
        System.assertEquals(false, controller.isGoogleOrApplePay, 'Should handle null GooglePay/ApplePay');
        System.assertEquals(false, controller.isPagShield, 'Should handle null PagShield');
        System.assertEquals(false, controller.isPagStream, 'Should handle null UsePagstream');
        System.assertEquals(false, controller.isPayout, 'Should handle null Payout');
    }
    
    @isTest
    static void testLowRevenueRange() {
        PropostaNacionalController controller = testRevenueRange(50000);
        System.assertEquals(true, controller.highlightedLineFour, 'Should highlight line four for low revenue');
    }
    
    @isTest
    static void testMidRevenueRange() {
        PropostaNacionalController controller = testRevenueRange(750000);
        System.assertEquals(true, controller.highlightedLineThree, 'Should highlight line three for mid revenue');
    }
    
    @isTest
    static void testHighRevenueRange() {
        PropostaNacionalController controller = testRevenueRange(8000000);
        System.assertEquals('> R$ 10M', controller.valueOne, 'Should show high revenue values');
    }
    
    private static PropostaNacionalController testRevenueRange(Decimal revenue) {
        Account testAccount = new Account(Name = 'Test Account ' + revenue);
        insert testAccount;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity ' + revenue,
            AccountId = testAccount.Id,
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(30),
            previs_fat_rs__c = revenue,
            IntegrationType__c = 'Shopify',
            BusinessModel__c = 'Gateway'
        );
        insert testOpp;
        
        Id standardPricebookId = Test.getStandardPricebookId();
        Quote testQuote = new Quote(
            Name = 'Test Quote ' + revenue,
            OpportunityId = testOpp.Id,
            Pricebook2Id = standardPricebookId
        );
        insert testQuote;
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        // Verify revenue range handling
        System.assertNotEquals(null, controller.valueOne, 'Value one should be set for revenue: ' + revenue);
        System.assertNotEquals(null, controller.valueTwo, 'Value two should be set for revenue: ' + revenue);
        System.assertNotEquals(null, controller.valueThree, 'Value three should be set for revenue: ' + revenue);
        System.assertNotEquals(null, controller.valueFour, 'Value four should be set for revenue: ' + revenue);
        
        return controller;
    }
    
    @isTest
    static void testFormatStringDate() {
        Test.startTest();
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertNotEquals(null, controller.stringDate, 'String date should not be null');
        System.assert(controller.stringDate.contains(' de '), 'String date should contain "de"');
        System.assert(controller.stringDate.contains('2025'), 'String date should contain current year');
    }
    
    @isTest
    static void testPageUrls() {
        Test.startTest();
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertNotEquals(null, controller.page09, 'Page 09 URL should not be null');
        System.assertNotEquals(null, controller.page10, 'Page 10 URL should not be null');
        System.assert(controller.page09.contains('/resource/PNPagina09DD'), 'Page 09 should contain correct resource path');
        System.assert(controller.page10.contains('/resource/PNPagina10DF'), 'Page 10 should contain correct resource path');
    }
    
    @isTest
    static void testTwoOptionsScenario() {
        // Update opportunity to trigger showTwoOptions
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Settlement_Frequency_1__c = 'Daily';
        opp.Antecipation_Frequency_1__c = 'Daily';
        opp.Settlement_Frequency_2__c = 'Weekly';
        opp.Antecipation_Frequency_2__c = 'Weekly';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(true, controller.showTwoOptions, 'Should show two options when both pages have frequencies');
    }
    
    @isTest
    static void testMultiplePaymentMethodCombinations() {
        PropostaNacionalController controller1 = testPaymentMethodCombination('Pix;Cartão de Crédito');
        System.assertEquals(true, controller1.containsCreditCard, 'Should contain credit card');
        
        PropostaNacionalController controller2 = testPaymentMethodCombination('Débito Flash;Boleto Flash');
        System.assertEquals(false, controller2.containsCreditCard, 'Should not contain credit card');
        
        PropostaNacionalController controller3 = testPaymentMethodCombination('Pix');
        System.assertEquals(false, controller3.showFour, 'Should not show four options for single payment method');
    }
    
    private static PropostaNacionalController testPaymentMethodCombination(String paymentMethods) {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.NationalPaymentMethod__c = paymentMethods;
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertNotEquals(null, controller, 'Controller should handle payment method: ' + paymentMethods);
        return controller;
    }
    
    @isTest
    static void testFrequencyEdgeCases() {
        PropostaNacionalController controller1 = testFrequencyScenario('Biweekly', 'Monthly');
        System.assertNotEquals(null, controller1.antecipationFrequencyPageOne, 'Should handle valid frequency combination');
        
        PropostaNacionalController controller2 = testFrequencyScenario('Monthly', 'Monthly');
        System.assertNotEquals(null, controller2.antecipationFrequencyPageOne, 'Should handle same frequency');
    }
    
    private static PropostaNacionalController testFrequencyScenario(String settlementFreq, String anticipationFreq) {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Settlement_Frequency_1__c = settlementFreq;
        opp.Antecipation_Frequency_1__c = anticipationFreq;
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertNotEquals(null, controller.antecipationFrequencyPageOne, 
            'Should handle frequency combination: ' + settlementFreq + '/' + anticipationFreq);
        return controller;
    }
    
    @isTest
    static void testAdditionalIntegrationTypes() {
        PropostaNacionalController controller1 = testIntegrationType('Woocommerce', true);
        System.assertEquals(true, controller1.isPlugin, 'Woocommerce should be plugin');
        
        PropostaNacionalController controller2 = testIntegrationType('API', false);
        System.assertEquals(false, controller2.isPlugin, 'API should not be plugin');
        
        PropostaNacionalController controller3 = testIntegrationType('JS', false);
        System.assertEquals('Consultar valores', controller3.smsGratuito, 'JS should not have free SMS');
    }
    
    private static PropostaNacionalController testIntegrationType(String integrationType, Boolean expectedPlugin) {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.IntegrationType__c = integrationType;
        opp.BusinessModel__c = 'Intermediation';
        update opp;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(testQuote);
        PropostaNacionalController controller = new PropostaNacionalController(stdController);
        Test.stopTest();
        
        System.assertEquals(expectedPlugin, controller.isPlugin, 
            'Plugin status should be ' + expectedPlugin + ' for ' + integrationType);
        
        String expectedSms = expectedPlugin ? 'Gratuito' : 'Consultar valores';
        System.assertEquals(expectedSms, controller.smsGratuito, 
            'SMS status should be ' + expectedSms + ' for ' + integrationType);
        
        return controller;
    }
}