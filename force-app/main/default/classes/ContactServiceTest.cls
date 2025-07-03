@IsTest
private class ContactServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test KYC record
        KYC__c testKyc = new KYC__c(
            Legal_Name__c = 'Test KYC Legal Name',
            Unique_Link__c = 'test-kyc-uuid'
        );
        insert testKyc;
        
        // Create test contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@example.com',
            Phone = '1234567890',
            KYC_Role__c = 'Director',
            Related_KYC__c = testKyc.Id
        );
        insert testContact;
    }
    
    @IsTest
    static void testGetSingleRecord_Success() {
        // Get test contact
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        // Set up REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/contact/' + testContact.Id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        Test.startTest();
        String result = ContactService.getSingleRecord();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(200, res.statusCode);
        Map<String, Object> deserializedResult = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(testContact.Id, (String) deserializedResult.get('Id'));
    }
    
    @IsTest
    static void testGetSingleRecord_InvalidId() {
        // Set up REST request with invalid ID
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/contact/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        Test.startTest();
        String result = ContactService.getSingleRecord();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(500, res.statusCode);
        Map<String, Object> deserializedResult = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(true, deserializedResult.containsKey('error'));
    }
    
    @IsTest
    static void testCreateContact_Success() {
        // Get test KYC
        KYC__c testKyc = [SELECT Id, Unique_Link__c FROM KYC__c LIMIT 1];
        
        // Set up REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/contact/' + testKyc.Unique_Link__c;
        req.httpMethod = 'POST';
        
        // Create request body
        Map<String, Object> requestBody = new Map<String, Object>{
            'FirstName' => 'New',
            'LastName' => 'Contact',
            'Email' => 'new@example.com',
            'Phone' => '9876543210',
            'KYC_Role__c' => 'Shareholder',
            'Birthdate' => '01/01/1990',
            'Ownership_Percentage__c' => 25.5
        };
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        Test.startTest();
        String result = ContactService.createContact();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(200, res.statusCode);
        Map<String, Object> deserializedResult = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(true, deserializedResult.containsKey('id'));
        
        // Verify contact was created
        Contact createdContact = [SELECT Id, FirstName, LastName, Email, Birthdate, Ownership_Percentage__c 
                                 FROM Contact 
                                 WHERE Email = 'new@example.com'];
        System.assertEquals('New', createdContact.FirstName);
        System.assertEquals(Date.newInstance(1990, 1, 1), createdContact.Birthdate);
        System.assertEquals(25.5, createdContact.Ownership_Percentage__c);
    }
    
    @IsTest
    static void testCreateContact_UpdateExisting() {
        // Get existing test contact
        Contact testContact = [SELECT Id, Email, KYC_Role__c, Related_KYC__c FROM Contact LIMIT 1];
        KYC__c testKyc = [SELECT Id, Unique_Link__c FROM KYC__c WHERE Id = :testContact.Related_KYC__c];
        
        // Set up REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/contact/' + testKyc.Unique_Link__c;
        req.httpMethod = 'POST';
        
        // Create request body with same email and role
        Map<String, Object> requestBody = new Map<String, Object>{
            'FirstName' => 'Updated',
            'LastName' => 'Contact',
            'Email' => testContact.Email,
            'Phone' => '5555555555',
            'KYC_Role__c' => testContact.KYC_Role__c
        };
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        Test.startTest();
        String result = ContactService.createContact();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(200, res.statusCode);
        Map<String, Object> deserializedResult = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(testContact.Id, (String) deserializedResult.get('id'));
        
        // Verify contact was updated
        Contact updatedContact = [SELECT FirstName, Phone FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals('Updated', updatedContact.FirstName);
        System.assertEquals('5555555555', updatedContact.Phone);
    }
    
    @IsTest
    static void testParseAndCreateNewContacts_Success() {
        // Get test KYC
        KYC__c testKyc = [SELECT Id, Unique_Link__c FROM KYC__c LIMIT 1];
        
        // Set up REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/contact/' + testKyc.Unique_Link__c;
        req.httpMethod = 'PUT';
        
        // Create request body with list of contacts
        List<Contact> contacts = new List<Contact>{
            new Contact(
                FirstName = 'First',
                LastName = 'Contact',
                Email = 'first@example.com',
                Related_KYC__c = testKyc.Id
            ),
            new Contact(
                FirstName = 'Second',
                LastName = 'Contact',
                Email = 'second@example.com',
                Related_KYC__c = testKyc.Id
            )
        };
        req.requestBody = Blob.valueOf(JSON.serialize(contacts));
        
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        Test.startTest();
        String result = ContactService.parseAndCreateNewContacts();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(200, res.statusCode);
        System.assertEquals('Contacts synced successfully', result);
        
        // Verify contacts were created
        List<Contact> createdContacts = [SELECT Id FROM Contact WHERE Email IN ('first@example.com', 'second@example.com')];
        System.assertEquals(2, createdContacts.size());
    }
    
    @IsTest
    static void testParseAndCreateNewContacts_EmptyList() {
        // Set up REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/contact/test-uuid';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('[]');
        
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        Test.startTest();
        String result = ContactService.parseAndCreateNewContacts();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(400, res.statusCode);
        System.assertEquals('No contact was created', result);
    }
    
    @IsTest
    static void testDeleteContact_Success() {
        // Get test contact
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        // Set up REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/contact/' + testContact.Id;
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        Test.startTest();
        String result = ContactService.deleteContact();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(204, res.statusCode);
        System.assertEquals(null, result);
        
        // Verify contact was deleted
        List<Contact> remainingContacts = [SELECT Id FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(0, remainingContacts.size());
    }
    
    @IsTest
    static void testDeleteContact_NotFound() {
        // Set up REST request with invalid ID
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/contact/001000000000000';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        Test.startTest();
        String result = ContactService.deleteContact();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(404, res.statusCode);
        Map<String, Object> deserializedResult = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(true, deserializedResult.containsKey('error'));
    }
    
    @IsTest
    static void testCreateContact_InvalidJSON() {
        // Set up REST request with invalid JSON
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/contact/test-uuid';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('invalid json');
        
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        Test.startTest();
        String result = ContactService.createContact();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(400, res.statusCode);
    }
    
    @IsTest
    static void testCreateContact_DmlException() {
        // Get test KYC
        KYC__c testKyc = [SELECT Id, Unique_Link__c FROM KYC__c LIMIT 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/integration/contact/' + testKyc.Unique_Link__c;
        req.httpMethod = 'POST';
    
        // Missing required LastName to force DmlException
        Map<String, Object> requestBody = new Map<String, Object>{
            'FirstName' => 'NoLastName',
            'Email' => 'dmlexception@example.com',
            'KYC_Role__c' => 'Director'
        };
        req.requestBody = Blob.valueOf(JSON.serialize(requestBody));
        RestContext.request = req;
        RestContext.response = res;
    
        Test.startTest();
        String result = ContactService.createContact();
        Test.stopTest();
    
        System.assertEquals(400, res.statusCode, 'Should return 400 for DML error');
        System.assert(result.contains('REQUIRED_FIELD_MISSING'), 'Should contain DML error message');
    }
    
    @IsTest
    static void testCreateContact_GenericException() {
        // Get test KYC
        KYC__c testKyc = [SELECT Id, Unique_Link__c FROM KYC__c LIMIT 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/integration/contact/' + testKyc.Unique_Link__c;
        req.httpMethod = 'POST';
    
        // Passa um valor inesperado para causar Exception (Blob vazio)
        req.requestBody = null;
        RestContext.request = req;
        RestContext.response = res;
    
        Test.startTest();
        String result = ContactService.createContact();
        Test.stopTest();
    
        System.assertEquals(500, res.statusCode, 'Should return 500 for generic exception');
        System.assert(result != null, 'Should return error message');
    }
    
    @IsTest
    static void testParseAndCreateNewContacts_JSONException() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/integration/contact/test-uuid';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf('invalid json');
        RestContext.request = req;
        RestContext.response = res;
    
        Test.startTest();
        String result = ContactService.parseAndCreateNewContacts();
        Test.stopTest();
    
        System.assertEquals(400, res.statusCode, 'Should return 400 for JSON parse error');
        System.assert(result != null, 'Should return error message');
    }
    
    @IsTest
    static void testParseAndCreateNewContacts_DmlException() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/integration/contact/test-uuid';
        req.httpMethod = 'PUT';
    
        // Lista com contato sem LastName (campo obrigatório)
        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName = 'NoLastName')
        };
        req.requestBody = Blob.valueOf(JSON.serialize(contacts));
        RestContext.request = req;
        RestContext.response = res;
    
        Test.startTest();
        String result = ContactService.parseAndCreateNewContacts();
        Test.stopTest();
    
        System.assertEquals(400, res.statusCode, 'Should return 400 for DML error');
        System.assert(result.contains('REQUIRED_FIELD_MISSING'), 'Should contain DML error message');
    }
    
    @IsTest
    static void testParseAndCreateNewContacts_GenericException() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/integration/contact/test-uuid';
        req.httpMethod = 'PUT';
    
        // Passa um valor inesperado para causar Exception (Blob null)
        req.requestBody = null;
        RestContext.request = req;
        RestContext.response = res;
    
        Test.startTest();
        String result = ContactService.parseAndCreateNewContacts();
        Test.stopTest();
    
        System.assertEquals(500, res.statusCode, 'Should return 500 for generic exception');
        System.assert(result != null, 'Should return error message');
    }
}