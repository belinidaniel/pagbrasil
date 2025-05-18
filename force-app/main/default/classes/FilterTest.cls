@isTest
private class FilterTest {
    @isTest
    static void testRelevantChangeRecordsFilter() {
        Opportunity oldOpp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Pix',
            Product_or_service_website_URL__c = 'www.site.com',
            Transacoes_Mensais__c = 4,
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'Salesforce CC',
            Recorrencia__c = 'Yes',
            Ticket_Medio__c = 123
        );
        insert oldOpp;
        
        Opportunity newOpp = new Opportunity(Id = oldOpp.Id, Name = 'Updated Opportunity');
        
        Map<Id, SObject> oldRecords = new Map<Id, SObject>{ oldOpp.Id => oldOpp };
        List<SObject> newRecords = new List<SObject>{ newOpp };
        
        Filter filter = new Filter();
        List<SObject> changedRecords = filter.relevantChangeRecordsFilter(newRecords, oldRecords, 'Name', 'Updated Opportunity');
        
        System.assertEquals(1, changedRecords.size(), 'Deveria haver um registro alterado');
        System.assertEquals('Updated Opportunity', changedRecords[0].get('Name'));
    }
    
    @isTest
    static void testRelevantChangeRecordsFilterMultipleFields() {
        Opportunity oldOpp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Pix',
            Product_or_service_website_URL__c = 'www.site.com',
            Transacoes_Mensais__c = 4,
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'Salesforce CC',
            Recorrencia__c = 'Yes',
            Ticket_Medio__c = 123
        );
        insert oldOpp;
        
        Opportunity newOpp = new Opportunity(Id = oldOpp.Id, Name = 'Updated Opportunity', StageName = 'Closed Won');
        
        Map<Id, SObject> oldRecords = new Map<Id, SObject>{ oldOpp.Id => oldOpp };
        List<SObject> newRecords = new List<SObject>{ newOpp };
        
        Filter filter = new Filter();
        List<SObject> changedRecords = filter.relevantChangeRecordsFilter(newRecords, oldRecords, new List<String>{'Name', 'StageName'});
        
        System.assertEquals(1, changedRecords.size(), 'Deveria haver um registro alterado');
    }
    
    @isTest
    static void testRelevantChangeRecordsFilterNoChange() {
        Opportunity oldOpp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Pix',
            Product_or_service_website_URL__c = 'www.site.com',
            Transacoes_Mensais__c = 4,
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'Salesforce CC',
            Recorrencia__c = 'Yes',
            Ticket_Medio__c = 123
        );
        insert oldOpp;
        
        Opportunity newOpp = new Opportunity(Id = oldOpp.Id, Name = 'Test Opportunity');
        
        Map<Id, SObject> oldRecords = new Map<Id, SObject>{ oldOpp.Id => oldOpp };
        List<SObject> newRecords = new List<SObject>{ newOpp };
        
        Filter filter = new Filter();
        List<SObject> changedRecords = filter.relevantChangeRecordsFilter(newRecords, oldRecords, 'Name', 'Different Name');
        
        System.assertEquals(0, changedRecords.size(), 'Não deveria haver registros alterados');
    }
}