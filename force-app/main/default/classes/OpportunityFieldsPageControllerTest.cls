@isTest
private class OpportunityFieldsPageControllerTest {

    @isTest
    static void testOpportunityFieldsPageController() {
        Opportunity opp = new Opportunity(
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
        insert opp;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', opp.Id);
        OpportunityFieldsPageController controller = new OpportunityFieldsPageController();
        Test.stopTest();
        
        System.assertNotEquals(null, controller.wrapper, 'Wrapper não deve ser nulo');
    }
}