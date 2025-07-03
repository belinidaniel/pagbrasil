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
    public String contractStartDateCharge { get; set; }
    public Boolean usePagstream { get; set; }
    public String settlementFrequency { get; set; }
    public Boolean payout { get; set; }
    public Boolean googlePay { get; set; }
    public Boolean applePay { get; set; }
    public Boolean pagShieldPremiumOnDemand { get; set; }
    public String recordType { get; set; }
    public AccountWrapper account { get; set; }
    public List<HomologationFormWrapper> homologationForms { get; set; }
    public List<ContactWrapper> contacts { get; set; }
    public List<QuoteLineItemWrapper> contracts { get; set; }
    public Rcc__c rcc { get; set; }
    public String moeda { get; set; }
    public QuoteLineItemWrapper taxaPagShieldItem { get; set; }
    public QuoteLineItemWrapper taxaMinimaManutencaoSF { get; set; }
    public QuoteLineItemWrapper taxaMinimaManutencaoPagStream { get; set; }
    public QuoteLineItemWrapper taxaPagStream { get; set; }
    public QuoteLineItemWrapper taxaMinimaPagStream { get; set; }
    public QuoteLineItemWrapper taxaBaseAntecipacao { get; set; }
    public QuoteLineItemWrapper taxaProcessamentoBoleto { get; set; }
    public QuoteLineItemWrapper taxaProcessamentoPix { get; set; }
    public QuoteLineItemWrapper taxaProcessamentoCredito { get; set; }
    public QuoteLineItemWrapper taxaProcessamentoCredito2a6 { get; set; }
    public QuoteLineItemWrapper taxaProcessamentoCredito7a12 { get; set; }
    public QuoteLineItemWrapper taxaProcessamentoDebito { get; set; }
    public QuoteLineItemWrapper taxaZeroAuth { get; set; }
    public QuoteLineItemWrapper pacoteMilEmails { get; set; }
    public QuoteLineItemWrapper pacoteDezMilEmails { get; set; }
    public QuoteLineItemWrapper pacoteCemMilEmails { get; set; }
    public QuoteLineItemWrapper pacote500sms { get; set; }
    public QuoteLineItemWrapper pacoteMilSms { get; set; }
    public QuoteLineItemWrapper pacoteDezMilSms { get; set; }
    public QuoteLineItemWrapper taxaTransferenciaFornecedores { get; set; }
    public QuoteLineItemWrapper taxaPayout { get; set; }
    public QuoteLineItemWrapper taxaMinimaManutencao { get; set; }
    public QuoteLineItemWrapper taxaSolucaoPagBrasil { get; set; }
    public QuoteLineItemWrapper valorMinimoRepasse { get; set; }
    public QuoteLineItemWrapper Reserva { get; set; }
    public QuoteLineItemWrapper taxaTransferencia { get; set; }
    public QuoteLineItemWrapper currencyMarkupSpread { get; set; }


    
    // Constructor
    public OpportunityWrapper(Opportunity opp) {
        this.id = opp.Id;
        this.name = opp.Name;
        this.productType = opp.Product_Type__c;
        this.paymentMethods = opp.NationalPaymentMethod__c;
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
        this.recordType = opp.RecordType.Name;
        this.moeda = opp.Moeda__c;
        this.settlementFrequency = opp.Settlement_Frequency_1__c;
        this.contractStartDateCharge = opp.Contract_Start_Fee_Date__c;

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
                if (qli.Product2.ProductCode == 'CUSTO_PAGSHIELD') {
                    this.taxaPagShieldItem = new QuoteLineItemWrapper(qli);
                } 
                else if (qli.Product2.ProductCode == 'TAXA_MIN_MANUTENCAO_SF') {
                    this.taxaMinimaManutencaoSF = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_MIN_PAGSTREAM') {
                    this.taxaMinimaManutencaoPagStream = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_PAGSTREAM') {
                    this.taxaPagStream = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_MIN_PAGSTREAM') {
                    this.taxaMinimaPagStream = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_ANTECIPACAO') {
                    this.taxaBaseAntecipacao = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_PROCESS_BOLETO' && qli.IsMain__c == true) {
                    this.taxaProcessamentoBoleto = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_PROCESS_PIX' && qli.IsMain__c == true) {
                    this.taxaProcessamentoPix = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_PROCESS_CREDITO' && qli.IsMain__c == true) {
                    this.taxaProcessamentoCredito = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_PARC_2A6') {
                    this.taxaProcessamentoCredito2a6 = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_PARC_7A12') {
                    this.taxaProcessamentoCredito7a12 = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_PROCESS_DEBITO' && qli.IsMain__c == true) {
                    this.taxaProcessamentoDebito = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'ZERO_AUTH_CARTAO') {
                    this.taxaZeroAuth = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'PACOTE_1000_EMAILS') {
                    this.pacoteMilEmails = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'PACOTE_10000_EMAILS') {
                    this.pacoteDezMilEmails = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'PACOTE_100000_EMAILS') {
                    this.pacoteCemMilEmails = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'PACOTE_500_SMS') {
                    this.pacote500sms = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'PACOTE_1000_SMS') {
                    this.pacoteMilSms = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'PACOTE_10000_SMS') {
                    this.pacoteDezMilSms = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_TRANSFER_FORNEC') {
                    this.taxaTransferenciaFornecedores = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_PAYOUT') {
                    this.taxaPayout = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_MIN_MANUTENCAO') {
                    this.taxaMinimaManutencao = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_PAGBRASIL' && qli.IsMain__c == true) {
                    this.taxaSolucaoPagBrasil = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'VALOR_MIN_REPASSE') {
                    this.valorMinimoRepasse = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'RESERVA_GIRATORIA') {
                    this.Reserva = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'TAXA_TRANSFERENCIA') {
                    this.taxaTransferencia = new QuoteLineItemWrapper(qli);
                }
                else if (qli.Product2.ProductCode == 'CURRENCY_EXCHANGE_MARKUP_SPREAD') {
                    this.currencyMarkupSpread = new QuoteLineItemWrapper(qli);
                }
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
        public String senha { get; set; }
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
        public String mccCode { get; set; }
        public String paymentAlert { get; set; }
        public String blockRefund { get; set; }
        public Decimal numberOfDays { get; set; }
        public Decimal boletoFlash { get; set; }
        public String SMSPackage { get; set; }
        public String merchantID { get; set; }
        public String merchantKey { get; set; }
        public String PV { get; set; }
        public String Token { get; set; }
        public String RegKey { get; set; }
        public String MID { get; set; }
        public String TerminalID { get; set; }
        public String mainContactEmail { get; set; }
        public Boolean pagShield { get; set; }
        public Boolean pagShieldPremium { get; set; }
        public Boolean pixPending { get; set; }
        public Boolean pixOpenFinance { get; set; }
        public String contactEmailNotification { get; set; }

        // Constructor to initialize the wrapper from a HomologationForms__c record
        public HomologationFormWrapper(HomologationForm__c form) {
            this.id = form.Id;
            this.login = form.Login__c;
            this.senha = form.Password__c;
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
            this.mccCode = form.MccCode__c;
            this.paymentAlert = form.PaymentAlert__c;
            this.blockRefund = form.BlockRefund__c;
            this.numberOfDays = form.NumberOfDays__c;
            this.boletoFlash = form.FlashBoleto__c;
            this.SMSPackage = form.SmsPackage__c;
            this.merchantID = form.MerchantId__c;
            this.merchantKey = form.MerchantKey__c;
            this.PV = form.Pv__c;
            this.Token = form.Token__c;
            this.RegKey = form.RegKey__c;
            this.MID = form.MidMerchantId__c; 
            this.TerminalID = form.TerminalId__c;  
            this.mainContactEmail = form.Main_Contact_Email__c;
            this.pagShieldPremium = form.PagShield_Premium__c;
            this.pagShield = form.PagShield__c;
            this.pixPending = form.Pix_Pending__c;
            this.pixOpenFinance = form.Pix_Open_Finance__c;
            this.contactEmailNotification = form.Contact_email_for_notification__c;
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
            this.phone = contact.Phone;
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
        public Date initialDate { get; set; }
        public Decimal percentValue { get; set; }
        

        QuoteLineItemWrapper(QuoteLineItem qli) {
            this.id = qli.Id;
            this.productName = qli.Product2.Name;
            this.order = qli.Order__c;
            this.productFamily = qli.ProductFamily__c;
            this.totalPrice = qli.TotalPrice;
            this.isMain = qli.IsMain__c;
            this.initialMonthlyRevenue = qli.InitialMonthlyRevenue__c;
            this.finalMonthlyRevenue = qli.FinalMonthlyRevenue__c;
            this.initialDate = qli.ServiceDate;
            this.percentValue = qli.PercentValue__c;
        }
    }

    public class RccWrapper {
        public String id { get; set; }
        public String FinalRisk { get; set; }
        
        public RccWrapper(Rcc__c rcc) {
                this.id = rcc.Id;
                this.FinalRisk = rcc.Final_Risk__c;
        }
    }

    public class KycWrapper {
        public String id { get; set; }
        public String name { get; set; }
        public Datetime lastModifiedDate { get; set; }

        public KYCWrapper(KYC__c kyc) {
            this.id = kyc.Id;
            this.name = kyc.Name;
            this.lastModifiedDate = kyc.LastModifiedDate;
        }
    }
}