trigger DocuSignEnvelopeStatusTrigger on dfsle__EnvelopeStatus__c (before insert, before update, after update) {
    new DocuSignEnvelopeStatusTriggerHandler().run();
}