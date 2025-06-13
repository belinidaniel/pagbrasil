trigger accountTrigger on Account (after insert, after update) {
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			AccountTriggerHandler.handleInsert(Trigger.new);
		} else if (Trigger.isUpdate) {
			AccountTriggerHandler.handleUpdate(Trigger.new, Trigger.oldMap);
		}
	}
}