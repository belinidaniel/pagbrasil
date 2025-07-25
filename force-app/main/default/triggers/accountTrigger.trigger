trigger AccountTrigger on Account (before insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.handleBeforeInsert(Trigger.new);
    }
    else if (Trigger.isAfter && Trigger.isUpdate) {
        AccountTriggerHandler.handleUpdate(Trigger.new, Trigger.oldMap);
    }
}