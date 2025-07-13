@isTest
private class HomologationFormCreateTest {
    @testSetup
    static void setup() {
        Account acc = new Account(
        	Name = 'QuoteTriggerHandler First Account',
            Type = 'Nacional (NB)',
            Legal_Business_Name__c = 'First Account Legal Business Name',
            Billing_Country__c = 'Brazil',
            Contacts_Amount__c = 1
        );
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'Opportunity NB',
            StageName = 'Discovery',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'www.site.com',
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'API',
            IntegrationType__c = 'Salesforce',
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123,
            PaymentRecurrence__c = 'Não',
            Product_Type__c = 'Physical',
            Segmento__c = 'Gaming',
            nb_receita_mensal__c = 5000.00,
            AccountId = acc.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly'
        );
        insert opp;
    }

    static testMethod void testSplitString_SingleUrl() {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        HomologationFormCreate.FlowInputs input = new HomologationFormCreate.FlowInputs();
        input.url = 'https://site.com';
        input.opportunityId = opp.Id;
        input.accountId = opp.AccountId;
        Test.startTest();
        HomologationFormCreate.splitString(new List<HomologationFormCreate.FlowInputs>{input});
        Test.stopTest();
        List<HomologationForm__c> forms = [SELECT Name, URL__c FROM HomologationForm__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(1, forms.size());
        System.assertEquals('https://site.com', forms[0].URL__c);
    }

    static testMethod void testSplitString_MultipleUrls() {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        HomologationFormCreate.FlowInputs input = new HomologationFormCreate.FlowInputs();
        input.url = 'https://a.com;https://b.com;https://c.com';
        input.opportunityId = opp.Id;
        input.accountId = opp.AccountId;
        Test.startTest();
        HomologationFormCreate.splitString(new List<HomologationFormCreate.FlowInputs>{input});
        Test.stopTest();
        List<HomologationForm__c> forms = [SELECT Name, URL__c FROM HomologationForm__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(3, forms.size());
    }

    static testMethod void testSplitString_NullInputs() {
        Test.startTest();
        HomologationFormCreate.splitString(null);
        Test.stopTest();
        System.assertEquals(0, [SELECT count() FROM HomologationForm__c]);
    }

    static testMethod void testSplitString_NullUrl() {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        HomologationFormCreate.FlowInputs input = new HomologationFormCreate.FlowInputs();
        input.url = null;
        input.opportunityId = opp.Id;
        input.accountId = opp.AccountId;
        Test.startTest();
        HomologationFormCreate.splitString(new List<HomologationFormCreate.FlowInputs>{input});
        Test.stopTest();
        System.assertEquals(0, [SELECT count() FROM HomologationForm__c]);
    }

    static testMethod void testSplitString_NullOpportunityId() {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        HomologationFormCreate.FlowInputs input = new HomologationFormCreate.FlowInputs();
        input.url = 'https://site.com';
        input.opportunityId = null;
        input.accountId = opp.AccountId;
        Test.startTest();
        HomologationFormCreate.splitString(new List<HomologationFormCreate.FlowInputs>{input});
        Test.stopTest();
        System.assertEquals(0, [SELECT count() FROM HomologationForm__c]);
    }
}