/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 07-16-2025
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
                UsePagstream__c,
                Country__c,
                Product_Type__c,
                GooglePay__c,
                ApplePay__c,
                ProductClass__c,
                Pix_Automatico__c,
                WebSite__c,
                TierCS__c,
                ThreeDSCreditCard__c,
                ZeroAuthCreditCard__c,
                SyncedQuoteId,
                Moeda__c,
                StageName,
                DateAccountCreation__c,
                Product_or_service_website_URL__c,
                IntegrationType__c,
                Antecipation_Frequency_1__c,
                Antecipation_Frequency_2__c,
                Settlement_Frequency_1__c,
                Settlement_Frequency_2__c,
                PagShield_Premium__c,
                PagShield_Premium_On_Demand__c,
                Priority__c,
                TicketId__c,
                TicketCreationDate__c,
                BusinessModelType__c,
                Cartao_Debito_Mensal__c,
                PaymentRecurrence__c,
                Antecipation__c,
                Which_platform__c,
                PagShield__c,
                PixOneClick__c,
                tempNBvalue__c,
                tempXBvalue__c,
                nb_receita_mensal__c,
                KYC_NB_Number__c,
                KYC_XB_Number__c,
                DisableAgency__c,
                Has_Synced_Quote__c,
                Quotes_Amount__c,
                RelatedKYCSendStatus__c,
                OpportunityKYCLegalApprovalStatus__c,
                OpportunityRCCLegalApprovalStatus__c,
                Was_Contract_PDF_Generated__c,
                Hibernate__c,
                Date_Discovery_Meeting__c,
                First_Appointment_Status__c,
                Acceptable_Proposal__c,
                Lead_Owner__c,
                Account_Billing_Country__c,
                Answered_Confirmation_Form__c,
                Is_Opportunity_Valid__c,
                Current_Platform__c,
                Other_Platform__c,
                RequestChangeClause__c,
                Can_Edit_Opportunity_Fields__c,
                Can_View_Opportunity_Fields__c,
                Can_Edit_Fields_Negotiation__c,
                Can_Read_Only_Compliance__c,
                Can_Edit_Fields_Discovery__c,
                Can_Read_Only_Negotiation__c,
                Contract_File_Id__c,
                Contract_Start_Fee_Date__c,
                Is_Opportunity_Hybrid__c,
                Visible_Settlement_Frequency__c,
                Visible_Anticipation_Frequency__c,
                Other_Payments_Settlement_Frequency_1__c,
                Other_Payments_Settlement_Frequency_2__c,
                Preferred_Language__c,
                Visible_Others_Settlement_Frequency__c,
                Negotiation_Completed__c,
                Signed_Contract__c,
                Homologation_Completed__c,
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
                Pix_Automatico__c,
                WebSite__c,
                TierCS__c,
                ThreeDSCreditCard__c,
                ZeroAuthCreditCard__c,
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
                Account.OrganizationId__c,
                RecordType.DeveloperName,
                PagShield__c,
                PagShield_Premium__c
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
                ThreeDSCreditCard__c,
                ZeroAuthCreditCard__c,
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
                Account.ParentId,
                PagShield_Premium__c,
                RecordType.DeveloperName,
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
                        PixPending__c,
                        Category__c,
                        BoletoBancario__c,
                        CartaoDeCredito__c,
                        DebitoDebitoFlash__c,
                        BoletoFlash__c,
                        Pix__c,
                        PagStream__c,
                        Allow_CPF_CNPJ__c,
                        Subscriber_Area__c,
                        AgendaDeLiberacao__c,
                        PixOpenFinance__c,
                        Pix_Valid_For__c,
                        MaximumNumberInstallments__c,
                        RegKey__c,
            			Account_Request_Date__c,
            			Account_in_Mode__c,
            			Minimum_Remittance_Amount__c,
            			Remittance_Tax__c,
						Remittance_Type__c,
						Remittance_Agent__c,
						Additional_for_Remote_Payments_Fixed__c,
						Additional_for_Remote_Payments_Variable__c,
						API_Fixed__c,
						API_Variable__c,
						PagBrasil_Mobile_POS_Fixed__c,
						PagBrasil_Mobile_POS_Variable__c,
                        Minimum_Amount_to_Activate_PagShield__c
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
                LastModifiedDate,
                Postal_Code__c,
                Trade_Name__c,
                Bank_Account_Document__c,
                Status__c,
                Integration_Type__c,
                Unique_Link__c,
                Adm_Street_Number__c,
                LastViewedDate,
                Corporate_Registration__c,
                Company_Type__c,
                LastReferencedDate,
                Company_URL__c,
                CreatedById,
                Corporate_URL__c,
                Bank_Account__c,
                CreatedDate,
                Bank_Account_Owner__c,
                Service_Shipping__c,
                IsDeleted,
                Adm_Complement__c,
                Personal_Contact__c,
                Legal_Approval_Status__c,
                Adm_Country__c,
                Founding_Date__c,
                Corporate_Name__c,
                Unique_Address__c,
                Address__c,
                State__c,
                Adm_Address__c,
                OwnerId,
                Adm_City__c,
                City__c,
                Adm_State__c,
                Service_Description__c,
                CurrencyIsoCode,
                Adm_Postal_Code__c,
                Client_Account__c,
                Main_Contact__c,
                Service_Category__c,
                Conformity__c,
                SystemModstamp,
                Bank_Number__c,
                Corporate_Group__c,
                Street_Number__c,
                Fiscal_Registration__c,
                Bank_Option__c,
                Proprietary_Contact__c,
                Bank_Agency__c,
                Legal_Name__c,
                UserRecordAccessId,
                Complement__c,
                Country__c,
                LastModifiedById,
                Bank_Name__c,
                Opportunity__c,
                Stage_Number__c,
                URLs_Quantity__c,
                Store_URL__c
            FROM KYC__c
            WHERE Opportunity__c = :opportunityId
        ];

        if(kycs.isEmpty()) {
            return null;
        }

        return kycs[0];
    }

    public static KYC_XB__c getKycXbByOpportunityId(Id opportunityId) {
        List<KYC_XB__c> kycs = [
            SELECT
                Id,
                Name,
                LastModifiedDate,
                Client_Account__c,
                Unique_Address__c,
                City__c,
                State__c,
                Country__c,
                Postal_Code__c,
                Street_Number__c,
                Address__c,
                Administrative_City__c,
                Administrative_State__c,
                Administrative_Country__c,
                Adm_Postal_Code__c,
                Administrative_Street_Number__c,
                Adm_Address__c,
                Administrative_Complement__c,
                Administrative_Address__c,
                Administrative_Postal_Code__c,
                Bank_Account__c,
                Bank_Agency__c,
                Beneficiary__c,
                Bank_Name__c,
                Bank_Branch_Address__c,
                Swift_Code__c,
                ABA_Routing_Number__c,
                IBAN_Number__c,
                Bank_Has_Intermediary__c,
                Intermediary_Bank_Name__c,
                Wire_Instructions__c,
                Company_Type__c,
                Company_URL__c,
                Conformity__c,
                Corporate_Group__c,
                Corporate_Name__c,
                Corporate_Registration__c,
                Corporate_URL__c,
                Founding_Date__c,
                Trade_Name__c,
                Legal_Name__c,
                Fiscal_Registration__c,
                Complement__c,
                Integration_Type__c,
                Has_PEP__c,
                Service_Category__c,
                Service_Description__c,
                Service_Shipping__c,
                Status__c,
                Store_URL__c,
                Opportunity__c,
                URLs_Quantity__c,
                Unique_Link__c,
                LegalApprovalStatus__c,
                Stage_Number__c,
                International_Carrier__c,
                Personal_Contact__c,
                OwnerId,
                IsDeleted,
                CurrencyIsoCode,
                CreatedDate,
                CreatedById,
                LastModifiedById,
                SystemModstamp,
                LastActivityDate,
                LastViewedDate,
                LastReferencedDate,
                UserRecordAccessId,

                (SELECT
                    Id,
                    Name,
                    Email,
                    KYC_Role__c
                FROM Contacts__r)

            FROM KYC_XB__c
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
                        RegKey__c,
            			Account_Request_Date__c,
            			Account_in_Mode__c,
            			Minimum_Remittance_Amount__c,
            			Remittance_Tax__c,
						Remittance_Type__c,
						Remittance_Agent__c,
						Additional_for_Remote_Payments_Fixed__c,
						Additional_for_Remote_Payments_Variable__c,
						API_Fixed__c,
						API_Variable__c,
						PagBrasil_Mobile_POS_Fixed__c,
						PagBrasil_Mobile_POS_Variable__c,
                        Minimum_Amount_per_Installment__c,
                        Category__c,
                        BoletoBancario__c,
                        BoletoFlash__c,
                        Pix__c,
                        CartaoDeCredito__c,
                        DebitoDebitoFlash__c,
                        Pix_Valid_For__c,
                        MaximumNumberInstallments__c,
                        PagStream__c,
                        Subscriber_Area__c,
                        Minimum_Amount_to_Activate_PagShield__c
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
                        RegKey__c,
            			Account_Request_Date__c,
            			Account_in_Mode__c,
            			Minimum_Remittance_Amount__c,
            			Remittance_Tax__c,
						Remittance_Type__c,
						Remittance_Agent__c,
						Additional_for_Remote_Payments_Fixed__c,
						Additional_for_Remote_Payments_Variable__c,
						API_Fixed__c,
						API_Variable__c,
						PagBrasil_Mobile_POS_Fixed__c,
						PagBrasil_Mobile_POS_Variable__c,
                        Minimum_Amount_per_Installment__c,
                        Category__c,
                        BoletoBancario__c,
                        BoletoFlash__c,
                        Pix__c,
                        CartaoDeCredito__c,
                        DebitoDebitoFlash__c,
                        Pix_Valid_For__c,
                        MaximumNumberInstallments__c,
                        PagStream__c,
                        Subscriber_Area__c,
                        Minimum_Amount_to_Activate_PagShield__c
        FROM HomologationForm__c
        WHERE Id = :homologationId
        LIMIT 1
    ];
    
        return homologations.isEmpty() ? null : homologations[0];
    }
}