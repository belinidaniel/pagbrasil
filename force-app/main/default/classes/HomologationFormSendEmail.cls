public with sharing class HomologationFormSendEmail {

    @InvocableMethod(label='Send Homologation Form Empty Fields List Email')
    public static void sendRequiredEmptyOrNullFieldsList(List<FlowInputs> inputs) {
        List<HomologationForm__c> forms = HomologationFormSelector.getByOpportunityId(inputs[0].opportunityId);
        System.debug('Forms: '+forms);
        Map<String, List<String>> requiredEmptyOrNullFieldsMap = builRequiredEmptyOrNullFieldsMap(forms, inputs[0].language);
        System.debug('requiredEmptyOrNullFieldsMap: '+requiredEmptyOrNullFieldsMap);

        final String ORG_WIDE_EMAIL_ADDRESS = 'naoresponda@pagbrasil.com.br';
        OrgWideEmailAddress fromEmail = [SELECT Id
            FROM OrgWideEmailAddress
            WHERE Address = :ORG_WIDE_EMAIL_ADDRESS
            LIMIT 1];
        Contact recipient = [SELECT Id, Email
            FROM Contact
            WHERE Id = :inputs[0].recipient
            LIMIT 1];

        String emailBody = buildEmailBody(requiredEmptyOrNullFieldsMap);
        sendEmail(fromEmail.Id, recipient.Email, emailBody);
    }

    private static Map<String, List<String>> builRequiredEmptyOrNullFieldsMap(List<HomologationForm__c> forms, String language) {
        
        Map<String, List<String>> requiredEmptyOrNullFieldsMap = new Map<String, List<String>>();

        for (HomologationForm__c form : forms) {
            List<String> requiredEmptyOrNullFieldsList = new List<String>();

            if (form.MccCode__c == null || form.MccCode__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Código MCC' : 'MCC Code');

            if (form.PodReminder__c == null || form.PodReminder__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'POD Reminder' : 'POD Reminder');

            if (form.BlockRefund__c == null || form.BlockRefund__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Block Refund' : 'Block Refund');    

            if (form.AutomaticCancellation__c == null || form.AutomaticCancellation__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Automatic Cancellation' : 'Automatic Cancellation');
            
            if (form.NumberOfDays__c == null)
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Number of Days' : 'Number of Days');

            if (form.CreditCardRecurrence__c == null || form.CreditCardRecurrence__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Credit Card Recurrence' : 'Credit Card Recurrence');
            
            if (form.DefaultSoftDescriptor__c == null || form.DefaultSoftDescriptor__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Default Soft Descriptor' : 'Default Soft Descriptor');

            if (form.InstallmentRecurrence__c == null || form.InstallmentRecurrence__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Installment Recurrence' : 'Installment Recurrence');
                
            if (form.BankSlipEmailService__c == null || form.BankSlipEmailService__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Bank Slip Email Service' : 'Bank Slip Email Service');

            if (form.BankSlipSmsService__c == null || form.BankSlipSmsService__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Bank Slip SMS Service' : 'Bank Slip SMS Service');

            if (form.PixEmailService__c == null || form.PixEmailService__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Pix Email Service' : 'Pix Email Service');

            if (form.EmailPackage__c == null || form.EmailPackage__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Email Package' : 'Email Package');

            if (form.PaymentConfirmationEmailService__c == null || form.PaymentConfirmationEmailService__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Payment Confirmation Email Service' : 'Payment Confirmation Email Service');

            if (form.SmsPackage__c == null || form.SmsPackage__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'SMS Package' : 'SMS Package');

            if (form.PaymentLinkEmailService__c == null || form.PaymentLinkEmailService__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Payment Link Email Service' : 'Payment Link Email Service');
            
            if (form.OneClickBuyingTokenization__c == null || form.OneClickBuyingTokenization__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'One Click Buying Tokenization' : 'One Click Buying Tokenization');

            if (form.AccountModel__c == null || form.AccountModel__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Account Model' : 'Account Model');

            if (form.ReviewPayeeRegistration__c == null || form.ReviewPayeeRegistration__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Review Payee Registration' : 'Review Payee Registration');

            if (form.TransactionType__c == null || form.TransactionType__c == '')
                requiredEmptyOrNullFieldsList.add(language == 'pt_BR' ? 'Transaction Type' : 'Transaction Type');

            requiredEmptyOrNullFieldsMap.put(form.Name, requiredEmptyOrNullFieldsList);
        }

        return requiredEmptyOrNullFieldsMap;
    }

    private static String buildEmailBody(Map<String, List<String>> requiredEmptyOrNullFieldsMap) {
        String emailBody = 'The following fields are required:\n\n';

        for (String formURL : requiredEmptyOrNullFieldsMap.keySet()) {
            emailBody += 'URL: ' + formURL + '\n';
            List<String> fields = requiredEmptyOrNullFieldsMap.get(formURL);
            for (String field : fields) {
                emailBody += '- ' + field + '\n';
            }
            emailBody += '\n';
        }

        return emailBody;
    }

    private static void sendEmail(String fromEmailId, String toEmail, String body) {
        
        System.debug('fromEmailId: '+fromEmailId);
        System.debug('toEmail: '+toEmail);
        System.debug('body: '+body);
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('Campos para ser preenchidos.');
        email.setToAddresses(new String[] { toEmail });
        email.setPlainTextBody(body);
        emails.add(email);
        
        Messaging.sendEmail(emails);
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