/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 08-09-2025
 * @last modified by  : Daniel Belini
**/
@isTest
public class QuoteLineItemTriggerTest {
	@isTest static void testQuoteLineItemTriggerSyncingTrue() {
        // Create test data
        Account testAccount = new Account(
            Name = 'Test Account',
            BillingStreet = '123 Test St',
            BillingCity = 'Test City',
            BillingState = 'TS',
            BillingPostalCode = '12345',
            BillingCountry = 'Test Country',
            BillingLatitude = 37.7749,
            BillingLongitude = -122.4194,
            BillingComplement__c = 'Suite 100',
            BillingNumber__c = '123',
            ShippingStreet = '456 Test St',
            ShippingCity = 'Test City',
            ShippingState = 'TS',
            ShippingPostalCode = '67890',
            ShippingCountry = 'Test Country',
            ShippingLatitude = 37.7749,
            ShippingLongitude = -122.4194,
            ShippingComplement__c = 'Suite 200',
            Nome_Empresarial__c = 'Test Business Name',
            Nome_Comercial__c = 'Test Trade Name',
            CNPJ__c = '60815863080',
            Bank_Details_Number__c = 1,

            Bank_Details_Branch__c = '001',
            Bank_Details_CNPJ__c = '60815863080',
            Bank_Details_Checking_Account__c = '12345678',
            Bank_Details_Name__c = 'Test Bank',
            Bank_Details_Company_Name__c = 'Test Company',
            CustomerFinalSupportChannelUrl__c = 'http://test.com',
            CustomerFinalSupportChannelEmail__c = 'support@test.com'
        );
        insert testAccount;

        Id nationalRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NaTional').getRecordTypeId();

        Date datClose = Date.today().addDays(30);

        Opportunity testOpportunity = new Opportunity(
				Name = 'Opp1',
				CloseDate = datClose,
				AccountId = testAccount.Id,
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

        insert testOpportunity;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test.contact@test.com',
            Phone = '123-456-7890',
            AccountId = testAccount.Id
        );
        insert testContact;

        HomologationForm__c testForm = new HomologationForm__c(
            Login__c = 'testlogin',
            Cielo30__c = 'Yes',
            MonthlyInterestOnCustomerInstallments__c = 1.5,
            PbCheckoutDiscount__c = 2.0,
            PagBrasilSolutionForTransferringFee__c = 'Yes',
            ShopifyDiscount__c = 3.0,
            PagBrasilPix__c = 4.0,
            NotInterestedInOfferingDiscount__c = 'Yes',
            RequirementResponseTime__c = 'Yes',
            RequirementPriceFormat__c = 'Yes',
            RequirementZipCodeValidator__c = 'Integration is not API, a validator already exists',
            RequirementInfoValidator__c = 'Integration is not API, a validator already exists',
            AlreadyRequestedReclameAqui__c = 'Yes',
            Opportunity__c = testOpportunity.Id,
            Account__c = testAccount.Id
        );
        insert testForm;

        Quote testQuote = new Quote(
            OpportunityId = testOpportunity.Id,
            Name = 'Test Quote',
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert testQuote;

        Product2 prod = new Product2(
            Name = 'Test Product',
            Family = 'Test Product Family',
			IsActive = true
        );

        insert prod;

        PricebookEntry pb = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = prod.Id,
            UnitPrice = 100.0,
            IsActive = true
        );

        insert pb;

        QuoteLineItem testQuoteLineItem = new QuoteLineItem(
            QuoteId = testQuote.Id,
            PricebookEntryId = Test.getStandardPricebookId(),
            Quantity = 1,
            UnitPrice = 100.0,
            Product2Id = pb.Id,
            IsMain__c = true
        );
        insert testQuoteLineItem;
        update testQuoteLineItem;
        
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Id = :testOpportunity.Id LIMIT 1];
		opp.SyncedQuoteId = testQuote.Id;
		update opp;

		// Cria Product2
	}
}