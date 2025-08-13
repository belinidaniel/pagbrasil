@IsTest
public class OpportunityUtilsTest {

    @TestSetup
    static void makeData() {
        // Cria lead usando TestDataFactory (como no padrão da org)
        Lead lead = TestDataFactory.createAndInsertLeadNB();

        // Converte lead para criar Account/Contact/Opportunity
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Closed - Converted');
        Database.convertLead(lc);

        // Recupera opportunity criada na conversão
        Opportunity opp = [
            SELECT Id, SyncedQuoteId, StageName, Answered_Confirmation_Form__c
            FROM Opportunity
            WHERE AccountId = :[SELECT AccountId FROM Contact WHERE AccountId != null LIMIT 1].AccountId
            LIMIT 1
        ];

        // Configura para cenário padrão de teste
        opp.StageName = 'Contract';
        opp.Answered_Confirmation_Form__c = false;
        update opp;

        // Cria dados para testar unsyncQuote
        Id stdPBId = Test.getStandardPricebookId();
        Product2 prod = new Product2(Name = 'Produto Teste', IsActive = true);
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = stdPBId,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        Quote q = new Quote(
            OpportunityId = opp.Id,
            Name = 'Quote Teste',
            Pricebook2Id = stdPBId,
            Status = 'Draft'
        );
        insert q;

        opp.SyncedQuoteId = q.Id;
        update opp;
    }

    @IsTest
    static void testUnsyncQuote() {
        Opportunity opp = [SELECT Id, SyncedQuoteId FROM Opportunity LIMIT 1];
        System.assertNotEquals(null, opp.SyncedQuoteId, 'Precisa estar preenchido antes');

        Test.startTest();
        OpportunityUtils.unsyncQuote(new List<Id>{ opp.Id });
        Test.stopTest();

        Opportunity after = [SELECT SyncedQuoteId FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(null, after.SyncedQuoteId, 'Deve ter sido limpo pelo método');
    }

    @IsTest
    static void testShouldShowModal_trueForRecent() {
        // Oportunidade criada agora (simula recente >= 10/08/2025)
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Boolean result = OpportunityUtils.shouldShowModal(opp.Id);
        Test.stopTest();

        System.assertEquals(true, result, 'Recente, em Contract e não respondida → deve mostrar modal');
    }

    @IsTest
    static void testShouldShowModal_historyAllValidStages() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];

        // Cria histórico apenas com Discovery / Negotiation
        opp.StageName = 'Discovery';
        update opp;

        opp.StageName = 'Negotiation';
        update opp;

        opp.StageName = 'Contract';
        opp.Answered_Confirmation_Form__c = false;
        update opp;

        Test.startTest();
        Boolean result = OpportunityUtils.shouldShowModal(opp.Id);
        Test.stopTest();

        System.assertEquals(true, result, 'Histórico só com Discovery/Negotiation deveria permitir modal');
    }

    @IsTest
    static void testShouldShowModal_historyInvalidStage() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];

        // Cria histórico com estágio inválido
        opp.StageName = 'Discovery';
        update opp;

        opp.StageName = 'Prospecting'; // inválido para regra
        update opp;

        opp.StageName = 'Contract';
        opp.Answered_Confirmation_Form__c = false;
        update opp;

        Test.startTest();
        Boolean result = OpportunityUtils.shouldShowModal(opp.Id);
        Test.stopTest();

        System.assertEquals(true, result, 'Histórico com stages inválidos não deve mostrar modal');
    }

    @IsTest
    static void testShouldShowModal_answeredTrue() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.Answered_Confirmation_Form__c = true;
        update opp;

        Test.startTest();
        Boolean result = OpportunityUtils.shouldShowModal(opp.Id);
        Test.stopTest();

        System.assertEquals(false, result, 'Com Answered = true deve retornar false');
    }

    @IsTest
    static void testShouldShowModal_stageNotContract() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        opp.StageName = 'Prospecting';
        opp.Answered_Confirmation_Form__c = false;
        update opp;

        Test.startTest();
        Boolean result = OpportunityUtils.shouldShowModal(opp.Id);
        Test.stopTest();

        System.assertEquals(false, result, 'Stage diferente de Contract deve retornar false');
    }

    @IsTest
    static void testShouldShowModal_nullId() {
        Test.startTest();
        Boolean result = OpportunityUtils.shouldShowModal(null);
        Test.stopTest();

        System.assertEquals(false, result, 'Id nulo deve retornar false');
    }
}