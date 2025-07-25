/**
 * @description			:
 * @author				: Hersilio Belini de Oliveira
 * @group				:
 * @last modified on	: 2025-01-14
 * @last modified by	: Hersilio Belini de Oliveira
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
	public Boolean isCrossBorder { get; set; }
	public Boolean containsShopify { get; set; }
	public Boolean containsGateway { get; set; }
	public Boolean payout { get; set; }
	public Boolean googlePay { get; set; }
	public Boolean applePay { get; set; }
	public Boolean pagShield { get; set; }
	public Boolean pagShieldPremium { get; set; }
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
		this.isCrossBorder = opp.RecordType.Name == 'Crossborder';
		this.containsShopify = opp.IntegrationType__c != null ? opp.IntegrationType__c.contains('Shopify') : false;
		this.containsGateway = opp.BusinessModel__c != null ? opp.BusinessModel__c.contains('Gateway') : false;
		this.pagShield = opp.PagShield__c;
		this.pagShieldPremium = opp.PagShield_Premium__c;

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
		public String category { get; set; }
		public String boletoBancario { get; set; }
		public String cartaoDeCredito { get; set; }
		public String debitoDebitoFlash { get; set; }
		public String boletoFlashPagamento { get; set; }
		public String pix { get; set; }
		public String agendaDeLiberacao { get; set; }
		public String pixOpenFinance2 { get; set; }
		public String pixValidFor { get; set; }
		public String maximumNumberInstallments { get; set; }
		public String pagStream { get; set; }
		public String subscriberArea { get; set; }
		public String allowCpfCnpj { get; set; }
		public String pixPending2 { get; set; }
		public Date requestDate { get; set; }
		public String accountMode { get; set; }
		public Decimal minimumRemittance { get; set; }
		public Decimal remittanceTax { get; set; }
		public String remittanceType { get; set; }
		public String remittanceAgent { get; set; }
		public Decimal apiFixed { get; set; }
		public Decimal apiVariable { get; set; }
		public Decimal mobilePosFixed { get; set; }
		public Decimal mobilePosVariable { get; set; }
		public Decimal remotePaymentFixed { get; set; }
		public Decimal remotePaymentVariable { get; set; }
		public Boolean hasApiTax { get; set; }
		public Boolean hasMobilePosTax { get; set; }
		public Boolean hasRemotePaymentTax { get; set; }
		public Decimal currentSpread { get; set; }
		public Decimal additionalSpread { get; set; }


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
			this.category = form.Category__c;
			this.boletoBancario = form.BoletoBancario__c;
			this.cartaoDeCredito = form.CartaoDeCredito__c;
			this.debitoDebitoFlash = form.DebitoDebitoFlash__c;
			this.boletoFlashPagamento = form.BoletoFlash__c;
			this.pix = form.Pix__c;
			this.agendaDeLiberacao = form.AgendaDeLiberacao__c;
			this.pixOpenFinance2 = form.PixOpenFinance__c;
			this.pixValidFor = form.Pix_Valid_For__c;
			this.maximumNumberInstallments = form.MaximumNumberInstallments__c;
			this.pagStream = form.PagStream__c;
			this.subscriberArea = form.Subscriber_Area__c;
			this.allowCpfCnpj = form.Allow_CPF_CNPJ__c;
			this.pixPending2 = form.PixPending__c;
			this.requestDate = form.Account_Request_Date__c;
			this.accountMode = form.Account_in_Mode__c;
			this.minimumRemittance = form.Minimum_Remittance_Amount__c;
			this.remittanceTax = form.Remittance_Tax__c; 
			this.remittanceType = form.Remittance_Type__c; 
			this.remittanceAgent = form.Remittance_Agent__c;
			this.apiFixed = form.API_Fixed__c;
			this.apiVariable = form.API_Variable__c;
			this.mobilePosFixed = form.Additional_for_Remote_Payments_Fixed__c;
			this.mobilePosVariable = form.Additional_for_Remote_Payments_Variable__c;
			this.remotePaymentFixed = form.PagBrasil_Mobile_POS_Fixed__c;
			this.remotePaymentVariable = form.PagBrasil_Mobile_POS_Variable__c;
			this.hasApiTax = (form.API_Fixed__c != null || form.API_Variable__c != null);
			this.hasMobilePosTax = (form.Additional_for_Remote_Payments_Fixed__c != null || form.Additional_for_Remote_Payments_Variable__c != null);
			this.hasRemotePaymentTax = (form.PagBrasil_Mobile_POS_Fixed__c != null || form.PagBrasil_Mobile_POS_Variable__c != null);
            this.currentSpread = 2.5;
            this.additionalSpread = 1.5;
		}
	}

	public class ContactWrapper {
		public String id { get; set; }
		public String name { get; set; }
		public String email { get; set; }
		public String phone { get; set; }
        public String kycRole { get; set; }
		public String type { get; set; }

		ContactWrapper(Contact contact) {
			this.id = contact.Id;
			this.name = contact.Name;
			this.email = contact.Email;
			this.phone = contact.Phone;
            this.kycRole = contact.KYC_Role__c;
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
		public Id clientAccountId { get; set; }
		public Boolean uniqueAddress { get; set; }
		public String city { get; set; }
		public String state { get; set; }
		public String country { get; set; }
		public String postalCode { get; set; }
		public String streetNumber { get; set; }
		public String address { get; set; }
		public String admCity { get; set; }
		public String admState { get; set; }
		public String admCountry { get; set; }
		public String admPostalCode { get; set; }
		public String admStreetNumber { get; set; }
		public String admAddress { get; set; }
		public String bankAccount { get; set; }
		public String bankAccountDocument { get; set; }
		public String bankAgency { get; set; }
		public String beneficiary { get; set; }
		public String bankName { get; set; }
		public String bankBranchAddress { get; set; }
		public String swiftCode { get; set; }
		public String abaRoutingNumber { get; set; }
		public String ibanNumber { get; set; }
		public Boolean bankHasIntermediary { get; set; }
		public String intermediaryBankName { get; set; }
		public String wireInstructions { get; set; }
		public String companyType { get; set; }
		public String companyURL { get; set; }
		public Boolean conformity { get; set; }
		public Boolean corporateGroup { get; set; }
		public String corporateName { get; set; }
		public String corporateRegistration { get; set; }
		public String corporateURL { get; set; }
		public Date foundingDate { get; set; }
		public String tradeName { get; set; }
		public String legalName { get; set; }
		public String fiscalRegistration { get; set; }
		public String complement { get; set; }
		public String integrationType { get; set; }
		public Boolean hasPEP { get; set; }
		public String serviceCategory { get; set; }
		public String serviceDescription { get; set; }
		public String serviceShipping { get; set; }
		public String status { get; set; }
		public String storeURL { get; set; }
		public Id opportunityId { get; set; }
		public Decimal stageNumber { get; set; }
		public Decimal urlsQuantity { get; set; }
		public String uniqueLink { get; set; }
		public String legalApprovalStatus { get; set; }
		public List<Contact> kycContacts { get; set; }

		// Campos exclusivos de KYC__c
		public String proprietaryContact { get; set; }
		public String bankOption { get; set; }
		public String bankNumber { get; set; }
		public String mainContact { get; set; }
		public String personalContact { get; set; }
		public KycWrapper(SObject kyc) {
			if (kyc.getSObjectType() == KYC__c.SObjectType) {
				KYC__c k = (KYC__c)kyc;

				this.id = k.Id;
				this.name = k.Name;
				this.lastModifiedDate = k.LastModifiedDate;
				this.opportunityId = k.Opportunity__c;
				this.uniqueAddress = k.Unique_Address__c;
				this.city = k.City__c;
				this.state = k.State__c;
				this.country = k.Country__c;
				this.postalCode = k.Postal_Code__c;
				this.streetNumber = k.Street_Number__c;
				this.address = k.Address__c;
				this.admCity = k.Adm_City__c;
				this.admState = k.Adm_State__c;
				this.admCountry = k.Adm_Country__c;
				this.admPostalCode = k.Adm_Postal_Code__c;
				this.admStreetNumber = k.Adm_Street_Number__c;
				this.admAddress = k.Adm_Address__c;
				this.bankAccount = k.Bank_Account__c;
				this.bankAccountDocument = k.Bank_Account_Document__c;
				this.bankAgency = k.Bank_Agency__c;
				this.bankName = k.Bank_Name__c;
				this.complement = k.Complement__c;
				this.companyType = k.Company_Type__c;
				this.companyURL = k.Company_URL__c;
				this.conformity = k.Conformity__c;
				this.corporateGroup = k.Corporate_Group__c;
				this.corporateName = k.Corporate_Name__c;
				this.corporateRegistration = k.Corporate_Registration__c;
				this.corporateURL = k.Corporate_URL__c;
				this.foundingDate = k.Founding_Date__c;
				this.tradeName = k.Trade_Name__c;
				this.legalName = k.Legal_Name__c;
				this.fiscalRegistration = k.Fiscal_Registration__c;
				this.integrationType = k.Integration_Type__c;
				this.serviceCategory = k.Service_Category__c;
				this.serviceDescription = k.Service_Description__c;
				this.serviceShipping = k.Service_Shipping__c;
				this.status = k.Status__c;
				this.storeURL = k.Store_URL__c;
				this.stageNumber = k.Stage_Number__c; //
				this.urlsQuantity = k.URLs_Quantity__c; //
				this.uniqueLink = k.Unique_Link__c;
				this.legalApprovalStatus = k.Legal_Approval_Status__c;
				this.mainContact = k.Main_Contact__c;
				this.personalContact = k.Personal_Contact__c;
				this.bankOption = k.Bank_Option__c;
				this.bankNumber = k.Bank_Number__c;
				this.proprietaryContact = k.Proprietary_Contact__c;

				this.kycContacts = k.KYC_Contacts__r;
			}
			else if (kyc.getSObjectType() == KYC_XB__c.SObjectType) {
				KYC_XB__c k = (KYC_XB__c)kyc;

				this.id = k.Id;
				this.name = k.Name;
				this.lastModifiedDate = k.LastModifiedDate;
				this.opportunityId = k.Opportunity__c;
				this.clientAccountId = k.Client_Account__c;
				this.uniqueAddress = k.Unique_Address__c;
				this.city = k.City__c;
				this.state = k.State__c;
				this.country = k.Country__c;
				this.postalCode = k.Postal_Code__c;
				this.streetNumber = k.Street_Number__c;
				this.address = k.Address__c;
				this.admCity = k.Administrative_City__c;
				this.admState = k.Administrative_State__c;
				this.admCountry = k.Administrative_Country__c;
				this.admPostalCode = k.Adm_Postal_Code__c;
				this.admStreetNumber = k.Administrative_Street_Number__c;
				this.admAddress = k.Adm_Address__c;
				this.bankAccount = k.Bank_Account__c;
				this.bankAgency = k.Bank_Agency__c;
				this.beneficiary = k.Beneficiary__c;
				this.bankName = k.Bank_Name__c;
				this.bankBranchAddress = k.Bank_Branch_Address__c;
				this.swiftCode = k.Swift_Code__c;
				this.abaRoutingNumber = k.ABA_Routing_Number__c;
				this.ibanNumber = k.IBAN_Number__c;
				this.bankHasIntermediary = k.Bank_Has_Intermediary__c;
				this.intermediaryBankName = k.Intermediary_Bank_Name__c;
				this.wireInstructions = k.Wire_Instructions__c;
				this.companyType = k.Company_Type__c;
				this.companyURL = k.Company_URL__c;
				this.conformity = k.Conformity__c;
				this.corporateGroup = k.Corporate_Group__c;
				this.corporateName = k.Corporate_Name__c;
				this.corporateRegistration = k.Corporate_Registration__c;
				this.corporateURL = k.Corporate_URL__c;
				this.foundingDate = k.Founding_Date__c;
				this.tradeName = k.Trade_Name__c;
				this.legalName = k.Legal_Name__c;
				this.fiscalRegistration = k.Fiscal_Registration__c;
				this.complement = k.Complement__c;
				this.integrationType = k.Integration_Type__c;
				this.hasPEP = k.Has_PEP__c;
				this.serviceCategory = k.Service_Category__c;
				this.serviceDescription = k.Service_Description__c;
				this.serviceShipping = k.Service_Shipping__c;
				this.status = k.Status__c;
				this.storeURL = k.Store_URL__c;
				this.stageNumber = k.Stage_Number__c; //
				this.urlsQuantity = k.URLs_Quantity__c; //
				this.uniqueLink = k.Unique_Link__c;
				this.legalApprovalStatus = k.LegalApprovalStatus__c;

				this.kycContacts = k.Contacts__r;
			}
			else {
				throw new AuraHandledException('Unsupported KYC object type: ' + kyc.getSObjectType());
			}
		}

		public String getVatOrCnpj() {
			return this.fiscalRegistration;
		}

		public String getBusinessName() {
			return this.legalName;
		}

		public String getBillingNumber() {
			return this.streetNumber;
		}

		public String getBillingComplement() {
			return this.complement;
		}

		public String getFinancialEmails() {
			if (this.kycContacts == null) return '';
			List<String> emails = new List<String>();
			for (Contact c : this.kycContacts) {
				if (c.Type__c != null && c.Type__c.contains('Financeiro') && c.Email != null) {
					emails.add(c.Email);
				}
			}
			return String.join(emails, '; ');
		}
	}

}