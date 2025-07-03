public with sharing class KYCTriggerHelper {
    public static void setURLQuantity(List<KYC__c> newKYCList, Map<Id, KYC__c> oldKYCMap) {
        for (KYC__c record : newKYCList) {
            KYC__c oldRecord = oldKYCMap.get(record.Id);

            if (record.Store_URL__c != oldRecord.Store_URL__c) {
                if (String.isNotBlank(record.Store_URL__c)) {
                    List<String> rawUrls = record.Store_URL__c.split(';');
                    List<String> cleanedUrls = new List<String>();

                    for (String url : rawUrls) {
                        String trimmed = url.trim();
                        if (!String.isEmpty(trimmed)) {
                            cleanedUrls.add(trimmed);
                        }
                    }

                    record.URLs_Quantity__c = cleanedUrls.size();
                } else {
                    record.URLs_Quantity__c = 0;
                }
            }
        }
    }

    public static void updateOpportunityLegalApprovalStatus(List<KYC__c> newKYCList, Map<Id, KYC__c> oldKYCMap) {
        Set<Id> oppIds = new Set<Id>();
        for (KYC__c kyc : newKYCList) {
            if (kyc.Opportunity__c != null) {
                oppIds.add(kyc.Opportunity__c);
            }
        }

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, RecordTypeId, OpportunityRCCLegalApprovalStatus__c, OpportunityKYCLegalApprovalStatus__c FROM Opportunity WHERE Id IN :oppIds]);

        for (KYC__c kyc : newKYCList) {
            if (kyc.Opportunity__c != null && oppMap.containsKey(kyc.Opportunity__c)) {
                Opportunity opp = oppMap.get(kyc.Opportunity__c);
                if (kyc.Legal_Approval_Status__c != oldKYCMap.get(kyc.Id).Legal_Approval_Status__c) {
                    opp.OpportunityKYCLegalApprovalStatus__c = kyc.Legal_Approval_Status__c;
                }
            }
        }

        if (!oppMap.isEmpty()) {
            update oppMap.values();
        }

        // OpportunityTriggerHelper.submitKYCAndRCCForApprovalHandler(oppMap.values());
    }
}