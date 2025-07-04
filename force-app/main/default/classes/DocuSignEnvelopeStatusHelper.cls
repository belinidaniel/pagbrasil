public with sharing class DocuSignEnvelopeStatusHelper {

    public static void hasContractBeenSignedAndHomologationCompleted(List<dfsle__EnvelopeStatus__c> newList, Map<Id,dfsle__EnvelopeStatus__c> oldMap){

        Map<Opportunity,Boolean> hasContractBeenSignedAndHomologationCompleted = new Map<Opportunity,Boolean>();

        if(newList == null || newList.isEmpty() || oldMap == null || oldMap.isEmpty())
            return;

        Set<Id> oppToValidate = new Set<Id>();

        for(dfsle__EnvelopeStatus__c envelopeStatus : newList)
            if(envelopeStatus.dfsle__Status__c == 'Completed' /*&& !oldMap.get(envelopeStatus.Id).dfsle__Status__c.equals('Completed')*/)
                oppToValidate.add(envelopeStatus.dfsle__SourceId__c);

        System.debug('oppToValidate: ' + oppToValidate);
                
        if(oppToValidate.isEmpty())
            return;

        List<Opportunity> oppList = [SELECT Id, StageName FROM Opportunity WHERE Id IN :oppToValidate];
        List<dfsle__EnvelopeStatus__c> envelopeStatusList = [SELECT Id, dfsle__Status__c,dfsle__SourceId__c FROM dfsle__EnvelopeStatus__c WHERE dfsle__SourceId__c IN :oppToValidate];

        Map<Id, List<dfsle__EnvelopeStatus__c>> envelopeStatusMap = new Map<Id, List<dfsle__EnvelopeStatus__c>>();

        System.debug('oppList: ' + oppList);
        
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
            
            for(dfsle__EnvelopeStatus__c envelopeStatus : envelopeStatusListAux)
                if(envelopeStatus.dfsle__Status__c == 'Completed' && hasContractBeenSignedAndHomologationCompleted.get(opportunity) == true)
                    hasContractBeenSignedAndHomologationCompleted.put(opportunity, true);

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
    
}