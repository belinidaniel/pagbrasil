/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-14
 * @last modified by  : Hersilio Belini de Oliveira
**/
public class OpportunityWrapper {
    public String id { get; set; }
    public String name { get; set; }
    public String productType { get; set; }
    public String paymentMethods { get; set; }
    public String productCategory { get; set; }
    public String integrationType { get; set; }
    public String tierCs { get; set; }
    public Decimal monthlyPix { get; set; }
    public String businessModel { get; set; }
    public String integrationTypeSpecify { get; set; }
    public Boolean usePagstream { get; set; }
    public Boolean payout { get; set; }
    public Boolean googlePay { get; set; }
    public Boolean applePay { get; set; }
    public Boolean pagShieldPremiumOnDemand { get; set; }
    public AccountWrapper account { get; set; }
    public List<HomologationFormWrapper> homologationForms { get; set; }
    public List<ContactWrapper> contacts { get; set; }
    public List<QuoteLineItemWrapper> contracts { get; set; }

    // Constructor
    public OpportunityWrapper(Opportunity opp) {
        this.id = opp.Id;
        this.name = opp.Name;
        this.productType = opp.Product_Type__c;
        this.paymentMethods = opp.Metodos_Pagamento__c;
        this.productCategory = opp.Categoria_de_Produto__c;
        this.integrationType = opp.IntegrationType__c;
        this.tierCs = opp.TierCS__c;
        this.monthlyPix = opp.PixMensal__c;
        this.businessModel = opp.BusinessModel__c;
        this.integrationTypeSpecify = opp.IntegrationTypeSpecify__c;
        this.usePagstream = opp.UsePagstream__c;
        this.payout = opp.Payout__c;
        this.googlePay = opp.GooglePay__c;
        this.applePay = opp.ApplePay__c;
        this.pagShieldPremiumOnDemand = opp.PagShield_Premium_On_Demand__c;

        // Map Account properties
        if (opp.Account != null) {
            this.account = new AccountWrapper(opp.Account);

            List<Contact> contactList = ContactSelector.getContactsByAccountId(opp.AccountId);
            this.contacts = new List<ContactWrapper>();
            for (Contact contact : contactList) {
                this.contacts.add(new ContactWrapper(contact));
            }
        }

        // Map HomologationForms
        if (opp.HomologationForms__r != null) {
            this.homologationForms = new List<HomologationFormWrapper>();
            for (HomologationForm__c form : opp.HomologationForms__r) {
                this.homologationForms.add(new HomologationFormWrapper(form));
            }
        }


        // Fetch and map Contract (QuoteLineItems)
        if (opp.SyncedQuoteId != null) {
            List<QuoteLineItem> quoteLineItemList = QuoteLineItemSelector.getQuoteLineItemByQuoteId(opp.SyncedQuoteId);
            this.contracts = new List<QuoteLineItemWrapper>();
            for (QuoteLineItem qli : quoteLineItemList) {
                this.contracts.add(new QuoteLineItemWrapper(qli));
            }
        }
    }

    // Nested AccountWrapper class
    public class AccountWrapper {
        public String name { get; set; }
        public String billingStreet { get; set; }
        public String billingCity { get; set; }
        public String billingState { get; set; }
        public String billingPostalCode { get; set; }
        public String billingCountry { get; set; }
        public Decimal billingLatitude { get; set; }
        public Decimal billingLongitude { get; set; }
        public String billingComplement { get; set; }
        public String billingNumber { get; set; }
        public String shippingStreet { get; set; }
        public String shippingCity { get; set; }
        public String shippingState { get; set; }
        public String shippingPostalCode { get; set; }
        public String shippingCountry { get; set; }
        public Decimal shippingLatitude { get; set; }
        public Decimal shippingLongitude { get; set; }
        public String shippingComplement { get; set; }
        public String businessName { get; set; }
        public String tradeName { get; set; }
        public String cnpj { get; set; }
        public Decimal bankDetailsNumber { get; set; }
        public String bankDetailsBranch { get; set; }
        public String bankDetailsCnpj { get; set; }
        public String bankDetailsCheckingAccount { get; set; }
        public String bankDetailsName { get; set; }
        public String bankDetailsCompanyName { get; set; }
        public String CustomerFinalSupportChannelEmail { get; set; }
        public String CustomerFinalSupportChannelUrl { get; set; }

        AccountWrapper(Account acc) {
            this.name = acc.Name;
            this.billingStreet = acc.BillingStreet;
            this.billingCity = acc.BillingCity;
            this.billingState = acc.BillingState;
            this.billingPostalCode = acc.BillingPostalCode;
            this.billingCountry = acc.BillingCountry;
            this.billingLatitude = acc.BillingLatitude;
            this.billingLongitude = acc.BillingLongitude;
            this.billingComplement = acc.BillingComplement__c;
            this.billingNumber = acc.BillingNumber__c;
            this.shippingStreet = acc.ShippingStreet;
            this.shippingCity = acc.ShippingCity;
            this.shippingState = acc.ShippingState;
            this.shippingPostalCode = acc.ShippingPostalCode;
            this.shippingCountry = acc.ShippingCountry;
            this.shippingLatitude = acc.ShippingLatitude;
            this.shippingLongitude = acc.ShippingLongitude;
            this.shippingComplement = acc.ShippingComplement__c;
            this.businessName = acc.Nome_Empresarial__c;
            this.tradeName = acc.Nome_Comercial__c;
            this.cnpj = acc.CNPJ__c;
            this.bankDetailsNumber = acc.Bank_Details_Number__c;
            this.bankDetailsBranch = acc.Bank_Details_Branch__c;
            this.bankDetailsCnpj = acc.Bank_Details_CNPJ__c;
            this.bankDetailsCheckingAccount = acc.Bank_Details_Checking_Account__c;
            this.bankDetailsName = acc.Bank_Details_Name__c;
            this.bankDetailsCompanyName = acc.Bank_Details_Company_Name__c;
            this.bankDetailsCompanyName = acc.CustomerFinalSupportChannelUrl__c;
            this.bankDetailsCompanyName = acc.CustomerFinalSupportChannelEmail__c;
        }
    }

    // Nested HomologationFormWrapper class
    public class HomologationFormWrapper {
        public Id id { get; set; }
        public String login { get; set; }
        public String cielo30 { get; set; }
        public Decimal monthlyInterestOnCustomerInstallments { get; set; }
        public Decimal pbCheckoutDiscount { get; set; }
        public String pagBrasilSolutionForTransferringFee { get; set; }
        public Decimal shopifyDiscount { get; set; }
        public Decimal pagBrasilPix { get; set; }
        public String notInterestedInOfferingDiscount { get; set; }
        public String evidenceCompanyDetails { get; set; }
        public String evidenceContactInformation { get; set; }
        public String evidenceResponseTime { get; set; }
        public String evidencePriceFormat { get; set; }
        public String evidenceInfoValidator { get; set; }
        public String evidenceDeliveryTime { get; set; }
        public String evidenceShippingProofPod { get; set; }
        public String evidenceCustomsFee { get; set; }
        public String evidenceZipCodeValidator { get; set; }
        public String evidenceGateway { get; set; }
        public String evidenceReclameAqui { get; set; }
        public String companyDetails { get; set; }
        public String contactInformation { get; set; }
        public String requirementResponseTime { get; set; }
        public String requirementPriceFormat { get; set; }
        public String deliveryTime { get; set; }
        public String shippingProofPod { get; set; }
        public String customsFee { get; set; }
        public String requirementZipCodeValidator { get; set; }
        public String requirementInfoValidator { get; set; }
        public String minimumInstallmentsForInterest { get; set; }
        public String interestRepassMethodToCustomer { get; set; }
        public String alreadyRequestedReclameAqui { get; set; }
        public String podReminder { get; set; }
        public String automaticCancellation { get; set; }
        public String creditCardRecurrence { get; set; }
        public String defaultSoftDescriptor { get; set; }
        public String installmentRecurrence { get; set; }
        public String bankSlipEmailService { get; set; }
        public String bankSlipSmsService { get; set; }
        public String pixEmailService { get; set; }
        public String emailPackage { get; set; }
        public String paymentConfirmationEmailService { get; set; }
        public String paymentLinkEmailService { get; set; }
        public String oneClickBuyingTokenization { get; set; }
        public String reviewPayeeRegistration { get; set; }
        public String transactionType { get; set; }
        public String emailsPodManager { get; set; }

        // Constructor to initialize the wrapper from a HomologationForms__c record
        public HomologationFormWrapper(HomologationForm__c form) {
            this.id = form.Id;
            this.login = form.Login__c;
            this.cielo30 = form.Cielo30__c;
            this.monthlyInterestOnCustomerInstallments = form.MonthlyInterestOnCustomerInstallments__c;
            this.pbCheckoutDiscount = form.PbCheckoutDiscount__c;
            this.pagBrasilSolutionForTransferringFee = form.PagBrasilSolutionForTransferringFee__c;
            this.shopifyDiscount = form.ShopifyDiscount__c;
            this.pagBrasilPix = form.PagBrasilPix__c;
            this.notInterestedInOfferingDiscount = form.NotInterestedInOfferingDiscount__c;
            this.evidenceCompanyDetails = form.EvidenceCompanyDetails__c;
            this.evidenceContactInformation = form.EvidenceContactInformation__c;
            this.evidenceResponseTime = form.EvidenceResponseTime__c;
            this.evidencePriceFormat = form.EvidencePriceFormat__c;
            this.evidenceInfoValidator = form.EvidenceInfoValidator__c;
            this.evidenceDeliveryTime = form.EvidenceDeliveryTime__c;
            this.evidenceShippingProofPod = form.EvidenceShippingProofPod__c;
            this.evidenceCustomsFee = form.EvidenceCustomsFee__c;
            this.evidenceZipCodeValidator = form.EvidenceZipCodeValidator__c;
            this.evidenceGateway = form.EvidenceGateway__c;
            this.evidenceReclameAqui = form.EvidenceReclameAqui__c;
            this.companyDetails = form.CompanyDetails__c;
            this.contactInformation = form.ContactInformation__c;
            this.requirementResponseTime = form.RequirementResponseTime__c;
            this.requirementPriceFormat = form.RequirementPriceFormat__c;
            this.deliveryTime = form.DeliveryTime__c;
            this.shippingProofPod = form.ShippingProofPod__c;
            this.customsFee = form.CustomsFee__c;
            this.requirementZipCodeValidator = form.RequirementZipCodeValidator__c;
            this.requirementInfoValidator = form.RequirementInfoValidator__c;
            this.minimumInstallmentsForInterest = form.MinimumInstallmentsForInterest__c;
            this.interestRepassMethodToCustomer = form.InterestRepassMethodToCustomer__c;
            this.alreadyRequestedReclameAqui = form.AlreadyRequestedReclameAqui__c;
            this.podReminder = form.PodReminder__c;
            this.automaticCancellation = form.AutomaticCancellation__c;
            this.creditCardRecurrence = form.CreditCardRecurrence__c;
            this.defaultSoftDescriptor = form.DefaultSoftDescriptor__c;
            this.installmentRecurrence = form.InstallmentRecurrence__c;
            this.bankSlipEmailService = form.BankSlipEmailService__c;
            this.bankSlipSmsService = form.BankSlipSmsService__c;
            this.pixEmailService = form.PixEmailService__c;
            this.emailPackage = form.EmailPackage__c;
            this.paymentConfirmationEmailService = form.PaymentConfirmationEmailService__c;
            this.paymentLinkEmailService = form.PaymentLinkEmailService__c;
            this.oneClickBuyingTokenization = form.OneClickBuyingTokenization__c;
            this.reviewPayeeRegistration = form.ReviewPayeeRegistration__c;
            this.transactionType = form.TransactionType__c;
            this.emailsPodManager = form.EmailsPodManager__c;
        }
    }

    public class ContactWrapper {
        public String id { get; set; }
        public String name { get; set; }
        public String email { get; set; }
        public String phone { get; set; }
        public String type { get; set; }

        ContactWrapper(Contact contact) {
            this.id = contact.Id;
            this.name = contact.Name;
            this.email = contact.Email;
            this.type = contact.Type__c;
        }
    }

    // Nested QuoteLineItemWrapper class
    public class QuoteLineItemWrapper {
        public String id { get; set; }
        public String productName { get; set; }
        public Decimal order { get; set; }
        public String productFamily { get; set; }
        public Decimal totalPrice { get; set; }
        public Boolean isMain { get; set; }
        public Decimal initialMonthlyRevenue { get; set; }
        public Decimal finalMonthlyRevenue { get; set; }

        QuoteLineItemWrapper(QuoteLineItem qli) {
            this.id = qli.Id;
            this.productName = qli.Product2.Name;
            this.order = qli.Order__c;
            this.productFamily = qli.ProductFamily__c;
            this.totalPrice = qli.TotalPrice;
            this.isMain = qli.IsMain__c;
            this.initialMonthlyRevenue = qli.InitialMonthlyRevenue__c;
            this.finalMonthlyRevenue = qli.FinalMonthlyRevenue__c;
        }
    }
}