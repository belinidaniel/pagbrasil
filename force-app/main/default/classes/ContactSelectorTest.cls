@isTest
private class ContactSelectorTest {

	@isTest
	static void testGetContactPrincipalByAccountId() {
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		Contact resultNull = ContactSelector.getContactPrincipalByAccountId(testAccount.Id);
		System.assertEquals(null, resultNull, 'Expected null when no Principal contact exists');

		Contact principalContact = new Contact(
			LastName = 'Principal',
			Email = 'principal@example.com',
			Phone = '1234567890',
			AccountId = testAccount.Id,
			Type__c = 'Principal'
		);
		insert principalContact;

		Contact secondaryContact = new Contact(
			LastName = 'Secondary',
			Email = 'secondary@example.com',
			Phone = '0987654321',
			AccountId = testAccount.Id,
			Type__c = 'Other'
		);
		insert secondaryContact;

		Contact result = ContactSelector.getContactPrincipalByAccountId(testAccount.Id);
		System.assertNotEquals(null, result, 'Expected a contact to be returned');
		System.assertEquals(principalContact.Id, result.Id, 'Expected Principal contact to be returned');
	}

	@isTest
	static void testGetContactsByAccountId() {
		Account testAccount = new Account(Name = 'Test Account 2');
		insert testAccount;

		List<Contact> contacts = new List<Contact>{
			new Contact(LastName = 'One', AccountId = testAccount.Id, Type__c = 'Reembolsos'),
			new Contact(LastName = 'Two', AccountId = testAccount.Id, Type__c = 'Representante Legal')
		};
		insert contacts;

		List<Contact> results = ContactSelector.getContactsByAccountId(testAccount.Id);

		System.assertEquals(2, results.size(), 'Expected two contacts returned');
	}
}