public with sharing class DocuSignEnvelopeStatusTriggerHandler extends TriggerHandler {

    private List<dfsle__EnvelopeStatus__c> newEnvelopeStatusList;
    private Map<Id, dfsle__EnvelopeStatus__c> oldEnvelopeStatusMap;
    private Map<Id, dfsle__EnvelopeStatus__c> newEnvelopeStatusMap;

    public DocuSignEnvelopeStatusTriggerHandler() {
        this((List<dfsle__EnvelopeStatus__c>) Trigger.new, (Map<Id, dfsle__EnvelopeStatus__c>) Trigger.oldMap);
    }

    public DocuSignEnvelopeStatusTriggerHandler( List<dfsle__EnvelopeStatus__c> newEnvelopeStatusList, Map<Id, dfsle__EnvelopeStatus__c> oldEnvelopeStatusMap ) {
        this.newEnvelopeStatusList = newEnvelopeStatusList;
        this.oldEnvelopeStatusMap = oldEnvelopeStatusMap;
        
        // Só cria o mapa se os registros já possuem Id (ou seja, não é before insert)
        if (!Trigger.isInsert) {
            this.newEnvelopeStatusMap = new Map<Id, dfsle__EnvelopeStatus__c>(newEnvelopeStatusList);
        }
    }

    public override void beforeInsert() {
        System.debug('DocuSignEnvelopeStatusTriggerHandler beforeInsert');
    }

    public override void beforeUpdate() {
        System.debug('DocuSignEnvelopeStatusTriggerHandler beforeUpdate');
    }    

    public override void afterUpdate() {
        DocuSignEnvelopeStatusHelper.hasContractBeenSignedAndHomologationCompleted(this.newEnvelopeStatusList, this.oldEnvelopeStatusMap);
        System.debug('DocuSignEnvelopeStatusTriggerHandler afterUpdate');
    }
}