@isTest
public class ContactTriggerTest {
	@isTest
	static void testContactFromKYC() {
		Account acct = new Account(Name = 'Test Account KYC');
		insert acct;

		KYC__c kyc = new KYC__c(Client_Account__c = acct.Id);
		insert kyc;

		Contact c = new Contact(
			LastName = 'Contact KYC',
			Related_KYC__c = kyc.Id,
			KYC_Role__c = 'technical'
		);
		insert c;

		c = [SELECT Id, AccountId, Type__c FROM Contact WHERE Id = :c.Id];
		System.assertEquals(acct.Id, c.AccountId, 'AccountId should be set from KYC');
		System.assertEquals('Técnico', c.Type__c, 'Type__c should be mapped from KYC_Role__c');
	}

	@isTest
	static void testContactFromKYC_XB() {
		Account acct = new Account(Name = 'Test Account KYC XB');
		insert acct;

		KYC_XB__c kycXb = new KYC_XB__c(Client_Account__c = acct.Id);
		insert kycXb;

		Contact c = new Contact(
			LastName = 'Contact KYC XB',
			Related_KYC_XB__c = kycXb.Id,
			KYC_Role__c = 'invoice'
		);
		insert c;

		c = [SELECT Id, AccountId, Type__c FROM Contact WHERE Id = :c.Id];
		System.assertEquals(acct.Id, c.AccountId, 'AccountId should be set from KYC_XB');
		System.assertEquals('Financeiro', c.Type__c, 'Type__c should be mapped from KYC_Role__c');
	}

	@isTest
	static void testContactWithAccountAlreadySet() {
		Account acct = new Account(Name = 'Direct Account');
		insert acct;

		Contact c = new Contact(
			LastName = 'Direct Contact',
			AccountId = acct.Id,
			KYC_Role__c = 'channel'
		);
		insert c;

		c = [SELECT Id, AccountId, Type__c FROM Contact WHERE Id = :c.Id];
		System.assertEquals(acct.Id, c.AccountId, 'AccountId should remain unchanged');
		System.assertEquals('Suporte', c.Type__c, 'Type__c should be mapped from KYC_Role__c');
	}

	@isTest
	static void testContactWithUnknownRole() {
		Contact c = new Contact(
			LastName = 'Unknown Role',
			KYC_Role__c = 'somethingElse'
		);
		insert c;

		c = [SELECT Id, Type__c FROM Contact WHERE Id = :c.Id];
		System.assertEquals('Other', c.Type__c, 'Type__c should default to Other for unknown role');
	}

	@isTest
	static void testContactWithoutKYCOrXB() {
		Contact c = new Contact(
			LastName = 'No KYC',
			KYC_Role__c = 'support'
		);
		insert c;

		c = [SELECT Id, AccountId, Type__c FROM Contact WHERE Id = :c.Id];
		System.assertEquals(null, c.AccountId, 'AccountId should remain null if no KYC links');
		System.assertEquals('Suporte', c.Type__c, 'Type__c should still be mapped');
	}
}