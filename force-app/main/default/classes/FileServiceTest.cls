@IsTest
private class FileServiceTest {
    @TestSetup
    static void setupTestData() {
        KYC__c testKyc = new KYC__c(
            Legal_Name__c = 'Test KYC',
            Unique_Link__c = 'test-kyc-uuid'
        );
        insert testKyc;

        ContentVersion cv = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.txt',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert cv;

        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = testKyc.Id,
            ContentDocumentId = cv.ContentDocumentId,
            ShareType = 'V'
        );
        insert cdl;
    }
    
    @IsTest
    static void testGetFiles_Success() {
        KYC__c testKyc = [SELECT Id, Unique_Link__c FROM KYC__c LIMIT 1];

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/file/' + testKyc.Unique_Link__c;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String result = FileService.getFiles();
        Test.stopTest();

        System.assertEquals(200, res.statusCode);

        List<ContentDocumentLink> files = (List<ContentDocumentLink>) JSON.deserialize(
            result, 
            List<ContentDocumentLink>.class
        );

        System.assertEquals(1, files.size());
        System.assertEquals('Test File', files[0].ContentDocument.Title);
    }
    
    @IsTest
    static void testGetFiles_InvalidKycUuid() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/file/invalid-uuid';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String result = FileService.getFiles();
        Test.stopTest();

        System.assertEquals(500, res.statusCode);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(true, responseMap.containsKey('error'));
    }
    
    @IsTest
    static void testDeleteFile_Success() {
        ContentDocument testDoc = [SELECT Id FROM ContentDocument LIMIT 1];

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/file/' + testDoc.Id;
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String result = FileService.deleteFile();
        Test.stopTest();

        System.assertEquals(200, res.statusCode);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals('File deleted successfully', responseMap.get('message'));
        System.assertEquals(testDoc.Id, responseMap.get('deletedDocumentId'));

        List<ContentDocument> remainingDocs = [SELECT Id FROM ContentDocument WHERE Id = :testDoc.Id];
        System.assertEquals(0, remainingDocs.size());
    }
    
    @IsTest
    static void testDeleteFile_NotFound() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/file/069000000000000';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String result = FileService.deleteFile();
        Test.stopTest();

        System.assertEquals(404, res.statusCode);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(true, responseMap.containsKey('error'));
    }
    
    @IsTest
    static void testDeleteFile_InvalidIdFormat() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/integration/file/not-a-valid-id';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        String result = FileService.deleteFile();
        Test.stopTest();

        System.assertEquals(404, res.statusCode);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(true, responseMap.containsKey('error'));
    }
}