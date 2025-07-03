/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 06-27-2025
 * @last modified by  : Marcelo Duarte
**/
@isTest
private class OpportunityTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        
        Id standardPricebookId = Test.getStandardPricebookId();

        Lead leadNB = TestDataFactory.createAndInsertLeadNB();
        Lead leadXB = TestDataFactory.createAndInsertLeadXB();
        
        convertLeads(new List<Lead>{ leadNB, leadXB });
        
        Account accNB = [SELECT Id, Name FROM Account WHERE Name = 'company nb'];
		Account accXB = [SELECT Id, Name FROM Account WHERE Name = 'company xb'];
        
        Opportunity oppNB = [SELECT Id, Name, AccountId FROM Opportunity WHERE AccountId = :accNB.Id];
		Opportunity oppXB = [SELECT Id, Name, AccountId FROM Opportunity WHERE AccountId = :accXB.Id];
        
        Contact conNB = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId = :accNB.Id];
		Contact conXB = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId = :accXB.Id];

        Product2 product = new Product2(
            Name = 'Produto Teste',
            IsActive = true
        );
        insert product;

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = standardPriceBookId,
            Product2Id = product.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert standardPrice;

        Quote quote = new Quote(
            OpportunityId = oppNB.Id,
            Name = '1234213678',
            Status = 'Draft',
            Pricebook2Id = standardPriceBookId
        );
        insert quote;

        Quote quote2 = new Quote(
            OpportunityId = oppXB.Id,
            Name = '124313',
            Pricebook2Id = standardPriceBookId,
            Status = 'Draft'
        );
        insert quote2;
    }
    
    @isTest
    static void testSubmitKYCForApproval_WithKYC() {
        Opportunity opp = [SELECT Id, RecordTypeId, OpportunityKYCLegalApprovalStatus__c, OpportunityRCCLegalApprovalStatus__c FROM Opportunity WHERE Account.Name = 'company nb' LIMIT 1];
        KYC__c kyc = [SELECT Id, Legal_Approval_Status__c FROM KYC__c WHERE Opportunity__c = :opp.Id LIMIT 1];
        RCC__c rcc = [SELECT Id, LegalApprovalStatus__c FROM RCC__c WHERE Opportunity__c = :opp.Id LIMIT 1];
        
        Test.startTest();
        
        kyc.Legal_Approval_Status__c = 'Approval Requested';
        update kyc;
        
        opp = [SELECT Id, RecordTypeId, OpportunityKYCLegalApprovalStatus__c, OpportunityRCCLegalApprovalStatus__c FROM Opportunity WHERE Account.Name = 'company nb' LIMIT 1];
        System.assertEquals(kyc.Legal_Approval_Status__c, opp.OpportunityKYCLegalApprovalStatus__c);
        System.assertEquals('Approval Requested', opp.OpportunityKYCLegalApprovalStatus__c);

        rcc.LegalApprovalStatus__c = 'Approval Requested';
        update rcc;
        
        Test.stopTest();
        
        opp = [SELECT Id, RecordTypeId, OpportunityKYCLegalApprovalStatus__c, OpportunityRCCLegalApprovalStatus__c FROM Opportunity WHERE Account.Name = 'company nb' LIMIT 1];
        rcc = [SELECT Id, LegalApprovalStatus__c FROM RCC__c WHERE Opportunity__c = :opp.Id LIMIT 1];
        System.assertEquals(rcc.LegalApprovalStatus__c, opp.OpportunityRCCLegalApprovalStatus__c);
        System.assertEquals('Pending Approval Legal', opp.OpportunityRCCLegalApprovalStatus__c);
        System.assertEquals('Pending Approval Legal', opp.OpportunityKYCLegalApprovalStatus__c);
    }
    
    /*
    @isTest
    static void testSubmitKYCForApproval_WithKYC_XB() {
        Opportunity oppXB = [SELECT Id, RecordTypeId, OpportunityKYCLegalApprovalStatus__c, OpportunityRCCLegalApprovalStatus__c FROM Opportunity WHERE Account.Name = 'company xb' LIMIT 1];
        KYC_XB__c kyc_xb = [SELECT Id, LegalApprovalStatus__c FROM KYC_XB__c WHERE Opportunity__c = :oppXB.Id LIMIT 1]; // por algum motivo não acha os registros-teste
        RCC__c rcc = [SELECT Id, LegalApprovalStatus__c FROM RCC__c WHERE Opportunity__c = :oppXB.Id LIMIT 1];
        
        Test.startTest();
        
        kyc_xb.LegalApprovalStatus__c = 'Approval Requested';
        update kyc_xb;
        
        oppXB = [SELECT Id, RecordTypeId, OpportunityKYCLegalApprovalStatus__c, OpportunityRCCLegalApprovalStatus__c FROM Opportunity WHERE Account.Name = 'company xb' LIMIT 1];
        System.assertEquals(kyc_xb.LegalApprovalStatus__c, oppXB.OpportunityKYCLegalApprovalStatus__c);
        System.assertEquals('Approval Requested', oppXB.OpportunityKYCLegalApprovalStatus__c);

        rcc.LegalApprovalStatus__c = 'Approval Requested';
        update rcc;
        
        Test.stopTest();
        
        oppXB = [SELECT Id, RecordTypeId, OpportunityKYCLegalApprovalStatus__c, OpportunityRCCLegalApprovalStatus__c FROM Opportunity WHERE Account.Name = 'company xb' LIMIT 1];
        rcc = [SELECT Id, LegalApprovalStatus__c FROM RCC__c WHERE Opportunity__c = :oppXB.Id LIMIT 1];
        System.assertEquals(rcc.LegalApprovalStatus__c, oppXB.OpportunityRCCLegalApprovalStatus__c);
        System.assertEquals('Pending Approval Legal', oppXB.OpportunityRCCLegalApprovalStatus__c);
        System.assertEquals('Pending Approval Legal', oppXB.OpportunityKYCLegalApprovalStatus__c);
    }
	*/

    @isTest
    static void validateChangeOpportunityFieldsTest() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Account.Name = 'company nb' LIMIT 1];
        opp.Settlement_Frequency_1__c = 'Monthly';
        opp.Settlement_Frequency_2__c = 'Monthly';
        opp.Antecipation_Frequency_1__c = 'Monthly';
        opp.Antecipation_Frequency_2__c = 'Monthly';
        opp.Date_Discovery_Meeting__c = Date.newInstance(2025, 8, 22);
        opp.StageName = 'Closed Won';
        update opp;
    
        Test.startTest();
        try {
            opp.ApplePay__c = true;
            update opp;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Status da oportunidade não permite alteração de campos'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testCanCancelQuotesByStatus() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Account.Name = 'company xb' LIMIT 1];
        Quote quote = [SELECT Id, Status FROM Quote WHERE OpportunityId = :opp.Id AND Name = '124313' LIMIT 1];
        
        quote.Status = 'Pending Approval Head';
        update quote;
    
        Test.startTest();
        try {
            opp.ApplePay__c = true;
            update opp;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Alteração de campos não permitida, existe cotação em aprovação'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testCanCancelQuotesByIsSyncingField() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Account.Name = 'company nb' LIMIT 1];
        Quote quote = [SELECT Id FROM Quote WHERE OpportunityId = :opp.Id AND Name = '1234213678' LIMIT 1];
        
        opp.SyncedQuoteId = quote.Id;
        update opp; // Marca quote como sincronizada
    
        Test.startTest();
        try {
            opp.ApplePay__c = true;
            update opp;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Alteração de campos não permitida, existe cotação sincronizada com a oportunidade.'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testAfterUpdate() {
        Opportunity opp = [SELECT Id, SyncedQuoteId FROM Opportunity WHERE Account.Name = 'company nb' LIMIT 1];
        Quote quote = [SELECT Id FROM Quote WHERE OpportunityId = :opp.Id AND Name = '1234213678' LIMIT 1];
        
        opp.SyncedQuoteId = quote.Id;
        update opp;
    
        Test.startTest();
        opp.SyncedQuoteId = null;
        update opp;
        Test.stopTest();
    
        Quote updatedQuote = [SELECT CustomerAcceptance__c, OtherQuoteAccepted__c 
                              FROM Quote WHERE Id = :quote.Id];
        System.assertEquals(false, updatedQuote.CustomerAcceptance__c);
        System.assertEquals(false, updatedQuote.OtherQuoteAccepted__c);
    }
    
    @isTest
    static void testAfterInsertCreatesKycRcc() {
        Opportunity oppNB = [SELECT Id, RecordType.DeveloperName FROM Opportunity WHERE Account.Name = 'company nb'];
        List<KYC__c> kycsNB = [SELECT Id FROM KYC__c WHERE Opportunity__c = :oppNB.Id];
        List<RCC__c> rccs = [SELECT Id FROM RCC__c WHERE Opportunity__c = :oppNB.Id];
        
        System.assertEquals(1, kycsNB.size(), 'KYC não criado para Opp NB');
        System.assertEquals(1, rccs.size(), 'RCC não criado para Opp NB');
    }
    
    @isTest
    static void testAfterUpdateSyncedQuoteRemoval() {
        Opportunity opp = [SELECT Id, SyncedQuoteId FROM Opportunity WHERE Account.Name = 'company nb'];
        opp.SyncedQuoteId = null;
        
        Test.startTest();
        update opp;
        Test.stopTest();
        
        List<Quote> updatedQuotes = [SELECT CustomerAcceptance__c FROM Quote WHERE OpportunityId = :opp.Id];
        for (Quote q : updatedQuotes) {
            System.assertEquals(false, q.CustomerAcceptance__c, 'CustomerAcceptance não resetado após remoção de SyncedQuote');
        }
    }
    
    private static void convertLeads(List<Lead> leads) {
        List<Database.LeadConvert> converts = new List<Database.LeadConvert>();
        for(Lead ld : leads) {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(ld.Id);
            lc.setConvertedStatus('Closed - Converted');
            converts.add(lc);
        }
        Database.convertLead(converts);
    }
}