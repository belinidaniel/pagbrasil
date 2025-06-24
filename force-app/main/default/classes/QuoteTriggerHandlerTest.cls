/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 05-27-2025
 * @last modified by  : Daniel Belini
**/
@isTest
public class QuoteTriggerHandlerTest {

    static Pricebook2 testPriceBook;
    static Pricebook2 testPriceBookCross;
    static Id standardPricebookId;

    @testSetup
    static void setupData() {
        // Armazena o ID do Standard Price Book
        standardPricebookId = Test.getStandardPricebookId();

        // Criar Pricebook customizado
        testPriceBook = new Pricebook2(Name = 'Test Pricebook', BusinessModel__c = 'Intermediation', IsActive = true);
        insert testPriceBook;

        testPriceBookCross = new Pricebook2(Name = 'Test Pricebook Cross', BusinessModel__c = 'Intermediation', IsActive = true, IsCrossBoard__c = true);
        insert testPriceBookCross;

        // Criar produtos
        Product2 product1 = new Product2(Name = 'Product CREDITO', ProductCode = 'CREDITO', IsActive = true);
        Product2 product2 = new Product2(Name = 'Product PACOTE', ProductCode = 'PACOTE', IsActive = true);
        Product2 product3 = new Product2(Name = 'Product BOLETO', ProductCode = 'PIX', IsActive = true);
        Product2 product4 = new Product2(Name = 'Product PACOTE', ProductCode = 'PACOTE', IsActive = true);
        Product2 product5 = new Product2(Name = 'Product PACOTE', ProductCode = 'PACOTE', IsActive = true);
        Product2 product6 = new Product2(Name = 'Product PACOTE', ProductCode = 'PACOTE', IsActive = true, Family = 'Payout');
        Product2 product7 = new Product2(Name = 'Product PACKAGE_', ProductCode = 'PACKAGE_', IsActive = true);

        insert new List<Product2>{ product1, product2, product3, product4, product5, product6, product7 };

        // Criar entradas no Standard Price Book para produtos
        PricebookEntry standardPriceBookEntry1 = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product1.Id,
            UnitPrice = 100.00,
            IsActive = true, // Garantir que está ativo para visibilidade
            UseTaxa__c = true
        );
        PricebookEntry standardPriceBookEntry2 = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product2.Id,
            UnitPrice = 200.00,
            UseTaxa__c = true,
            IsActive = true
        );
        PricebookEntry standardPriceBookEntry3 = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product3.Id,
            UnitPrice = 300.00,
            UseTaxa__c = true,
            IsActive = true
        );
        PricebookEntry standardPriceBookEntry4 = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product4.Id,
            UnitPrice = 400.00,
            UseTaxa__c = true,
            IsActive = true
        );
        PricebookEntry standardPriceBookEntry5 = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product5.Id,
            UnitPrice = 500.00,
            IsActive = true,
            UseTaxa__c = false
        );
        PricebookEntry standardPriceBookEntry6 = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product6.Id,
            UnitPrice = 600.00,
            IsActive = true,
            UseTaxa__c = false
        );
        PricebookEntry standardPriceBookEntry7 = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product7.Id,
            UnitPrice = 700.00,
            IsActive = true,
            UseTaxa__c = false
        );
        insert new List<PricebookEntry>{ standardPriceBookEntry1, standardPriceBookEntry2, standardPriceBookEntry3, standardPriceBookEntry4, standardPriceBookEntry5,
        standardPriceBookEntry6, standardPriceBookEntry7 };

            PricebookEntry priceBookEntry1 = new PricebookEntry(
                Pricebook2Id = testPriceBook.Id,
                Product2Id = product1.Id,
                UnitPrice = 100.00,
                IsActive = true,
                UseTaxa__c = true
            );
        PricebookEntry priceBookEntry2 = new PricebookEntry(
            Pricebook2Id = testPriceBook.Id,
            Product2Id = product2.Id,
            UnitPrice = 100.00,
            IsActive = true,
            UseTaxa__c = true
        );
        PricebookEntry priceBookEntry3 = new PricebookEntry(
            Pricebook2Id = testPriceBook.Id,
            Product2Id = product3.Id,
            UnitPrice = 200.00,
            IsActive = true,
            UseTaxa__c = true
        );
        PricebookEntry priceBookEntry4 = new PricebookEntry(
            Pricebook2Id = testPriceBook.Id,
            Product2Id = product4.Id,
            UnitPrice = 200.00,
            IsActive = true,
            UseTaxa__c = true
        );
        PricebookEntry priceBookEntry5 = new PricebookEntry(
            Pricebook2Id = testPriceBook.Id,
            Product2Id = product5.Id,
            UnitPrice = 200.00,
            IsActive = true,
            UseTaxa__c = false
        );
        PricebookEntry priceBookEntry6 = new PricebookEntry(
            Pricebook2Id = testPriceBook.Id,
            Product2Id = product6.Id,
            UnitPrice = 200.00,
            IsActive = true,
            UseTaxa__c = false
        );
        PricebookEntry priceBookEntry7 = new PricebookEntry(
            Pricebook2Id = testPriceBookCross.Id,
            CurrencyIsoCode__c = 'EUR',
            Product2Id = product7.Id,
            UnitPrice = 200.00,
            IsActive = true,
            UseTaxa__c = true
        );

        insert new List<PricebookEntry>{ priceBookEntry1, priceBookEntry2,priceBookEntry3, priceBookEntry4, priceBookEntry5, priceBookEntry6,
            priceBookEntry7};

        Id TaxaGatewayId = Schema.SObjectType.Taxes__c.getRecordTypeInfosByDeveloperName().get('TaxaGateway').getRecordTypeId();
        Id TaxaBaseAntecipacaoId = Schema.SObjectType.Taxes__c.getRecordTypeInfosByDeveloperName().get('TaxaBaseAntecipacao').getRecordTypeId();
        Id TaxaProcessamentoId = Schema.SObjectType.Taxes__c.getRecordTypeInfosByDeveloperName().get('TaxaProcessamento').getRecordTypeId();
        Id TaxaSolucaoPagBrasilId = Schema.SObjectType.Taxes__c.getRecordTypeInfosByDeveloperName().get('TaxaSolucaoPagBrasil').getRecordTypeId();

        List<Taxes__c> taxesList = new List<Taxes__c>{
            new Taxes__c(
                Product__c = product2.Id,
                RecordTypeId = TaxaBaseAntecipacaoId,
                PercentValue__c = 5,
                ReceitaMensalInicial__c = 0,
                RangeFaixaInicial__c = 5000,
                ReceitaMensalFinal__c = 15000,
                TicketInicial__c = 0,
                TicketFinal__c = 20000,
                IsActive__c = true
            ),
                new Taxes__c(
                    Product__c = product3.Id,
                    RecordTypeId = TaxaProcessamentoId,
                    PercentValue__c = 10,
                    ReceitaMensalInicial__c = 5000,
                    RangeFaixaInicial__c = 5000,
                    ReceitaMensalFinal__c = 10000,
                    TicketInicial__c = 0,
                    TicketFinal__c = 20000,
                    ProductClass__c = '5331',
                    IsActive__c = true
                ),
                new Taxes__c(
                    Product__c = product4.Id,
                    RecordTypeId = TaxaSolucaoPagBrasilId,
                    PercentValue__c = 7,
                    IntegrationType__c = 'API',
                    ReceitaMensalInicial__c = 0,
                    RangeFaixaInicial__c = 5000,
                    ReceitaMensalFinal__c = 5000,
                    IsActive__c = true
                ),
                new Taxes__c(
                    Product__c = product1.Id,
                    RecordTypeId = TaxaGatewayId,
                    UnitPrice__c = 100,
                    PercentValue__c = 10,
                    TicketInicial__c = 10000,
                    ReceitaMensalInicial__c = 0,
                    RangeFaixaInicial__c = 5000,
                    TicketFinal__c = 20000,
                    ReceitaMensalFinal__c = 10000,
                    IsActive__c = true
                ),
                new Taxes__c(
                    Product__c = product5.Id,
                    RecordTypeId = TaxaProcessamentoId,
                    UnitPrice__c = 100,
                    TicketInicial__c = 10000,
                    ReceitaMensalInicial__c = 0,
                    RangeFaixaInicial__c = 5000,
                    TicketFinal__c = 20000,
                    ReceitaMensalFinal__c = 10000,
                    ProductClass__c = '5331',
                    IsActive__c = true
                ),
                new Taxes__c(
                    Product__c = product6.Id,
                    RecordTypeId = TaxaProcessamentoId,
                    UnitPrice__c = 200,
                    TicketInicial__c = 10000,
                    ReceitaMensalInicial__c = 0,
                    RangeFaixaInicial__c = 5000,
                    TicketFinal__c = 20000,
                    ReceitaMensalFinal__c = 10000,
                    IsActive__c = true
                ),
                new Taxes__c(
                    Product__c = product6.Id,
                    RecordTypeId = TaxaProcessamentoId,
                    UnitPrice__c = 200,
                    TicketInicial__c = 10000,
                    ReceitaMensalInicial__c = 0,
                    RangeFaixaInicial__c = 5000,
                    TicketFinal__c = 20000,
                    ReceitaMensalFinal__c = 10000,
                    IsActive__c = true
                )
                };
                    insert taxesList;
    }

    @isTest
    static void testUpdatePriceBook() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Pix',
            Product_or_service_website_URL__c = 'www.site.com',
            Transacoes_Mensais__c = 4,
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'Salesforce CC',
            Recorrencia__c = 'Yes',
            Ticket_Medio__c = 123
        );
        insert opp;

        Quote quote = new Quote(
            OpportunityId = opp.Id,
            Name = 'Test Quote',
            Pricebook2Id = null
        );
        insert quote;

        Opportunity opp2 = new Opportunity(
            Name = 'Test Opportunity2',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = '',
            Product_or_service_website_URL__c = 'www.site.com',
            AverageSalesTicket__c = 10000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'Salesforce CC',
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123
        );
        insert opp2;

        Quote quote2 = new Quote(
            OpportunityId = opp.Id,
            Name = 'Test Quote2',
            Pricebook2Id = null
        );
        insert quote2;

        Test.startTest();
        QuoteTriggerHandler handler = new QuoteTriggerHandler(new List<Quote>{quote}, null);
        handler.beforeInsert();
        Test.stopTest();

        quote = [SELECT Pricebook2Id FROM Quote WHERE Id = :quote.Id];
        System.assertNotEquals(null, quote.Pricebook2Id, 'O Pricebook2Id deve ter sido definido.');
    }

    @isTest
    static void testCreateQuoliteItem() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity with QuoteLineItems',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'www.site.com',
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'API',
            IntegrationType__c = 'Salesforce',
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123
        );
        insert opp;

        Quote quote = new Quote(
            OpportunityId = opp.Id,
            Name = 'Test Quote with Items',
            Pricebook2Id = standardPricebookId

        );
        insert quote;

        Test.startTest();
        QuoteTriggerHandler handler = new QuoteTriggerHandler(new List<Quote>{quote}, null);
        handler.afterInsert();
        Test.stopTest();

        List<QuoteLineItem> quoteLineItems = [SELECT Id, Product2Id, Quantity, UnitPrice, QuoteId FROM QuoteLineItem WHERE QuoteId = :quote.Id];
        System.assert(quoteLineItems.size() > 0, 'QuoteLineItems devem ter sido criados.');
        System.assertEquals(1, quoteLineItems[0].Quantity, 'A quantidade do QuoteLineItem deve ser 1.');
        System.assertEquals(100, quoteLineItems[0].UnitPrice, 'O preço unitário do QuoteLineItem deve ser conforme o PricebookEntry.');
    }

    @isTest
    static void testWithoutBusiness() {

        // Id recordTypeIdNational = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId(); está dando erro na org

        Opportunity oppWithoutBusinessModel = new Opportunity(
            Name = 'Test Opportunity 1',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = '',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'www.site.com',
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'API',
            IntegrationType__c = 'Salesforce',
            // RecordTypeId = recordTypeIdNational,
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123
        );

        insert oppWithoutBusinessModel;

        Quote quote1 = new Quote(OpportunityId = oppWithoutBusinessModel.Id, Name = 'Test Quote 1');

        Test.startTest();

        try {

            insert quote1;

            QuoteTriggerHandler handler = new QuoteTriggerHandler(new List<Quote>{quote1}, null);
            handler.afterInsert();

            System.assert(false, 'A validação deveria ter lançado uma exceção, mas não lançou.');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Business Model is required'), 'Erro esperado para Business Model não foi capturado.');
        }

        Test.stopTest();
    }

    @isTest
    static void testWithoutCurrency() {

        Id recordTypeIdCross = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Crossborder').getRecordTypeId();

        Opportunity oppWithoutCurrency = new Opportunity(
            Name = 'Test Opportunity 2',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'www.site.com',
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'API',
            IntegrationType__c = 'Salesforce',
            RecordTypeId = recordTypeIdCross,
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123
        );

        insert oppWithoutCurrency;

        Quote quote2 = new Quote(OpportunityId = oppWithoutCurrency.Id, Name = 'Test Quote 2');

        Test.startTest();

        try {

            insert quote2;

            QuoteTriggerHandler handler = new QuoteTriggerHandler(new List<Quote>{quote2}, null);
            handler.afterInsert();

            System.assert(false, 'A validação deveria ter lançado uma exceção, mas não lançou.');
        } catch (Exception e) {

            System.assert(e.getMessage().contains('Remittance Currency is required'), 'Erro esperado para Remittance Currency não foi capturado.');
        }

        Test.stopTest();
    }

    @isTest
    static void testCurrencyIsoCode() {

        Id recordTypeIdCross = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Crossborder').getRecordTypeId();

        Opportunity oppWithoutCurrency = new Opportunity(
            Name = 'Test Opportunity 2',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'www.site.com',
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'API',
            IntegrationType__c = 'Salesforce',
            Moeda__C = 'USD',
            RecordTypeId = recordTypeIdCross,
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123
        );

        insert oppWithoutCurrency;

        Quote quote2 = new Quote(
            OpportunityId = oppWithoutCurrency.Id,
            Name = 'Test Quote 2',
            Pricebook2Id = standardPricebookId
        );

        Test.startTest();
            insert quote2;
            QuoteTriggerHandler handler = new QuoteTriggerHandler(new List<Quote>{quote2}, null);
            handler.afterInsert();
        Test.stopTest();
    }
}