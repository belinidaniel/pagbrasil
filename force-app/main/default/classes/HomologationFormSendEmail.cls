public with sharing class HomologationFormSendEmail {

    @InvocableMethod(label='Send Homologation Form Empty Fields List Email')
    public static void sendRequiredEmptyOrNullFieldsList(List<FlowInputs> inputs) {
        List<HomologationForm__c> forms = HomologationFormSelector.getByOpportunityId(inputs[0].opportunityId);
        Map<String, List<String>> requiredEmptyOrNullFieldsMap = builRequiredEmptyOrNullFieldsMap(forms, inputs[0].language);

        Contact recipient = [SELECT Id, Email
            FROM Contact
            WHERE Id = :inputs[0].recipient
            LIMIT 1];

        String emailBody = buildEmailBody(requiredEmptyOrNullFieldsMap);
        sendEmail(recipient.Email, emailBody);
    }

    private static Map<String, List<String>> builRequiredEmptyOrNullFieldsMap(List<HomologationForm__c> forms, String language) {
        
        Map<String, List<String>> requiredEmptyOrNullFieldsMap = new Map<String, List<String>>();

        for (HomologationForm__c form : forms) {
            requiredEmptyOrNullFieldsMap.put(form.Name, getFieldLabels(form.Required_Fields__c));
        }

        return requiredEmptyOrNullFieldsMap;
    }

    private static String buildEmailBody(Map<String, List<String>> requiredEmptyOrNullFieldsMap) {
        String emailBody = 'Prezado, solicito informações referentes aos formulários de homologação:\n\n';

        for (String formURL : requiredEmptyOrNullFieldsMap.keySet()) {
            emailBody += 'Formulário de homologação: ' + formURL + '\n';
            List<String> fields = requiredEmptyOrNullFieldsMap.get(formURL);
            for (String field : fields) {
                emailBody += '- ' + field + '\n';
            }
            emailBody += '\n';
        }

        return emailBody;
    }

    private static void sendEmail(String toEmail, String body) {
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { toEmail });
        email.setSubject('Campos obrigatórios não preenchidos nos formulários de homologação');
        email.setPlainTextBody(body);
        emails.add(email);
        
        Messaging.sendEmail(emails);
    }

    private static List<String> getFieldLabels(String requiredFields) {
        List<String> fieldApiNames = requiredFields.split(',');
        List<String> fieldLabels = new List<String>();
        List<String> fieldsNotFound = new List<String>();

        Schema.SObjectType objType = HomologationForm__c.SObjectType;
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();

        for (String apiName : fieldApiNames) {
            if (fieldMap.containsKey(apiName)) {
                String label = fieldMap.get(apiName).getDescribe().getLabel();
                fieldLabels.add(label);
            } else{
                fieldsNotFound.add(apiName);
            }
        }

        System.debug('Fields not found: ' + fieldsNotFound);

        return fieldLabels;
    }

    public class FlowInputs {
        @InvocableVariable
        public Id opportunityId;
        @InvocableVariable
        public String recipient;
        @InvocableVariable
        public String language;
    }
}