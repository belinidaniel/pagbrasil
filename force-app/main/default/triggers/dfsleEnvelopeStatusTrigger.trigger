trigger dfsleEnvelopeStatusTrigger on dfsle__EnvelopeStatus__c (after update) {
    Set<Id> opportunityIds = new Set<Id>();
    
    for (dfsle__EnvelopeStatus__c envelope : Trigger.new) {
        dfsle__EnvelopeStatus__c oldEnvelope = Trigger.oldMap.get(envelope.Id);
        if (envelope.dfsle__Status__c == 'Completed' 
            && oldEnvelope.dfsle__Status__c != 'Completed'
            && envelope.dfsle__Opportunity__c != null) {
            opportunityIds.add(envelope.dfsle__Opportunity__c);
        }
    }
    
    if (!opportunityIds.isEmpty()) {
        Map<Id, Opportunity> opportunities = new Map<Id, Opportunity>(
            [SELECT Id, StageName FROM Opportunity 
             WHERE Id IN :opportunityIds AND StageName = 'Contract']
        );
        
        List<Opportunity> toUpdate = new List<Opportunity>();
        
        for (dfsle__EnvelopeStatus__c envelope : Trigger.new) {
            if (opportunities.containsKey(envelope.dfsle__Opportunity__c)) {
                Opportunity opp = opportunities.get(envelope.dfsle__Opportunity__c);
                opp.StageName = 'Homologation';
                toUpdate.add(opp);
                opportunities.remove(opp.Id);
            }
        }
        
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}