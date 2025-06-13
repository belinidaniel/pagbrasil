@IsTest
private class AccountTriggerTest {

    @IsTest
    static void testAccountTriggerWithFilialBrasilSim() {
        Account acc = new Account(Name = 'Test Account 1', Type = 'Nacional (NB)', BillingCountry = 'Brazil');
        insert acc;
        
        List<KYC__c> kycs = [SELECT Id, Client_Account__c FROM KYC__c WHERE Client_Account__c = :acc.Id];
        System.assertEquals(1, kycs.size());
    }

    @IsTest
    static void testAccountTriggerWithOtherFilial() {
        Account acc = new Account(Name = 'Test Account 3', Type = 'Cross Border (XB)', BillingCountry = 'United States');
        insert acc;
        
        List<KYC_XB__c> kycxbs = [SELECT Id, Client_Account__c FROM KYC_XB__c WHERE Client_Account__c = :acc.Id];
        System.assertEquals(1, kycxbs.size());
    }

    @IsTest
    static void testUpdateCreatesKYCWhenTypeChangesToNB() {
        Account acc = new Account(Name = 'Update Type Test', Type = 'Cross Border (XB)', BillingCountry = 'Chile');
        insert acc;

        acc.Type = 'Nacional (NB)';
        update acc;

        List<KYC__c> kycs = [SELECT Id FROM KYC__c WHERE Client_Account__c = :acc.Id];
        System.assertEquals(1, kycs.size());
    }

    @IsTest
    static void testUpdateCreatesKYCXBWhenTypeChangesFromNB() {
        Account acc = new Account(Name = 'Reverse Type Test', Type = 'Nacional (NB)', BillingCountry = 'Brazil');
        insert acc;

        acc.Type = 'Cross Border (XB)';
        update acc;

        List<KYC_XB__c> kycxbs = [SELECT Id FROM KYC_XB__c WHERE Client_Account__c = :acc.Id];
        System.assertEquals(1, kycxbs.size());
    }

    @IsTest
    static void testUpdateDoesNotCreateNewKYCIfTypeUnchanged() {
        Account acc = new Account(Name = 'No Type Change', Type = 'Nacional (NB)', BillingCountry = 'Brazil');
        insert acc;

        acc.BillingCity = 'São Paulo';
        update acc;

        List<KYC__c> kycs = [SELECT Id FROM KYC__c WHERE Client_Account__c = :acc.Id];
        System.assertEquals(1, kycs.size());
    }

    @IsTest
    static void testNoDuplicateKYCOnRepeatedTypeChange() {
        Account acc = new Account(Name = 'Toggle Type', Type = 'Nacional (NB)', BillingCountry = 'Brazil');
        insert acc;

        acc.Type = 'Cross Border (XB)';
        update acc;

        acc.Type = 'Nacional (NB)';
        update acc;

        List<KYC__c> kycs = [SELECT Id FROM KYC__c WHERE Client_Account__c = :acc.Id];
        List<KYC_XB__c> kycxbs = [SELECT Id FROM KYC_XB__c WHERE Client_Account__c = :acc.Id];

        System.assertEquals(1, kycs.size(), 'Only 1 KYC should exist');
        System.assertEquals(1, kycxbs.size(), 'Only 1 KYC_XB should exist');
    }
}