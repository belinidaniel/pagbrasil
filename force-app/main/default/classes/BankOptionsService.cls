@RestResource(urlMapping='/integration/bankoptions/*')
global class BankOptionsService {
	@HttpGet
    global static List<Bank_Option__c> getBankOptions() {
        List<Bank_Option__c> options = [SELECT Number__c, Description__c, ISPB__c FROM Bank_Option__c ORDER BY Number__c];
        return options;
    }
}