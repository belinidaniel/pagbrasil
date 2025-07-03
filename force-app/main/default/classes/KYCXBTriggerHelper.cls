public with sharing class KYCXBTriggerHelper {
    public static void setURLQuantity(List<KYC_XB__c> newKYCXBList, Map<Id, KYC_XB__c> oldKYCXBMap) {
        for (KYC_XB__c record : newKYCXBList) {
            KYC_XB__c oldRecord = oldKYCXBMap.get(record.Id);

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

    public static void updateOpportunityLegalApprovalStatus(List<KYC_XB__c> newKYCXBList, Map<Id, KYC_XB__c> oldKYCXBMap) {
        Set<Id> oppIds = new Set<Id>();
        for (KYC_XB__c kyc : newKYCXBList) {
            if (kyc.Opportunity__c != null) {
                oppIds.add(kyc.Opportunity__c);
            }
        }

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, RecordTypeId, OpportunityRCCLegalApprovalStatus__c, OpportunityKYCLegalApprovalStatus__c FROM Opportunity WHERE Id IN :oppIds]);

        for (KYC_XB__c kyc : newKYCXBList) {
            if (kyc.Opportunity__c != null && oppMap.containsKey(kyc.Opportunity__c)) {
                Opportunity opp = oppMap.get(kyc.Opportunity__c);
                if (kyc.LegalApprovalStatus__c != oldKYCXBMap.get(kyc.Id).LegalApprovalStatus__c) {
                    opp.OpportunityKYCLegalApprovalStatus__c = kyc.LegalApprovalStatus__c;
                }
            }
        }

        if (!oppMap.isEmpty()) {
            update oppMap.values();
        }

        // OpportunityTriggerHelper.submitKYCAndRCCForApprovalHandler(oppMap.values());
    }
}