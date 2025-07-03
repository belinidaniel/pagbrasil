public with sharing class RCCTriggerHelper {
    public static void updateOpportunityLegalApprovalStatus(List<RCC__c> newRCCList, Map<Id, RCC__c> oldRCCMap) {
        Set<Id> oppIds = new Set<Id>();
        for (RCC__c rcc : newRCCList) {
            if (rcc.Opportunity__c != null) {
                oppIds.add(rcc.Opportunity__c);
            }
        }

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, RecordTypeId, OpportunityRCCLegalApprovalStatus__c, OpportunityKYCLegalApprovalStatus__c FROM Opportunity WHERE Id IN :oppIds]);

        for (RCC__c rcc : newRCCList) {
            if (rcc.Opportunity__c != null && oppMap.containsKey(rcc.Opportunity__c)) {
                Opportunity opp = oppMap.get(rcc.Opportunity__c);
                if (rcc.LegalApprovalStatus__c != oldRCCMap.get(rcc.Id).LegalApprovalStatus__c) {
                    opp.OpportunityRCCLegalApprovalStatus__c = rcc.LegalApprovalStatus__c;
                }
            }
        }

        if (!oppMap.isEmpty()) {
            update oppMap.values();
        }
        
        // OpportunityTriggerHelper.submitKYCAndRCCForApprovalHandler(oppMap.values());
    }
}