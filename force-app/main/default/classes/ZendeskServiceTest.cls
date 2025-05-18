@isTest
public class ZendeskServiceTest {

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
    static void createTicketSuccess() {
        String mockResponse = '{"ticket": {"id": "12345"},"upload": {"token": "abcdef12345"}}';
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setBody(mockResponse);
        mockHttpResponse.setStatusCode(201);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockHttpResponse));

        Opportunity opp = [
        SELECT Id, AccountId, Priority__c, BusinessModel__c,
        DateAccountCreation__c, Account.Name
        FROM Opportunity 
        WHERE Name = 'Opp teste' 
        LIMIT 1];

        List<String> uploads = new List<String>{'file1.png', 'file2.png'};

        ZendeskTicketWrapper.TicketCheck ticketCheck = new ZendeskTicketWrapper.TicketCheck();
        ticketCheck.pagShieldActivationCheck = true;
        ticketCheck.paymentMethodsInFooter = false;
        ticketCheck.logoInsertionInBoleto = false;
        ticketCheck.reclameAqui = false;
        ticketCheck.pods = false;
        ticketCheck.visualIdentityManualRequest = false;
        ticketCheck.welcomeEmailAndTrainingLinks = true;
        ticketCheck.triggerIndication = 'SIM';

        String organizationId = '12345';

        ZendeskTicketWrapper zendeskWrapper = new ZendeskTicketWrapper(opp, uploads, ticketCheck, organizationId);

        ZendeskService zendeskService = new ZendeskService();

        Test.startTest();
        String ticketId = zendeskService.createTicket(zendeskWrapper);
        Test.stopTest();

        System.assertNotEquals(null, ticketId, 'Ticket ID should not be null.');
        System.assertEquals('12345', ticketId, 'Ticket ID should match the mock response.');
    }

    @isTest
    static void createTicketError() {
        Opportunity opp = [
            SELECT Id, AccountId, Priority__c, BusinessModel__c,
            DateAccountCreation__c, Account.Name 
            FROM Opportunity 
            WHERE Name = 'Opp teste' 
            LIMIT 1
        ];

        List<String> uploads = new List<String>{'file1.png', 'file2.png'};

        ZendeskTicketWrapper.TicketCheck ticketCheck = new ZendeskTicketWrapper.TicketCheck();
        ticketCheck.pagShieldActivationCheck = true;
        ticketCheck.paymentMethodsInFooter = false;
        ticketCheck.logoInsertionInBoleto = false;
        ticketCheck.reclameAqui = false;
        ticketCheck.pods = false;
        ticketCheck.visualIdentityManualRequest = false;
        ticketCheck.welcomeEmailAndTrainingLinks = true;
        ticketCheck.triggerIndication = 'SIM';

        String organizationId = '12345';

        ZendeskTicketWrapper zendeskWrapper = new ZendeskTicketWrapper(opp, uploads, ticketCheck, organizationId);

        ZendeskService zendeskService = new ZendeskService();

        try {
            Test.startTest();
            String ticketId = zendeskService.createTicket(zendeskWrapper);
            Test.stopTest();
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains('Script'), 'Error message should have been thrown.');
        }
    }

    @isTest
    static void createTicketStatusCodeError() {
        String mockResponse = '{"ticket": {"id": "12345"},"upload": {"token": "abcdef12345"}}';
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setBody(mockResponse);
        mockHttpResponse.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockHttpResponse));

        Opportunity opp = [
        SELECT Id, AccountId, Priority__c, BusinessModel__c,
        DateAccountCreation__c, Account.Name
        FROM Opportunity 
        WHERE Name = 'Opp teste' 
        LIMIT 1];

        List<String> uploads = new List<String>{'file1.png', 'file2.png'};

        ZendeskTicketWrapper.TicketCheck ticketCheck = new ZendeskTicketWrapper.TicketCheck();
        ticketCheck.pagShieldActivationCheck = true;
        ticketCheck.paymentMethodsInFooter = false;
        ticketCheck.logoInsertionInBoleto = false;
        ticketCheck.reclameAqui = false;
        ticketCheck.pods = false;
        ticketCheck.visualIdentityManualRequest = false;
        ticketCheck.welcomeEmailAndTrainingLinks = true;
        ticketCheck.triggerIndication = 'SIM';

        String organizationId = '12345';

        ZendeskTicketWrapper zendeskWrapper = new ZendeskTicketWrapper(opp, uploads, ticketCheck, organizationId);

        ZendeskService zendeskService = new ZendeskService();

        try {
            Test.startTest();
            String ticketId = zendeskService.createTicket(zendeskWrapper);
            Test.stopTest();
            System.assert(false, 'An exception should have been thrown for status 200.');
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains('exception'), 'Error should have been thrown for status 200.');
        }
    }

    @isTest
    static void createAttachSuccess() {
        String mockResponse = '{"ticket": {"id": "12345"},"upload": {"token": "abcdef12345"}}';
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setBody(mockResponse);
        mockHttpResponse.setStatusCode(201);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockHttpResponse));

        ZendeskService service = new ZendeskService();
        Blob fileBlob = Blob.valueOf('Test content');
        String fileName = 'TestFile.json';

        Test.startTest();
        String token = service.createAttach(fileBlob, fileName, 'json');
        Test.stopTest();

        System.assertNotEquals(null, token, 'Token should not be null.');
        System.assertEquals('abcdef12345', token, 'Token should match the mock response.');
    }

    @isTest
    static void createAttachStatusCodeError() {
        String mockResponse = '{"ticket": {"id": "12345"},"upload": {"token": "abcdef12345"}}';
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setBody(mockResponse);
        mockHttpResponse.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockHttpResponse));

        ZendeskService service = new ZendeskService();
        Blob fileBlob = Blob.valueOf('Test content');
        String fileName = 'TestFile.json';

        try {
            Test.startTest();
            String token = service.createAttach(fileBlob, fileName, 'json');
            Test.stopTest();
            System.assert(false, 'An exception should have been thrown for status 200.');
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains('exception'), 'Error should have been thrown for status 200.');
        }
    }

    @isTest
    static void createAttachError() {
        ZendeskService service = new ZendeskService();
        Blob fileBlob = Blob.valueOf('Test content');
        String fileName = 'TestFile.json';

        try {
            Test.startTest();
            String token = service.createAttach(fileBlob, fileName, 'json');
            Test.stopTest();
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains('Script'), 'Error message should have been thrown.');
        }
    }

    @isTest
    static void getOrganizationSuccess() {
        String mockResponse = '{"organization": {"id": 12345, "name": "Test Organization"}}';
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setBody(mockResponse);
        mockHttpResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockHttpResponse));        
        
        String filter = 'Test Organization';

        ZendeskService service = new ZendeskService();

        Test.startTest();
        String response = service.getOrganization(filter);
        Test.stopTest();

        System.assertNotEquals(null, response, 'Response should not be null.');
    }

    @isTest
    static void createOrUpdateOrganizationSuccess() {
        String mockResponse = '{"organization": {"id": 12345, "name": "Test Organization"}}';
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setBody(mockResponse);
        mockHttpResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockHttpResponse));

        ZendeskService service = new ZendeskService();
        OrganizationWrapper orgWrapper = new OrganizationWrapper();
        orgWrapper.organization.name = 'Test Organization';

        Test.startTest();
        OrganizationWrapper response = service.createOrUpdateOrganization(orgWrapper);
        Test.stopTest();

        System.assertNotEquals(null, response, 'Response should not be null.');
        System.assertEquals('Test Organization', response.organization.name, 'Organization name should match.');
    }

    @isTest
    static void createOrUpdateOrganizationError() {
        String mockResponse = '{"organization": {"id": 12345, "name": "Test Organization"}}';
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setBody(mockResponse);
        mockHttpResponse.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockHttpResponse));

        ZendeskService service = new ZendeskService();
        OrganizationWrapper orgWrapper = new OrganizationWrapper();
        orgWrapper.organization.name = 'Test Organization';

        try {
            Test.startTest();
            OrganizationWrapper response = service.createOrUpdateOrganization(orgWrapper);
            Test.stopTest();
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains('Script'), 'Error message should have been thrown.');
        }
    }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse response;
    
        public MockHttpResponseGenerator(HttpResponse response) {
            this.response = response;
        }
        
        public HttpResponse respond(HttpRequest req) {
            return response;
        }
    }
}