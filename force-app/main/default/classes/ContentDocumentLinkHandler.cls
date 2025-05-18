public class ContentDocumentLinkHandler {
    private static final Map<String, Schema.RecordTypeInfo> opportunityRecordTypes = 
        Schema.SObjectType.Opportunity.getRecordTypeInfosByName();

    public static void afterInsert(Map<Id, ContentDocumentLink> newMap) {
        if (newMap == null || newMap.isEmpty()) {
            return; 
        }

        Set<Id> opportunityIds = collectOpportunityIds(newMap);

        Set<Id> contentDocumentIds = collectContentDocumentIds(newMap);

        if (opportunityIds.isEmpty() || contentDocumentIds.isEmpty()) {
            return; 
        }

        Set<Id> validOpportunityIds = filterOpportunitiesByRecordType(opportunityIds);

        if (!validOpportunityIds.isEmpty()) {
            ContentDocumentLinkService.sendDocumentWhitDocusing(contentDocumentIds, validOpportunityIds);
        }
    }

    private static Set<Id> collectOpportunityIds(Map<Id, ContentDocumentLink> newMap) {
        Set<Id> opportunityIds = new Set<Id>();
        for (ContentDocumentLink link : newMap.values()) {
            if (link.LinkedEntityId != null && link.LinkedEntityId.getSObjectType() == Opportunity.SObjectType) {
                opportunityIds.add(link.LinkedEntityId);
            }
        }
        return opportunityIds;
    }

    private static Set<Id> collectContentDocumentIds(Map<Id, ContentDocumentLink> newMap) {
        Set<Id> contentDocumentIds = new Set<Id>();
        for (ContentDocumentLink link : newMap.values()) {
            if (link.ContentDocumentId != null) {
                contentDocumentIds.add(link.ContentDocumentId);
            }
        }
        return contentDocumentIds;
    }

    private static Set<Id> filterOpportunitiesByRecordType(Set<Id> opportunityIds) {
        Set<Id> validOpportunityIds = new Set<Id>();
        
        List<Opportunity> opportunities = [
            SELECT Id, RecordTypeId 
            FROM Opportunity 
            WHERE Id IN :opportunityIds
        ];

        for (Opportunity opp : opportunities) {
            if (opp.RecordTypeId != null) {
                Schema.RecordTypeInfo recordTypeInfo = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.RecordTypeId);

                if (recordTypeInfo != null && recordTypeInfo.getName() == 'National') {
                    validOpportunityIds.add(opp.Id);
                }
            }
        }

        return validOpportunityIds;
    }
}