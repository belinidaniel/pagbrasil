@isTest
private class OpportunityTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        
        Id standardPricebookId = Test.getStandardPricebookId();

        Account acct = new Account(
            Name = 'Conta teste',
            Filial_no_Brasil__c = 'Sim',
            Nome_Empresarial__c = 'Empresa X',
            BillingCountry = 'Brasil'
        );
        insert acct;

        List<Opportunity> opportunities = new List<Opportunity>{
            new Opportunity(
            Name = 'Opp teste',
            AccountId = acct.Id,
            StageName = 'Contact',
            CloseDate = System.today().addDays(30),
            ApplePay__c = false,
            Product_or_service_website_URL__c = 'https://www.google.com.br/',
            previs_fat_rs__c = 100,
            AverageSalesTicket__c = 100,
            BusinessModel__c = 'Intermediation',
            PaymentRecurrence__c = 'Sim',
            ProductClass__c = '5122',
            NationalPaymentMethod__c = 'Pix',
            Settlement_Frequency_1__c = 'Daily',
            Settlement_Frequency_2__c = 'Weekly',
            IntegrationType__c = 'API',
            Antecipation_Frequency_1__c = 'Daily',
            Antecipation_Frequency_2__c = 'Weekly',
            Moeda__c = 'BRL',
            Product_Type__c = 'Physical',
            Segmento__c = 'Digital'
            ),
            new Opportunity(
            Name = 'Opp teste2',
            AccountId = acct.Id,
            StageName = 'Hibernate',
            CloseDate = System.today().addDays(30),
            ApplePay__c = false,
            Product_or_service_website_URL__c = 'https://www.google.com.br/',
            previs_fat_rs__c = 100,
            AverageSalesTicket__c = 100,
            BusinessModel__c = 'Intermediation',
            PaymentRecurrence__c = 'Sim',
            ProductClass__c = '5122',
            NationalPaymentMethod__c = 'Pix',
            Settlement_Frequency_1__c = 'Daily',
            Settlement_Frequency_2__c = 'Weekly',
            IntegrationType__c = 'API',
            Antecipation_Frequency_1__c = 'Daily',
            Antecipation_Frequency_2__c = 'Weekly',
            Moeda__c = 'BRL',
            Product_Type__c = 'Physical',
            Segmento__c = 'Digital'
            ),
            new Opportunity(
            Name = 'Opp teste3',
            AccountId = acct.Id,
            StageName = 'Hibernate',
            CloseDate = System.today().addDays(30),
            ApplePay__c = false,
            Product_or_service_website_URL__c = 'https://www.google.com.br/',
            previs_fat_rs__c = 100,
            AverageSalesTicket__c = 100,
            BusinessModel__c = 'Intermediation',
            PaymentRecurrence__c = 'Sim',
            ProductClass__c = '5122',
            NationalPaymentMethod__c = 'Pix',
            Settlement_Frequency_1__c = 'Daily',
            Settlement_Frequency_2__c = 'Weekly',
            IntegrationType__c = 'API',
            Antecipation_Frequency_1__c = 'Daily',
            Antecipation_Frequency_2__c = 'Weekly',
            Moeda__c = 'BRL',
            Product_Type__c = 'Physical',
            Segmento__c = 'Digital'
            )
        };
        insert opportunities;

        Opportunity opp = opportunities[0];
        Opportunity opp2 = opportunities[1];
        Opportunity opp3 = opportunities[2];

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
            OpportunityId = opp.Id,
            Name = '1234213678',
            Status = 'Draft',
            Pricebook2Id = standardPriceBookId
        );
        insert quote;

        Quote quote2 = new Quote(
            OpportunityId = opp2.Id,
            Name = '124313',
            Pricebook2Id = standardPriceBookId,
            Status = 'Draft'
        );
        insert quote2;

        Quote quote3 = new Quote(
            OpportunityId = opp3.Id,
            Name = '12431323113',
            Pricebook2Id = standardPriceBookId,
            Status = 'Draft'
        );
        insert quote3;

    }

    @isTest
    static void validateChangeOpportunityFieldsTest() {

        Opportunity opp = [SELECT Id, Name, ApplePay__c, StageName, TierCS__c, ProductClass__c FROM Opportunity WHERE Name = 'Opp teste' LIMIT 1];

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

        Opportunity opp2 = [SELECT Id, Name, ApplePay__c, StageName FROM Opportunity WHERE Name = 'Opp teste2' LIMIT 1];
        Quote quote2 = [SELECT Id, Name, Status, IsSyncing FROM Quote WHERE Name = '124313' LIMIT 1];

        Test.startTest();
        try {
            quote2.Status = 'Pending Approval Head';
            update quote2;

            opp2.ApplePay__c = true;
            update opp2;
            
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Alteração de campos não permitida, existe cotação em aprovação'));
        }
        Test.stopTest();

    }

    @isTest
    static void testCanCancelQuotesByIsSyncingField() {

        Id standardPricebookId = Test.getStandardPricebookId();
        Opportunity opp3 = [SELECT Id, Name, ApplePay__c, StageName FROM Opportunity WHERE Name = 'Opp teste3' LIMIT 1];

        Test.startTest();
        try {

            Quote quote3 = new Quote(
                OpportunityId = opp3.Id,
                Name = '12431323113',
                Pricebook2Id = standardPriceBookId,
                Status = 'Draft'
            );
            insert quote3;

            Quote quote4 = new Quote(
                OpportunityId = opp3.Id,
                Name = '124313231132132',
                Pricebook2Id = standardPriceBookId,
                Status = 'Draft'
            );
            insert quote4;

            opp3.ApplePay__c = true;
            update opp3;
        
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Alteração de campos não permitida, existe cotação sincronizada com a oportunidade.'));
        }
        Test.stopTest();

    }

    @isTest
    static void testAfterUpdate() {
        Opportunity opp = [SELECT Id, SyncedQuoteId FROM Opportunity WHERE Name = 'Opp teste3' LIMIT 1];
        Quote quote = [SELECT Id, OpportunityId FROM Quote WHERE OpportunityId = :opp.Id LIMIT 1];

        opp.SyncedQuoteId = quote.Id;
        update opp;

        Test.startTest();
        try {
            opp.SyncedQuoteId = null;
            update opp;
            
        } catch (Exception e) {
            System.assert(false, 'No exception should be thrown during after update logic.');
        }
        Test.stopTest();

        Quote updatedDesynchronizedQuote = [SELECT Id, CustomerAcceptance__c, OtherQuoteAccepted__c FROM Quote WHERE Id = :quote.Id];
        System.assertEquals(false, updatedDesynchronizedQuote.CustomerAcceptance__c);
        System.assertEquals(false, updatedDesynchronizedQuote.OtherQuoteAccepted__c);
    }
}