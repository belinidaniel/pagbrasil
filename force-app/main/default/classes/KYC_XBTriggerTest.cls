@isTest
public class KYC_XBTriggerTest {
    @isTest
    static void testSingleUrl() {
        KYC_XB__c kyc = new KYC_XB__c(Store_URL__c = 'initial');
        insert kyc;

        kyc.Store_URL__c = 'https://store.com';
        update kyc;

        KYC_XB__c result = [SELECT URLs_Quantity__c FROM KYC_XB__c WHERE Id = :kyc.Id];
        System.assertEquals(1, result.URLs_Quantity__c);
    }

    @isTest
    static void testMultipleUrls() {
        KYC_XB__c kyc = new KYC_XB__c(Store_URL__c = 'initial');
        insert kyc;

        kyc.Store_URL__c = 'https://store1.com;https://store2.com;https://store3.com';
        update kyc;

        KYC_XB__c result = [SELECT URLs_Quantity__c FROM KYC_XB__c WHERE Id = :kyc.Id];
        System.assertEquals(3, result.URLs_Quantity__c);
    }

    @isTest
    static void testBlankUrls() {
        KYC_XB__c kyc = new KYC_XB__c(Store_URL__c = 'initial');
        insert kyc;

        kyc.Store_URL__c = ' ; ; ';
        update kyc;

        KYC_XB__c result = [SELECT URLs_Quantity__c FROM KYC_XB__c WHERE Id = :kyc.Id];
        System.assertEquals(0, result.URLs_Quantity__c);
    }

    @isTest
    static void testUnchangedStoreUrl() {
        KYC_XB__c kyc = new KYC_XB__c(Store_URL__c = 'https://store1.com;https://store2.com');
        insert kyc;

        kyc.Trade_Name__c = 'Updated Name';
        update kyc;

        KYC_XB__c result = [SELECT URLs_Quantity__c FROM KYC_XB__c WHERE Id = :kyc.Id];
        System.assertEquals(null, result.URLs_Quantity__c);
    }
}