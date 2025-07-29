/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 07-28-2025
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
        String query = 'SELECT Id, BusinessModel__c, IntegrationType__c, Product__c, UnitPrice__c, PercentValue__c, FlexHead__c, FlexBoard__c, IsPercent__c, StatusTaxa__c, TaxaBaseAntecipacao__c, ProcessingType__c, RecordTypeName__c, RangeFaixaInicial__c, RangeFaixaFinal__c, Flexibilization__c, TicketInicial__c, InstallmentNumber__c, AntecipationFrequency__c, TicketFinal__c, ReceitaMensalInicial__c, ReceitaMensalFinal__c, IsActive__c, TaxRegion__c, Can_Edit_All_Taxes__c, ProductClass__c, Type__c, IsGatewayAndIntermediation__c FROM Taxes__c WHERE Product__c != null ';
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
    public static void updatePriceEntrys(List<Object> taxes) {
        if (taxes == null || taxes.isEmpty()) {
            throw new AuraHandledException('Input taxes is null or empty');
        }
        Map<String, Schema.SObjectField> fieldMap = PricebookEntry.SObjectType.getDescribe().fields.getMap();
        List<PricebookEntry> entriesToUpdate = new List<PricebookEntry>();
        for (Object o : taxes) {
            if (o == null) continue;
            Map<String, Object> row = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(o));
            if (row != null && row.containsKey('Id')) {
                PricebookEntry pbe = new PricebookEntry();
                for (String key : row.keySet()) {
                    if (key == 'attributes') continue;
                    if (!fieldMap.containsKey(key)) continue; // skip unknown fields
                    Object value = row.get(key);
                    System.debug('Processing key: ' + key + ', value: ' + value);
                    System.debug('Field type: ' + fieldMap.get(key).getDescribe().getType());

                    Schema.DisplayType dtype = fieldMap.get(key).getDescribe().getType();
                    if (value == null) {
                        pbe.put(key, null);
                    } else if (dtype == Schema.DisplayType.DOUBLE || dtype == Schema.DisplayType.CURRENCY || dtype == Schema.DisplayType.PERCENT) {
                        pbe.put(key, Decimal.valueOf(String.valueOf(value)));
                    } else if (dtype == Schema.DisplayType.INTEGER) {
                        pbe.put(key, Integer.valueOf(String.valueOf(value)));
                    } else if (dtype == Schema.DisplayType.BOOLEAN) {
                        pbe.put(key, (value instanceof Boolean) ? (Boolean)value : (String.valueOf(value).toLowerCase() == 'true'));
                    } else {
                        pbe.put(key, value);
                    }
                }
                entriesToUpdate.add(pbe);
            }
        }
        if (entriesToUpdate.isEmpty()) {
            throw new AuraHandledException('No valid entries to update');
        }
        update entriesToUpdate;
    }


    // Busca PricebookEntry para um produto específico (ou todos)
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getPricebookEntries(String productId) {
        String query = 'SELECT Id, Name, Pricebook2Id, Pricebook2.Name, Product2Id, CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice, ProductCode, UseTaxa__c, PercentValue__c, FlexHead__c, FlexBoard__c, IsPercent__c, CurrencyIsoCode__c, Order__c, Optional__c FROM PricebookEntry WHERE Pricebook2.Name IN (\'Preços - Intermediação + Gateway\', \'Preços - Gateway\', \'Preços - Intermediação\', \'Preços - Intermediação Cross\') ';
        if (String.isNotBlank(productId)) {
            query += ' AND Product2Id = :productId';
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
        @AuraEnabled public List<String> selectedProductClass;
        @AuraEnabled public List<String> selectedType;
        @AuraEnabled public List<String> selectedStatusTaxa;
        @AuraEnabled public List<String> selectedProcessingType;
        @AuraEnabled public List<String> selectedRecordTypeName;
        @AuraEnabled public List<String> selectedProductName;
        @AuraEnabled public List<String> selectedProductId;
        // Added for filters without flexibilização
        @AuraEnabled public Boolean isPercent;
        @AuraEnabled public Boolean isActive;
        @AuraEnabled public List<String> selectedPricebook2Name;
        @AuraEnabled public List<String> selectedProduct2Name;
        @AuraEnabled public String unitPrice;
        @AuraEnabled public String percentValue;
        @AuraEnabled public String order;
    }

    @AuraEnabled
    public static String filterTaxesOrPrices(String filterJson, Boolean isFlex) {
        if (isFlex) {
            return filterTaxesWithFlex(filterJson);
        } else {
            return filterTaxesWithoutFlex(filterJson);
        }
    }

    // Filtering with flexibilization
    @AuraEnabled
    public static String filterTaxesWithFlex(String filterJson) {
        TaxesPriceFilterDTO filter = null;
        if(String.isNotBlank(filterJson) && filterJson != 'null' && filterJson != '{}' && filterJson != '""') {
            filter = (TaxesPriceFilterDTO)JSON.deserialize(filterJson, TaxesPriceFilterDTO.class);
        }
        
        String baseQuery = 'SELECT Id, Name, BusinessModel__c, IntegrationType__c, Product__c, Product__r.Name, UnitPrice__c, PercentValue__c, FlexHead__c, FlexBoard__c, IsPercent__c, StatusTaxa__c, TaxaBaseAntecipacao__c, ProcessingType__c, RecordTypeName__c, RangeFaixaInicial__c, RangeFaixaFinal__c, Flexibilization__c, TicketInicial__c, InstallmentNumber__c, AntecipationFrequency__c, TicketFinal__c, ReceitaMensalInicial__c, ReceitaMensalFinal__c, IsActive__c, TaxRegion__c, Can_Edit_All_Taxes__c, ProductClass__c, Type__c, IsGatewayAndIntermediation__c FROM Taxes__c WHERE Product__c != null ';
        List<String> whereClauses = new List<String>();

        if (filter != null) {
            // Business Model Exception
            if (filter.selectedBusinessModel != null && !filter.selectedBusinessModel.isEmpty()) {
                List<String> bmClauses = new List<String>();
                for (String bm : filter.selectedBusinessModel) {
                    if (bm == 'Intermediation') {
                        bmClauses.add('BusinessModel__c = \'Intermediation\'');
                    } else {
                        bmClauses.add('BusinessModel__c LIKE \'%' + String.escapeSingleQuotes(bm) + '%\'');
                    }
                }
                whereClauses.add('(' + String.join(bmClauses, ' OR ') + ')');
            }
            if (filter.selectedIntegrationType != null && !filter.selectedIntegrationType.isEmpty()) {
                whereClauses.add('IntegrationType__c IN :selectedIntegrationType');
            }
            if (filter.selectedTaxRegion != null && !filter.selectedTaxRegion.isEmpty()) {
                whereClauses.add('TaxRegion__c IN :selectedTaxRegion');
            }
            if (filter.selectedProductClass != null && !filter.selectedProductClass.isEmpty()) {
                whereClauses.add('ProductClass__c IN :selectedProductClass');
            }
            if (filter.selectedType != null && !filter.selectedType.isEmpty()) {
                whereClauses.add('Type__c IN :selectedType');
            }
            if (filter.selectedStatusTaxa != null && !filter.selectedStatusTaxa.isEmpty()) {
                whereClauses.add('StatusTaxa__c IN :selectedStatusTaxa');
            }
            if (filter.selectedProcessingType != null && !filter.selectedProcessingType.isEmpty()) {
                whereClauses.add('ProcessingType__c IN :selectedProcessingType');
            }
            if (filter.selectedRecordTypeName != null && !filter.selectedRecordTypeName.isEmpty()) {
                whereClauses.add('RecordTypeName__c IN :selectedRecordTypeName');
            }
            if (filter.selectedProductName != null && !filter.selectedProductName.isEmpty()) {
                whereClauses.add('Product__r.Name IN :selectedProductName');
            }
            if (filter.selectedProductId != null && !filter.selectedProductId.isEmpty()) {
                whereClauses.add('Product__c IN :selectedProductId');
            }
            if(filter.isPercent != null) {
                whereClauses.add('IsPercent__c = ' + (filter.isPercent ? 'true' : 'false'));
            }
            if(filter.isActive != null) {
                whereClauses.add('IsActive__c = ' + (filter.isActive ? 'true' : 'false'));
            }
        }

        String finalQuery = baseQuery;
        if (!whereClauses.isEmpty()) {
            finalQuery += ' AND ' + String.join(whereClauses, ' AND ');
        }
        finalQuery += ' ORDER BY Product__r.Name, Name';
        System.debug('FINAL QUERY FLEX: ' + finalQuery);

        try {
            // Assign filter values to local variables for binding
            List<String> selectedIntegrationType = filter?.selectedIntegrationType;
            List<String> selectedTaxRegion = filter?.selectedTaxRegion;
            List<String> selectedProductClass = filter?.selectedProductClass;
            List<String> selectedType = filter?.selectedType;
            List<String> selectedStatusTaxa = filter?.selectedStatusTaxa;
            List<String> selectedProcessingType = filter?.selectedProcessingType;
            List<String> selectedRecordTypeName = filter?.selectedRecordTypeName;
            List<String> selectedProductName = filter?.selectedProductName;
            List<String> selectedProductId = filter?.selectedProductId;

            List<SObject> result = Database.query(finalQuery);
            return JSON.serialize(result);
        } catch (Exception e) {
            System.debug('Query failed: ' + e.getMessage());
            throw new AuraHandledException('Query failed: ' + e.getMessage());
        }
    }

    // Filtering without flexibilization
    @AuraEnabled
    public static String filterTaxesWithoutFlex(String filterJson) {
        TaxesPriceFilterDTO filter = null;
        if(String.isNotBlank(filterJson) && filterJson != 'null' && filterJson != '{}' && filterJson != '""') {
            filter = (TaxesPriceFilterDTO)JSON.deserialize(filterJson, TaxesPriceFilterDTO.class);
        }
        List<SObject> result;
        String baseQuery = 'SELECT Id, Name, Pricebook2Id, Pricebook2.Name, Product2Id, Product2.Name, CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice, ProductCode, UseTaxa__c, PercentValue__c, FlexHead__c, FlexBoard__c, IsPercent__c, CurrencyIsoCode__c, Order__c, Optional__c FROM PricebookEntry WHERE Id != null AND UseTaxa__c = false AND Pricebook2.Name IN (\'Preços - Intermediação + Gateway\', \'Preços - Gateway\', \'Preços - Intermediação\', \'Preços - Intermediação Cross\') ';
        List<String> whereClauses = new List<String>();
        // Only add filters for the fields present in the UI/datatable
        if (filter != null) {
            List<String> selectedProductIds = filter?.selectedProductId;
            // Product2Id
            if (filter.selectedProductId != null && !filter.selectedProductId.isEmpty()) {
                whereClauses.add('Product2Id IN :selectedProductIds');
            } else if (filter.selectedProduct2Name != null && !filter.selectedProduct2Name.isEmpty()) {
                // Product2.Name
                whereClauses.add('Product2.Name IN :filter.selectedProduct2Name');
            }
            // IsPercent__c (expecting a single value: true/false)
            if (filter.isPercent != null) {
                whereClauses.add('IsPercent__c = ' + (filter.isPercent ? 'true' : 'false'));
            }
            // IsActive (expecting a single value: true/false)
            if (filter.isActive != null) {
                whereClauses.add('IsActive = ' + (filter.isActive ? 'true' : 'false'));
            }
            // Pricebook2.Name
            if (filter.selectedPricebook2Name != null && !filter.selectedPricebook2Name.isEmpty()) {
                whereClauses.add('Pricebook2.Name IN :filter.selectedPricebook2Name');
            }
            if (filter.selectedType != null && !filter.selectedType.isEmpty()) {
                // Type__c (expecting values: 'Cross', 'Nacional', or both)
                List<String> typeFilters = filter.selectedType;
                List<String> pbNames = new List<String>();
                if (typeFilters.contains('crossborder')) {
                    pbNames.add('Preços - Intermediação Cross');
                }
                if (typeFilters.contains('national')) {
                    pbNames.add('Preços - Intermediação');
                    pbNames.add('Preços - Gateway');
                    pbNames.add('Preços - Intermediação + Gateway');
                }
                if (!pbNames.isEmpty()) {
                    whereClauses.add('Pricebook2.Name IN :pbNames');
                }
            }

            if(filter.selectedBusinessModel != null && !filter.selectedBusinessModel.isEmpty()) {
                List<String> bmClauses = new List<String>();
                for (String bm : filter.selectedBusinessModel) {
                    if (bm == 'Intermediation' && (filter.selectedType.contains('crossborder') || filter.selectedType.isEmpty())) {
                        bmClauses.add('Preços - Intermediação Cross');
                    } 
                    if (bm == 'Gateway' && ( filter.selectedType.contains('national') || filter.selectedType.isEmpty())) {
                        bmClauses.add('Preços - Gateway');
                        bmClauses.add('Preços - Intermediação + Gateway');
                    } 
                    if (bm == 'Intermediation' && (filter.selectedType.contains('national') || filter.selectedType.isEmpty())) {
                        bmClauses.add('Preços - Intermediação');
                        bmClauses.add('Preços - Intermediação + Gateway');
                    } 
                }
                    whereClauses.add('Pricebook2.Name IN :bmClauses');
            }

            // if(filter.selectedRecordTypeName != null && !filter.selectedRecordTypeName.isEmpty()) {
            //     // RecordTypeName__c
            //     whereClauses.add('recordtype.developerName IN :filter.selectedRecordTypeName');
            // }
        }

        String finalQuery = baseQuery;

        if (!whereClauses.isEmpty()) {  
            finalQuery += ' AND ' + String.join(whereClauses, ' AND ');
        }
        finalQuery += ' ORDER BY Pricebook2.Name, Product2.Name';
        System.debug('FINAL QUERY NO FLEX: ' + finalQuery);
        result = Database.query(finalQuery);
        return JSON.serialize(result);
    }
}