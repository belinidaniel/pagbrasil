/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 08-06-2025
 * @last modified by  : Daniel Belini
**/
@isTest
public class ManageTaxesPricesControllerTest {

    @testSetup
    static void setup() {
        // Criar dados de teste para Product2
        Product2 prod = new Product2(Name = 'Produto Teste', IsActive = true);
        insert prod;

        // Criar Taxes__c
        Taxes__c tax = new Taxes__c(
            BusinessModel__c = 'Intermediation',
            UnitPrice__c = 0,
            PercentValue__c = 0,
            IsPercent__c = true,
            TaxaBaseAntecipacao__c = '1.50',
            Flexibilization__c = 'Sem Autonomia',
            AntecipationFrequency__c = 'Monthly',
            IsActive__c = true,
            TaxRegion__c = 'National',
            ProductClass__c = '5122',
            Product__c = prod.Id
        );
        insert tax;

        // Criar Pricebook2
        Pricebook2 pb = new Pricebook2(Name = 'Preços - Intermediação', IsActive = true);
        insert pb;

        // Criar Standard PricebookEntry (obrigatório para produtos customizados)
        Id standardPricebookId = Test.getStandardPricebookId();
        PricebookEntry standardEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = prod.Id,
            UnitPrice = 200,
            IsActive = true
        );
        insert standardEntry;

        // Criar PricebookEntry customizado
        PricebookEntry entry = new PricebookEntry(
            Pricebook2Id = pb.Id,
            Product2Id = prod.Id,
            UnitPrice = 200,
            IsActive = true,
            UseTaxa__c = false
        );
        insert entry;
    }

    @isTest
    static void testPicklistMethods() {
        Test.startTest();
        System.assertNotEquals(null, ManageTaxesPricesController.getBusinessModels());
        System.assertNotEquals(null, ManageTaxesPricesController.getIntegrationTypes());
        System.assertNotEquals(null, ManageTaxesPricesController.getTaxRegions());
        System.assertNotEquals(null, ManageTaxesPricesController.getProductClasses());
        System.assertNotEquals(null, ManageTaxesPricesController.getTypes());
        System.assertNotEquals(null, ManageTaxesPricesController.getStatusTaxas());
        System.assertNotEquals(null, ManageTaxesPricesController.getProcessingTypes());
        System.assertNotEquals(null, ManageTaxesPricesController.getRecordTypeNames());
        System.assertNotEquals(null, ManageTaxesPricesController.getProductNames());
        System.assertNotEquals(null, ManageTaxesPricesController.getProductOptions());
        Test.stopTest();
    }

    @isTest
    static void testGetTaxesWithFlex() {
        Product2 p = [SELECT Id FROM Product2 LIMIT 1];
        Test.startTest();
        List<Taxes__c> taxes = ManageTaxesPricesController.getTaxesWithFlex(p.Id);
        System.assert(!taxes.isEmpty(), 'Deve retornar taxas para produto válido');
        Test.stopTest();
    }

    @isTest
    static void testUpdateTaxes() {
        Taxes__c t = [SELECT Id FROM Taxes__c LIMIT 1];
        t.UnitPrice__c = 999;
        Test.startTest();
        ManageTaxesPricesController.updateTaxes(new List<Taxes__c>{ t });
        Test.stopTest();

        Taxes__c updated = [SELECT UnitPrice__c FROM Taxes__c WHERE Id = :t.Id];
        System.assertEquals(999, updated.UnitPrice__c);
    }

    @isTest
    static void testUpdatePriceEntrys() {
        PricebookEntry entry = [SELECT Id, UnitPrice FROM PricebookEntry LIMIT 1];
        Map<String, Object> fakeUpdate = new Map<String, Object>{
            'Id' => entry.Id,
            'UnitPrice' => 888
        };

        Test.startTest();
        ManageTaxesPricesController.updatePriceEntrys(new List<Object>{ fakeUpdate });
        Test.stopTest();

        PricebookEntry updated = [SELECT UnitPrice FROM PricebookEntry WHERE Id = :entry.Id];
        System.assertEquals(888, updated.UnitPrice);
    }

    @isTest
    static void testGetPricebookEntries() {
        Product2 p = [SELECT Id FROM Product2 LIMIT 1];
        Test.startTest();
        List<PricebookEntry> result = ManageTaxesPricesController.getPricebookEntries(p.Id);
        System.assert(!result.isEmpty(), 'Deve retornar entradas de pricebook');
        Test.stopTest();
    }

    @isTest
    static void testFilterTaxesWithFlex() {
        Taxes__c tax = [SELECT Product__c FROM Taxes__c LIMIT 1];
        ManageTaxesPricesController.TaxesPriceFilterDTO dto = new ManageTaxesPricesController.TaxesPriceFilterDTO();
        dto.selectedProductId = new List<String>{ tax.Product__c };
        String jsonFilter = JSON.serialize(dto);

        Test.startTest();
        String result = ManageTaxesPricesController.filterTaxesOrPrices(jsonFilter, true);
        Test.stopTest();
    }

    @isTest
    static void testFilterTaxesWithoutFlex() {
        PricebookEntry entry = [SELECT Product2Id FROM PricebookEntry LIMIT 1];
        ManageTaxesPricesController.TaxesPriceFilterDTO dto = new ManageTaxesPricesController.TaxesPriceFilterDTO();
        dto.selectedProductId = new List<String>{ entry.Product2Id };
        String jsonFilter = JSON.serialize(dto);

        Test.startTest();
        String result = ManageTaxesPricesController.filterTaxesOrPrices(jsonFilter, false);
        Test.stopTest();
    }

    @isTest
    static void testUpdatePriceEntrys_Invalid() {
        Test.startTest();
        try {
            ManageTaxesPricesController.updatePriceEntrys(new List<Object>());
        } catch (AuraHandledException e) {
        }
        Test.stopTest();
    }
}