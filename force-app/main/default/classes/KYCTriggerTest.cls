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

    @isTest
    static void testKYCTrigger_NoPdfWhenNotApproved() {
        KYC__c kycRecord = new KYC__c(
            Trade_Name__c = 'Test KYC',
            Legal_Approval_Status__c = 'Added'
        );
        insert kycRecord;

        kycRecord.Trade_Name__c = 'Updated Name';

        Test.startTest();
        update kycRecord;
        Test.stopTest();

        List<ContentDocumentLink> links = [
            SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :kycRecord.Id
        ];

        System.assertEquals(0, links.size(), 'No file should be attached if status did not change to Approved');
    }

	@isTest
	static void testAfterUpdate_TriggersQueueable() {
		KYC__c kyc = new KYC__c(Trade_Name__c = 'Test KYC', Legal_Approval_Status__c = 'Added');
		insert kyc;

		kyc.Legal_Approval_Status__c = 'Approved';
		Test.startTest();
		update kyc;
		Test.stopTest();

		List<ContentDocumentLink> links = [
			SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :kyc.Id
		];

		System.assertEquals('Approved', [SELECT Legal_Approval_Status__c FROM KYC__c WHERE Id = :kyc.Id].Legal_Approval_Status__c);
		System.assertNotEquals(0, links.size(), 'File should be attached if status changed to Approved');
	}
}