@IsTest
private class KYCPdfControllerTest {

    @testSetup
    static void setupData() {
        KYC__c kycRecord = new KYC__c(Legal_Name__c = 'Test KYC');
        insert kycRecord;

        List<Contact> contacts = new List<Contact>{
            new Contact(LastName = 'Personal', KYC_Role__c = 'personal', Related_KYC__c = kycRecord.Id),
            new Contact(LastName = 'Owner', KYC_Role__c = 'owner', Related_KYC__c = kycRecord.Id),
            new Contact(LastName = 'Representative', KYC_Role__c = 'representative', Related_KYC__c = kycRecord.Id),
            new Contact(LastName = 'Contract', KYC_Role__c = 'contract', Related_KYC__c = kycRecord.Id),
            new Contact(LastName = 'Billing', KYC_Role__c = 'billing', Related_KYC__c = kycRecord.Id),
            new Contact(LastName = 'Technical', KYC_Role__c = 'technical', Related_KYC__c = kycRecord.Id),
            new Contact(LastName = 'Channel', KYC_Role__c = 'channel', Related_KYC__c = kycRecord.Id),
            new Contact(LastName = 'Refund', KYC_Role__c = 'refund', Related_KYC__c = kycRecord.Id)
        };
        insert contacts;

        List<String> filePrefixes = new List<String>{
            'cpf', 'address_partners', 'taxId', 'address', 'sec', 'con', 'rep'
        };

        List<ContentVersion> contentVersions = new List<ContentVersion>();

        for (String prefix : filePrefixes) {
            contentVersions.add(new ContentVersion(
                Title = prefix + '_document.pdf',
                PathOnClient = prefix + '_document.pdf',
                VersionData = Blob.valueOf(prefix + ' file content'),
                IsMajorVersion = true
            ));
        }

        insert contentVersions;

        List<ContentDocumentLink> links = new List<ContentDocumentLink>();

        for (ContentVersion cv : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :contentVersions]) {
            links.add(new ContentDocumentLink(
                ContentDocumentId = cv.ContentDocumentId,
                LinkedEntityId = kycRecord.Id,
                ShareType = 'V'
            ));
        }

        insert links;
    }

    @IsTest
    static void testKYCPdfControllerInit() {
        KYC__c kyc = [SELECT Id FROM KYC__c WHERE Legal_Name__c = 'Test KYC' LIMIT 1];

        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', kyc.Id);
        KYCPdfController controller = new KYCPdfController();
        Test.stopTest();

        System.assertNotEquals(null, controller.kyc, 'Expected kyc to be loaded');
        System.assert(controller.hasCpfFiles, 'Expected hasCpfFiles to be true');
    }

    @IsTest
    static void testKYCPdfControllerContacts() {
        KYC__c kyc = [SELECT Id FROM KYC__c WHERE Legal_Name__c = 'Test KYC' LIMIT 1];

        ApexPages.currentPage().getParameters().put('id', kyc.Id);
        KYCPdfController controller = new KYCPdfController();

        System.assertNotEquals(null, controller.personalContact);
        System.assert(controller.ownerContacts.size() > 0, 'Expected owner contacts');
        System.assert(controller.representativeContacts.size() > 0, 'Expected representative contacts');
        System.assert(controller.contractContacts.size() > 0, 'Expected contract contacts');
        System.assert(controller.billingContacts.size() > 0, 'Expected billing contacts');
        System.assert(controller.technicalContacts.size() > 0, 'Expected technical contacts');
        System.assert(controller.channelContacts.size() > 0, 'Expected channel contacts');
        System.assert(controller.refundContacts.size() > 0, 'Expected refund contacts');
    }
    
    @IsTest
    static void testKYCPdfControllerFiles() {
        KYC__c kyc = [SELECT Id FROM KYC__c WHERE Legal_Name__c = 'Test KYC' LIMIT 1];

        ApexPages.currentPage().getParameters().put('id', kyc.Id);
        KYCPdfController controller = new KYCPdfController();

        System.assert(controller.hasCpfFiles, 'Expected cpf files to be populated');
        System.assert(controller.hasAddressPartnersFiles, 'Expected address_partners files to be populated');
        System.assert(controller.hasCnpjFiles, 'Expected cnpj files to be populated');
        System.assert(controller.hasAddressFiles, 'Expected address files to be populated');
        System.assert(controller.hasSecFiles, 'Expected sec files to be populated');
        System.assert(controller.hasConFiles, 'Expected con files to be populated');
        System.assert(controller.hasRepFiles, 'Expected rep files to be populated');
    }
}