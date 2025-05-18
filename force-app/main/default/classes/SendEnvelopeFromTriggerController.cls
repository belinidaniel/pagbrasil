public with sharing class SendEnvelopeFromTriggerController {
    
    public class EnvelopeSendResponse {
        public String message { get; private set; }
        public Boolean status { get; private set; }

        public EnvelopeSendResponse(final String message, final Boolean status) {
            this.message = message;
            this.status = status;
        }
    }

    public static void sendEnvelope(Set<Id> opportunityIds) {
        if (opportunityIds.isEmpty()) {
            return;
        }
        
        System.debug('sendEnvelope chamado com os IDs de oportunidades: ' + opportunityIds);

        for (Id oppId : opportunityIds) {
            EnvelopeSendResponse response = sendEnvelope(oppId);
            System.debug('Resposta ao enviar envelope para oportunidade ' + oppId + ': ' + response.message);
        }
    }

    public static EnvelopeSendResponse sendEnvelope(final Id opportunityId) {
        EnvelopeSendResponse response;
        try {
            System.debug('Enviando envelope para a oportunidade com Id: ' + opportunityId);

            Opportunity myOpportunity = [SELECT Id, Name, OwnerId FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
            System.debug('Oportunidade encontrada: ' + myOpportunity.Name);

            User myOwner = [SELECT Id, Name, Email FROM User WHERE Id = :myOpportunity.OwnerId LIMIT 1];
            System.debug('Proprietário da oportunidade: ' + myOwner.Name + ' - Email: ' + myOwner.Email);
            
            dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(opportunityId));
            System.debug('Envelope criado: ' + myEnvelope);

            dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
                myOwner.Name,  
                myOwner.Email,
                null, 
                'Signer 1', 
                new dfsle.Entity(opportunityId)
            );
            System.debug('Destinatário adicionado: ' + myRecipient);

            myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient>{myRecipient});

            dfsle.UUID myTemplateId = dfsle.UUID.parse('62923b68-8f5e-486d-b432-0114b11dcb7b');
            dfsle.Document myDocument = dfsle.Document.fromTemplate(myTemplateId, 'Envelope - PagBrasil');
            myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document>{myDocument});
            System.debug('Documento adicionado ao envelope: ' + myDocument);

            myEnvelope = dfsle.EnvelopeService.sendEnvelope(myEnvelope, true);
            System.debug('Envelope enviado: ' + myEnvelope);

            response = new EnvelopeSendResponse('Envelope enviado com sucesso', true);
        } catch (Exception ex) {
            System.debug('Erro ao enviar o envelope: ' + ex.getMessage());
            response = new EnvelopeSendResponse('Erro ao enviar o envelope: ' + ex.getMessage(), false);
        }
        return response;
    }
}