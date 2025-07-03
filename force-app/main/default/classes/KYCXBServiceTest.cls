@isTest
public class KYCXBServiceTest {
	@testSetup
    static void setupTestData() {
		Contact contact = new Contact(
			FirstName = 'John',
			LastName = 'Doe',
			Email = 'john.doe@example.com',
			Phone = '1234567890',
			KYC_Fiscal_Code__c = 'XYZ123'
		);
		insert contact;

		KYC_XB__c kyc = new KYC_XB__c(
			Unique_Link__c = 'unique123',
			Personal_Contact__c = contact.Id,
			Legal_Name__c = 'Test Legal Name'
		);
		insert kyc;

		Contact kycContact = new Contact(
			FirstName = 'KYC_XB',
			LastName = 'Contact',
			Related_KYC_XB__c = kyc.Id,
			Email = 'related@example.com'
		);
		insert kycContact;
	}

    @isTest
	static void testGetKYC_XB() {
		System.debug('called testGetKYC_XB');

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestUri = '/services/apexrest/integration/kyc-xb/unique123';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		String response = KYCXBService.getKYC();
		Test.stopTest();

		System.assert(response.contains('unique123'), 'Expected Unique_Link__c in response');
	}

	@isTest
	static void testCreateKYC_XB() {
		System.debug('called testCreateKYC_XB');
		Contact contact = new Contact(FirstName = 'New', LastName = 'Contact');
		insert contact;

		Map<String, Object> requestBody = new Map<String, Object>{
			'Legal_Name__c' => 'Created via API',
			'Founding_Date__c' => '01/01/2024',
			'Personal_Contact__c' => contact.Id
		};

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestUri = '/services/apexrest/integration/kyc-xb';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		String response = KYCXBService.createKYC();
		Test.stopTest();

		System.assert(response.contains('id'), 'Expected Id in response');
	}

	@isTest
	static void testUpdateKYC_XB() {
		System.debug('called testUpdateKYC_XB');
		Contact contact = new Contact(FirstName = 'Update', LastName = 'Contact');
		insert contact;

		KYC_XB__c kyc = new KYC_XB__c(
			Unique_Link__c = 'toUpdate123',
			Legal_Name__c = 'Original Name'
		);
		insert kyc;

		Map<String, Object> requestBody = new Map<String, Object>{
			'Legal_Name__c' => 'Updated Legal Name',
			'Personal_Contact__c' => contact.Id,
			'Stage_Number__c' => '2',
			'Conformity__c' => true
		};

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestUri = '/services/apexrest/integration/kyc-xb/toUpdate123';
		req.httpMethod = 'PATCH';
		req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		String response = KYCXBService.updateKYC();
		Test.stopTest();

		System.assert(response.contains('id'), 'Expected updated Id in response');
	}

	@isTest
	static void testInvalidGet() {
		System.debug('called testInvalidGet');
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestUri = '/services/apexrest/integration/kyc-xb/';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		String response = KYCXBService.getKYC();
		Test.stopTest();
		System.assert(response.contains('Invalid or missing KYC record ID'), 'Expected missing ID error');
	}

	@isTest
	static void testInvalidJsonPost() {
		System.debug('called testInvalidJsonPost');
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestUri = '/services/apexrest/integration/kyc-xb';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf('Invalid JSON');
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		String response = KYCXBService.createKYC();
		Test.stopTest();

		System.assert(response.contains('Invalid JSON format'), 'Expected JSON error message');
	}

	@isTest
	static void testInvalidJsonPatch() {
		System.debug('called testInvalidJsonPatch');
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestUri = '/services/apexrest/integration/kyc-xb/unique123';
		req.httpMethod = 'PATCH';
		req.requestBody = Blob.valueOf('Invalid JSON');
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		String response = KYCXBService.updateKYC();
		Test.stopTest();

		System.assert(response.contains('Invalid JSON format'), 'Expected JSON error message');
	}

	@isTest
	static void testValidJsonPatch() {
		System.debug('called testValidJsonPatch');

		Map<String, Object> requestBody = new Map<String, Object>{
			'Founding_Date__c' => '2002-02-02'
		};

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestUri = '/services/apexrest/integration/kyc-xb/unique123';
		req.httpMethod = 'PATCH';
		req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
		String response = KYCXBService.updateKYC();
		Test.stopTest();

		System.assert(response.contains('id'), 'Expected id in response');
	}
}