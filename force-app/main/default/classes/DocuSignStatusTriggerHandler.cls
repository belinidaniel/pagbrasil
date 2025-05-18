public class DocuSignStatusTriggerHandler {
    @future (callout=true)
    public static void handleOrderComplete(Set<Id> validOpportunityIds) {
        SendEnvelopeFromTriggerController.sendEnvelope(validOpportunityIds);
        System.debug('Método SendEnvelopeFromTriggerController.sendEnvelope executado.');
    }
}