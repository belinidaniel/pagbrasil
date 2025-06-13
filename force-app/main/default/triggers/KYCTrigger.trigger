trigger KYCTrigger on KYC__c (before update) {
    new KYCTriggerHandler().run();
}