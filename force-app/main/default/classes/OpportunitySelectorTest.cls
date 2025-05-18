/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-03-03
 * @last modified by  : Hersilio Belini de Oliveira
**/
@isTest
public class OpportunitySelectorTest {

    @testSetup
    static void setup() {
        Account acct = new Account(
            Name = 'Conta teste',
            Filial_no_Brasil__c = 'Sim',
            Nome_Empresarial__c = 'Empresa X',
            BillingCountry = 'Brasil'
        );

        insert acct;

        Id nationalRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NaTional').getRecordTypeId();

        Date datClose = Date.today().addDays(30);

        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(Name = 'Opp1', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com'),
            new Opportunity(Name = 'Opp2', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Gateway', RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com')
        };

        insert opps;
    }

    @isTest
    static void testGetOpportuniesByIds() {
        // Positive test case
        Set<Id> oppIds = new Set<Id>();
        for (Opportunity opp : [SELECT Id FROM Opportunity]) {
            oppIds.add(opp.Id);
        }
        List<Opportunity> result = OpportunitySelector.getOpportuniesByIds(oppIds);
        System.assertEquals(2, result.size(), 'There should be 2 opportunities');

        // Negative test case
        List<Opportunity> emptyResult = OpportunitySelector.getOpportuniesByIds(new Set<Id>());
        System.assertEquals(0, emptyResult.size(), 'There should be no opportunities');
    }

    @isTest
    static void testGetOpportunityById() {
        // Positive test case
        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        Opportunity result = OpportunitySelector.getOpportunityById(testOpportunity.Id);
        System.assertNotEquals(null, result, 'Opportunity should not be null');

        // Negative test case
        Opportunity nullResult = OpportunitySelector.getOpportunityById(null);
        System.assertEquals(null, nullResult, 'Opportunity should be null');
    }

    @isTest
    static void testGetCompleteOpportunityById() {
        // Positive test case
        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        Opportunity result = OpportunitySelector.getCompleteOpportunityById(testOpportunity.Id);
        System.assertNotEquals(null, result, 'Opportunity should not be null');

        // Negative test case
        Opportunity nullResult = OpportunitySelector.getCompleteOpportunityById(null);
        System.assertEquals(null, nullResult, 'Opportunity should be null');
    }
}