trigger HomologationFormTrigger on HomologationForm__c (before insert, before update, after update) {
    new HomologationFormTriggerHandler().run();
}