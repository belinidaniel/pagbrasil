@isTest
public class KYCTriggerTest {
    @isTest
    static void testSingleUrl() {
        KYC__c kyc = new KYC__c(Store_URL__c = 'https://store.com');
        insert kyc;

        kyc.Store_URL__c = 'https://store1.com';
        update kyc;

        KYC__c result = [SELECT URLs_Quantity__c FROM KYC__c WHERE Id = :kyc.Id];
        System.assertEquals(1, result.URLs_Quantity__c);
    }

    @isTest
    static void testMultipleUrls() {
        KYC__c kyc = new KYC__c(Store_URL__c = 'https://store1.com');
        insert kyc;

        kyc.Store_URL__c = 'https://store1.com;https://store2.com;https://store3.com';
        update kyc;

        KYC__c result = [SELECT URLs_Quantity__c FROM KYC__c WHERE Id = :kyc.Id];
        System.assertEquals(3, result.URLs_Quantity__c);
    }

    @isTest
    static void testBlankUrls() {
        KYC__c kyc = new KYC__c(Store_URL__c = '');
        insert kyc;

        kyc.Store_URL__c = ' ; ; ';
        update kyc;

        KYC__c result = [SELECT URLs_Quantity__c FROM KYC__c WHERE Id = :kyc.Id];
        System.assertEquals(0, result.URLs_Quantity__c);
    }

    @isTest
    static void testUnchangedStoreUrl() {
        KYC__c kyc = new KYC__c(Store_URL__c = 'https://store1.com;https://store2.com');
        insert kyc;

        kyc.Trade_Name__c = 'Update Only';
        update kyc;

        KYC__c result = [SELECT URLs_Quantity__c FROM KYC__c WHERE Id = :kyc.Id];
        System.assertEquals(null, result.URLs_Quantity__c);
    }
}