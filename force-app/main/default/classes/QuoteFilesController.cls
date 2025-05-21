public with sharing class QuoteFilesController {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getSyncedQuoteFiles(Id opportunityId) {
        List<Quote> syncedQuote = [
            SELECT Id
            FROM Quote
            WHERE OpportunityId = :opportunityId
            AND IsSyncing = true
            LIMIT 1
        ];

        if (syncedQuote.isEmpty()) return new List<ContentDocumentLink>();

        return [
            SELECT 
                ContentDocument.Title, 
                ContentDocument.FileExtension,
                ContentDocument.ContentSize, 
                ContentDocument.LatestPublishedVersionId,
                LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :syncedQuote[0].Id
            ORDER BY ContentDocument.CreatedDate DESC
            LIMIT 1
        ];
    }
}