@isTest
public class KYCTriggerHelperTest {

	@isTest
    static void testSetURLQuantity_withMultipleURLs() {
        KYC__c originalKYC = new KYC__c(
            Legal_Name__c = 'Test KYC',
            Store_URL__c = 'https://original.com',
            URLs_Quantity__c = 1
        );
        insert originalKYC;

        KYC__c updatedKYC = new KYC__c(
            Id = originalKYC.Id,
            Store_URL__c = ' https://one.com;https://two.com;https://three.com'
        );

        List<KYC__c> newList = new List<KYC__c>{ updatedKYC };
        Map<Id, KYC__c> oldMap = new Map<Id, KYC__c>{ originalKYC.Id => originalKYC };

        Test.startTest();
        KYCTriggerHelper.setURLQuantity(newList, oldMap);
        Test.stopTest();

        System.assertEquals(3, updatedKYC.URLs_Quantity__c);
    }
}