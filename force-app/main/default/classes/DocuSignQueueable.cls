public class DocuSignQueueable implements Queueable, Database.AllowsCallouts {
    private Set<Id> opportunityIds;
    private Set<Id> contentDocumentIds;

    public DocuSignQueueable(Set<Id> opportunityIds, Set<Id> contentDocumentIds) {
        this.opportunityIds = opportunityIds;
        this.contentDocumentIds = contentDocumentIds;
    }

    public void execute(QueueableContext context) {
        try {
            Id mySourceId = opportunityIds.iterator().next();
            dfsle.UUID myTemplateId = dfsle.UUID.parse('1906ec1c-0c7a-4cb9-9d36-299cf3e6061e');

            dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
                new dfsle.Entity(mySourceId)
            );

            Opportunity opp = [
                SELECT Id, Owner.Name, Owner.Email
                FROM Opportunity
                WHERE Id = :mySourceId
                LIMIT 1
            ];

            dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
                opp.Owner.Name,
                opp.Owner.Email,
                null,
                'Signer 1',
                new dfsle.Entity(opp.Id)
            );

            myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });

            dfsle.Document myDocument = dfsle.Document.fromTemplate(
                myTemplateId,
                'Template Gerado'
            );

            myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });

            myEnvelope = dfsle.EnvelopeService.sendEnvelope(
                myEnvelope,
                true
            );

            System.debug('Envelope enviado com sucesso: ' + myEnvelope);
        } catch (Exception e) {
            System.debug('Erro ao enviar envelope: ' + e.getMessage());
        }
    }
}