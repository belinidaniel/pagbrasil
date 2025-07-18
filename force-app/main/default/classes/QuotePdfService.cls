/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 06-30-2025
 * @last modified by  : Marcelo Duarte
**/
public with sharing class QuotePdfService {

    @AuraEnabled(cacheable=true)
    public static Quote getOpportunityType(Id quoteId) {
        return [
            SELECT Id, Name, Status, OpportunityId, 
                   Opportunity.RecordType.DeveloperName,
                   Opportunity.SyncedQuoteId, 
                   Opportunity.SyncedQuote.IsSyncing, 
                   IsSyncing,
                   Opportunity.Owner.Email,
                   Opportunity.Owner.Name
            FROM Quote
            WHERE Id = :quoteId
            LIMIT 1
        ];
    }

    @AuraEnabled
    public static void savePdfVersion(Id quoteId) {
        Quote proposta = getOpportunityType(quoteId);

        PageReference pdfPage = (proposta.Opportunity.RecordType.DeveloperName == 'Crossborder')
            ? Page.PropostaCross
            : Page.PropostaNacional;
            
        pdfPage.getParameters().put('id', quoteId);
        Blob pdfBlob;

        if(Test.isRunningTest()) {
            pdfBlob = Blob.valueOf('PDF_MOCK_CONTENT');
        } else {
            pdfBlob = pdfPage.getContentAsPDF();
        }

        String baseName = proposta.Name != null ? proposta.Name.replace(' ', '_') : 'Quote';
        String filePrefix = 'Proposal_' + baseName;

        List<ContentVersion> existingVersions = [
            SELECT Title 
            FROM ContentVersion 
            WHERE FirstPublishLocationId = :quoteId 
              AND Title LIKE :('%' + filePrefix + '%')
        ];

        System.debug('Existing ContentVersions: ' + existingVersions.size());

        Integer latestVersion = 0;
        for (ContentVersion version : existingVersions) {
            String title = version.Title;
            if (title != null && title.startsWith(filePrefix + '_V')) {
                try {
                    // Extract the version number after the last '_V'
                    Integer parsedVersion = Integer.valueOf(title.substringAfterLast('_V').replace('.pdf', ''));
                    if (parsedVersion > latestVersion) {
                        latestVersion = parsedVersion;
                    }
                } catch (Exception e) { /* Ignore files with non-standard names */ }
            }
        }

        Integer nextVersion =  existingVersions.size() + 1;
        String finalFileName = filePrefix + '_V' + nextVersion;

        // 1. Cria ContentVersion com nome correto
        ContentVersion cv = new ContentVersion(
            Title = finalFileName,
            PathOnClient = finalFileName + '.pdf',
            VersionData = pdfBlob,
            FirstPublishLocationId = quoteId
        );
        insert cv;

        // 2. Linka também na oportunidade
        ContentVersion contentVersion = [
            SELECT ContentDocumentId
            FROM ContentVersion 
            WHERE Id = :cv.Id 
            LIMIT 1
        ];

        if (proposta.OpportunityId != null) {
            insert new ContentDocumentLink(
                ContentDocumentId = contentVersion.ContentDocumentId,
                LinkedEntityId = proposta.OpportunityId,
                ShareType = 'V',
                Visibility = 'AllUsers'
            );
        }

        // 3. Atualiza campo e estágio
        update new Quote(Id = quoteId, Acceptable__c = true);
        if (proposta.OpportunityId != null) {
            update new Opportunity(Id = proposta.Opportunity.Id, StageName = 'Negotiation');
        }
    }

    @AuraEnabled
    public static void sendToEmail(Id quoteId) {
        Quote proposta = getOpportunityType(quoteId);

        // Validate Opportunity relationship exists
        if(proposta.OpportunityId == null) {
            throw new AuraHandledException('Quote is not associated with an Opportunity');
        }

        PageReference pdfPage = (proposta.Opportunity.RecordType.DeveloperName == 'Crossborder')
            ? Page.PropostaCross
            : Page.PropostaNacional;
        pdfPage.getParameters().put('id', quoteId);
        
        Blob pdfBlob;
        
        if(Test.isRunningTest()) {
            pdfBlob = Blob.valueOf('PDF_MOCK_CONTENT');
        } else {
            pdfBlob = pdfPage.getContentAsPDF();
        }

        String baseName = proposta.Name != null ? proposta.Name.replace(' ', '_') : 'Quote';
        String fileName = 'Proposal_' + baseName + '.pdf';

        // Use Opportunity Owner instead of Quote Owner
        String ownerEmail = proposta.Opportunity.Owner.Email;
        if (String.isBlank(ownerEmail)) {
            throw new AuraHandledException('Opportunity owner does not have an email address.');
        }

        // Prepare and send email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { ownerEmail });
        mail.setSubject('Proposal PDF for Quote: ' + proposta.Name);
        mail.setPlainTextBody('Please find attached the proposal PDF for quote: ' + proposta.Name);
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(fileName);
        attachment.setBody(pdfBlob);
        attachment.setContentType('application/pdf');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}