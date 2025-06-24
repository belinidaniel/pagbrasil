public with sharing class HomologationFormHelper {
    public static void hasContractBeenSignedAndHomologationCompleted(List<HomologationForm__c> newList, Map<Id,HomologationForm__c> oldMap){

        Map<Opportunity,Boolean> hasContractBeenSignedAndHomologationCompleted = new Map<Opportunity,Boolean>();

        if(newList == null || newList.isEmpty() || oldMap == null || oldMap.isEmpty())
            return;

        Set<Id> oppToValidate = new Set<Id>();

        for(HomologationForm__c homologationForm : newList)
            oppToValidate.add(homologationForm.Opportunity__c);

        System.debug('oppToValidate: ' + oppToValidate);

        if(oppToValidate.isEmpty())
            return;

        List<Opportunity> oppList = [SELECT Id, StageName FROM Opportunity WHERE Id IN :oppToValidate];
        System.debug('oppList: ' + oppList);

        List<dfsle__EnvelopeStatus__c> envelopeStatusList = [SELECT Id, dfsle__Status__c,dfsle__SourceId__c FROM dfsle__EnvelopeStatus__c WHERE dfsle__SourceId__c IN :oppToValidate];
        System.debug('envelopeStatusList: ' + envelopeStatusList);

        Map<Id, List<dfsle__EnvelopeStatus__c>> envelopeStatusMap = new Map<Id, List<dfsle__EnvelopeStatus__c>>();

        for(Opportunity opportunity : oppList)
            hasContractBeenSignedAndHomologationCompleted.put(opportunity, false);

        for(dfsle__EnvelopeStatus__c envelopeStatus : envelopeStatusList){
            if(!envelopeStatusMap.containsKey(envelopeStatus.dfsle__SourceId__c))
                envelopeStatusMap.put(envelopeStatus.dfsle__SourceId__c, new List<dfsle__EnvelopeStatus__c>());
            envelopeStatusMap.get(envelopeStatus.dfsle__SourceId__c).add(envelopeStatus);
        }

        for(Opportunity opportunity : hasContractBeenSignedAndHomologationCompleted.keySet()){

            List<dfsle__EnvelopeStatus__c> envelopeStatusListAux = envelopeStatusMap.get(opportunity.Id);

            System.debug('envelopeStatusListAux: '+ envelopeStatusListAux);

            if(envelopeStatusListAux == null || envelopeStatusListAux.isEmpty()){
                hasContractBeenSignedAndHomologationCompleted.put(opportunity, false);
                continue;
            }

            Boolean hasCompleted = false;
            for(dfsle__EnvelopeStatus__c envelopeStatus : envelopeStatusListAux) {
                if(envelopeStatus.dfsle__Status__c == 'Completed') {
                    hasCompleted = true;
                    break;
                }
            }
            hasContractBeenSignedAndHomologationCompleted.put(opportunity, hasCompleted);

            System.debug('Opportunity: ' + opportunity.Id + ' - hasContractBeenSignedAndHomologationCompleted: ' + hasContractBeenSignedAndHomologationCompleted.get(opportunity));
        }

        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(Opportunity opportunity : hasContractBeenSignedAndHomologationCompleted.keySet()){
            if(hasContractBeenSignedAndHomologationCompleted.get(opportunity)){
                opportunity.StageName = 'Homologation';
                oppsToUpdate.add(opportunity);
            }
        }

        if(!oppsToUpdate.isEmpty())
            update oppsToUpdate;

    }

    public static void updateRequiredFields(List<HomologationForm__c> newList){

        System.debug('updateRequiredFields');

        if(newList == null || newList.isEmpty())
            return;

        Set<Id> oppsToValidate = new Set<Id>();
        for(HomologationForm__c homologationForm : newList)
            oppsToValidate.add(homologationForm.Opportunity__c);

        List<Opportunity> oppList = [SELECT Id, AccountId,Segmento__c,NationalPaymentMethod__c,IntegrationType__c,Payout__c FROM Opportunity WHERE Id IN :oppsToValidate];

        for(Opportunity opportunity : oppList)
            for(HomologationForm__c homologationForm : newList)
                if(homologationForm.Opportunity__c == opportunity.Id)
                if(homologationForm.Opportunity__c == opportunity.Id)
                    homologationForm.Required_Fields__c = validateFieldsFill(homologationForm,opportunity);

    }

    public static String validateFieldsFill(HomologationForm__c homologationForm, Opportunity opp) {
        List<String> requiredFields = getRequiredFields(opp);
        List<String> remaining = new List<String>();

        for (String fieldName : requiredFields) {
            Object value;

            try {
                value = homologationForm.get(fieldName);
                System.debug('Field: ' + fieldName + ' - Value: ' + value);
            } catch (Exception e) {
                System.debug('Exception while getting field value: ' + e.getMessage());
                continue;
            }

            if (value == null || String.valueOf(value).trim() == '') {
                remaining.add(fieldName);
            }
        }

        System.debug('Remaining fields: ' + remaining);

        return remaining.isEmpty() ? null : String.join(remaining, ',');
    }

    public static void updateOppStatusWhenApprovalCompleted(List<HomologationForm__c> homologationForms) {

        Set<Id> oppsToValidate = new Set<Id>();
        if(homologationForms == null || homologationForms.isEmpty())
            return;

        for(HomologationForm__c homologationForm : homologationForms)
            oppsToValidate.add(homologationForm.Opportunity__c);

        List<HomologationForm__c> homologationFormsToValidate = [SELECT Id, Opportunity__c, Legal_Approval_Status__c FROM HomologationForm__c WHERE Opportunity__c IN :oppsToValidate];

        List<Opportunity> oppList = [SELECT Id, StageName FROM Opportunity WHERE Id IN :oppsToValidate];
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        System.debug('oppList: ' + oppList);
        for(Opportunity opportunity : oppList){

            for(HomologationForm__c homologationForm : homologationFormsToValidate){
                System.debug('homologationForm: ' + homologationForm);
                if(homologationForm.Opportunity__c == opportunity.Id){
                    System.debug('homologationForm.Legal_Approval_Status__c: ' + homologationForm.Legal_Approval_Status__c);
                    if(homologationForm.Legal_Approval_Status__c == 'Approved')
                        opportunity.StageName = 'Go Live';
                    else
                        break;
                }
                oppsToUpdate.add(opportunity);
            }
        }
        if(!oppsToUpdate.isEmpty())
            update oppList;

    }

    public static List<String> getRequiredFields(Opportunity opp) {

        Boolean isDropshiping = opp.Segmento__c == 'Dropshipping';
        Boolean isPayout = opp.Payout__c;
        Boolean isIntegrationTypeAPIorJS = opp.IntegrationType__c == 'API' || opp.IntegrationType__c == 'JS';
        Boolean isPaymentMethodCreditCard = opp.NationalPaymentMethod__c.contains('Cartão de Crédito');
        Boolean isPaymentMethodBankSlip = opp.NationalPaymentMethod__c.contains('Boleto Flash');

        List<String> requiredFields = new List<String>{
            'AlreadyRequestedReclameAqui__c','Cielo30__c','ERede__c',
            'NotInterestedInOfferingDiscount__c','PagBrasilSolutionForTransferringFee__c',
            'RequirementInfoValidator__c','RequirementPriceFormat__c','RequirementResponseTime__c',
            'RequirementZipCodeValidator__c','Stone__c','InterestRepassMethodToCustomer__c',
            'BankSlipEmailService__c','BankSlipSmsService__c','PixEmailService__c','MccCode__c',
            'BlockRefund__c','CompanyDetails__c','ContactInformation__c','EvidenceCompanyDetails__c',
            'CustomsFee__c','DeliveryTime__c','EmailPackage__c','EmailsPodManager__c', 'TerminalId__c',
            'EvidenceContactInformation__c','EvidenceCustomsFee__c','EvidenceDeliveryTime__c','EvidenceGateway__c',
            'EvidenceInfoValidator__c','EvidencePriceFormat__c','EvidenceReclameAqui__c','EvidenceResponseTime__c',
            'EvidenceShippingProofPod__c','EvidenceZipCodeValidator__c','FlashBoleto__c',
            'Login__c','MerchantId__c','MerchantKey__c','MidMerchantId__c','MinimumInstallmentsForInterest__c',
            'MonthlyInterestOnCustomerInstallments__c', 'OneClickBuyingTokenization__c', 'PagBrasilPix__c', 'Password__c',
            'PaymentAlert__c','PaymentConfirmationEmailService__c','PaymentLinkEmailService__c', 'PbCheckoutDiscount__c',
            'Pv__c', 'RegKey__c', 'ReimbursementPolicy__c','ShippingProofPod__c','ShopifyDiscount__c', 'SmsPackage__c'
        };

        if(isDropshiping)
            requiredFields.add('PodReminder');

        if(isPayout){
            requiredFields.add('AccountModel');
            requiredFields.add('ReviewPayeeRegistration');
            requiredFields.add('TransactionType');
        }

        if(isPaymentMethodCreditCard){
            requiredFields.add('DefaultSoftDescriptor');
            if(isIntegrationTypeAPIorJS){
                requiredFields.add('CreditCardRecurrence');
                requiredFields.add('InstallmentRecurrence');
            }
        }

        if(isPaymentMethodBankSlip){
            requiredFields.add('AutomaticCancellation');
            requiredFields.add('NumberOfDays');
        }

        return requiredFields;
    }
}