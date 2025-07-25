trigger RCCTrigger on RCC__c (before update) {
    new RCCTriggerHandler().run();
}