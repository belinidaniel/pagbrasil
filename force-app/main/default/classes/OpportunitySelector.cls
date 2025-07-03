/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 05-27-2025
 * @last modified by  : Daniel Belini
**/
public without sharing class OpportunitySelector {

    public static List<Opportunity> getOpportuniesByIds(Set<Id> oppIds){
        return [
            SELECT
                Id,
                Name,
                Payout__c,
                BusinessModel__c,
                NationalPaymentMethod__c,
                AverageSalesTicket__c,
                previs_fat_rs__c,
                AntecipationFrequency__c,
                Settlement_Frequency_Test__c,
                Country__c,
                Product_Type__c,
                ProductClass__c,
                WebSite__c,
                TierCS__c,
                Moeda__c,
                StageName,
                DateAccountCreation__c,
                Product_or_service_website_URL__c,
                IntegrationType__c,
                Antecipation_Frequency_1__c,
                Settlement_Frequency_1__c,
                SyncedQuoteId,
                Priority__c,
                RecordType.Name,
                AccountId,
                Account.Name,
                Account.Nome_Empresarial__c,
                Account.Phone,
                Account.Website,
                Account.VATCNPJ__c,
                Account.OrganizationId__c,
                RecordType.DeveloperName
            FROM Opportunity
            WHERE Id IN :oppIds
        ];
    }

    /**
    * @description get opportunity by id
    * @author Hersilio Belini de Oliveira | 2025-01-08
    * @param opportunityId
    * @return Opportunity
    **/
    public static Opportunity getOpportunityById(Id opportunityId) {
        List<Opportunity> opps = [
            SELECT
                Id,
                Name,
                Country__c,
                Product_Type__c,
                ProductClass__c,
                WebSite__c,
                TierCS__c,
                Moeda__c,
                StageName,
                AntecipationFrequency__c,
                Settlement_Frequency_Test__c,
                UsePagstream__c,
                ApplePay__c,
                GooglePay__c,
                DateAccountCreation__c,
                PagShield_Premium_On_Demand__c,
                Product_or_service_website_URL__c,
                IntegrationTypeSpecify__c,
                PixMensal__c,
                Categoria_de_Produto__c,
                Metodos_Pagamento__c,
                IntegrationType__c,
                SyncedQuoteId,
                Priority__c,
                Payout__c,
                Integracao__c,
                BusinessModel__c,
                NationalPaymentMethod__c,
                Settlement_Frequency_1__c,
                previs_fat_rs__c,
                RecordType.Name,
                AccountId,
                Account.Name,
                Account.Nome_Empresarial__c,
                Antecipation_Frequency_1__c,
                Account.Phone,
                Account.Website,
                Account.CNPJ__c,
                Account.VATCNPJ__c,
                Account.OrganizationId__c
            FROM Opportunity
            WHERE Id = :opportunityId
        ];

        if(opps.isEmpty()) {
            return null;
        }

        return opps[0];
    }

    /**
    * @description get opportunity by id
    * @author Hersilio Belini de Oliveira | 2025-01-08
    * @param opportunityId
    * @return Opportunity
    **/
    public static Opportunity getCompleteOpportunityById(Id opportunityId) {
        List<Opportunity> opps = [
            SELECT
                Id,
                Name,
                Product_Type__c,
                Metodos_Pagamento__c,
                Categoria_de_Produto__c,
                IntegrationType__c,
                TierCS__c,
                PixMensal__c,
                Moeda__c,
                BusinessModel__c,
                IntegrationTypeSpecify__c,
                Contract_Start_Fee_Date__c,
                NationalPaymentMethod__c,
                UsePagstream__c,
                Payout__c,
                GooglePay__c,
                PagShield__c,
                ApplePay__c,
                Settlement_Frequency_1__c,
                PagShield_Premium_On_Demand__c,
                SyncedQuoteId,
                Priority__c,
                Integracao__c,
                RecordType.Name,
                Account.Name,
                DateAccountCreation__c,
                Account.OrganizationId__c,
                Account.BillingStreet,
                Account.BillingCity,
                Account.BillingState,
                Account.BillingPostalCode,
                Account.BillingCountry,
                Account.BillingLatitude,
                Account.BillingLongitude,
                Account.BillingGeocodeAccuracy,
                Account.BillingComplement__c,
                Account.BillingNumber__c,
                Account.ShippingStreet,
                Account.ShippingCity,
                Account.ShippingState,
                Account.ShippingPostalCode,
                Account.ShippingCountry,
                Account.ShippingLatitude,
                Account.ShippingLongitude,
                Account.ShippingGeocodeAccuracy,
                Account.ShippingAddress,
                Account.ShippingNumber__c,
                Account.ShippingComplement__c,
                Account.Nome_Empresarial__c,
                Account.Nome_Comercial__c,
                Account.CNPJ__c,
                Account.Bank_Details_Number__c,
                Account.Bank_Details_Branch__c,
                Account.Bank_Details_CNPJ__c,
                Account.Bank_Details_Checking_Account__c,
                Account.Bank_Details_Name__c,
                Account.Bank_Details_Company_Name__c,
                Account.CustomerFinalSupportChannelUrl__c,
                Account.CustomerFinalSupportChannelEmail__c,

                (SELECT Id,
                        Login__c,
                        Password__c,
                        Cielo30__c,
                        MonthlyInterestOnCustomerInstallments__c,
                        TerminalId__c,
                        PbCheckoutDiscount__c,
                        PagBrasilSolutionForTransferringFee__c,
                        MidMerchantId__c,
                        ShopifyDiscount__c,
                        PagBrasilPix__c,
                        MerchantId__c,
                        NotInterestedInOfferingDiscount__c,
                        EvidenceCompanyDetails__c,
                        EvidenceContactInformation__c,
                        EvidenceResponseTime__c,
                        EvidencePriceFormat__c,
                        EvidenceInfoValidator__c,
                        EvidenceDeliveryTime__c,
                        EvidenceShippingProofPod__c,
                        EvidenceCustomsFee__c,
                        EvidenceZipCodeValidator__c,
                        EvidenceGateway__c,
                        EvidenceReclameAqui__c,
                        Opportunity__c,
                        CompanyDetails__c,
                        ContactInformation__c,
                        RequirementResponseTime__c,
                        RequirementPriceFormat__c,
                        DeliveryTime__c,
                        ShippingProofPod__c,
                        CustomsFee__c,
                        RequirementZipCodeValidator__c,
                        RequirementInfoValidator__c,
                        MinimumInstallmentsForInterest__c,
                        InterestRepassMethodToCustomer__c,
                        AlreadyRequestedReclameAqui__c,
                        PodReminder__c,
                        AutomaticCancellation__c,
                        CreditCardRecurrence__c,
                        DefaultSoftDescriptor__c,
                        InstallmentRecurrence__c,
                        BankSlipEmailService__c,
                        BankSlipSmsService__c,
                        PagShield__c,
                        PagShield_Premium__c,
                        PixEmailService__c,
                        EmailPackage__c,
                        PaymentConfirmationEmailService__c,
                        PaymentLinkEmailService__c,
                        OneClickBuyingTokenization__c,
                        ReviewPayeeRegistration__c,
                        main_contact_email__c,
                        TransactionType__c,
                        EmailsPodManager__c,
                        MccCode__c,
                        PaymentAlert__c,
                        BlockRefund__c,
                        NumberOfDays__c,
                        FlashBoleto__c,
                        Pix_Pending__c,
                        Contact_email_for_notification__c,
                        Pix_Open_Finance__c,
                        SmsPackage__c,
                        MerchantKey__c,
                        Pv__c,
                        Token__c,
                        RegKey__c
                FROM HomologationForms__r)
            FROM Opportunity
            WHERE Id = :opportunityId
        ];

        if(opps.isEmpty()) {
            return null;
        }

        return opps[0];
    }

    public static Rcc__c getRccByOpportunityId(Id opportunityId) {
        List<Rcc__c> rccs = [
            SELECT
                Id,
                Final_Risk__c
            FROM Rcc__c
            WHERE Opportunity__c = :opportunityId
        ];

        if(rccs.isEmpty()) {
            return null;
        }

        return rccs[0];
    }
    public static KYC__c getKycByOpportunityId(Id opportunityId) {
        List<KYC__c> kycs = [
            SELECT
                Id,
                Name,
                LastModifiedDate
            FROM KYC__c
            WHERE Opportunity__c = :opportunityId
        ];

        if(kycs.isEmpty()) {
            return null;
        }

        return kycs[0];
    }

    public static List<HomologationForm__c> getHomologationsByOpportunityId(Id opportunityId) {
        return [
            SELECT Id, 
                        Name,
                        Opportunity__c,
                        Login__c,
                        Password__c,
                        Cielo30__c,
                        MonthlyInterestOnCustomerInstallments__c,
                        TerminalId__c,
                        PbCheckoutDiscount__c,
                        PagBrasilSolutionForTransferringFee__c,
                        MidMerchantId__c,
                        ShopifyDiscount__c,
                        PagBrasilPix__c,
                        MerchantId__c,
                        NotInterestedInOfferingDiscount__c,
                        EvidenceCompanyDetails__c,
                        EvidenceContactInformation__c,
                        EvidenceResponseTime__c,
                        EvidencePriceFormat__c,
                        EvidenceInfoValidator__c,
                        EvidenceDeliveryTime__c,
                        EvidenceShippingProofPod__c,
                        EvidenceCustomsFee__c,
                        EvidenceZipCodeValidator__c,
                        EvidenceGateway__c,
                        EvidenceReclameAqui__c,
                        CompanyDetails__c,
                        ContactInformation__c,
                        RequirementResponseTime__c,
                        RequirementPriceFormat__c,
                        DeliveryTime__c,
                        ShippingProofPod__c,
                        CustomsFee__c,
                        RequirementZipCodeValidator__c,
                        RequirementInfoValidator__c,
                        MinimumInstallmentsForInterest__c,
                        InterestRepassMethodToCustomer__c,
                        AlreadyRequestedReclameAqui__c,
                        PodReminder__c,
                        AutomaticCancellation__c,
                        CreditCardRecurrence__c,
                        DefaultSoftDescriptor__c,
                        InstallmentRecurrence__c,
                        BankSlipEmailService__c,
                        BankSlipSmsService__c,
                        PagShield__c,
                        PagShield_Premium__c,
                        PixEmailService__c,
                        EmailPackage__c,
                        PaymentConfirmationEmailService__c,
                        PaymentLinkEmailService__c,
                        OneClickBuyingTokenization__c,
                        ReviewPayeeRegistration__c,
                        main_contact_email__c,
                        TransactionType__c,
                        EmailsPodManager__c,
                        MccCode__c,
                        PaymentAlert__c,
                        BlockRefund__c,
                        NumberOfDays__c,
                        FlashBoleto__c,
                        Pix_Pending__c,
                        Contact_email_for_notification__c,
                        Pix_Open_Finance__c,
                        SmsPackage__c,
                        MerchantKey__c,
                        Pv__c,
                        Token__c,
                        RegKey__c
            FROM HomologationForm__c
            WHERE Opportunity__c = :opportunityId
        ];
    }

    public static HomologationForm__c getHomologationById(Id homologationId) {
    List<HomologationForm__c> homologations = [
                        SELECT Id, 
                        Opportunity__c,
                        Name,
                        Login__c,
                        Password__c,
                        Cielo30__c,
                        MonthlyInterestOnCustomerInstallments__c,
                        TerminalId__c,
                        PbCheckoutDiscount__c,
                        PagBrasilSolutionForTransferringFee__c,
                        MidMerchantId__c,
                        ShopifyDiscount__c,
                        PagBrasilPix__c,
                        MerchantId__c,
                        NotInterestedInOfferingDiscount__c,
                        EvidenceCompanyDetails__c,
                        EvidenceContactInformation__c,
                        EvidenceResponseTime__c,
                        EvidencePriceFormat__c,
                        EvidenceInfoValidator__c,
                        EvidenceDeliveryTime__c,
                        EvidenceShippingProofPod__c,
                        EvidenceCustomsFee__c,
                        EvidenceZipCodeValidator__c,
                        EvidenceGateway__c,
                        EvidenceReclameAqui__c,
                        CompanyDetails__c,
                        ContactInformation__c,
                        RequirementResponseTime__c,
                        RequirementPriceFormat__c,
                        DeliveryTime__c,
                        ShippingProofPod__c,
                        CustomsFee__c,
                        RequirementZipCodeValidator__c,
                        RequirementInfoValidator__c,
                        MinimumInstallmentsForInterest__c,
                        InterestRepassMethodToCustomer__c,
                        AlreadyRequestedReclameAqui__c,
                        PodReminder__c,
                        AutomaticCancellation__c,
                        CreditCardRecurrence__c,
                        DefaultSoftDescriptor__c,
                        InstallmentRecurrence__c,
                        BankSlipEmailService__c,
                        BankSlipSmsService__c,
                        PagShield__c,
                        PagShield_Premium__c,
                        PixEmailService__c,
                        EmailPackage__c,
                        PaymentConfirmationEmailService__c,
                        PaymentLinkEmailService__c,
                        OneClickBuyingTokenization__c,
                        ReviewPayeeRegistration__c,
                        main_contact_email__c,
                        TransactionType__c,
                        EmailsPodManager__c,
                        MccCode__c,
                        PaymentAlert__c,
                        BlockRefund__c,
                        NumberOfDays__c,
                        FlashBoleto__c,
                        Pix_Pending__c,
                        Contact_email_for_notification__c,
                        Pix_Open_Finance__c,
                        SmsPackage__c,
                        MerchantKey__c,
                        Pv__c,
                        Token__c,
                        RegKey__c
        FROM HomologationForm__c
        WHERE Id = :homologationId
        LIMIT 1
    ];
    
        return homologations.isEmpty() ? null : homologations[0];
    }
}