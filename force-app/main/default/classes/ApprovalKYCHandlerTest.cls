@IsTest
public class ApprovalKYCHandlerTest {
	@testSetup
	static void setupTestData() {
		Account acct = new Account(Name = 'Test Account', Type = 'Customer');
		insert acct;

		Contact c = new Contact(FirstName = 'Test', LastName = 'User', AccountId = acct.Id, Email = 'test@example.com');
		insert c;

		Opportunity opp = new Opportunity(
			Name='Test Opp',
			StageName='Prospecting',
			CloseDate=Date.today(),
			ForecastCategoryName = 'Pipeline',
			CurrencyIsoCode = UserInfo.getDefaultCurrency(),
			Probability = 10,
			AccountId = acct.Id,
			AverageSalesTicket__c = 1000,
			nb_receita_mensal__c = 50000,
			previs_fat_rs__c = 40000,
			Antecipation_Frequency_1__c = 'Weekly',
			Antecipation_Frequency_2__c = 'Monthly',
			Settlement_Frequency_1__c = 'Weekly',
			Settlement_Frequency_2__c = 'Monthly',
			Segmento__c = 'Gaming',
			Product_Type__c = 'Digital',
			BusinessModel__c = 'Intermediation',
			BusinessModelType__c = 'B2C',
			NationalPaymentMethod__c = 'Pix',
			PaymentRecurrence__c = 'Sim',
			IntegrationType__c = 'API'
		);
		insert opp;

		RCC__c rcc = new RCC__c(Opportunity__c = opp.Id, LegalApprovalStatus__c = 'Approval Requested');
		insert rcc;

		KYC__c kyc = new KYC__c(Opportunity__c = opp.Id, Legal_Approval_Status__c = 'Added');
		insert kyc;

		KYC__c kycBlocked = new KYC__c(Opportunity__c = opp.Id, Legal_Approval_Status__c = 'Approved');
		insert kycBlocked;

		KYC_XB__c kycXB = new KYC_XB__c(Opportunity__c = opp.Id, LegalApprovalStatus__c = 'Added');
		insert kycXB;

		KYC_XB__c kycXBBlocked = new KYC_XB__c(Opportunity__c = opp.Id, LegalApprovalStatus__c = 'Approval Requested');
		insert kycXBBlocked;
	}

	@isTest
	static void testUpdateKYC() {
		KYC__c record = [SELECT Id FROM KYC__c WHERE Legal_Approval_Status__c = 'Added' LIMIT 1];
		String result = ApprovalKYCHandler.updateApprovalStatus(record.Id);
		System.assertEquals('Added', result);

		KYC__c updated = [SELECT Legal_Approval_Status__c FROM KYC__c WHERE Id = :record.Id];
		System.assertEquals('Approval Requested', updated.Legal_Approval_Status__c);
	}

	@isTest
	static void testUpdateKYCXB() {
		KYC_XB__c record = [SELECT Id FROM KYC_XB__c WHERE LegalApprovalStatus__c = 'Added' LIMIT 1];
		String result = ApprovalKYCHandler.updateApprovalStatus(record.Id);
		System.assertEquals('Added', result);

		KYC_XB__c updated = [SELECT LegalApprovalStatus__c FROM KYC_XB__c WHERE Id = :record.Id];
		System.assertEquals('Approval Requested', updated.LegalApprovalStatus__c);
	}

	@isTest
	static void testBlockedKYC() {
		KYC__c record = [SELECT Id FROM KYC__c WHERE Legal_Approval_Status__c = 'Approved' LIMIT 1];
		Test.startTest();
		try {
			ApprovalKYCHandler.updateApprovalStatus(record.Id);
			System.assert(false, 'Expected AuraHandledException not thrown');
		} catch (AuraHandledException e) {
			System.assert(e.getMessage().contains('exception'));
		}
		Test.stopTest();
	}

	@isTest
	static void testBlockedKYCXB() {
		KYC_XB__c record = [SELECT Id FROM KYC_XB__c WHERE LegalApprovalStatus__c = 'Approval Requested' LIMIT 1];
		Test.startTest();
		try {
			ApprovalKYCHandler.updateApprovalStatus(record.Id);
			System.assert(false, 'Expected AuraHandledException not thrown');
		} catch (AuraHandledException e) {
			System.assert(e.getMessage().contains('exception'));
		}
		Test.stopTest();
	}

	@isTest
	static void testRecordNotFound() {
		Test.startTest();
		try {
			ApprovalKYCHandler.updateApprovalStatus(Id.valueOf('001000000000000AAA'));
			System.assert(false, 'Expected AuraHandledException not thrown');
		} catch (Exception e) {
			System.assert(e.getMessage().contains('no rows'));
		}
		Test.stopTest();
	}
}