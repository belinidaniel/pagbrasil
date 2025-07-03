public with sharing class KYCTriggerHandler extends TriggerHandler {
    private List<KYC__c> newKYCList;
    private Map<Id, KYC__c> oldKYCMap;

    public KYCTriggerHandler() {
        this((List<KYC__c>) Trigger.new, (Map<Id, KYC__c>) Trigger.oldMap);
    }

    public KYCTriggerHandler(List<KYC__c> newKYCList, Map<Id, KYC__c> oldKYCMap) {
        this.newKYCList = newKYCList;
        this.oldKYCMap = oldKYCMap;
    }

    public override void beforeUpdate() {
        KYCTriggerHelper.setURLQuantity(newKYCList, oldKYCMap);
        KYCTriggerHelper.updateOpportunityLegalApprovalStatus(newKYCList, oldKYCMap);
    }
}