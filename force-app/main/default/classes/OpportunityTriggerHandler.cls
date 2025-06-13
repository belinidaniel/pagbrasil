/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-04-22
 * @last modified by  : luis.tavares
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
        OpportunityTriggerHelper.autoFillOppFields(this.newOppList);
    }

    public override void beforeUpdate() {
        OpportunityTriggerHelper.validateChangeFields(this.newOppList, this.oldOppMap);
        OpportunityTriggerHelper.verifyRemovedSyncedQuoteId(this.newOppList, this.oldOppMap);
    }    

    public override void afterUpdate() {
            OpportunityTriggerHelper.updateQuotesOnSyncedQuoteRemoval(this.newOppList, this.oldOppMap);
            List<Id> oppsIds = new List<Id>();
            for (Opportunity opp : this.newOppList) {
                oppsIds.add(opp.Id);
            }
        if (!System.isFuture()) {
            OpportunityTriggerHelper.submitKYCAndRCCForApprovalHandler(oppsIds);
        }
    }
}