/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-06-27
 * @last modified by  : marcelo.aguiar
**/
public with sharing class OpportunityTriggerHandler extends TriggerHandler {

    private List<Opportunity> newOppList;
    private Map<Id, Opportunity> oldOppMap;
    private Map<Id, Opportunity> newOppMap;

    public OpportunityTriggerHandler() {
        this((List<Opportunity>) Trigger.new, (Map<Id, Opportunity>) Trigger.oldMap);
    }

    public OpportunityTriggerHandler( List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap ) {
        this.newOppList = newOppList;
        this.oldOppMap = oldOppMap;
        
        // Só cria o mapa se os registros já possuem Id (ou seja, não é before insert)
        if (!Trigger.isInsert) {
            this.newOppMap = new Map<Id, Opportunity>(newOppList);
        }
    }

    public override void beforeInsert() {
        if (RecursionControl.isOpportunityTriggerRunning) return;
        RecursionControl.isOpportunityTriggerRunning = true;
        
        OpportunityTriggerHelper.autoFillOppFields(this.newOppList);
        OpportunityTriggerHelper.makeTheNewOppValidAndTheOldOppsInvalid(this.newOppList);
    }

    public override void beforeUpdate() {
        if (RecursionControl.isOpportunityTriggerRunning) return;
        RecursionControl.isOpportunityTriggerRunning = true;
        
        OpportunityTriggerHelper.validateChangeFields(this.newOppList, this.oldOppMap);
        OpportunityTriggerHelper.verifyRemovedSyncedQuoteId(this.newOppList, this.oldOppMap);
    }    

    public override void afterUpdate() {
        List<Id> oppsIds = new List<Id>();
        for (Opportunity opp : this.newOppList) {
            oppsIds.add(opp.Id);
        }
        
        if (!System.isFuture()) {
            OpportunityTriggerHelper.submitKYCAndRCCForApprovalHandler(oppsIds);
        }
        
        // if (RecursionControl.isOpportunityTriggerRunning) return;
        // RecursionControl.isOpportunityTriggerRunning = true;
        
        OpportunityTriggerHelper.updateQuotesOnSyncedQuoteRemoval(this.newOppList, this.oldOppMap);
    }
    
    public override void afterInsert() {
        
        OpportunityTriggerHelper.createKycAndRccRecords(this.newOppList);
    }
}