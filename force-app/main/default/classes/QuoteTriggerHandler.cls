/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 07-10-2025
 * @last modified by  : Daniel Belini
**/
public with sharing class QuoteTriggerHandler extends TriggerHandler {

    private static final String BOLETO = 'BOLETO';
    private static final String CREDITO = 'CREDITO';
    private static final String CREDIT_CARD = 'CREDIT_CARD';
    private static final String PIX = 'PIX';
    private static final String PIX_AUTO = 'PIX_AUTO';
    private static final String DEBITO = 'DEBITO';
    private static final String INTERMEDIATION = 'Intermediation';

    private List<String> productCodHasSalesforce {
        get {
            return new List<String>{ 'TAXA_MIN_MANUTENCAO', 'TAXA_INSTALACAO',  'TAXA_ENCERRAMENTO' };
        }
    }

    private List<String> integrations {
        get {
            return new List<String>{ 'shopify','shopify with buda','shopify with yampi','shopify with cart panda','woocommerce','salesforce cc','salesforce' };
        }
    }

    private static Map<String, List<Taxes__c>> taxMap {
        get{
            if(taxMap == null){
                taxMap = new Map<String, List<Taxes__c>>();

                for(Taxes__c tax : [SELECT Id, ProductClass__c, TaxRegion__c, Product__c, PercentValue__c, UnitPrice__c, RecordTypeName__c, BusinessModel__c, IntegrationType__c, ProcessingType__c, RangeFaixaInicial__c, RangeFaixaFinal__c, TicketInicial__c, TicketFinal__c, ReceitaMensalInicial__c, ReceitaMensalFinal__c, Type__c FROM Taxes__c WHERE IsActive__c = true]){
                    if(taxMap.containsKey(tax.Product__c)){
                        taxMap.get(tax.Product__c).add(tax);
                    } else {
                        taxMap.put(tax.Product__c, new List<Taxes__c>{ tax });
                    }
                }
            }

            return taxMap;
        }

        set;
    }

    private List<Quote> newQuotes;

    private Set<Id> oppIds;

    public QuoteTriggerHandler() {
        this((List<Quote>) Trigger.new, (Map<Id, Quote>) Trigger.oldMap);
    }

    public QuoteTriggerHandler( List<Quote> newQuotes, Map<Id, Quote> oldQuotes ) {
        this.newQuotes = newQuotes;

        oppIds = new Set<Id>();

        for(Quote quote : newQuotes){
            oppIds.add(quote.OpportunityId);
        }
    }

    public override void afterInsert() {
        createQuoliteItem();
    }

    public override void beforeInsert(){
        updatePriceBook();
    }

    /**
    * @description update price book
    * @author Hersilio Belini de Oliveira | 2024-11-01
    **/
    public void updatePriceBook(){
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([SELECT Id, BusinessModel__c, RecordType.DeveloperName FROM Opportunity WHERE Id IN : oppIds]);

        for(Quote quote : newQuotes){

            Opportunity opportunity = opportunityMap.get(quote.OpportunityId);

            if (opportunity == null) {
                continue;
            }
            Boolean isClossBoard = opportunity.RecordType.DeveloperName == 'Crossborder';
            Boolean isGatewayAndIntermediation = hasGatewayAndIntermediation(opportunity.BusinessModel__c);
            List<PricebookEntry> priceBookEntries = getPriceBookByBusinessModel(opportunity.BusinessModel__c, isClossBoard);
            if (priceBookEntries == null) {
                continue;
            }

            for(PricebookEntry priceBookEntry : priceBookEntries){
                if(quote.Pricebook2Id == null){
                    quote.Pricebook2Id = priceBookEntry.Pricebook2Id;
                    break;
                }
            }
        }
    }

    /**
    * @description create quote line item
    * @author Hersilio Belini de Oliveira | 2024-10-29
    **/
    public void createQuoliteItem(){

        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>(OpportunitySelector.getOpportuniesByIds(oppIds));

        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();

        for(Quote quote : newQuotes){
            Opportunity opportunity = opportunityMap.get(quote.OpportunityId);

            if(opportunity.SyncedQuoteId != null){
                quote.addError('Opportunity already has a synced quote');
                continue;
            }

            if(opportunity.BusinessModel__c == null){
                quote.addError('Business Model is required');
                continue;
            }

            if(opportunity.RecordType.DeveloperName != 'National' && opportunity.Moeda__c == null){
                quote.addError('Remittance Currency is required');
                continue;
            }

            Boolean isClossBoard = opportunity.RecordType.DeveloperName == 'Crossborder';
            Boolean isGatewayAndIntermediation = hasGatewayAndIntermediation(opportunity.BusinessModel__c);
            List<PricebookEntry> priceBookEntries = getPriceBookByBusinessModel(opportunity.BusinessModel__c, isClossBoard);

            if (priceBookEntries == null) {
                continue;
            }

            for(PricebookEntry priceBookEntry : priceBookEntries){
                if(byPassProduct(opportunity, priceBookEntry.Product2)){
                    continue;
                }
                Boolean isPixAutomatic = priceBookEntry.Product2.ProductCode.contains('PIX_AUTO');
                Boolean isPagstream = priceBookEntry.Product2.ProductCode.contains('_PAGSTREAM');
                Boolean isPackage = priceBookEntry.Product2.ProductCode.contains('SMS') || priceBookEntry.Product2.ProductCode.contains('EMAILS');
                System.debug('isPixAutomatic - ' + isPixAutomatic + ' quote.opportunity.Pix_Automatico__c ' + quote.opportunity.Pix_Automatico__c);
                
                if(opportunity.Pix_Automatico__c == false && isPixAutomatic){
                    continue;
                }

                if(opportunity.UsePagstream__c == false && isPagstream){
                    continue;
                }

                if(isPlugin(opportunity.IntegrationType__c) && isPackage){
                    continue;   
                }
                
                if(opportunity.BusinessModel__c.contains(INTERMEDIATION) && priceBookEntry.Product2.ProductCode.contains('REMITTANCE_FEE')){
                    continue;
                }

                if(opportunity.recordType.DeveloperName != 'National'){
                    Boolean isRemittanceFee = priceBookEntry.Product2.ProductCode.contains('REMITTANCE_FEE');
  
                    if(isRemittanceFee && !priceBookEntry.Product2.ProductCode.contains(opportunity.Moeda__c)){
                        continue;
                    }

                    if(!isRemittanceFee && priceBookEntry.CurrencyIsoCode__c != 'BRL' && opportunity.Moeda__c != priceBookEntry.CurrencyIsoCode__c){
                        continue;
                    }
                }
                if(priceBookEntry.UseTaxa__c){
                    addValueTaxToLineItem(priceBookEntry, opportunity, quote, quoteLineItems);
                } else {
                    Decimal discount = applyDiscount(opportunity, priceBookEntry);
                    if( quote.Pricebook2Id != priceBookEntry.Pricebook2Id ){
                    }
                    System.debug('PricebookId - ' + priceBookEntry.Pricebook2Id);
                    quoteLineItems.add(new QuoteLineItem(
                        PricebookEntryId = priceBookEntry.Id,
                        Product2Id = priceBookEntry.Product2Id,
                        Quantity = 1,
                        UnitPrice = priceBookEntry.UnitPrice,
                        PercentValue__c  = priceBookEntry.PercentValue__c,
                        QuoteId = quote.Id,
                        Discount = discount,
                        IsMain__c = true
                    ));
                }
            }
        }

        if(!quoteLineItems.isEmpty()){
            insert quoteLineItems;
        }
    }

    /**
    * @description Apply discount
    * @author Hersilio Belini de Oliveira | 2024-10-30
    * @param opportunity
    * @param priceBookEntry
    * @return Decimal
    **/
    private Decimal applyDiscount(Opportunity opportunity, PricebookEntry priceBookEntry){
        // TODO mudar para dinamico
        if(opportunity.IntegrationType__c != null && this.integrations.contains(opportunity.IntegrationType__c.toLowerCase()) && priceBookEntry.Product2.ProductCode.contains('PACOTE')){
            return 100;
        }

        return null;
    }

    /**
    * @description by pass product to include in quote line item
    * @author Hersilio Belini de Oliveira | 2024-10-29
    * @param opportunity
    * @param product
    * @return boolean
    **/
    private boolean byPassProduct(Opportunity opportunity, Product2 product){
        if(String.isBlank(product.ProductCode)){
            return true;
        }

        // não ignorar no cross esse produtos
        if(new List<String>{'REFUND_CARD_ACQUIRER_PIX', 'RECURRING_PIX', 'ZERO_AUTH_CREDIT_CARD' }.contains(product.ProductCode)){
            return false;
        }


        String productCode = product.ProductCode;

        // colocar productCodHasSalesforce em uma cumstom setting
        if(opportunity.IntegrationType__c != null &&
          ((!opportunity.IntegrationType__c.toLowerCase().contains('salesforce') && product.ProductCode.contains('_SF')) ||
           (opportunity.IntegrationType__c.toLowerCase().contains('salesforce') && productCodHasSalesforce.contains(product.ProductCode)))){
            return true;
        }

        String paymentMethod = getPaymentMethod(opportunity);

        if((productCode.contains(DEBITO) && !paymentMethod.contains(DEBITO)) ||
           (productCode.contains(PIX) && !paymentMethod.contains(PIX) && !productCode.contains(PIX_AUTO) )  ||
           (productCode.contains(CREDITO) && !paymentMethod.contains(CREDITO)) ||
           (productCode.contains(CREDIT_CARD) && !paymentMethod.contains(CREDITO)) ||
           (productCode.contains(BOLETO) && !paymentMethod.contains(BOLETO)) ){
            return true;
        }

        if(opportunity.RecordType.DeveloperName == 'National' && !opportunity.Payout__c && product.Family == 'Payout'){
            return true;
        }

        if(productCode.contains('PACKAGE_') && opportunity.RecordType.DeveloperName != 'National'
            && (opportunity.IntegrationType__c == null || !this.integrations.contains(opportunity.IntegrationType__c.toLowerCase()))){
            return true;
        }

        return false;
    }

    /**
    * @description add value tax to line item
    * @author Hersilio Belini de Oliveira | 2024-10-29
    * @param priceBookEntry
    * @param opportunity
    * @param quote
    * @param quoteLineItems
    **/
    private void addValueTaxToLineItem(PricebookEntry priceBookEntry, Opportunity opportunity, Quote quote, List<QuoteLineItem> quoteLineItems){

        List<Taxes__c> taxes = taxMap.get(priceBookEntry.Product2Id);
        Decimal percentValue = 0;
        Decimal unitPrice = 0;
        Boolean isTaxMain = false;
        Id taxId;

        String paymentMethod = getPaymentMethod(opportunity);

        for(Taxes__c tax : taxes){

       
            Boolean isTicketRange = tax.TicketInicial__c <= opportunity.AverageSalesTicket__c && (tax.TicketFinal__c >= opportunity.AverageSalesTicket__c || tax.TicketFinal__c == null);
            Boolean isInsideRange = 
                (opportunity.previs_fat_rs__c >= tax.RangeFaixaInicial__c) &&
                (opportunity.previs_fat_rs__c < tax.RangeFaixaFinal__c);
            System.System.debug('paymentMethod - ' + paymentMethod);
            switch on tax.RecordTypeName__c {
                when 'TaxaBaseAntecipacao' {

                        percentValue = tax.PercentValue__c;
                        isTaxMain = true;
                        taxId = tax.Id;
                        break;
                }
                when 'TaxaProcessamento' {
                     if(
                       ((paymentMethod.contains(BOLETO) || paymentMethod.contains(PIX) || paymentMethod.contains(CREDIT_CARD) || paymentMethod.contains(DEBITO) && tax.TaxRegion__c == 'Crossborder')) ||
                       ((paymentMethod.contains(BOLETO) || paymentMethod.contains(PIX)) && isTicketRange) ||
                       ((paymentMethod.contains(DEBITO) || paymentMethod.contains(CREDITO)) && tax.ProductClass__c.contains(opportunity.ProductClass__c))
                    ){
                        this.addOtherTaxRanges(taxes, tax, quote, priceBookEntry, quoteLineItems, opportunity);
                        break;
                    }
                }
                when 'TaxaSolucaoPagBrasil' {
                    System.debug('TaxaSolucaoPagBrasil - ' + tax.RecordTypeName__c);
                    if(opportunity.BusinessModel__c.contains('Intermediation') && (!opportunity.IntegrationType__c.toLowerCase().contains('api') ||!opportunity.IntegrationType__c.toLowerCase().contains('js'))){
                        percentValue = tax.PercentValue__c;
                        if(isInsideRange){
                            isTaxMain = true;
                        }
                        taxId = tax.Id;
                        this.addOtherTaxRanges(taxes, tax, quote, priceBookEntry, quoteLineItems, opportunity);
                        break;
                    }
                }
                when 'TaxaGateway' {
                    if(opportunity.BusinessModel__c.contains('Gateway') && (!opportunity.IntegrationType__c.toLowerCase().contains('api') ||!opportunity.IntegrationType__c.toLowerCase().contains('js'))){
                        unitPrice = tax.UnitPrice__c;
                        isTaxMain = true;
                        taxId = tax.Id;
                        break;
                    }
                }
            }
        }
        System.debug('PricebookId - ' + priceBookEntry.Pricebook2Id);
        if(isTaxMain){
            quoteLineItems.add(new QuoteLineItem(
                PricebookEntryId = priceBookEntry.Id,
                Product2Id = priceBookEntry.Product2Id,
                Quantity = 1,
                UnitPrice = unitPrice,
                PercentValue__c  = percentValue,
                QuoteId = quote.Id,
                UseTaxa__c = true,
                Tax__c = taxId,
                IsMain__c = isTaxMain
            ));
        }
    }


    private static Boolean isPlugin(String integrationType) {
        if (String.isBlank(integrationType)) return false;
        List<String> pluginTypes = new List<String>{
            'Vtex',
            'Shopify',
            'Shopify with Buda',
            'Shopify with Yampi',
            'Shopify with Cart Panda',
            'Salesforce',
            'PB Checkout'
        };
        for (String type : pluginTypes) {
            if (integrationType.contains(type)) {
                return true;
            }
        }
        return false;
    }

    /**
    * @description Add other taxes ranges
    * @author Hersilio Belini de Oliveira | 2024-10-29
    * @param taxes
    * @param tax
    * @param quote
    * @param priceBookEntry
    * @param quoteLineItems
    **/
    private void addOtherTaxRanges(List<Taxes__c> taxes, Taxes__c tax, Quote quote, PricebookEntry priceBookEntry, List<QuoteLineItem> quoteLineItems, Opportunity opportunity){
        for(Taxes__c currentTax : taxes){

            //comentei && currentTax.Id != tax.Id
            if(currentTax.RecordTypeName__c == tax.RecordTypeName__c &&
               currentTax.Product__c == tax.Product__c &&
               currentTax.TicketInicial__c == tax.TicketInicial__c &&
               currentTax.TicketFinal__c == tax.TicketFinal__c &&
               currentTax.ProductClass__c == tax.ProductClass__c &&
               currentTax.IntegrationType__c == tax.IntegrationType__c ){

                
            Boolean isInsideRange = 
                (opportunity.previs_fat_rs__c >= currentTax.RangeFaixaInicial__c) &&
                (opportunity.previs_fat_rs__c < currentTax.RangeFaixaFinal__c);

                if(currentTax.Type__c != null && currentTax.Type__c != opportunity.Recordtype.DeveloperName.toLowerCase() ){
                    continue;
                }
                    System.debug('PricebookId - ' + priceBookEntry.Pricebook2Id);
                   quoteLineItems.add(new QuoteLineItem(
                    PricebookEntryId = priceBookEntry.Id,
                    Product2Id = priceBookEntry.Product2Id,
                    Quantity = 1,
                    UnitPrice = currentTax.UnitPrice__c != null ? currentTax.UnitPrice__c : 0,
                    PercentValue__c  = currentTax.percentValue__c,
                    QuoteId = quote.Id,
                    UseTaxa__c = true,
                    IsMain__c = isInsideRange,
                    Tax__c = currentTax.Id
                ));
            }
        }
    }

    /**
    * @description get Payment Method from opportunity
    * @author Hersilio Belini de Oliveira | 2024-11-01
    * @param opp
    * @return String
    **/
    private String getPaymentMethod(Opportunity opp){
        return opp.NationalPaymentMethod__c != null
                ? StringUtil.removeAccents(opp.NationalPaymentMethod__c.toUpperCase())
                : '';
    }

    private Map<String, List<PricebookEntry>> getPriceBookMap(Boolean isCrossBoard) {
        Map<String, List<PricebookEntry>> priceBookMap = new Map<String, List<PricebookEntry>>();

        for(PricebookEntry priceBookEntry : [SELECT Id,
                                                PercentValue__c,
                                                Pricebook2Id,
                                                Pricebook2.BusinessModel__c,
                                                Product2.Name,
                                                Product2.Family,
                                                Product2.ProductCode,
                                                Product2Id,
                                                UseTaxa__c,
                                                Name,
                                                UnitPrice,
                                                CurrencyIsoCode__c
                                            FROM priceBookEntry
                                           WHERE IsActive = true
                                             AND Pricebook2.IsActive = true
                                             AND Pricebook2.IsCrossBoard__c =: isCrossBoard]){
            if(priceBookMap.containsKey(priceBookEntry.Pricebook2.BusinessModel__c)){
                priceBookMap.get(priceBookEntry.Pricebook2.BusinessModel__c).add(priceBookEntry);
            } else {
                priceBookMap.put(priceBookEntry.Pricebook2.BusinessModel__c, new List<PricebookEntry>{ priceBookEntry });
            }
        }

        return priceBookMap;
    }

        public List<priceBookEntry> getPriceBookByBusinessModel(String businessModel, Boolean isCrossBoard ) {
        Map<String, List<PricebookEntry>> priceBookMap = new Map<String, List<PricebookEntry>>();

        return [SELECT Id,
                                                PercentValue__c,
                                                Pricebook2Id,
                                                Pricebook2.BusinessModel__c,
                                                Product2.Name,
                                                Product2.Family,
                                                Product2.ProductCode,
                                                Product2Id,
                                                UseTaxa__c,
                                                Name,
                                                UnitPrice,
                                                CurrencyIsoCode__c
                                            FROM priceBookEntry
                                           WHERE IsActive = true
                                             AND Pricebook2.IsActive = true
                                             AND Pricebook2.BusinessModel__c =: businessModel 
                                             AND Pricebook2.IsCrossBoard__c =: isCrossBoard];
        }

    // Helper to check if both 'Intermediation' and 'Gateway' are present in a multi-select picklist
    private Boolean hasGatewayAndIntermediation(String businessModel) {
        if (String.isBlank(businessModel)) return false;
        List<String> values = businessModel.split(';');
        Boolean hasGateway = false;
        Boolean hasIntermediation = false;
        for (String val : values) {
            if (val.trim() == 'Gateway') hasGateway = true;
            if (val.trim() == 'Intermediation') hasIntermediation = true;
        }
        return hasGateway && hasIntermediation;
    }
}