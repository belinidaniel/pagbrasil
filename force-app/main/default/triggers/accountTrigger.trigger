trigger accountTrigger on Account (after insert) {
	List<KYC__c> kycRecords = new List<KYC__c>();
	List<KYC_XB__c> kycXBRecords = new List<KYC_XB__c>();

	for (Account acc : Trigger.new) {
		String uniqueId = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(acc.Id + String.valueOf(System.now().millisecond()))));

		if (acc.Filial_no_Brasil__c == 'Sim' || acc.Filial_no_Brasil__c == 'N/A') {
			KYC__c kyc = new KYC__c();

			kyc.Client_Account__c = acc.Id;
			kyc.Unique_Link__c = uniqueId;
			kyc.Status__c = 'Pending';
			kyc.Stage_Number__c = 0;

			kycRecords.add(kyc);
		} else {
			KYC_XB__c kyc = new KYC_XB__c();

			kyc.Client_Account__c = acc.Id;
			kyc.Unique_Link__c = uniqueId;
			kyc.Status__c = 'Pending';
			kyc.Stage_Number__c = 0;

			kycXBRecords.add(kyc);
		}
	}

	if (!kycRecords.isEmpty()) {
		insert kycRecords;
	}

	if (!kycXBRecords.isEmpty()) {
		insert kycXBRecords;
	}
}