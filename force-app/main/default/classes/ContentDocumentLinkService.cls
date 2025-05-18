public class ContentDocumentLinkService {

    public static void sendDocumentWhitDocusing(Set<Id> contentDocumentIds, Set<Id> validOpportunityIds) {
        if (contentDocumentIds.isEmpty() || validOpportunityIds.isEmpty()) {
            return;
        }

        Map<Id, ContentDocument> contentDocumentsMap = new Map<Id, ContentDocument>(
            [SELECT Id, Title, FileType FROM ContentDocument WHERE Id IN :contentDocumentIds]
        );

        for (ContentDocument doc : contentDocumentsMap.values()) {
            if (doc.Title != null && doc.Title.contains('ContractNacionalPage') && doc.FileType == 'PDF') {
                DocuSignStatusTriggerHandler.handleOrderComplete(validOpportunityIds);
                System.debug('handleOrderComplete called for validOpportunityIds: ' + validOpportunityIds);
            }
        }
    }
}