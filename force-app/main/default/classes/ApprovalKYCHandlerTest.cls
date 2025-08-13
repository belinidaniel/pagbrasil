/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 07-12-2025
 * @last modified by  : Daniel Belini
**/
@IsTest
public class ApprovalKYCHandlerTest {
	@testSetup
	static void setupTestData() {
		Account acct = new Account(
			Name = 'Conta teste',
            Filial_no_Brasil__c = 'Sim',
            Nome_Empresarial__c = 'Empresa X',
            BillingCountry = 'Brasil'
		);
		insert acct;

		Contact c = new Contact(FirstName = 'Test', LastName = 'User', AccountId = acct.Id, Email = 'test@example.com');
		insert c;

		Id nationalRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NaTional').getRecordTypeId();

		Opportunity opp = new Opportunity(
			Name = 'Opp1',
			CloseDate = Date.today().addDays(30),
			AccountId = acct.Id,
			RecordTypeId = nationalRT,
			StageName = 'Contact',
			Product_or_service_website_URL__c = 'www.google.com',
			Transacoes_Mensais__c = 1213,
			BusinessModel__c = 'Intermediation',
			NationalPaymentMethod__c = 'Pix',
			AverageSalesTicket__c = 15000.00,
			ProductClass__c = '5331',
			previs_fat_rs__c = 5000.00,
			nb_receita_mensal__c = 50000,
			Integracao__c = 'Salesforce CC',
			Recorrencia__c = 'Yes',
			Ticket_Medio__c = 123,
			Product_Type__c = 'Digital',
			Antecipation_Frequency_1__c = 'Weekly',
			Antecipation_Frequency_2__c = 'Monthly',
			Settlement_Frequency_1__c = 'Weekly',
			Settlement_Frequency_2__c = 'Monthly',
			Segmento__c = 'Gaming',
			IntegrationType__c = 'API',
			PaymentRecurrence__c = 'Sim'
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