public with sharing class OpportunityUtils {
    @InvocableMethod
    public static void unsyncQuote(List<Id> opportunityIds) {
        List<Opportunity> opportunities = [SELECT Id, SyncedQuoteId FROM Opportunity WHERE Id IN :opportunityIds];
        for (Opportunity opp : opportunities) {
            opp.SyncedQuoteId = null;
        }
        update opportunities;
    }

    @AuraEnabled
    public static Boolean shouldShowModal(Id opportunityId) {
        if (opportunityId == null) return false;

        // Data de corte de criação
        DateTime limitCreated = DateTime.newInstance(2025, 8, 10, 0, 0, 0);

        // Busca oportunidade
        Opportunity opp = [
            SELECT Id, StageName, CreatedDate, Answered_Confirmation_Form__c
            FROM Opportunity
            WHERE Id = :opportunityId
            LIMIT 1
        ];

        // Precisa estar em Contract e não ter respondido
        if (opp.StageName != 'Contract' || opp.Answered_Confirmation_Form__c) {
            return false;
        }

        // Criadas a partir de 10/08/2025 → sempre pode mostrar
        if (opp.CreatedDate >= limitCreated) {
            return true;
        }

        // Criadas antes → valida se **todo** o histórico tem só Discovery ou Negotiation
        List<OpportunityHistory> history = [
            SELECT StageName
            FROM OpportunityHistory
            WHERE OpportunityId = :opportunityId
        ];

        // Regra: todos históricos devem ser Discovery ou Negotiation
        for (OpportunityHistory h : history) {
            if (h.StageName != 'Discovery' && h.StageName != 'Negotiation') {
                return false; // achou um stage que não é permitido
            }
        }

        // Se passou pela validação, pode mostrar
        return true;
    }
}