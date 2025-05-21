@isTest
public class KYCServiceTest {
    static testMethod void testGetKYC() {
        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            Phone = '1234567890',
            KYC_Fiscal_Code__c = 'XYZ123'
        );
        insert contact;

        Bank_Option__c bank = new Bank_Option__c(
            ISPB__c = 123456789,
            Number__c = 1,
            Description__c = 'Sample bank'
        );
        insert bank;

        KYC__c kyc = new KYC__c(
            Unique_Link__c = 'unique123',
            Personal_Contact__c = contact.Id,
            Bank_Option__c = bank.Id,
            Legal_Name__c = 'Test Legal Name'
        );
        insert kyc;

        Contact kycContact = new Contact(
            FirstName = 'KYC',
            LastName = 'Contact',
            Related_KYC__c = kyc.Id,
            Email = 'related@example.com'
        );
        insert kycContact;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/integration/kyc/unique123';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = KYCService.getKYC();
        Test.stopTest();

        System.assert(response.contains('unique123'), 'Expected Unique_Link__c in response');
    }

    static testMethod void testCreateKYC() {
        Contact contact = new Contact(FirstName = 'New', LastName = 'Contact');
        insert contact;

        Map<String, Object> requestBody = new Map<String, Object>{
            'Legal_Name__c' => 'Created via API',
            'Founding_Date__c' => '01/01/2024',
            'Personal_Contact__c' => contact.Id
        };

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/integration/kyc';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = KYCService.createKYC();
        Test.stopTest();

        System.assert(response.contains('id'), 'Expected Id in response');
    }

    static testMethod void testUpdateKYC() {
        Contact contact = new Contact(FirstName = 'Update', LastName = 'Contact');
        insert contact;

        Bank_Option__c bank = new Bank_Option__c(ISPB__c = 987654321, Description__c = 'Patch Bank');
        insert bank;

        KYC__c kyc = new KYC__c(
            Unique_Link__c = 'toUpdate123',
            Legal_Name__c = 'Original Name'
        );
        insert kyc;

        Map<String, Object> requestBody = new Map<String, Object>{
            'Legal_Name__c' => 'Updated Legal Name',
            'Founding_Date__c' => '15/02/2023',
            'Personal_Contact__c' => contact.Id,
            'Bank_Number__c' => '987654321',
            'Stage_Number__c' => '2',
            'Conformity__c' => true
        };

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/integration/kyc/toUpdate123';
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = KYCService.updateKYC();
        Test.stopTest();

        System.assert(response.contains('id'), 'Expected updated Id in response');
    }

    static testMethod void testInvalidGet() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/integration/kyc/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = KYCService.getKYC();
        Test.stopTest();
        System.assert(response.contains('Invalid or missing KYC record ID'), 'Expected missing ID error');
    }

    static testMethod void testInvalidJsonPost() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/integration/kyc';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('Invalid JSON');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String response = KYCService.createKYC();
        Test.stopTest();

        System.assert(response.contains('Invalid JSON format'), 'Expected JSON error message');
    }
}