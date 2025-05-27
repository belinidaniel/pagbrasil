/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-03-03
 * @last modified by  : Hersilio Belini de Oliveira
**/
@isTest
public class OpportunityWrapperTest {

    @testSetup
    static void setup() {
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

        Id nationalRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId();

        Date datClose = Date.today().addDays(30);

        Opportunity testOpportunity = new Opportunity(Name = 'Opp1', CloseDate = datClose, AccountId = testAccount.Id, BusinessModel__c = 'Intermediation', RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com');

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
            RequirementZipCodeValidator__c = 'Yes',
            RequirementInfoValidator__c = 'Yes',
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
            Family = 'Test Product Family'
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
    }

    @isTest
    static void testOpportunityWrapper() {
        Opportunity testOpportunity = OpportunitySelector.getCompleteOpportunityById([SELECT Id FROM Opportunity LIMIT 1].Id);
        OpportunityWrapper oppWrapper = new OpportunityWrapper(testOpportunity);

        System.assertNotEquals(null, oppWrapper, 'OpportunityWrapper should not be null');
        System.assertNotEquals(null, oppWrapper.account, 'AccountWrapper should not be null');
        System.assertNotEquals(null, oppWrapper.contacts, 'Contacts should not be null');
        System.assertNotEquals(null, oppWrapper.homologationForms, 'HomologationForms should not be null');
    }

    @isTest
    static void testSelecQuotelineItem(){
        Quote quote = [SELECT Id FROM Quote LIMIT 1];

        Test.startTest();
        List<QuoteLineItem> quoteLineItems = QuoteLineItemSelector.getQuoteLineItemByQuoteId(quote.Id);
        Test.stopTest();

        System.assert(quoteLineItems.size() > 0, 'QuoteLineItems should not be empty');
    }
}