/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-07
 * @last modified by  : Hersilio Belini de Oliveira
**/
public with sharing class CreateOrganizationMethod {

    @InvocableMethod
    public static void createOrganization(List<FlowInputs> inputs) {
        if (inputs == null || inputs.size() != 1) {
            throw new IllegalArgumentException('This method requires exactly one input object.');
        }

        FlowInputs input = inputs[0];

        if (input.idOpportunity == null) {
            throw new IllegalArgumentException('Opportunity Id is required.');
        }

        Opportunity opportunity = getOpportunity(input.idOpportunity);

    }

    public static Opportunity getOpportunity(Id idOpportunity) {
        List<Opportunity> opps = [
            SELECT
                Id,
                Name,
                Account.Name,
                Account.Nome_Empresarial__c,
                Country__c, Product_Type__c,
                ProductClass__c,
                WebSite__c,
                TierCS__c,
                Moeda__c,
                StageName,
                IntegrationType__c
            FROM Opportunity
            WHERE Id = :idOpportunity
        ];

        if(opps.isEmpty()) {
            throw new AuraHandledException('No Opportunity found with the provided Id.');
        }

        return opps[0];
    }

    public class FlowInputs {
        @InvocableVariable
        public Id idOpportunity;
    }
}