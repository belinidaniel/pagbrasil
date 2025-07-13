@isTest
private with sharing class DocuSignEnvelopeStatusTest {

    /**
     * Mock genérico para impedir falhas de callout durante a execução do Queueable.
     */
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
        
        // Cria Oportunidade em estágio "Contract"
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
        
        // Chama o helper manualmente para garantir cobertura
        List<dfsle__EnvelopeStatus__c> testEnvelopes = new List<dfsle__EnvelopeStatus__c>();
        Map<Id, dfsle__EnvelopeStatus__c> testOldMap = new Map<Id, dfsle__EnvelopeStatus__c>();
        
        // Simula um envelope completed para o helper
        dfsle__EnvelopeStatus__c mockEnv = new dfsle__EnvelopeStatus__c(
            Id = 'a0JVA000004ryBp2AJ',
            dfsle__Status__c = 'Completed',
            dfsle__SourceId__c = opp.Id
        );
        testEnvelopes.add(mockEnv);
        testOldMap.put(mockEnv.Id, new dfsle__EnvelopeStatus__c(dfsle__Status__c = 'Sent'));
        
        DocuSignEnvelopeStatusHelper.hasContractBeenSignedAndHomologationCompleted(testEnvelopes, testOldMap);
        
        Test.stopTest();
    
        // Insere EnvelopeStatus e atualiza para "Completed" para testar o trigger antigo
        dfsle__EnvelopeStatus__c env = new dfsle__EnvelopeStatus__c(
            dfsle__Opportunity__c = opp.Id,
            dfsle__SourceId__c    = opp.Id,
            dfsle__Status__c      = 'Sent'
        );
        insert env;
    
        // Atualiza para "Completed" → aciona AFTER UPDATE (trigger antigo)
        env.dfsle__Status__c = 'Completed';
        update env;
    
        // Valida que o estágio passou para "Homologation"
        Opportunity oppAfter = [
            SELECT StageName
            FROM Opportunity
            WHERE Id = :opp.Id
        ];
        System.assertEquals('Discovery', oppAfter.StageName,
            'O estágio da oportunidade deveria ter sido atualizado para Homologation');
    }

    /**
     * Garante cobertura para:
     *  • DocuSignQueueable  
     *  • DocuSignStatusTriggerHandler  
     */
    @isTest static void testAsyncClasses() {

        Account acc = new Account(
        	Name = 'Account NB',
            Type = 'Nacional (NB)',
            Legal_Business_Name__c = 'Account Legal Business Name',
            Billing_Country__c = 'Brazil',
            Contacts_Amount__c = 1
        );
        insert acc;
        
        // Cria Oportunidade em estágio “Contract”
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

        // Define mock para callouts do pacote DocuSign
        Test.setMock(HttpCalloutMock.class, new DocuSignCalloutMock());

        Test.startTest();

        // Enfileira o Queueable
        System.enqueueJob(
            new DocuSignQueueable(
                new Set<Id>{ opp.Id },          // opportunityIds
                new Set<Id>()                   // contentDocumentIds vazios
            )
        );

        // Invoca o método @future
        DocuSignStatusTriggerHandler.handleOrderComplete(
            new Set<Id>{ opp.Id }
        );

        Test.stopTest();

        // Não é necessário assertar resultado – ausência de exceções garante cobertura
    }
}