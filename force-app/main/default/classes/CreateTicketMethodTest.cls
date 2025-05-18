@isTest
public class CreateTicketMethodTest {

    @TestSetup
    static void makeData() {
        Account acct = new Account(
            Name = 'Conta teste',
            Filial_no_Brasil__c = 'Sim',
            Nome_Empresarial__c = 'Empresa X',
            BillingCountry = 'Brasil'
        );
        insert acct;

        Opportunity opp = new Opportunity(
            Name = 'Opp teste',
            AccountId = acct.Id,
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(30),
            ApplePay__c = false,
            Product_or_service_website_URL__c = 'https://www.google.com.br/',
            Transacoes_Mensais__c = 1213,
            BusinessModel__c = 'Intermediation'
        );
        insert opp;
    }

    @isTest
    static void testCreateTicketSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Opp teste' LIMIT 1];

        CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
        input.idOpportunity = opp.Id;
        input.priority = 'P0';
        input.organizationId = '1234';
        input.dataCreateAccount = Date.today();
        input.pagShieldActivationCheck = false;
        input.paymentMethodsInFooter = false;
        input.logoInsertionInBoleto = false;
        input.reclameAqui = false;
        input.pods = false;
        input.visualIdentityManualRequest = false;
        input.welcomeEmailAndTrainingLinks = false;
        input.triggerIndication = 'SIM';

        Test.startTest();
            CreateTicketMethod.createTicket(new List<CreateTicketMethod.FlowInputs>{ input });
        Test.stopTest();

        Opportunity updatedOpportunity = [SELECT TicketId__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertNotEquals(null, updatedOpportunity.TicketId__c, 'TicketId__c should be updated.');
        System.assertEquals('12345', updatedOpportunity.TicketId__c, 'TicketId__c should match the mocked ticketId.');
    }

    @isTest
    static void testCreateTicketFailed() {

        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Opp teste' LIMIT 1];

        CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
        input.idOpportunity = opp.Id;
        input.priority = 'High';

        Test.startTest();
        try {
            CreateTicketMethod.createTicket(new List<CreateTicketMethod.FlowInputs>{ input });
        } catch (Exception e) {
        }        
        Test.stopTest();
    }

    @isTest
    static void testCreateTicketWithNullOpportunityId() {
        CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
        input.idOpportunity = null;
        input.priority = 'High';

        Test.startTest();
        try {
            CreateTicketMethod.createTicket(new List<CreateTicketMethod.FlowInputs>{ input });
            System.assert(false, 'Expected IllegalArgumentException was not thrown.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Opportunity Id is required.', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateTicketWithNullPriority() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Opp teste' LIMIT 1];

        CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
        input.idOpportunity = opp.Id;
        input.priority = null;

        Test.startTest();
        try {
            CreateTicketMethod.createTicket(new List<CreateTicketMethod.FlowInputs>{ input });
            System.assert(false, 'Expected IllegalArgumentException was not thrown.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Priority is required.', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateTicketWithMultipleInputs() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Opp teste' LIMIT 1];

        CreateTicketMethod.FlowInputs input1 = new CreateTicketMethod.FlowInputs();
        input1.idOpportunity = opp.Id;
        input1.priority = 'High';

        CreateTicketMethod.FlowInputs input2 = new CreateTicketMethod.FlowInputs();
        input2.idOpportunity = opp.Id;
        input2.priority = 'Low';

        Test.startTest();
        try {
            CreateTicketMethod.createTicket(new List<CreateTicketMethod.FlowInputs>{ input1, input2 });
            System.assert(false, 'Expected IllegalArgumentException was not thrown.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('This method requires exactly one input object.', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateTicketWithNonExistentOpportunity() {
        CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
        input.idOpportunity = '006000000000000AAA';
        input.priority = 'High';

        Test.startTest();
        try {
            CreateTicketMethod.createTicket(new List<CreateTicketMethod.FlowInputs>{ input });
            System.assert(false, 'Expected AuraHandledException was not thrown.');
        } catch (AuraHandledException e) {
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(201);
            response.setBody('{"ticket": {"id": "12345"},"upload": {"token": "abcdef12345"}}');
            return response;
        }
    }
}