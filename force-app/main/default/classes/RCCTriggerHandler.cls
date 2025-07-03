public with sharing class RCCTriggerHandler extends TriggerHandler {
    private List<RCC__c> newRCCList;
    private Map<Id, RCC__c> oldRCCMap;

    public RCCTriggerHandler() {
        this((List<RCC__c>) Trigger.new, (Map<Id, RCC__c>) Trigger.oldMap);
    }

    public RCCTriggerHandler(List<RCC__c> newRCCList, Map<Id, RCC__c> oldRCCMap) {
        this.newRCCList = newRCCList;
        this.oldRCCMap = oldRCCMap;
    }

    public override void beforeUpdate() {
        RCCTriggerHelper.updateOpportunityLegalApprovalStatus(newRCCList, oldRCCMap);
    }
}