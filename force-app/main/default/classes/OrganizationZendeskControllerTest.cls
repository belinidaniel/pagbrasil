/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-02-28
 * @last modified by  : Hersilio Belini de Oliveira
**/
@isTest
private class OrganizationZendeskControllerTest {

    @TestSetup
    static void makeData(){

        Account acct = new Account(
            Name = 'Conta teste',
            Filial_no_Brasil__c = 'Sim',
            Nome_Empresarial__c = 'Empresa X',
            BillingCountry = 'Brasil'
        );
        insert acct;

        Contact contact = new Contact(
            LastName = 'Contato teste',
            Type__c = 'Principal',
            AccountId = acct.Id
        );
        insert contact;

        Opportunity opp = new Opportunity(
            Name = 'Opp teste',
            AccountId = acct.Id,
            StageName = 'Contact',
            CloseDate = System.today().addDays(30),
            ApplePay__c = false,
            Product_or_service_website_URL__c = 'https://www.google.com.br/',
            Transacoes_Mensais__c = 1213,
            BusinessModel__c = 'Intermediation'
        );
        insert opp;
    }

    @isTest
    static void testCreateOrganization() {

        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Opp Teste' LIMIT 1];
        String organizationId = '34312421321312';
        List<String> domains = new List<String>{'google.com', 'uol.com.br'};
        String timeZone = 'America/Sao_Paulo';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpServiceMockSuccess());

        OrganizationWrapper  org = OrganizationZendeskController.createOrganization(opp.Id, organizationId, domains, timeZone);

        Test.stopTest();
    }

    @isTest
    static void testCreateOrganizationError() {

        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Opp Teste' LIMIT 1];
        String organizationId = '34312421321312';
        List<String> domains = new List<String>{'google.com', 'uol.com.br'};
        String timeZone = 'America/Sao_Paulo';

        delete [SELECT Id FROM Contact];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpServiceMockSuccess());
        Boolean error;

        try {
            OrganizationWrapper  org = OrganizationZendeskController.createOrganization(opp.Id, organizationId, domains, timeZone);
        } catch (Exception ex) {
            error = true;
        }

        Test.stopTest();

        System.assertNotEquals(false, error, 'error should be true');
    }

    @isTest
    static void testSearchOrganization() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpServiceMockSuccess());
        OrganizationZendeskController.searchOrganization('test');
        Test.stopTest();
    }

    public class HttpServiceMockSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            res.setBody('{ "id" : "34312421321312" }');
            return res;
        }
    }
}