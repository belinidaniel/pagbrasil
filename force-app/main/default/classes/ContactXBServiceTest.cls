@IsTest
public class ContactXBServiceTest {

    @IsTest
    static void testGetSingleRecord_NotFound() {
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/integration/contact-xb/003xxxxxxxxxxxx'; // invalid ID
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        String response = ContactXBService.getSingleRecord();
        System.assert(response.contains('error'));
        System.assertEquals(500, RestContext.response.statusCode);
    }

    @IsTest
    static void testCreateContact_WithBirthdateAndOwnership() {
        KYC_XB__c kyc = new KYC_XB__c(Unique_Link__c = 'uuid-birth');
        insert kyc;

        Map<String, Object> requestBody = new Map<String, Object>{
            'LastName' => 'With Fields',
            'Email' => 'field@example.com',
            'KYC_Role__c' => 'Director',
            'Birthdate' => '01/12/1980',
            'Ownership_Percentage__c' => 35.5,
            'Related_KYC_XB__c' => kyc.Id
        };

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/integration/contact-xb/' + kyc.Unique_Link__c;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        RestContext.request = req;
        RestContext.response = new RestResponse();

        String response = ContactXBService.createContact();
        System.assert(response.contains('id'));
    }

    @IsTest
    static void testCreateContact_UpdateExisting() {
        KYC_XB__c kyc = new KYC_XB__c(Unique_Link__c = 'uuid-update');
        insert kyc;

        Contact existing = new Contact(
            LastName = 'Duplicate',
            Email = 'duplicate@example.com',
            KYC_Role__c = 'Rep',
            Related_KYC_XB__c = kyc.Id
        );
        insert existing;

        Map<String, Object> requestBody = new Map<String, Object>{
            'LastName' => 'Duplicate',
            'Email' => 'duplicate@example.com',
            'KYC_Role__c' => 'Rep'
        };

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/integration/contact-xb/' + kyc.Unique_Link__c;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        RestContext.request = req;
        RestContext.response = new RestResponse();

        String response = ContactXBService.createContact();
        System.assert(response.contains(existing.Id));
    }

    @IsTest
    static void testCreateContact_KycNotFound() {
        Map<String, Object> requestBody = new Map<String, Object>{
            'LastName' => 'Fail Case',
            'Email' => 'fail@example.com',
            'KYC_Role__c' => 'None'
        };

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/integration/contact-xb/invalid-kyc-id';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        RestContext.request = req;
        RestContext.response = new RestResponse();

        String response = ContactXBService.createContact();
        System.assert(RestContext.response.statusCode == 500);
    }

    @IsTest
    static void testParseAndCreateNewContacts_EmptyList() {
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/integration/contact-xb/empty-test';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('[]');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        String response = ContactXBService.parseAndCreateNewContacts();
        System.assertEquals('No contact was created', response);
        System.assertEquals(400, RestContext.response.statusCode);
    }

    @IsTest
    static void testDeleteContact_NoId() {
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/integration/contact-xb/';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        String response = ContactXBService.deleteContact();
        System.assertEquals(400, RestContext.response.statusCode);
        System.assert(response.contains('Missing contact ID'));
    }

    @IsTest
    static void testDeleteContact_InvalidId() {
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/integration/contact-xb/003xxxxxxxxxxxx'; // Non-existent
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        String response = ContactXBService.deleteContact();
        System.assertEquals(404, RestContext.response.statusCode);
        System.assert(response.contains('Contact not found'));
    }
}