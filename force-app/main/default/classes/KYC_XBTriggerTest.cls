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

    @isTest
    static void testKYCTrigger_NoPdfWhenNotApproved() {
        KYC_XB__c kycRecord = new KYC_XB__c(
            Trade_Name__c = 'Test KYC',
            LegalApprovalStatus__c = 'Added'
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
		KYC_XB__c kyc = new KYC_XB__c(Trade_Name__c = 'Test KYC', LegalApprovalStatus__c = 'Added');
		insert kyc;

		kyc.LegalApprovalStatus__c = 'Approved';
		Test.startTest();
		update kyc;
		Test.stopTest();

		List<ContentDocumentLink> links = [
			SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :kyc.Id
		];

		System.assertEquals('Approved', [SELECT LegalApprovalStatus__c FROM KYC_XB__c WHERE Id = :kyc.Id].LegalApprovalStatus__c);
		System.assertNotEquals(0, links.size(), 'File should be attached if status changed to Approved');
	}
}