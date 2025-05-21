@IsTest
private class KYCPdfControllerTest {

    @IsTest
    static void testKYCPdfController() {
        KYC__c kycRecord = new KYC__c(Legal_Name__c = 'Test KYC');
        insert kycRecord;

        Contact personal = new Contact(LastName = 'Personal', KYC_Role__c = 'personal', Related_KYC__c = kycRecord.Id);
        Contact owner = new Contact(LastName = 'Owner', KYC_Role__c = 'owner', Related_KYC__c = kycRecord.Id);
        Contact representative = new Contact(LastName = 'Representative', KYC_Role__c = 'representative', Related_KYC__c = kycRecord.Id);
        Contact contract = new Contact(LastName = 'Contract', KYC_Role__c = 'contract', Related_KYC__c = kycRecord.Id);
        Contact billing = new Contact(LastName = 'Billing', KYC_Role__c = 'billing', Related_KYC__c = kycRecord.Id);
        Contact technical = new Contact(LastName = 'Technical', KYC_Role__c = 'technical', Related_KYC__c = kycRecord.Id);
        Contact channel = new Contact(LastName = 'Channel', KYC_Role__c = 'channel', Related_KYC__c = kycRecord.Id);
        Contact refund = new Contact(LastName = 'Refund', KYC_Role__c = 'refund', Related_KYC__c = kycRecord.Id);
        insert new List<Contact>{ personal, owner, representative, contract, billing, technical, channel, refund };

        ContentVersion contentVersion = new ContentVersion(
            Title = 'cpf_document',
            PathOnClient = 'cpf_document.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;

        ContentDocumentLink contentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId,
            LinkedEntityId = kycRecord.Id,
            ShareType = 'V'
        );
        insert contentLink;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', kycRecord.Id);
        KYCPdfController controller = new KYCPdfController();
        Test.stopTest();

        System.assertNotEquals(null, controller.kyc);
        System.assert(controller.hasCpfFiles);
        System.assertNotEquals(null, controller.personalContact);
        System.assert(controller.ownerContacts.size() > 0);
        System.assert(controller.representativeContacts.size() > 0);
        System.assert(controller.contractContacts.size() > 0);
        System.assert(controller.billingContacts.size() > 0);
        System.assert(controller.technicalContacts.size() > 0);
        System.assert(controller.channelContacts.size() > 0);
        System.assert(controller.refundContacts.size() > 0);
    }
}