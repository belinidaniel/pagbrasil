@IsTest
public class BankOptionsServiceTest {
    @IsTest
    static void testGetBankOptions() {
        Bank_Option__c option1 = new Bank_Option__c(Number__c = 1, Description__c = 'Bank A', ISPB__c = 12345678);
        Bank_Option__c option2 = new Bank_Option__c(Number__c = 2, Description__c = 'Bank B', ISPB__c = 87654321);
        insert new List<Bank_Option__c>{ option1, option2 };

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/integration/bankoptions/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        List<Bank_Option__c> result = BankOptionsService.getBankOptions();
        Test.stopTest();

        System.assertEquals(2, result.size());
        System.assertEquals(1, result[0].Number__c);
        System.assertEquals(2, result[1].Number__c);
    }
}