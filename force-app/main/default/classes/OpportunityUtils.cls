public class OpportunityUtils {
    @InvocableMethod
    public static void unsyncQuote(List<Id> opportunityIds) {
        List<Opportunity> opportunities = [SELECT Id, SyncedQuoteId FROM Opportunity WHERE Id IN :opportunityIds];
        for (Opportunity opp : opportunities) {
            opp.SyncedQuoteId = null;
        }
        update opportunities;
    }
}