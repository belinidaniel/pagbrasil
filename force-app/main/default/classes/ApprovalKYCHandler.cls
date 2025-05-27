public with sharing class ApprovalKYCHandler {
    @AuraEnabled
    public static String updateApprovalStatus(Id recordId) {
        SObject record = Database.query(
            '' + (recordId.getSObjectType() == KYC_XB__c.SObjectType ? 'SELECT LegalApprovalStatus__c, Opportunity__c FROM KYC_XB__c' : 'SELECT Legal_Approval_Status__c, Opportunity__c FROM KYC__c') + ' WHERE Id = :recordId LIMIT 1'
        );

        Id opportunityId;

        if (record != null) {
            if (record instanceof KYC_XB__c) {
                KYC_XB__c xbRecord = (KYC_XB__c) record;

                opportunityId = xbRecord.Opportunity__c;

                xbRecord.LegalApprovalStatus__c = 'Approval Requested';
                update xbRecord;
            } else if (record instanceof KYC__c) {
                KYC__c nbRecord = (KYC__c) record;

                opportunityId = nbRecord.Opportunity__c;

                nbRecord.Legal_Approval_Status__c = 'Approval Requested';
                update nbRecord;
            }
        } else {
            throw new AuraHandledException('Record not found');
        }

        System.debug('opportunityId: ' + opportunityId);

        String opportunityRccLegalStatus = [SELECT LegalApprovalStatus__c FROM RCC__c WHERE Opportunity__c = :opportunityId LIMIT 1].LegalApprovalStatus__c;

        if (opportunityRccLegalStatus != null) {
            return opportunityRccLegalStatus;
        } else {
            return '';
        }
    }
}