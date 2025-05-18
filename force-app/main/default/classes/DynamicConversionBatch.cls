/**
 * @description       : Automação dinâmica para conversão de campos picklist para numérico.
 *                     Possui duas etapas:
 *                      - PreConversion: Mapeia os valores dos picklists NB e XB para o "último valor do range"
 *                         e grava em campos temporários (tempNBvalue__c e tempXBvalue__c).
 *                      - PostConversion: Converte os valores dos campos temporários para Decimal e atualiza
 *                         os campos legados convertidos (nb_receita_mensal__c e xb_receita_mensal__c).
 *                     O Monitoramento será feito através de consultas:
 *                      - Opportunity: SELECT COUNT(Id), nb_receita_mensal__c, xb_receita_mensal__c FROM Opportunity GROUP BY nb_receita_mensal__c, xb_receita_mensal__c 
 *                      - Lead: SELECT COUNT(Id), nb_receita_mensal__c, xb_receita_mensal__c FROM Lead GROUP BY nb_receita_mensal__c, xb_receita_mensal__c
 *                     As etapas execução da conversão:
 * 						1- Rodar batch de Pre Conversion para Lead e Opp.
 * 							- Opportunity: 
 *                          	Database.executeBatch(new DynamicConversionBatch('Opportunity', 'PreConversion'));
 *                      	- Lead: 
 *                          	Database.executeBatch(new DynamicConversionBatch('Lead', 'PreConversion'));
 * 
 * 						2- Comentar referencias de uso dos campos:
 * 							- Classes
 * 									OpportunityTriggerHelper, DynamicConversionBatchTest
 * 
 * 						3- Trocar tipo dos campos para decimal:
 * 							nb_receita_mensal__c, xb_receita_mensal__c
 * 
 * 						4- Rodar batch de Post Conversion para Lead e Opp.
 *                      	- Opportunity: 
 *                          	Database.executeBatch(new DynamicConversionBatch('Opportunity', 'PostConversion'));
 *                      	- Lead: 
 *                          	Database.executeBatch(new DynamicConversionBatch('Lead', 'PostConversion'));
 * 
 * 
 * @author            : aydhan.passos
 * @last modified on  : 04-06-2025
 * @last modified by  : aydhan.passos
 */
public class DynamicConversionBatch implements Database.Batchable<SObject>, Database.Stateful {

    private String objectName;
    private String stage; // "PreConversion" ou "PostConversion"
    private final List<String> supportedObjects = new List<String>{'Opportunity', 'Lead'};  
    
    private class IllegalArgumentException extends Exception {}

    // Mapas estáticos para NB e XB
    private static final Map<String, String> NB_RANGES = new Map<String, String>{
        'Estamos iniciando no e-commerce' => '0',
        'Até R$50 mil' => '50000',
        'R$50 mil até R$100 mil' => '100000',
        'R$100 mil até R$200 mil' => '200000',
        'R$100 mil até R$500 mil' => '500000',
        'R$200 mil até R$500 mil' => '500000',
        'R$500 mil até R$1 milhão' => '1000000',
        'R$1 milhão até R$10 milhões' => '10000000',
        'Acima de R$10 milhões' => '10000001'
    };

    private static final Map<String, String> XB_RANGES = new Map<String, String>{
        'Não vende para o Brasil ainda' => '0',
        'Até R$100K' => '100000',
        'R$100K até R$250K' => '250000',
        'R$250K até R$1M' => '1000000',
        'R$1M até R$5M' => '5000000',
        'Acima de R$5M' => '5000001'
    };

    // Statistical variables to track processing
    private Integer totalRecordsProcessed = 0;
    private Integer totalRecordsUpdated = 0;
    private Integer totalErrors = 0;
    private List<String> errorMessages = new List<String>();
    private Set<String> unmatchedNBValues = new Set<String>();
    private Set<String> unmatchedXBValues = new Set<String>();
      
    // Construtor: exige o nome do sObject e a etapa a ser executada
    public DynamicConversionBatch(String objectName, String stage) {
        if(String.isBlank(objectName) || String.isBlank(stage)){
            throw new IllegalArgumentException('Parâmetros "objectName" e "stage" são obrigatórios.');
        }
        this.objectName = objectName;
        this.stage = stage;
    }
    public DynamicConversionBatch() {
        if(String.isBlank(objectName) || String.isBlank(stage)){
            throw new IllegalArgumentException('Parâmetros "objectName" e "stage" são obrigatórios. É necessário informar o nome do objeto e a etapa, nessa ordem, para ser executada.');
        }
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {

        String query = '';
        if(objectName == 'Opportunity' || objectName == 'Lead'){
            query = 'SELECT Id, nb_receita_mensal__c, xb_receita_mensal__c, ' + 
                    'tempNBvalue__c, tempXBvalue__c ' +
                    ' FROM ' + objectName; //+ ' WHERE ' +
                    //' (nb_receita_mensal__c != null OR xb_receita_mensal__c != null) ';
        } else {            
            throw new IllegalArgumentException('Objeto informado não é suportado. Utilize um dos seguintes: ' + String.join(this.supportedObjects, ', ') + '.');
        }
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        
        List<SObject> recordsToUpdate = new List<SObject>();

        totalRecordsProcessed += scope.size();
        
        switch on this.stage {
            
            when 'PreConversion' {
                // For each record, map the picklist values NB and XB to the text value (last value of the range)
                for(SObject sobj : scope){
                    // Field NB
                    String nbPicklist = (String)sobj.get('nb_receita_mensal__c');
                    String nbRange = getNBRangeValue(nbPicklist);
                    if(nbRange != null){
                        sobj.put('tempNBvalue__c', nbRange);
                    }else if(nbRange == null && nbPicklist != ''){
                        unmatchedNBValues.add(nbPicklist);
                    }
                    
                    // Field XB
                    String xbPicklist = (String)sobj.get('xb_receita_mensal__c');
                    String xbRange = getXBRangeValue(xbPicklist);
                    if(xbRange != null){
                        sobj.put('tempXBvalue__c', xbRange);
                    }else if(xbRange == null && xbPicklist != ''){
                        unmatchedXBValues.add(xbPicklist);
                    }
                    
                    // Add the record to the update list only if at least one of the values was updated
                    if(nbRange != null || xbRange != null){
                        recordsToUpdate.add(sobj);
                        totalRecordsUpdated++;
                    }
                }
            }
            
            when 'PostConversion' {
                // Convert the temporary field values to Decimal and update the legacy fields
                for(SObject sobj : scope){
                    // Field NB
                    String nbTexto = (String)sobj.get('tempNBvalue__c');
                    if(nbTexto != null){
                        try {
                            Decimal nbNumero = Decimal.valueOf(nbTexto);
                            sobj.put('nb_receita_mensal__c', nbNumero);
                        } catch(Exception e) {
                            totalErrors++;
                            errorMessages.add('Erro na conversão NB do registro Id ' + sobj.get('Id') + ': ' + e.getMessage());
                        }
                    }
                    // Field XB
                    String xbTexto = (String)sobj.get('tempXBvalue__c');
                    if(xbTexto != null){
                        try {
                            Decimal xbNumero = Decimal.valueOf(xbTexto);
                            sobj.put('xb_receita_mensal__c', xbNumero);
                        } catch(Exception e) {
                            totalErrors++;
                            errorMessages.add('Erro na conversão XB do registro Id ' + sobj.get('Id') + ': ' + e.getMessage());
                        }
                    }
                    recordsToUpdate.add(sobj);
                    totalRecordsUpdated++;
                }
            }
            
            when else {
                throw new IllegalArgumentException('Etapa inválida. Utilize "PreConversion" ou "PostConversion".');
            }
        }
        
        if(!recordsToUpdate.isEmpty()){
            TriggerHandler.bypass('OpportunityTriggerHandler');
            update recordsToUpdate;
            TriggerHandler.clearBypass('OpportunityTriggerHandler');
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finalizado para objeto ' + objectName + ' na etapa ' + stage);
        sendNotification();
    }

    // Supporting methods bellow:

    // Maps the values of the NB field to the "last value" in text format.
    private String getNBRangeValue(String nbPicklistValue) {
        return NB_RANGES.containsKey(nbPicklistValue) ? NB_RANGES.get(nbPicklistValue) : null;
    }
    
    // Maps the values of the XB field to the "last value" in text format.
    private String getXBRangeValue(String xbPicklistValue) {
        return XB_RANGES.containsKey(xbPicklistValue) ? XB_RANGES.get(xbPicklistValue) : null;
    }

    private void sendNotification() {
        // Monta a mensagem usando as variáveis de estatística
        String body = 'Batch finalizado para objeto ' + objectName + ' na etapa ' + stage + '\n' +
                      'Total de registros processados: ' + totalRecordsProcessed + '\n' +
                      'Total de registros atualizados: ' + totalRecordsUpdated + '\n' +
                      'Total de erros: ' + totalErrors + '\n\n';
        if(!errorMessages.isEmpty() && totalErrors > 0){
            body += 'Erros: ' + String.join(errorMessages, '; ') + '\n';
        }
        body +='\n';  
        if(!unmatchedNBValues.isEmpty() && this.stage == 'PreConversion'){
            body += 'Valores NB não mapeados: ' + String.join(new List<String>(unmatchedNBValues), ', ') + '\n';
        }
        body +='\n';  
        if(!unmatchedXBValues.isEmpty() && this.stage == 'PreConversion'){
            body += 'Valores XB não mapeados: ' + String.join(new List<String>(unmatchedXBValues), ', ') + '\n';
        }
        
        String targetEmail = UserInfo.getUserEmail();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{targetEmail});
        mail.setSubject('Batch Finalizado - Conversão de Campos [' + objectName + ']');
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});

        CustomNotificationType notificationType = [
            SELECT Id
            FROM CustomNotificationType
            WHERE DeveloperName = 'CompletedBatchExecution'
            LIMIT 1
        ];

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Batch Finalizado');
        notification.setBody(body);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(UserInfo.getUserId());
        Set<String> recipients = new Set<String>{ UserInfo.getUserId() }; // quem vai receber
        notification.send(recipients);
    }
}