/**
 * @description       : 
 * @author            : aydhan.passos
 * @group             : 
 * @last modified on  : 04-10-2025
 * @last modified by  : aydhan.passos
**/
public with sharing class OpportunityTriggerHelper {
   
    /**
    * @description adicionado regra de opp sincronizada para não gerar erro qdo criar nova cotação
    * @author Hersilio Belini de Oliveira | 2025-02-18
    **/
    public static void verifyRemovedSyncedQuoteId( List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){

        for(Opportunity opp : newOppList){
            if(opp.SyncedQuoteId == null && oldOppMap.get(opp.Id).SyncedQuoteId != null){
                opp.Pricebook2Id = null;
            }
        }
    }

    /**
    * @description popula a data de fechamento com 90 dias automaticamente.
    * @author aydhan.passos | 04-04-2025 
    * @param newOppList 
    **/
    public static void autoFillOppFields( List<Opportunity> newOppList){

        for(Opportunity opp : newOppList){
            opp.CloseDate = Date.today().addDays(90);
            opp.StageName = 'Discovery';
        }
    }

    /**
    * @description validate change fields
    * @author Hersilio Belini de Oliveira | 2024-12-24
    **/
    public static void validateChangeFields(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){
        Map<Id, List<Quote>> quoteMap = OpportunityTriggerHelper.getQuotesByOpportunityIds(oldOppMap.keyset());
        List<Quote> quotesToCancel = new List<Quote>();
        Map<String, Quote> quotesToSync = new Map<String, Quote>();

        for(Opportunity opp : newOppList){

            if(OpportunityTriggerHelper.hasFieldModified(opp, oldOppMap)){

                if(opp.StageName != 'Hibernate' && opp.StageName != 'Discovery' && opp.StageName != 'Negotiation' && oldOppMap.get(opp.Id).Contract_Start_Fee_Date__c == opp.Contract_Start_Fee_Date__c){
                    opp.addError('Status da oportunidade não permite alteração de campos');
                    break;
                }

                List<Quote> quotes = quoteMap.get(opp.Id);

                if(quotes != null && quotes.size() > 0 && OpportunityTriggerHelper.canCancelQuotes(opp, quotes)){
                    for(Quote quote : quotes){
                        if(quote.Status == 'Draft' || quote.Status == 'Approved' || quote.Status == 'Rejected'){
                            quote.Status = 'Canceled';
                            quotesToCancel.add(quote);
                            continue;
                        }
                    }
                }
            }
        }

        if(!quotesToCancel.isEmpty()){
            TriggerHandler.bypass('QuoteTriggerHandler');
            update quotesToCancel;
            TriggerHandler.clearBypass('QuoteTriggerHandler');
        }
    }


    /**
    * @description can cancel quotes
    * @author Hersilio Belini de Oliveira | 2024-12-24
    * @param opp
    * @param quotes
    * @return Boolean
    **/
    private static Boolean canCancelQuotes(Opportunity opp, List<Quote> quotes){
        for(Quote quote : quotes){

            if(quote.Status != null && quote.Status.toLowerCase().contains('pending approval')){
                opp.addError('Alteração de campos não permitida, existe cotação em aprovação');
                return false;
            }

            if(quote.IsSyncing){
                opp.addError('Alteração de campos não permitida, existe cotação sincronizada com a oportunidade.');
                return false;
            }
        }

        return true;
    }

    /**
    * @description has field modified
    * @author Hersilio Belini de Oliveira | 2024-12-24
    * @param opp
    * @return Boolean
    **/
    private static Boolean hasFieldModified(Opportunity opp, Map<Id, Opportunity> oldOppMap){
        Opportunity oldOpp = oldOppMap.get(opp.Id);

        return opp.BusinessModel__c != oldOpp.BusinessModel__c ||
        opp.Integracao__c != oldOpp.Integracao__c ||
        opp.IntegrationType__c != oldOpp.IntegrationType__c ||
        opp.NationalPaymentMethod__c != oldOpp.NationalPaymentMethod__c ||
        opp.PaymentRecurrence__c != oldOpp.PaymentRecurrence__c ||
        opp.UsePagstream__c != oldOpp.UsePagstream__c ||
        opp.Payout__c != oldOpp.Payout__c ||
        opp.GooglePay__c != oldOpp.GooglePay__c ||
        opp.ApplePay__c != oldOpp.ApplePay__c ||
        opp.TierCS__c != oldOpp.TierCS__c ||
        opp.ProductClass__c != oldOpp.ProductClass__c ||
        opp.AverageSalesTicket__c != oldOpp.AverageSalesTicket__c ||
        opp.Transacoes_Mensais__c != oldOpp.Transacoes_Mensais__c ||
        opp.previs_fat_rs__c != oldOpp.previs_fat_rs__c ||
        opp.nb_receita_mensal__c != oldOpp.nb_receita_mensal__c ||
        opp.BusinessModelType__c != oldOpp.BusinessModelType__c;
    }

    /**
    * @description get quote
    * @author Hersilio Belini de Oliveira | 2024-12-20
    * @param oppIds
    * @return List<Quote>
    **/
    private static Map<Id, List<Quote>> getQuotesByOpportunityIds(Set<Id> oppIds){
        List<Quote> quotes = [SELECT Id, Name, OpportunityId, Status, IsSyncing FROM Quote WHERE OpportunityId IN :oppIds AND Status != 'Canceled'];

        Map<Id, List<Quote>> quotesMap = new Map<Id, List<Quote>>();

        for(Quote quote : quotes){
            if(!quotesMap.containsKey(quote.OpportunityId)){
                quotesMap.put(quote.OpportunityId, new List<Quote>());
            }

            quotesMap.get(quote.OpportunityId).add(quote);
        }

        return quotesMap;
    }

    /**
     * @description update related opportunity quotes when the synced quote is removed
     * @author luis.tavares | 2025-04-22
     * @param newOppList, oldOppMap
     * @return void
     **/
     public static void updateQuotesOnSyncedQuoteRemoval(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap) {
         List<Quote> quotesToUpdate = new List<Quote>();
         Map<Id, List<Quote>> quotesMap = OpportunityTriggerHelper.getQuotesByOpportunityIds(new Set<Id>((new Map<Id, Opportunity>(newOppList)).keySet()));

         for (Opportunity newOpp : newOppList) {
            Opportunity oldOpp = oldOppMap.get(newOpp.Id);


            if (oldOpp.SyncedQuoteId != null && newOpp.SyncedQuoteId == null) {
                // se a SyncedQuoteId foi removida significa que a quote antes sincronizada agora foi dessincronizada
                // então, precisamos atualizar as flags de CustomerAcceptance__c e OtherQuoteAccepted__c para false em todas quotes relacionadas a oportunidade
                List<Quote> opportunityQuotes = quotesMap.get(newOpp.Id);


                if (opportunityQuotes != null && !opportunityQuotes.isEmpty()) {
                    for (Quote quote : opportunityQuotes) {
                        quote.CustomerAcceptance__c = false;
                        quote.OtherQuoteAccepted__c = false;

                        quotesToUpdate.add(quote);
                    }
                }
            }
        }

        if (!quotesToUpdate.isEmpty()) {
            TriggerHandler.bypass('QuoteTriggerHandler');
            update quotesToUpdate;
            TriggerHandler.clearBypass('QuoteTriggerHandler');
        }
    }

    @future
    public static void submitKYCAndRCCForApprovalHandler(List<Id> opportunityIds) {
        List<Opportunity> opportunities = [SELECT Id,
            OpportunityKYCLegalApprovalStatus__c, 
            OpportunityRCCLegalApprovalStatus__c,
            RecordTypeId
            FROM Opportunity 
            WHERE Id IN :opportunityIds];
        for (Opportunity opp : opportunities) {
            if (opp.OpportunityKYCLegalApprovalStatus__c == 'Approval Requested' && opp.OpportunityRCCLegalApprovalStatus__c == 'Approval Requested') {
                submitKYCForApproval(opp);
                submitRCCForApproval(opp);
            } else if (opp.OpportunityKYCLegalApprovalStatus__c == 'Approval Requested' && opp.OpportunityRCCLegalApprovalStatus__c != 'Approval Requested') {
                if (opp.OpportunityRCCLegalApprovalStatus__c == 'Approved')
                    submitKYCForApproval(opp);
            } else if (opp.OpportunityKYCLegalApprovalStatus__c != 'Approval Requested' && opp.OpportunityRCCLegalApprovalStatus__c == 'Approval Requested') {
                if (opp.OpportunityKYCLegalApprovalStatus__c == 'Approved')
                    submitRCCForApproval(opp);
            } else {
                continue;
            }
        }
    }

    public static void submitKYCForApproval(opportunity newOpp) {
        Id opportunityId = newOpp.Id;
        Id nationalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('National').getRecordTypeId();

        Boolean isKycXB = nationalRecordTypeId != newOpp.RecordTypeId;

        System.debug('isKycXB: ' + isKycXB);
        System.debug('newOpp: ' + JSON.serializePretty(newOpp));

        SObject kycToSubmit = Database.query(
            '' + (isKycXB == true ? 'SELECT LegalApprovalStatus__c, Opportunity__c FROM KYC_XB__c' : 'SELECT Legal_Approval_Status__c, Opportunity__c FROM KYC__c') + ' WHERE Opportunity__c = :opportunityId LIMIT 1'
        );

        if (kycToSubmit == null)
            return;

        Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
        submitRequest.setObjectId(kycToSubmit.Id);
        submitRequest.setProcessDefinitionNameOrId(isKycXB == true ? 'XB_KYC_Approval' : 'NB_KYC_Approval');
        submitRequest.setSkipEntryCriteria(true);
        Approval.process(submitRequest);
    }

    public static void submitRCCForApproval(Opportunity newOpp) {
        Id opportunityId = newOpp.Id;
        
        RCC__c rccToSubmit = [SELECT Id, LegalApprovalStatus__c FROM RCC__c WHERE Opportunity__c = :opportunityId LIMIT 1];

        if (rccToSubmit == null)
            return;

        Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
        submitRequest.setObjectId(rccToSubmit.Id);
        submitRequest.setProcessDefinitionNameOrId('RCC_Approval');
        submitRequest.setSkipEntryCriteria(true);
        Approval.process(submitRequest);
    }
    
    public static void makeTheNewOppValidAndTheOldOppsInvalid(List<Opportunity> newOpps) {
        Set<Id> accountIds = new Set<Id>();
        List<Opportunity> oldOppsToUpdate = new List<Opportunity>();

        for (Opportunity opp : newOpps) {
            opp.Is_Opportunity_Valid__c = true;
            opp.Lead_Owner__c = opp.OwnerId;
            accountIds.add(opp.AccountId);
        }

        if (!accountIds.isEmpty()) {
            for (Opportunity oldOpp : [
                SELECT Id FROM Opportunity 
                WHERE AccountId IN :accountIds 
                AND Is_Opportunity_Valid__c = true
                AND Id NOT IN :newOpps
            ]) {
                oldOpp.Is_Opportunity_Valid__c = false;
                oldOppsToUpdate.add(oldOpp);
            }
        }

        if (!oldOppsToUpdate.isEmpty()) {
            update oldOppsToUpdate;
        }
    }

	public static void createKycAndRccRecords(List<Opportunity> newOpps) {
        Set<Id> recordTypeIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            recordTypeIds.add(opp.RecordTypeId);
        }
        Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>(
            [SELECT Id, DeveloperName FROM RecordType WHERE Id IN :recordTypeIds AND SObjectType = 'Opportunity']
        );
        
        List<KYC__c> kycsNB = new List<KYC__c>();
        List<KYC_XB__c> kycsXB = new List<KYC_XB__c>();
        List<RCC__c> rccs = new List<RCC__c>();
        
        for (Opportunity opp : newOpps) {
            String devName = recordTypeMap.get(opp.RecordTypeId).DeveloperName;
            String uniqueId = 'UniqueID' + opp.Id;
            
            if (devName == 'Crossborder' || devName == 'Pix_International_Pix_Roaming') {
                kycsXB.add(new KYC_XB__c(
                    Client_Account__c = opp.AccountId,
                    Opportunity__c = opp.Id,
                    Stage_Number__c = 0,
                    Status__c = 'Pending',
                    Unique_Link__c = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(opp.Id + String.valueOf(System.currentTimeMillis()))))
                ));
            } else if (devName == 'NaTional') {
                kycsNB.add(new KYC__c(
                    Client_Account__c = opp.AccountId,
                    Opportunity__c = opp.Id,
                    Stage_Number__c = 0,
                    Status__c = 'Pending',
                    Unique_Link__c = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(opp.Id + String.valueOf(System.currentTimeMillis()))))
                ));
            }
            
            rccs.add(new RCC__c(
                Account__c = opp.AccountId,
                Opportunity__c = opp.Id
            ));
        }
        
        if (!kycsNB.isEmpty()) insert kycsNB;
        if (!kycsXB.isEmpty()) insert kycsXB;
        if (!rccs.isEmpty()) insert rccs;
    }
}