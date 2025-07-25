public with sharing class OpportunityFieldsPageController {

    public OpportunityWrapper wrapper { get; private set; }
    public OpportunityWrapper.RccWrapper rccWrapper { get; private set; }
    public OpportunityWrapper.KycWrapper kycWrapper { get; private set; }

    public List<HomologationForm__c> homologationForms { get; private set; }
    public List<HomologationUser__c> homologationUsers { get; private set; }

public Boolean hasMainSection {
    get {
        return wrapper != null && wrapper.name != null && wrapper.name != '';
    }
}

public Boolean hasBillingInfo {
    get {
        return kycWrapper != null && (
            (kycWrapper.fiscalRegistration != null && kycWrapper.fiscalRegistration != '') ||
            (kycWrapper.legalName != null && kycWrapper.legalName != '') ||
            (kycWrapper.country != null && kycWrapper.country != '')
        );
    }
}

public Boolean hasHomologationUsers {
    get {
        return homologationUsers != null && !homologationUsers.isEmpty();
    }
}

public Boolean hasPagShieldSection {
    get {
        return homologationForms != null && !homologationForms.isEmpty() &&
            (homologationForms[0].Minimum_Amount_to_Activate_PagShield__c != null ||
             homologationForms[0].Contact_email_for_notification__c != null);
    }
}

public Boolean hasFormData {
    get {
        return homologationForms != null && !homologationForms.isEmpty();
    }
}

public Boolean hasPayments {
    get {
        return homologationForms != null && !homologationForms.isEmpty() && (
            homologationForms[0].BoletoBancario__c != null ||
            homologationForms[0].BoletoFlash__c != null ||
            homologationForms[0].Pix__c != null ||
            homologationForms[0].CartaoDeCredito__c != null ||
            homologationForms[0].DebitoDebitoFlash__c != null
        );
    }
}

public Boolean hasPaymentAlert {
    get {
        return homologationForms != null && !homologationForms.isEmpty() && 
            (homologationForms[0].PaymentAlert__c != null && homologationForms[0].PaymentAlert__c != '');
    }
}

public Boolean hasTransferRelease {
    get {
        return wrapper != null && wrapper.payout != null;
    }
}

public Boolean hasFunctionalities {
    get {
        return homologationForms != null && !homologationForms.isEmpty() && 
            (homologationForms[0].BlockRefund__c != null && homologationForms[0].BlockRefund__c != '');
    }
}

public Boolean hasShipment {
    get {
        return wrapper != null && (wrapper.settlementFrequency != null || (wrapper.currencyMarkupSpread != null && wrapper.currencyMarkupSpread.percentValue != null));
    }
}

public Boolean hasProducts_BankBillet {
    get {
        return homologationForms != null && !homologationForms.isEmpty() && 
            (homologationForms[0].AutomaticCancellation__c != null || homologationForms[0].NumberOfDays__c != null);
    }
}

public Boolean hasProducts_Pix {
    get {
        return homologationForms != null && !homologationForms.isEmpty() &&
            (homologationForms[0].Pix_Open_Finance__c != null || homologationForms[0].Pix_Valid_For__c != null);
    }
}

public Boolean hasProducts_CreditCard {
    get {
        return homologationForms != null && !homologationForms.isEmpty() &&
            (homologationForms[0].CreditCardRecurrence__c != null || homologationForms[0].InstallmentRecurrence__c != null);
    }
}

public Boolean hasProducts_PaymentLink {
    get {
        return homologationForms != null && !homologationForms.isEmpty() &&
            (homologationForms[0].PaymentLinkEmailService__c != null || homologationForms[0].FlashBoleto__c != null || homologationForms[0].PagBrasilPix__c != null);
    }
}

public Boolean hasProducts_Pagstream {
    get {
        return homologationForms != null && !homologationForms.isEmpty() &&
            (homologationForms[0].PagStream__c != null || homologationForms[0].Subscriber_Area__c != null);
    }
}

public Boolean hasAccountFees_Maintenance {
    get {
        return wrapper != null && (wrapper.taxaMinimaManutencao != null || wrapper.taxaSolucaoPagBrasil != null || wrapper.taxaPagStream != null || wrapper.taxaMinimaPagStream != null);
    }
}

public Boolean hasAccountFees_MonthlyAnticipation {
    get {
        return wrapper != null && (wrapper.taxaBaseAntecipacao != null);
    }
}

public Boolean hasAccountFees_Fees {
    get {
        return wrapper != null;
    }
}

public Boolean hasEmailSmsService {
    get {
        return homologationForms != null && !homologationForms.isEmpty() &&
            (homologationForms[0].BankSlipEmailService__c != null ||
            homologationForms[0].PixEmailService__c != null ||
            homologationForms[0].PaymentConfirmationEmailService__c != null ||
            homologationForms[0].PaymentLinkEmailService__c != null ||
            homologationForms[0].BankSlipSmsService__c != null);
    }
}

public Boolean hasEmailPackage {
    get {
        return wrapper != null && (wrapper.pacoteMilEmails != null || wrapper.pacoteDezMilEmails != null || wrapper.pacoteCemMilEmails != null) &&
               homologationForms != null && !homologationForms.isEmpty() && homologationForms[0].EmailPackage__c != null;
    }
}

public Boolean hasSmsPackage {
    get {
        return wrapper != null && (wrapper.pacote500sms != null || wrapper.pacoteMilSms != null || wrapper.pacoteDezMilSms != null) &&
               homologationForms != null && !homologationForms.isEmpty() && homologationForms[0].SmsPackage__c != null;
    }
}

public Boolean hasShopify {
    get {
        return wrapper != null && wrapper.containsShopify != null && wrapper.containsShopify;
    }
}

public Boolean hasPayout {
    get {
        return wrapper != null && wrapper.payout != null;
    }
}

public Boolean hasGateway {
    get {
        return wrapper != null && wrapper.containsGateway != null && wrapper.containsGateway;
    }
}

    public OpportunityFieldsPageController() {
        String opportunityId = ApexPages.currentPage().getParameters().get('id');
        String homologationId = ApexPages.currentPage().getParameters().get('homologationId');

        if (String.isNotBlank(opportunityId)) {
            Opportunity opp = OpportunitySelector.getCompleteOpportunityById(opportunityId);
            Rcc__c rcc = OpportunitySelector.getRccByOpportunityId(opportunityId);

            sObject kyc;

            if (opp.RecordType.DeveloperName == 'NaTional') {
                kyc = OpportunitySelector.getKycByOpportunityId(opportunityId);
            } else {
                kyc = OpportunitySelector.getKycXbByOpportunityId(opportunityId);
            }

            rccWrapper = new OpportunityWrapper.RccWrapper(rcc);
            kycWrapper = new OpportunityWrapper.KycWrapper(kyc);
            wrapper = new OpportunityWrapper(opp);

            if (String.isNotBlank(homologationId)) {
                homologationForms = new List<HomologationForm__c>{
                    OpportunitySelector.getHomologationById(homologationId)
                };
            } else {
                homologationForms = OpportunitySelector.getHomologationsByOpportunityId(opportunityId);
            }

            if (!homologationForms.isEmpty()) {
                Set<Id> homologationFormIds = new Set<Id>();
                for (HomologationForm__c form : homologationForms) {
                    homologationFormIds.add(form.Id);
                }

                homologationUsers = [
                    SELECT Id, Name, Nivel_de_Acesso__c, Nome_e_Sobrenome__c, 
                        Email__c, Idioma__c, Users__c
                    FROM HomologationUser__c 
                    WHERE Users__c IN :homologationFormIds
                ];
            }
        }
    }
}