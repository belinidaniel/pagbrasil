public with sharing class KYCXBTriggerHandler extends TriggerHandler {
    private List<KYC_XB__c> newKYCXBList;
    private Map<Id, KYC_XB__c> oldKYCXBMap;

    public KYCXBTriggerHandler() {
        this((List<KYC_XB__c>) Trigger.new, (Map<Id, KYC_XB__c>) Trigger.oldMap);
    }

    public KYCXBTriggerHandler(List<KYC_XB__c> newKYCXBList, Map<Id, KYC_XB__c> oldKYCXBMap) {
        this.newKYCXBList = newKYCXBList;
        this.oldKYCXBMap = oldKYCXBMap;
    }

    public override void beforeUpdate() {
        KYCXBTriggerHelper.setURLQuantity(newKYCXBList, oldKYCXBMap);
        KYCXBTriggerHelper.updateOpportunityLegalApprovalStatus(newKYCXBList, oldKYCXBMap);
    }
}