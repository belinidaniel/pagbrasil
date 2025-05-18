/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-02-28
 * @last modified by  : Hersilio Belini de Oliveira
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
                BusinessModel__c,
                IntegrationTypeSpecify__c,
                UsePagstream__c,
                Payout__c,
                GooglePay__c,
                ApplePay__c,
                PagShield_Premium_On_Demand__c,
                SyncedQuoteId,
                Priority__c,
                Integracao__c,
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
                        PixEmailService__c,
                        EmailPackage__c,
                        PaymentConfirmationEmailService__c,
                        PaymentLinkEmailService__c,
                        OneClickBuyingTokenization__c,
                        ReviewPayeeRegistration__c,
                        TransactionType__c,
                        EmailsPodManager__c
                FROM HomologationForms__r)
            FROM Opportunity
            WHERE Id = :opportunityId
        ];

        if(opps.isEmpty()) {
            return null;
        }

        return opps[0];
    }
}