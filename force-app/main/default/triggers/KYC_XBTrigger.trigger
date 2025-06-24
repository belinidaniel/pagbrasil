trigger KYC_XBTrigger on KYC_XB__c (before update) {
    new KYCXBTriggerHandler().run();
}