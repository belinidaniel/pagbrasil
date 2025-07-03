@IsTest
private class KYCXBPdfControllerTest {

	@testSetup
	static void setupData() {
		KYC_XB__c kycXb = new KYC_XB__c(Legal_Name__c = 'Test KYC XB');
		insert kycXb;

		List<Contact> contacts = new List<Contact>{
			new Contact(LastName = 'Personal', KYC_Role__c = 'personal', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Owner', KYC_Role__c = 'owner', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Representative', KYC_Role__c = 'representative', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Contract', KYC_Role__c = 'contract', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Invoice', KYC_Role__c = 'invoice', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Technical', KYC_Role__c = 'technical', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Emergency', KYC_Role__c = 'emergency', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Channel', KYC_Role__c = 'channel', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Refund', KYC_Role__c = 'refund', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Political', KYC_Role__c = 'political', Related_KYC_XB__c = kycXb.Id),
			new Contact(LastName = 'Support', KYC_Role__c = 'support', Related_KYC_XB__c = kycXb.Id)
		};
		insert contacts;

		List<ContentVersion> versions = new List<ContentVersion>{
			new ContentVersion(Title = 'file_shareholder_0_1', PathOnClient = 'file_shareholder_0_1.pdf', VersionData = Blob.valueOf('sh'), IsMajorVersion = true),
			new ContentVersion(Title = 'file_representative_0_1', PathOnClient = 'file_representative_0_1.pdf', VersionData = Blob.valueOf('rep'), IsMajorVersion = true),
			new ContentVersion(Title = 'address_partners_doc.pdf', PathOnClient = 'address_partners_doc.pdf', VersionData = Blob.valueOf('ap'), IsMajorVersion = true),
			new ContentVersion(Title = 'companyInformationCertificateIncorporation.pdf', PathOnClient = 'companyInformationCertificateIncorporation.pdf', VersionData = Blob.valueOf('cnpj'), IsMajorVersion = true),
			new ContentVersion(Title = 'companyInformationProofAddress.pdf', PathOnClient = 'companyInformationProofAddress.pdf', VersionData = Blob.valueOf('addr'), IsMajorVersion = true),
			new ContentVersion(Title = 'sec_doc.pdf', PathOnClient = 'sec_doc.pdf', VersionData = Blob.valueOf('sec'), IsMajorVersion = true),
			new ContentVersion(Title = 'con_doc.pdf', PathOnClient = 'con_doc.pdf', VersionData = Blob.valueOf('con'), IsMajorVersion = true),
			new ContentVersion(Title = 'bank_doc.pdf', PathOnClient = 'bank_doc.pdf', VersionData = Blob.valueOf('bank'), IsMajorVersion = true)
		};
		insert versions;

		List<ContentDocumentLink> links = new List<ContentDocumentLink>();
		for (ContentVersion v : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :versions]) {
			links.add(new ContentDocumentLink(
				ContentDocumentId = v.ContentDocumentId,
				LinkedEntityId = kycXb.Id,
				ShareType = 'V'
			));
		}
		insert links;
	}

	@IsTest
	static void testKYCXBPdfControllerInitialization() {
		KYC_XB__c kyc = [SELECT Id FROM KYC_XB__c WHERE Legal_Name__c = 'Test KYC XB' LIMIT 1];
		ApexPages.currentPage().getParameters().put('id', kyc.Id);

		KYCXBPdfController controller = new KYCXBPdfController();

		System.assertNotEquals(null, controller.kycXB, 'Expected kyc to be loaded');
	}

	@IsTest
	static void testKYCPdfControllerContacts() {
		KYC_XB__c kyc = [SELECT Id FROM KYC_XB__c WHERE Legal_Name__c = 'Test KYC XB' LIMIT 1];
		ApexPages.currentPage().getParameters().put('id', kyc.Id);

		KYCXBPdfController controller = new KYCXBPdfController();

		System.assertNotEquals(null, controller.personalContact);
		System.assert(controller.ownerContacts.size() > 0);
		System.assert(controller.representativeContacts.size() > 0);
		System.assert(controller.contractContacts.size() > 0);
		System.assert(controller.invoiceContacts.size() > 0);
		System.assert(controller.technicalContacts.size() > 0);
		System.assert(controller.emergencyContacts.size() > 0);
		System.assert(controller.channelContacts.size() > 0);
		System.assert(controller.refundContacts.size() > 0);
		System.assert(controller.politicalContacts.size() > 0);
		System.assert(controller.supportContacts.size() > 0);        
	}

	@IsTest
	static void testKYCXBPdfControllerFiles() {
		KYC_XB__c kyc = [SELECT Id FROM KYC_XB__c WHERE Legal_Name__c = 'Test KYC XB' LIMIT 1];
		ApexPages.currentPage().getParameters().put('id', kyc.Id);

		KYCXBPdfController controller = new KYCXBPdfController();

		System.assert(controller.hasCpfFiles);
		System.assert(controller.hasAddressPartnersFiles);
		System.assert(controller.hasCnpjFiles);
		System.assert(controller.hasAddressFiles);
		System.assert(controller.hasSecFiles);
		System.assert(controller.hasConFiles);
		System.assert(controller.hasRepFiles);
		System.assert(controller.hasBankFiles);

		System.assert(controller.wrappedShareholders.size() == controller.ownerContacts.size());
		System.assert(controller.wrappedRepresentatives.size() == controller.representativeContacts.size());

		System.assert(controller.shFileMapByIndexAndType.containsKey(0));
		System.assert(controller.shFileMapByIndexAndType.get(0).containsKey(1));
		System.assertEquals(1, controller.shFileMapByIndexAndType.get(0).get(1).size());

		System.assert(controller.repFileMapByIndexAndType.containsKey(0));
		System.assert(controller.repFileMapByIndexAndType.get(0).containsKey(1));
		System.assertEquals(1, controller.repFileMapByIndexAndType.get(0).get(1).size());
	}
}