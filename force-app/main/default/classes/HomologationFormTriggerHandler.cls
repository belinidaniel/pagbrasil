public with sharing class HomologationFormTriggerHandler extends TriggerHandler {

    private List<HomologationForm__c> newHomologationList;
    private Map<Id, HomologationForm__c> oldHomologationMap;
    private Map<Id, HomologationForm__c> newHomologationMap;

    public HomologationFormTriggerHandler() {
        this((List<HomologationForm__c>) Trigger.new, (Map<Id, HomologationForm__c>) Trigger.oldMap);
    }

    public HomologationFormTriggerHandler( List<HomologationForm__c> newHomologationList, Map<Id, HomologationForm__c> oldHomologationMap ) {
        this.newHomologationList = newHomologationList;
        this.oldHomologationMap = oldHomologationMap;
        
        // Só cria o mapa se os registros já possuem Id (ou seja, não é before insert)
        if (!Trigger.isInsert) {
            this.newHomologationMap = new Map<Id, HomologationForm__c>(newHomologationList);
        }
    }

    public override void beforeInsert() {
        System.debug('HomologationFormTriggerHandler beforeInsert');
    }

    public override void beforeUpdate() {
        System.debug('HomologationFormTriggerHandler beforeUpdate');
        HomologationFormHelper.updateRequiredFields(this.newHomologationList);
    }    

    public override void afterUpdate() {
        HomologationFormHelper.hasContractBeenSignedAndHomologationCompleted(this.newHomologationList, this.oldHomologationMap);
        HomologationFormHelper.updateOppStatusWhenApprovalCompleted(this.newHomologationList);
        System.debug('HomologationFormTriggerHandler afterUpdate');
    }
}