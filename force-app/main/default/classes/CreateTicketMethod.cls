/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 07-08-2025
 * @last modified by  : Daniel Belini
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
       //sendIntegration(input);
        // Logic to create a ticket using the idOpportunity
      createChildAccountsForHomologations(input.idOpportunity);
    }

    // Method to send the PDF through email to test the PDF generation
    // This method is commented out in the original code, but can be used for testing purposes
   private static void sendPdfThroughEmail(FlowInputs input) {
    if (input.idOpportunity != null) {
        try {
                List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();

                // Busca todas as homologações relacionadas à oportunidade
                List<HomologationForm__c> homologations = OpportunitySelector.getHomologationsByOpportunityId(input.idOpportunity);

                if (homologations.isEmpty()) {
                    throw new IllegalArgumentException('No HomologationForm__c found for Opportunity Id: ' + input.idOpportunity);
                }

                for (HomologationForm__c h : homologations) {
                    PageReference pg = Page.OpportunityFields;
                    pg.getParameters().put('id', input.idOpportunity);
                    pg.getParameters().put('homologationId', h.Id);

                    Blob filePdf = pg.getContentAsPDF();

                    Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                    attachment.setFileName('Opportunity_' + input.idOpportunity + '_Homologation_' + h.Id + '.pdf');
                    attachment.setBody(filePdf);
                    attachment.setContentType('application/pdf');

                    attachments.add(attachment);
                }

                // Configura e envia um único e-mail com todos os PDFs anexados
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {
                    'eduardo.teixeira@srconsulting.io'
                    //'gustavo.pias@srconsulting.io',
                    //'daniel.oliveira@srconsulting.io'
                });
                email.setSubject('Opportunity PDF - Multiple Homologations');
                email.setPlainTextBody('Segue em anexo os PDFs gerados para todas as homologações da Opportunity ' + input.idOpportunity);
                email.setFileAttachments(attachments);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

            } catch (Exception e) {
                throw new IllegalArgumentException('Failed to send PDFs: ' + e.getMessage());
            }
        } else {
            throw new IllegalArgumentException('No Opportunity found with the provided Id.');
        }
    }



    public static void sendIntegration(FlowInputs input){
        Opportunity opp = OpportunitySelector.getCompleteOpportunityById(input.idOpportunity);
        List<HomologationForm__c> homologations = OpportunitySelector.getHomologationsByOpportunityId(input.idOpportunity);
        Blob filePdf;
        List<String> pdfTokenList = new List<String>();
        if (homologations.isEmpty()) {
            throw new IllegalArgumentException('No HomologationForm__c found for Opportunity Id: ' + input.idOpportunity);
        }

        if (opp != null) {
            
                String pdfToken = '';
                ZendeskService zendeskService = new ZendeskService();
                String fileName = 'Opp_' + StringUtil.replaceCaracteresSpecials(opp.Name, '_');
                String json = JSON.serialize(new OpportunityWrapper(opp));
                System.debug('json: ' + json);
                Blob fileJson = Blob.valueOf(json);
                String jsonToken = zendeskService.createAttach(fileJson, fileName + '.json', 'json');
                System.debug('jsonToken: ' + jsonToken);
                for (HomologationForm__c h : homologations) {
                    PageReference pg = Page.OpportunityFields;
                    pg.getParameters().put('id', input.idOpportunity);
                    pg.getParameters().put('homologationId', h.Id);
                    if (Test.isRunningTest()){
                        filePdf = Blob.valueOf('Blob');
                    } else {
                        filePdf = pg.getContentaspdf();
                    }
                    // Extract the name between the first and second dot in the URL
                    String extractedName = extractNameFromUrl(h.Name);
                    String pdfFileName = 'Opp_' + StringUtil.replaceCaracteresSpecials(opp.Name, '_') + '_' + extractedName + '.pdf';
                    pdfToken = zendeskService.createAttach(filePdf, pdfFileName, 'pdf');
                    pdfTokenList.add(pdfToken);
                }


                ZendeskTicketWrapper.TicketCheck ticketCheck = new ZendeskTicketWrapper.TicketCheck();
                ticketCheck.pagShieldActivationCheck = input.pagShieldActivationCheck;
                ticketCheck.paymentMethodsInFooter = input.paymentMethodsInFooter;
                ticketCheck.logoInsertionInBoleto = input.logoInsertionInBoleto;
                ticketCheck.reclameAqui = input.reclameAqui;
                ticketCheck.pods = input.pods;
                ticketCheck.visualIdentityManualRequest = input.visualIdentityManualRequest;
                ticketCheck.welcomeEmailAndTrainingLinks = input.welcomeEmailAndTrainingLinks;
                ticketCheck.triggerIndication = input.triggerIndication;

                ZendeskTicketWrapper ticket = new ZendeskTicketWrapper(opp, pdfTokenList, ticketCheck, input.organizationId);

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

        System.debug('contentVersion: ' + JSON.serialize(contentVersion));

        insert contentVersion;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id].ContentDocumentId;
        cdl.LinkedEntityId = oppId;
        cdl.ShareType = 'V';
        insert cdl;

        return contentVersion;
    }

    // Method to create child accounts for each homologation
    @future
    public static void createChildAccountsForHomologations(String opportunityId) {
        try {
            // Get the opportunity and related account
            Opportunity opp = OpportunitySelector.getCompleteOpportunityById(opportunityId);
            if (opp == null) {
                throw new IllegalArgumentException('No Opportunity found with the provided Id: ' + opportunityId);
            }

            // Only create child accounts if the opportunity account doesn't have a parent
            if (opp.Account.ParentId != null) {
                System.debug('Account already has a parent, skipping child account creation');
                return;
            }

            // Get all homologations for the opportunity
            List<HomologationForm__c> homologations = OpportunitySelector.getHomologationsByOpportunityId(opportunityId);
            if (homologations.isEmpty()) {
                System.debug('No homologations found for opportunity: ' + opportunityId);
                return;
            }

            // Get existing child accounts to avoid duplicates
            Set<String> existingChildAccountNames = new Set<String>();
            List<Account> existingChildAccounts = [
                SELECT Name 
                FROM Account 
                WHERE ParentId = :opp.AccountId
            ];
            for (Account childAccount : existingChildAccounts) {
                existingChildAccountNames.add(childAccount.Name);
            }

            List<Account> childAccountsToCreate = new List<Account>();

            for (HomologationForm__c homologation : homologations) {
                // Extract name between first and second dot from homologation name (URL)
                String extractedName = extractNameFromUrl(homologation.Name);
                
                if (String.isBlank(extractedName)) {
                    System.debug('Could not extract name from homologation: ' + homologation.Name);
                    continue;
                }

                // Check if child account with this name already exists
                if (existingChildAccountNames.contains(extractedName)) {
                    System.debug('Child account already exists with name: ' + extractedName);
                    continue;
                }

                // Create child account
                Account childAccount = new Account();
                childAccount.Name = extractedName;
                childAccount.ParentId = opp.AccountId;
                
                // Copy fields from parent account
                childAccount.RecordTypeId = opp.Account.RecordTypeId;
                childAccount.Type = opp.Account.Type;
                
                // Copy billing address
                childAccount.BillingStreet = opp.Account.BillingStreet;
                childAccount.BillingCity = opp.Account.BillingCity;
                childAccount.BillingState = opp.Account.BillingState;
                childAccount.BillingPostalCode = opp.Account.BillingPostalCode;
                childAccount.BillingCountry = opp.Account.BillingCountry;
                childAccount.BillingLatitude = opp.Account.BillingLatitude;
                childAccount.BillingLongitude = opp.Account.BillingLongitude;
                childAccount.BillingGeocodeAccuracy = opp.Account.BillingGeocodeAccuracy;
                childAccount.BillingComplement__c = opp.Account.BillingComplement__c;
                childAccount.BillingNumber__c = opp.Account.BillingNumber__c;
                
                // Set OrganizationId__c = parent OrganizationId__c + homologation account name
                String parentOrgId = opp.Account.OrganizationId__c != null ? opp.Account.OrganizationId__c : '';
                childAccount.OrganizationId__c = parentOrgId + extractedName;

                childAccountsToCreate.add(childAccount);
                existingChildAccountNames.add(extractedName); // Add to set to avoid duplicates within this batch
            }

            // Insert child accounts
            if (!childAccountsToCreate.isEmpty()) {
                insert childAccountsToCreate;
                System.debug('Successfully created ' + childAccountsToCreate.size() + ' child accounts');
            } else {
                System.debug('No new child accounts to create');
            }

        } catch (Exception e) {
            System.debug('Error creating child accounts: ' + e.getMessage());
            throw new IllegalArgumentException('Failed to create child accounts: ' + e.getMessage());
        }
    }

    // Helper method to extract name between first and second dot from URL
    private static String extractNameFromUrl(String url) {
        if (String.isBlank(url)) {
            return '';
        }
        
        Integer firstDot = url.indexOf('.');
        Integer secondDot = url.indexOf('.', firstDot + 1);
        
        if (firstDot != -1 && secondDot != -1 && secondDot > firstDot + 1) {
            return url.substring(firstDot + 1, secondDot);
        }
        
        return '';
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