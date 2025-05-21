@IsTest
private class AccountTriggerTest {

    @IsTest
    static void testAccountTriggerWithFilialBrasilSim() {
        Account acc = new Account(Name = 'Test Account 1', Filial_no_Brasil__c = 'Sim', BillingCountry = 'Brazil');
        insert acc;
        
        List<KYC__c> kycs = [SELECT Id, Client_Account__c FROM KYC__c WHERE Client_Account__c = :acc.Id];
        System.assertEquals(1, kycs.size());
    }

    @IsTest
    static void testAccountTriggerWithFilialBrasilNA() {
        Account acc = new Account(Name = 'Test Account 2', Filial_no_Brasil__c = 'N/A', BillingCountry = 'Brazil');
        insert acc;
        
        List<KYC__c> kycs = [SELECT Id, Client_Account__c FROM KYC__c WHERE Client_Account__c = :acc.Id];
        System.assertEquals(1, kycs.size());
    }

    @IsTest
    static void testAccountTriggerWithOtherFilial() {
        Account acc = new Account(Name = 'Test Account 3', Filial_no_Brasil__c = 'Não', BillingCountry = 'United States');
        insert acc;
        
        List<KYC_XB__c> kycxbs = [SELECT Id, Client_Account__c FROM KYC_XB__c WHERE Client_Account__c = :acc.Id];
        System.assertEquals(1, kycxbs.size());
    }
}