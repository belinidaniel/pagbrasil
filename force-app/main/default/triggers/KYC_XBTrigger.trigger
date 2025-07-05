trigger KYC_XBTrigger on KYC_XB__c (before update, after update) {
	if (Trigger.isAfter && Trigger.isUpdate) {
		List<Id> toGenerate = new List<Id>();

		for (KYC_XB__c record : Trigger.new) {
			KYC_XB__c oldRecord = Trigger.oldMap.get(record.Id);
			if (record.LegalApprovalStatus__c == 'Approved' && oldRecord.LegalApprovalStatus__c != 'Approved') {
				toGenerate.add(record.Id);
			}
		}

		for (Id recordId : toGenerate) {
			System.enqueueJob(new KYCXBQueueablePdfJob(recordId));
		}
	} else {
		new KYCXBTriggerHandler().run();
	}
}