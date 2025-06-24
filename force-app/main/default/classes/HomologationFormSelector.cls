public with sharing class HomologationFormSelector {

    @AuraEnabled(cacheable=true)
    public static List<HomologationForm__c> getByOpportunityId(String opportunityId) {
        return [
            SELECT Id,
            Name,
            Completed__c,
            MccCode__c,
            PodReminder__c,
            BlockRefund__c,
            AutomaticCancellation__c,
            NumberOfDays__c,
            CreditCardRecurrence__c,
            DefaultSoftDescriptor__c,
            InstallmentRecurrence__c,
            BankSlipEmailService__c,
            BankSlipSmsService__c,
            PixEmailService__c,
            EmailPackage__c,
            PaymentConfirmationEmailService__c,
            SmsPackage__c,
            PaymentLinkEmailService__c,
            OneClickBuyingTokenization__c,
            AccountModel__c,
            ReviewPayeeRegistration__c,
            TransactionType__c,
            Required_Fields__c
            FROM HomologationForm__c 
            WHERE Opportunity__c = :opportunityId 
            ORDER BY CreatedDate DESC
        ];
    }
}