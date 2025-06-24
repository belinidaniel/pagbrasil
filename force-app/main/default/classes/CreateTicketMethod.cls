/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-22
 * @last modified by  : Hersilio Belini de Oliveira
**/
public class CreateTicketMethod {

    @InvocableMethod
    public static void createTicket(List<FlowInputs> inputs) {
        // Ensure the list has exactly one input object
        if (inputs == null || inputs.size() != 1) {
            throw new IllegalArgumentException('This method requires exactly one input object.');
        }

        FlowInputs input = inputs[0];

        // Validate mandatory fields
        if (input.idOpportunity == null) {
            throw new IllegalArgumentException('Opportunity Id is required.');
        }
        
         if (input.priority == null || String.isEmpty(input.priority)) {
             throw new IllegalArgumentException('Priority is required.');
         }

        String priority = input.priority;
        Date dataCreateAccount = input.dataCreateAccount;

        sendPdfThroughEmail(input);
        // sendIntegration(input);
        // Logic to create a ticket using the idOpportunity
    }

    private static void sendPdfThroughEmail(FlowInputs input) {
        if (input.idOpportunity != null) {
            try {
                PageReference pg = Page.OpportunityFields;
                pg.getParameters().put('id', input.idOpportunity);

                Blob filePdf = pg.getContentaspdf();

                String fileName = 'Opp.pdf';
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName(fileName);
                attachment.setBody(filePdf);
                attachment.setContentType('application/pdf');
                email.setToAddresses(new String[] { 'eduardo.teixeira@srconsulting.io' } ); 
                email.setSubject('Opportunity PDF Test');
                email.setPlainTextBody('Test');
                email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

            } catch (Exception e) {
                throw new IllegalArgumentException('Failed to send PDF through email: ' + e.getMessage());
            }
        } else {
            throw new IllegalArgumentException('No Opportunity found with the provided Id.');
        }
    }

    private static void sendIntegration(FlowInputs input){
        Opportunity opp = OpportunitySelector.getCompleteOpportunityById(input.idOpportunity);
        Blob filePdf;
        String pdfToken = '';

        if (opp != null) {

            try {
                ZendeskService zendeskService = new ZendeskService();
                String fileName = 'Opp_' + StringUtil.replaceCaracteresSpecials(opp.Name, '_');
                String json = JSON.serialize(new OpportunityWrapper(opp));
                System.debug('json: ' + json);
                Blob fileJson = Blob.valueOf(json);
                String jsonToken = zendeskService.createAttach(fileJson, fileName + '.json', 'json');
                System.debug('jsonToken: ' + jsonToken);

                PageReference pg = Page.OpportunityFields;
                pg.getParameters().put('id', opp.Id);

                if (Test.isRunningTest()){
                    filePdf = Blob.valueOf('Blob');
                } else {
                    filePdf = pg.getContentaspdf();
                }

                pdfToken = zendeskService.createAttach(filePdf, fileName + '.pdf', 'pdf');

                System.debug('pdfToken: ' + pdfToken);

                ZendeskTicketWrapper.TicketCheck ticketCheck = new ZendeskTicketWrapper.TicketCheck();
                ticketCheck.pagShieldActivationCheck = input.pagShieldActivationCheck;
                ticketCheck.paymentMethodsInFooter = input.paymentMethodsInFooter;
                ticketCheck.logoInsertionInBoleto = input.logoInsertionInBoleto;
                ticketCheck.reclameAqui = input.reclameAqui;
                ticketCheck.pods = input.pods;
                ticketCheck.visualIdentityManualRequest = input.visualIdentityManualRequest;
                ticketCheck.welcomeEmailAndTrainingLinks = input.welcomeEmailAndTrainingLinks;
                ticketCheck.triggerIndication = input.triggerIndication;

                ZendeskTicketWrapper ticket = new ZendeskTicketWrapper(opp, new List<String>{ jsonToken, pdfToken }, ticketCheck, input.organizationId);

                // System.debug('ticket: ' + JSON.serialize(ticket).replace('publicComment', 'public'));

                String tiketId = zendeskService.createTicket(ticket);

                System.debug('tiketId:' + tiketId);

                if(String.isNotBlank(tiketId)){
                    opp.TicketId__c = tiketId;
                    opp.Priority__c = input.priority;
                    opp.DateAccountCreation__c = input.dataCreateAccount;
                    opp.TicketCreationDate__c = Datetime.now();

                    createContentVersion(opp.Id, fileName, 'json', fileJson);
                    createContentVersion(opp.Id, fileName, 'pdf', filePdf);

                    update opp;

                    if(opp.Account.OrganizationId__c == null){
                        update new Account(Id = opp.AccountId, OrganizationId__c = input.organizationId);
                    }
                } else {
                    throw new AuraHandledException('Failed to create ticket');
                }
            } catch (Exception e) {
                throw new AuraHandledException('Failed to create ticket: ' + e.getMessage());
            }
        } else {
            throw new AuraHandledException('No Opportunity found with the provided Id.');
        }
    }

    private static ContentVersion createContentVersion(Id oppId, String fileName, String extension, Blob fileBlob){
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = fileName;
        contentVersion.PathOnClient = fileName + '.' + extension;
        contentVersion.VersionData =  fileBlob;
        contentVersion.Origin = 'H';

        insert contentVersion;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id].ContentDocumentId;
        cdl.LinkedEntityId = oppId;
        cdl.ShareType = 'V';
        insert cdl;

        return contentVersion;
    }

    public class FlowInputs {
        @InvocableVariable
        public Id idOpportunity;

        @InvocableVariable
        public String organizationId;

        @InvocableVariable
        public String priority;

        @InvocableVariable
        public Date dataCreateAccount;

        @InvocableVariable
        public Boolean pagShieldActivationCheck;

        @InvocableVariable
        public Boolean paymentMethodsInFooter;

        @InvocableVariable
        public Boolean logoInsertionInBoleto;

        @InvocableVariable
        public Boolean reclameAqui;

        @InvocableVariable
        public Boolean pods;

        @InvocableVariable
        public Boolean visualIdentityManualRequest;

        @InvocableVariable
        public Boolean welcomeEmailAndTrainingLinks;

        @InvocableVariable
        public String triggerIndication;
    }
}