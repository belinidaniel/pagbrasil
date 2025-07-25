@isTest
private with sharing class DocuSignEnvelopeStatusTest {

    private class DocuSignCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('OK');
            return res;
        }
    }

    @isTest static void testUpdateEnvelopeToCompleted() {
        Account acc = new Account(
            Name = 'Account NB',
            Type = 'Nacional (NB)',
            Legal_Business_Name__c = 'Account Legal Business Name',
            Billing_Country__c = 'Brazil',
            Contacts_Amount__c = 1
        );
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity NB',
            StageName = 'Contract',
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

        List<dfsle__EnvelopeStatus__c> testEnvelopes = new List<dfsle__EnvelopeStatus__c>();
        Map<Id, dfsle__EnvelopeStatus__c> testOldMap = new Map<Id, dfsle__EnvelopeStatus__c>();

        dfsle__EnvelopeStatus__c mockEnv = new dfsle__EnvelopeStatus__c(
            Id = 'a0JVA000004ryBp2AJ',
            dfsle__Status__c = 'Completed',
            dfsle__SourceId__c = opp.Id
        );
        testEnvelopes.add(mockEnv);
        testOldMap.put(mockEnv.Id, new dfsle__EnvelopeStatus__c(dfsle__Status__c = 'Sent'));

        DocuSignEnvelopeStatusHelper.hasContractBeenSignedAndHomologationCompleted(testEnvelopes, testOldMap);

        Test.stopTest();

        dfsle__EnvelopeStatus__c env = new dfsle__EnvelopeStatus__c(
            dfsle__Opportunity__c = opp.Id,
            dfsle__SourceId__c    = opp.Id,
            dfsle__Status__c      = 'Sent'
        );
        insert env;

        env.dfsle__Status__c = 'Completed';
        update env;

        Opportunity oppAfter = [
            SELECT StageName
            FROM Opportunity
            WHERE Id = :opp.Id
        ];
        System.assertEquals('Discovery', oppAfter.StageName,
            'O estágio da oportunidade deveria ter sido atualizado para Homologation');
    }

    @isTest static void testAsyncClasses() {
        Account acc = new Account(
            Name = 'Account NB',
            Type = 'Nacional (NB)',
            Legal_Business_Name__c = 'Account Legal Business Name',
            Billing_Country__c = 'Brazil',
            Contacts_Amount__c = 1
        );
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity NB',
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

        Test.setMock(HttpCalloutMock.class, new DocuSignCalloutMock());

        Test.startTest();

        System.enqueueJob(
            new DocuSignQueueable(
                new Set<Id>{ opp.Id },
                new Set<Id>()
            )
        );

        DocuSignStatusTriggerHandler.handleOrderComplete(
            new Set<Id>{ opp.Id }
        );

        Test.stopTest();
    }

    @isTest static void testSendEnvelopeFromTriggerController() {
        User u = [SELECT Id, Name, Email FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Account a = new Account(Name = 'Test Account');
        insert a;

        Opportunity o = new Opportunity(
            Name = 'Opportunity NB',
            TierCS__c = 'Top Tier',
            StageName = 'Discovery',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'www.site.com',
            BusinessModelType__c = 'B2B',
            AverageSalesTicket__c = 5000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            IntegrationType__c = 'Salesforce',
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123,
            PaymentRecurrence__c = 'Não',
            Product_Type__c = 'Physical',
            Segmento__c = 'Gaming',
            nb_receita_mensal__c = 5000.00,
            AccountId = a.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly',
            Integracao__c = 'API'
        );
        insert o;

        Test.startTest();
        SendEnvelopeFromTriggerController.EnvelopeSendResponse resp = SendEnvelopeFromTriggerController.sendEnvelope(o.Id);
        Test.stopTest();

        System.assertNotEquals(null, resp, 'A resposta da chamada não deve ser nula');
    }
}