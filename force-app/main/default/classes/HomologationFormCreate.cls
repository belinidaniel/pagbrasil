public with sharing class HomologationFormCreate {
    
    @InvocableMethod
    public static void splitString(List<FlowInputs> inputs) {

        System.debug('HomologationFormCreate.splitString called with inputs: ' + inputs);

        if (inputs == null || inputs[0].url == null || inputs[0].opportunityId == null)
            return;

        FlowInputs input = inputs[0];
        System.debug('Input URL: ' + input.url);

        Opportunity opp = [SELECT Id, AccountId,Segmento__c,NationalPaymentMethod__c,IntegrationType__c,Payout__c FROM Opportunity WHERE Id = :input.opportunityId];
        System.debug('Opportunity: ' + opp);
        Boolean isDropshiping = opp.Segmento__c == 'Dropshipping';
        Boolean isPayout = opp.Payout__c;
        Boolean isIntegrationTypeAPIorJS = opp.IntegrationType__c == 'API' || opp.IntegrationType__c == 'JS';
        Boolean isPaymentMethodCreditCard = opp.NationalPaymentMethod__c.contains('Cartão de Crédito');
        Boolean isPaymentMethodBankSlip = opp.NationalPaymentMethod__c.contains('Boleto Flash');

        List<String> requiredFields = HomologationFormHelper.getRequiredFields(opp);

        List<HomologationForm__c> homologationFormsToCreate = new List<HomologationForm__c>();

        if(input.url.contains(';'))
            for(String u : input.url.split(';'))
                homologationFormsToCreate.add(new HomologationForm__c(Opportunity__c = input.opportunityId,Account__c = input.accountId,Name = u,URL__c = u, Required_Fields__c = String.join(requiredFields, ',')));
        else
            homologationFormsToCreate.add(new HomologationForm__c(Opportunity__c = input.opportunityId, Account__c = input.accountId, Name = input.url, URL__c = input.url, Required_Fields__c = String.join(requiredFields, ',')));   
        
        System.debug('homologationFormsToCreate: ' + homologationFormsToCreate);

        if(!homologationFormsToCreate.isEmpty())
            insert homologationFormsToCreate;
        
    }

    public class FlowInputs {
        @InvocableVariable
        public String url;
        @InvocableVariable
        public Id opportunityId;
        @InvocableVariable
        public Id accountId;
    }
    
}