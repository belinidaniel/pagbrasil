trigger KYCTrigger on KYC__c (before update, after update) {
	if (Trigger.isAfter && Trigger.isUpdate) {
		List<Id> toGenerate = new List<Id>();

		for (KYC__c record : Trigger.new) {
			KYC__c oldRecord = Trigger.oldMap.get(record.Id);
			if (record.Legal_Approval_Status__c == 'Approved' && oldRecord.Legal_Approval_Status__c != 'Approved') {
				toGenerate.add(record.Id);
			}
		}

		for (Id recordId : toGenerate) {
			System.enqueueJob(new KYCQueueablePdfJob(recordId));
		}
	} else {
		new KYCTriggerHandler().run();
	}
}