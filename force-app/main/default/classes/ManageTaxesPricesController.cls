/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 07-26-2025
 * @last modified by  : Daniel Belini
**/
public with sharing class ManageTaxesPricesController {

    //fields to be filtered in the UI
    @AuraEnabled public String productName { get; set; }
    @AuraEnabled public String businessModel { get; set; }
    @AuraEnabled public String integrationType { get; set; }
    @AuraEnabled public String taxRegion { get; set; }
    @AuraEnabled public String productClass { get; set; }
    @AuraEnabled public String type { get; set; }
    @AuraEnabled public String statusTaxa { get; set; }
    @AuraEnabled public String processingType { get; set; }
    @AuraEnabled public String recordTypeName { get; set; }

    // Dynamic picklist methods for UI filters

    @AuraEnabled(cacheable=true)
    public static List<String> getBusinessModels() {
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Taxes__c.BusinessModel__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            values.add(entry.getValue());
        }
        values.sort();
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getIntegrationTypes() {
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Taxes__c.IntegrationType__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            values.add(entry.getValue());
        }
        values.sort();
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getTaxRegions() {
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Taxes__c.TaxRegion__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            values.add(entry.getValue());
        }
        values.sort();
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getProductClasses() {
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Taxes__c.ProductClass__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            values.add(entry.getValue());
        }
        values.sort();
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getTypes() {
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Taxes__c.Type__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            values.add(entry.getValue());
        }
        values.sort();
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getStatusTaxas() {
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Taxes__c.StatusTaxa__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            values.add(entry.getValue());
        }
        values.sort();
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getProcessingTypes() {
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Taxes__c.ProcessingType__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            values.add(entry.getValue());
        }
        values.sort();
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getRecordTypeNames() {
        List<String> values = new List<String>();
        Map<Id, Schema.RecordTypeInfo> rtMap = Taxes__c.SObjectType.getDescribe().getRecordTypeInfosById();
        for (Schema.RecordTypeInfo rtInfo : rtMap.values()) {
            if (rtInfo.isAvailable()) {
                values.add(rtInfo.getName());
            }
        }
        values.sort();
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getProductNames() {
        List<String> names = new List<String>();
        for (Product2 p : [SELECT Name FROM Product2 WHERE IsActive = true]) {
            names.add(p.Name);
        }
        names.sort();
        return names;
    }
    // Busca taxas com flexibilização para um produto específico (ou todos)
    @AuraEnabled(cacheable=true)
    public static List<Taxes__c> getTaxesWithFlex(String productId) {
        String query = 'SELECT Id, BusinessModel__c, IntegrationType__c, Product__c, UnitPrice__c, PercentValue__c, FlexHead__c, FlexBoard__c, IsPercent__c, StatusTaxa__c, TaxaBaseAntecipacao__c, ProcessingType__c, RecordTypeName__c, RangeFaixaInicial__c, RangeFaixaFinal__c, Flexibilization__c, TicketInicial__c, InstallmentNumber__c, AntecipationFrequency__c, TicketFinal__c, ReceitaMensalInicial__c, ReceitaMensalFinal__c, IsActive__c, TaxRegion__c, Can_Edit_All_Taxes__c, ProductClass__c, Type__c, IsGatewayAndIntermediation__c FROM Taxes__c WHERE Flexibilization__c = true';
        if (String.isNotBlank(productId)) {
            query += ' AND Product__c = :productId';
        }
        return Database.query(query);
    }

    // Atualiza taxas editadas
    @AuraEnabled
    public static void updateTaxes(List<Taxes__c> taxes) {
        update taxes;
    }

    @AuraEnabled
    public static void updatePriceEntrys(List<PricebookEntry> PricebookEntrys) {
        update PricebookEntrys;
    }


    // Busca PricebookEntry para um produto específico (ou todos)
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getPricebookEntries(String productId) {
        String query = 'SELECT Id, Name, Pricebook2Id, Product2Id, CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice, ProductCode, UseTaxa__c, PercentValue__c, FlexHead__c, FlexBoard__c, IsPercent__c, CurrencyIsoCode__c, Order__c, Optional__c FROM PricebookEntry';
        if (String.isNotBlank(productId)) {
            query += ' WHERE Product2Id = :productId';
        }
        return Database.query(query);
    }


    public class ProductOptionWrapper {
        @AuraEnabled public String value;
        @AuraEnabled public String label;
        public ProductOptionWrapper(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
    // Retorna opções de produtos ativos para o filtro (corrigido)
    @AuraEnabled(cacheable=true)
    public static List<ProductOptionWrapper> getProductOptions() {
        List<ProductOptionWrapper> options = new List<ProductOptionWrapper>();
        for (Product2 p : [SELECT Id, Name FROM Product2 WHERE IsActive = true]) {
            options.add(new ProductOptionWrapper(p.Id, p.Name));
        }
        return options;
    }

    public class TaxesPriceFilterDTO {
        @AuraEnabled public String isFlexible;
        @AuraEnabled public List<String> selectedBusinessModel;
        @AuraEnabled public List<String> selectedIntegrationType;
        @AuraEnabled public List<String> selectedTaxRegion;
        @AuraEnabled public String selectedProductClass;
        @AuraEnabled public List<String> selectedType;
        @AuraEnabled public List<String> selectedStatusTaxa;
        @AuraEnabled public List<String> selectedProcessingType;
        @AuraEnabled public List<String> selectedRecordTypeName;
        @AuraEnabled public List<String> selectedProductName;
        @AuraEnabled public List<String> selectedProductId;
    }

    @AuraEnabled
    public static String filterTaxesOrPrices(String filterJson, Boolean isFlex) {
        TaxesPriceFilterDTO filter = null;
        if(String.isNotBlank(filterJson) && filterJson != 'null' && filterJson != '{}' && filterJson != '""') {
            filter = (TaxesPriceFilterDTO)JSON.deserialize(filterJson, TaxesPriceFilterDTO.class);
        }
        List<SObject> result;
        String baseQuery;
        List<String> whereClauses = new List<String>();
        if (isFlex) {
            baseQuery = 'SELECT Id, BusinessModel__c, IntegrationType__c, Product__c, UnitPrice__c, PercentValue__c, FlexHead__c, FlexBoard__c, IsPercent__c, StatusTaxa__c, TaxaBaseAntecipacao__c, ProcessingType__c, RecordTypeName__c, RangeFaixaInicial__c, RangeFaixaFinal__c, Flexibilization__c, TicketInicial__c, InstallmentNumber__c, AntecipationFrequency__c, TicketFinal__c, ReceitaMensalInicial__c, ReceitaMensalFinal__c, IsActive__c, TaxRegion__c, Can_Edit_All_Taxes__c, ProductClass__c, Type__c, IsGatewayAndIntermediation__c FROM Taxes__c   WHERE Product__c != null ';
            // Business Model Exception
            if (filter.selectedBusinessModel != null && !filter.selectedBusinessModel.isEmpty()) {
                List<String> bmClauses = new List<String>();
                for (String bm : filter.selectedBusinessModel) {
                    if (bm == 'Intermediation') {
                        bmClauses.add('BusinessModel__c = \'Intermediation\'');
                    } else {
                        bmClauses.add('BusinessModel__c LIKE \'%' + bm + '%\'');
                    }
                }
                whereClauses.add('(' + String.join(bmClauses, ' OR ') + ')');
            }
            if (filter.selectedIntegrationType != null && !filter.selectedIntegrationType.isEmpty()) {
                whereClauses.add('IntegrationType__c IN :filter.selectedIntegrationType');
            }
            if (filter.selectedTaxRegion != null && !filter.selectedTaxRegion.isEmpty()) {
                whereClauses.add('TaxRegion__c IN :filter.selectedTaxRegion');
            }
            if (String.isNotBlank(filter.selectedProductClass)) {
                whereClauses.add('ProductClass__c = :filter.selectedProductClass');
            }
            if (filter.selectedType != null && !filter.selectedType.isEmpty()) {
                whereClauses.add('Type__c IN :filter.selectedType');
            }
            if (filter.selectedStatusTaxa != null && !filter.selectedStatusTaxa.isEmpty()) {
                whereClauses.add('StatusTaxa__c IN :filter.selectedStatusTaxa');
            }
            if (filter.selectedProcessingType != null && !filter.selectedProcessingType.isEmpty()) {
                whereClauses.add('ProcessingType__c IN :filter.selectedProcessingType');
            }
            if (filter.selectedRecordTypeName != null && !filter.selectedRecordTypeName.isEmpty()) {
                whereClauses.add('RecordTypeName__c IN :filter.selectedRecordTypeName');
            }
            if (filter.selectedProductName != null && !filter.selectedProductName.isEmpty()) {
                whereClauses.add('Product__r.Name IN :filter.selectedProductName');
            }
            List<String> selectedProductIds = filter?.selectedProductId;
            if (selectedProductIds != null && !selectedProductIds.isEmpty()) {
                whereClauses.add('Product__c IN :selectedProductIds');
            }
        } else {
            baseQuery = 'SELECT Id, Name, Pricebook2Id, Product2Id, CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice, ProductCode, UseTaxa__c, PercentValue__c, FlexHead__c, FlexBoard__c, IsPercent__c, CurrencyIsoCode__c, Order__c, Optional__c FROM PricebookEntry WHERE Id != null And useTaxa__c = false';
            List<String> selectedProductIds = filter?.selectedProductId;
            if (selectedProductIds != null && !selectedProductIds.isEmpty()) {
                whereClauses.add('Product2Id IN :selectedProductIds');
            }
            // Add more filters for PricebookEntry as needed, similar to above
        }

        String finalQuery = baseQuery;
        if (!whereClauses.isEmpty()) {
            if (baseQuery.contains('WHERE')) {
                finalQuery += ' AND ' + String.join(whereClauses, ' AND ');
            } else {
                finalQuery += ' WHERE ' + String.join(whereClauses, ' AND ');
            }
        }
        System.debug('FINAL QUERY: ' + finalQuery);
        List<String> selectedProductIds = filter?.selectedProductId;
        if (isFlex) {
            result = Database.query(finalQuery);
        } else {
            result = Database.query(finalQuery);
        }
        return JSON.serialize(result);
    }
}
