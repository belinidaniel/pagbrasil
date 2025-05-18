@RestResource(urlMapping='/webhook/messages/*')
global class MessageWebhook {
    @HttpPost
    global static void doPost() {
        String responseJSON;

        try {
            RestRequest request = RestContext.request;
            
            WebhookDTO whatsDTO = WebhookDTO.parse(request.requestBody.toString().replaceAll('"from":', '"from_x":').replaceAll('"date":', '"date_x":').replaceAll('#tunnel.originator', 'tunneloriginator'));

            String txtMessage = '';
            String txtMessageConversa = '';
            String nomeCliente = 'Cliente';
            String nomeAtendente = 'Atendente';
            String oppId = null;
            Datetime initConversa = null;
            Datetime fimConversa = null;

            List<WebhookDTO.Items> listInverted = new List<WebhookDTO.Items>();
            //inverter ordem
            for (Integer item = whatsDTO.resource.items.size()-1; item>= 0; item-- ) {
                listInverted.add(whatsDTO.resource.items[item]);
             }

            for(WebhookDTO.Items forItem: listInverted){
                if(oppId == null) if(forItem.metadata?.tunnelOriginator != null) oppId = forItem.metadata.tunnelOriginator.split('@')[0].startsWith('55') ? forItem.metadata.tunnelOriginator.split('@')[0].substring(2, forItem.metadata.tunnelOriginator.split('@')[0].length()) : forItem.metadata.tunnelOriginator.split('@')[0];
                if(initConversa == null) if(forItem.date_x != null) initConversa = forItem.date_x;
                if(nomeCliente == 'Cliente') if(forItem.content?.customerIdentity != null) nomeAtendente = forItem.content.customerIdentity;
                if(nomeAtendente == 'Atendente') if(forItem.content?.agentIdentity != null) nomeAtendente = forItem.content.agentIdentity.split('@')[0];

                if(forItem.content_x != null){
                    if(forItem.direction == 'sent'){
                        if(forItem.content?.metadata?.messageEmitter == 'Human'){
                            txtMessageConversa += nomeAtendente+': '+(forItem.content_x != null ? forItem.content_x : forItem.content.text) + '\n';
                        }else{
                            txtMessageConversa += 'Bot: '+(forItem.content_x != null ? forItem.content_x : forItem.content.text) + '\n';
                        }
                    }else if(forItem.direction == 'received'){
                        txtMessageConversa += nomeCliente +': '+(forItem.content_x != null ? forItem.content_x : forItem.content.text) + '\n';
                    }
                }

                fimConversa = forItem.date_x;

            }

            txtMessage += '- Nome do atendente: '+nomeAtendente+'\n';
            txtMessage += '- Nome do cliente: '+nomeCliente+'\n';
            txtMessage += '- Data e hora de início da conversa: '+initConversa+'\n';
            txtMessage += '- Data e hora de término da conversa: '+fimConversa+'\n';
            txtMessage += '- Data e hora de exportação do histórico: '+fimConversa+'\n';
            txtMessage += '- Conteúdo da conversa: \n';
            txtMessage += txtMessageConversa;

            Attachment newAttach = new Attachment();
            newAttach.Body = Blob.valueOf(txtMessage);
            newAttach.Name = nomeCliente+'-'+System.now()+'.txt';
            newAttach.ParentId = [SELECT Id FROM Opportunity WHERE Telefone__c =: oppId LIMIT 1].Id;
            newAttach.ContentType = 'text/plain; charset=UTF-8';
            insert newAttach;

            responseJSON = '{"success": true, "message": "success"}'; 
        } catch (Exception e) {
            System.debug('error:'+e);
            responseJSON = '{"success": false, "message": "' + e.getMessage() + '"}'; 
        }

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = 200;
        RestContext.response.responseBody = Blob.valueOf(responseJSON); 
    }
}