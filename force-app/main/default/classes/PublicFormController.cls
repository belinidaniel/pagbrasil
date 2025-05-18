public without sharing class PublicFormController {

    @AuraEnabled(cacheable=true)
    public static Opportunity getOpportunityDetails(Id opportunityId) {
        return [
            SELECT Id, Name, Amount, CloseDate, IntegrationType__c, Product_Type__c, AccountId, BusinessModel__c, Segmento__c, RecordType.DeveloperName	 
            FROM Opportunity 
            WHERE Id = :opportunityId 
            LIMIT 1
        ];
    }

    @AuraEnabled(cacheable=true)
    public static HomologationForm__c getHomologationForm(Id opportunityId) {
        try {
            HomologationForm__c form = [
                SELECT Id, Account__c, Opportunity__c
                FROM HomologationForm__c
                WHERE Opportunity__c = :opportunityId
                LIMIT 1
            ];
            return form;
        } catch (Exception e) {
            throw new AuraHandledException('⚠️ Nenhum formulário encontrado para esta Oportunidade.');
        }
    }

    @AuraEnabled
    public static void criarContato(Map<String, Object> contactData) {
        Contact newContact = new Contact();
        for (String fieldName : contactData.keySet()) {
            if (Schema.sObjectType.Contact.fields.getMap().containsKey(fieldName)) {
                newContact.put(fieldName, contactData.get(fieldName));
            }
        }

        insert newContact;
    }

    @AuraEnabled
    public static void saveFormData(String formDataJson) {
        try {
                Map<String, Object> formData = (Map<String, Object>) JSON.deserializeUntyped(formDataJson);

                Id opportunityId = (Id) formData.get('Opportunity__c');
                System.debug('Opportunity ID recebido: ' + opportunityId);
        
                HomologationForm__c newRecord = [
                    SELECT Id, Account__c, Opportunity__c
                    FROM HomologationForm__c
                    WHERE Opportunity__c = :opportunityId
                    LIMIT 1
                ];

                if (formData.containsKey('fileMap')) {
                    Map<String, Object> fileMap = (Map<String, Object>) formData.get('fileMap');
                    Map<String, Object> linkMap = (formData.containsKey('linkMap')) ? 
                                                  (Map<String, Object>) formData.get('linkMap') : 
                                                  new Map<String, Object>();
                
                    for (String fieldName : fileMap.keySet()) {
                        Object fileUrlObj = fileMap.get(fieldName);
                        System.debug('📌 fileUrlObj recebido: ' + fileUrlObj);
                
                        if (fileUrlObj instanceof String) {
                            String fileUrl = (String) fileUrlObj;
                            System.debug('✅ Link do arquivo: ' + fileUrl);
                
                            String existingLinks = (String) linkMap.get(fieldName);
                            String finalLinks;
                
                            if (existingLinks != null) {
                                finalLinks = existingLinks + '<br>' + fileUrl;
                            } else {
                                finalLinks = fileUrl;
                            }
                
                            newRecord.put(fieldName, finalLinks);
                        }
                    }
                }                        
                    
                
                for (String fieldName : formData.keySet()) {
                    if (fieldName == 'Opportunity__c' || fieldName == 'Account__c' || fieldName.startsWith('Evidence')) {
                        continue;
                    }
                    if (Schema.sObjectType.HomologationForm__c.fields.getMap().containsKey(fieldName)) {
                        Object fieldValue = formData.get(fieldName);
        
                        if (fieldValue instanceof List<Object>) {
                            List<Object> valueList = (List<Object>) fieldValue;
                            List<String> stringList = new List<String>();
                            for (Object item : valueList) {
                                stringList.add((String) item);
                            }
                            String valueString = String.join(stringList, ';');
                            newRecord.put(fieldName, valueString);
                        } else if (fieldValue instanceof String) {
                            Schema.DisplayType fieldType = Schema.sObjectType.HomologationForm__c.fields.getMap().get(fieldName).getDescribe().getType();
        
                            if (fieldType == Schema.DisplayType.Boolean) {
                                Boolean booleanValue = fieldValue == 'true';
                                newRecord.put(fieldName, booleanValue);
                            }
                            else if (fieldType == Schema.DisplayType.Currency || fieldType == Schema.DisplayType.Double || fieldType == Schema.DisplayType.Percent) {
                                Decimal decimalValue = Decimal.valueOf((String) fieldValue);
                                newRecord.put(fieldName, decimalValue);
                            }
                            else {
                                newRecord.put(fieldName, fieldValue);
                            }
                        } else {
                            newRecord.put(fieldName, fieldValue);
                        }
                    }
                }

                newRecord.Status__c = 'Preenchida';
                update newRecord;
                System.debug('Registro atualizado com campos de evidências.');
                sendEmailToOpportunityOwner(opportunityId);


            } catch (Exception e) {
                System.debug('Erro geral: ' + e.getMessage());
                System.debug('Detalhes do Erro Geral: ' + e.getStackTraceString());
                System.debug(LoggingLevel.ERROR, '@@@ e.getMessage()' + e.getMessage());
                System.debug(LoggingLevel.ERROR, '@@@ e.getStackTraceString()' + e.getStackTraceString());
                throw new AuraHandledException('Erro ao salvar dados: ' + e.getMessage());

            }
        }

        @AuraEnabled
        public static String uploadImage(String base64Image, String fileName, String recordId) {
            try {
                ContentVersion cv = new ContentVersion();
                cv.Title = fileName;
                cv.PathOnClient = fileName;
                cv.VersionData = EncodingUtil.base64Decode(base64Image);
                cv.FirstPublishLocationId = recordId;
                insert cv;
                
                ContentVersion insertedVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
                String contentDocumentId = insertedVersion.ContentDocumentId;
                

                String salesforceBaseUrl = URL.getOrgDomainURL().toExternalForm();
                String publicUrl = salesforceBaseUrl + '/' + contentDocumentId;
                return publicUrl;
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }



                
        private static void sendEmailToOpportunityOwner(Id opportunityId) {
            
            try {
                Opportunity opp = [
                    SELECT Id, OwnerId, Owner.Email, Name, RecordType.DeveloperName
                    FROM Opportunity
                    WHERE Id = :opportunityId
                    LIMIT 1
                ];

                OrgWideEmailAddress orgWideEmail = [
                    SELECT Id
                    FROM OrgWideEmailAddress
                    WHERE Address = 'naoresponda@pagbrasil.com.br'
                    LIMIT 1
                ];

                sendCustomNotification(opp);
                
                if(opp.RecordType.DeveloperName == 'Crossborder'){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] { opp.Owner.Email });
                    email.setSubject('Completed homologation procedure: ' + opp.Name);
                    email.setPlainTextBody('The opportunity ' + opp.Name + ' have successfully completed the homologation procedure.');
                    email.setOrgWideEmailAddressId(orgWideEmail.Id);
    
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                    System.debug('E-mail enviado com sucesso para: ' + opp.Owner.Email);
    
                } else {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] { opp.Owner.Email });
                    email.setSubject('Formulário de homologação preenchido: ' + opp.Name);
                    email.setPlainTextBody('A Oportunidade ' + opp.Name + ' preencheu o formulário de homologação com sucesso.');
                    email.setOrgWideEmailAddressId(orgWideEmail.Id);

                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                    System.debug('E-mail enviado com sucesso para: ' + opp.Owner.Email);
                }
            } catch (Exception e) {
                System.debug('Erro geral: ' + e.getMessage());
                System.debug('Detalhes do Erro Geral: ' + e.getStackTraceString());
                System.debug(LoggingLevel.ERROR, '@@@ e.getMessage()' + e.getMessage());
                System.debug(LoggingLevel.ERROR, '@@@ e.getStackTraceString()' + e.getStackTraceString());
                throw new AuraHandledException('Erro ao salvar dados: ' + e.getMessage());
            }
        }

        private static void sendCustomNotification(Opportunity opp) {
            try {


                if(opp.RecordType.DeveloperName == 'Crossborder'){
                    CustomNotificationType notificationType = [
                        SELECT Id, DeveloperName
                        FROM CustomNotificationType
                        WHERE DeveloperName = 'HomologationProcedureCompletedXb'
                        LIMIT 1
                    ];
            
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
                    notification.setTitle('Update on homologation procedure: ');
                    notification.setBody('The opportunity ' + opp.Name + ' completed the homologation procedure. Check it out!');
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetId(opp.Id);
            
                    notification.send(new Set<String>{ opp.OwnerId });
                    System.debug('Custom Notification enviada com sucesso para: ' + opp.OwnerId);
    
                } else{
                    CustomNotificationType notificationType = [
                        SELECT Id, DeveloperName
                        FROM CustomNotificationType
                        WHERE DeveloperName = 'HomologationProcedureCompletedNb'
                        LIMIT 1
                    ];
            
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
                    notification.setTitle('Atualização no formulário de homologação');
                    notification.setBody('A Oportunidade ' + opp.Name + ' preencheu o formulário de homologação. Confira!');
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetId(opp.Id);
            
                    notification.send(new Set<String>{ opp.OwnerId });
                    System.debug('Custom Notification enviada com sucesso para: ' + opp.OwnerId);
    
                }
            } catch (Exception e) {
                System.debug('Erro ao enviar Custom Notification: ' + e.getMessage());
            }        

        }
}