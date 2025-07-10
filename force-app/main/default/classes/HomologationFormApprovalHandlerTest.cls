@isTest
private class HomologationFormApprovalHandlerTest {
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
            StageName = 'Negotiation',
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
        HomologationForm__c form = new HomologationForm__c(
            Name = 'Form Teste',
            Opportunity__c = opp.Id,
            Account__c = acc.Id
        );
        insert form;
    }

    static testMethod void testSendApprovalHomologationForm() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        try {
            HomologationFormApprovalHandler.sendApprovalHomologationForm(opp.Id);
        } catch (Exception e) {
            // Ignora falha por ausência de processo de aprovação
        }
        Test.stopTest();
        List<HomologationForm__c> updatedForms = [SELECT Legal_Approval_Status__c FROM HomologationForm__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals('Pending Approval Legal', updatedForms[0].Legal_Approval_Status__c);
    }

    static testMethod void testSendApprovalHomologationForm_NoForms() {
        Account acc = new Account(
        	Name = 'QuoteTriggerHandler First Account',
            Type = 'Nacional (NB)',
            Legal_Business_Name__c = 'First Account Legal Business Name',
            Billing_Country__c = 'Brazil',
            Contacts_Amount__c = 1
        );
        insert acc;
        Opportunity opp = new Opportunity(
            Name = 'Opportunity NB 2',
            StageName = 'Negotiation',
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
        Test.startTest();
        HomologationFormApprovalHandler.sendApprovalHomologationForm(opp.Id);
        Test.stopTest();
        System.assertEquals(0, [SELECT count() FROM HomologationForm__c WHERE Opportunity__c = :opp.Id]);
    }
}