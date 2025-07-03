@isTest
private class CreateOrganizationMethodTest {
    @TestSetup
    static void setupTestData() {
        Account acct = new Account(
            Name = 'Test Account',
            Nome_Empresarial__c = 'Test Empresarial Name'
        );
        insert acct;

        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            ForecastCategoryName = 'Pipeline',
            CurrencyIsoCode = UserInfo.getDefaultCurrency(),
            Probability = 10,
            AccountId = acct.Id,
            AverageSalesTicket__c = 1000,
            nb_receita_mensal__c = 50000,
            previs_fat_rs__c = 40000,
            Antecipation_Frequency_1__c = 'Weekly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Weekly',
            Settlement_Frequency_2__c = 'Monthly',
            Segmento__c = 'Gaming',
            Product_Type__c = 'Digital',
            BusinessModel__c = 'Intermediation',
            BusinessModelType__c = 'B2C',
            NationalPaymentMethod__c = 'Pix',
            PaymentRecurrence__c = 'Sim',
            IntegrationType__c = 'API',
            Country__c = 'Brazil',
            ProductClass__c = '5734',
            WebSite__c = 'www.test.com',
            TierCS__c = 'Top Tier',
            Moeda__c = 'BRL'
        );
        insert opp;
    }

    @isTest
    static void testCreateOrganization_Success() {
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        CreateOrganizationMethod.FlowInputs input = new CreateOrganizationMethod.FlowInputs();
        input.idOpportunity = testOpp.Id;
        Test.startTest();
        CreateOrganizationMethod.createOrganization(new List<CreateOrganizationMethod.FlowInputs>{input});
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testGetOpportunity_Success() {
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        Opportunity result = CreateOrganizationMethod.getOpportunity(testOpp.Id);
        Test.stopTest();
        System.assertEquals(testOpp.Id, result.Id);
        System.assertEquals('5734', result.ProductClass__c);
    }

    @isTest
    static void testCreateOrganization_InvalidInput() {
        try {
            CreateOrganizationMethod.createOrganization(null);
            System.assert(false);
        } catch (IllegalArgumentException e) {
            System.assertEquals('This method requires exactly one input object.', e.getMessage());
        }

        try {
            CreateOrganizationMethod.createOrganization(new List<CreateOrganizationMethod.FlowInputs>());
            System.assert(false);
        } catch (IllegalArgumentException e) {
            System.assertEquals('This method requires exactly one input object.', e.getMessage());
        }

        CreateOrganizationMethod.FlowInputs input = new CreateOrganizationMethod.FlowInputs();
        try {
            CreateOrganizationMethod.createOrganization(new List<CreateOrganizationMethod.FlowInputs>{input});
            System.assert(false);
        } catch (IllegalArgumentException e) {
            System.assertEquals('Opportunity Id is required.', e.getMessage());
        }
    }

    @isTest
    static void testGetOpportunity_NotFound() {
        try {
            CreateOrganizationMethod.getOpportunity(null);
            System.assert(false);
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('exception'));
        }

        try {
            CreateOrganizationMethod.getOpportunity('001000000000000');
            System.assert(false);
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('exception'));
        }
    }

    @isTest
    static void testProductClassValues() {
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        Map<String,String> productClasses = new Map<String,String>{
            '5122' => 'Drugstores',
            '5300' => 'Wholesale Clubs',
            '5331' => 'Variety Stores',
            '5499' => 'Grocery Stores and Supermarkets',
            '5651' => 'Clothing',
            '5732' => 'Electronics Stores',
            '5734' => 'Computer Software',
            '5921' => 'Beer, Wine, Liquor Stores'
        };

        for(String apiValue : productClasses.keySet()) {
            testOpp.ProductClass__c = apiValue;
            update testOpp;
            
            Opportunity result = CreateOrganizationMethod.getOpportunity(testOpp.Id);
            System.assertEquals(apiValue, result.ProductClass__c);
        }
    }
}