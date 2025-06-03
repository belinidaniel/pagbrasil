/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 05-29-2025
 * @last modified by  : Daniel Belini
**/
public with sharing class QuotePdfService {

    @AuraEnabled(cacheable=true)
    public static Quote getOpportunityType(Id quoteId) {
        return [
            SELECT Id, Name, Status, OpportunityId, Opportunity.RecordType.DeveloperName,
                   Opportunity.SyncedQuoteId, Opportunity.SyncedQuote.IsSyncing, IsSyncing
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
        Blob pdfBlob = pdfPage.getContentAsPDF();

        String baseName = proposta.Name != null ? proposta.Name.replace(' ', '_') : 'Quote';
        String filePrefix = 'Proposal_' + baseName;

        // 🔄 Corrigir a busca diretamente por ContentVersion
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
}