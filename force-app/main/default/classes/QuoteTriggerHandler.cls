/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 04-10-2025
 * @last modified by  : aydhan.passos
**/
public with sharing class QuoteTriggerHandler extends TriggerHandler {

    private static final String BOLETO = 'BOLETO';
    private static final String CREDITO = 'CREDITO';
    private static final String CREDIT_CARD = 'CREDIT_CARD';
    private static final String PIX = 'PIX';
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

                for(Taxes__c tax : [SELECT Id, ProductClass__c, TaxRegion__c, Product__c, PercentValue__c, UnitPrice__c, RecordTypeName__c, BusinessModel__c, IntegrationType__c, ProcessingType__c, RangeFaixaInicial__c, RangeFaixaFinal__c, TicketInicial__c, TicketFinal__c, ReceitaMensalInicial__c, ReceitaMensalFinal__c FROM Taxes__c WHERE IsActive__c = true]){
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

            Map<String, List<PricebookEntry>> priceBookMapNational = getPriceBookMap(false);
            Map<String, List<PricebookEntry>> priceBookMapCross = getPriceBookMap(true);

            List<PricebookEntry> priceBookEntries = opportunity.RecordType.DeveloperName == 'National'
            ? priceBookMapNational.get(opportunity.BusinessModel__c)
            : priceBookMapCross.get(opportunity.BusinessModel__c);

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

        Map<String, List<PricebookEntry>> priceBookMapNational = getPriceBookMap(false);
        Map<String, List<PricebookEntry>> priceBookMapCross = getPriceBookMap(true);

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

            List<PricebookEntry> priceBookEntries = opportunity.RecordType.DeveloperName == 'National'
                                                    ? priceBookMapNational.get(opportunity.BusinessModel__c)
                                                    : priceBookMapCross.get(opportunity.BusinessModel__c);

            if (priceBookEntries == null) {
                continue;
            }

            for(PricebookEntry priceBookEntry : priceBookEntries){

                if(byPassProduct(opportunity, priceBookEntry.Product2)){
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

        System.debug('opportunity-business_model: ' + opportunity.BusinessModel__c);

        String productCode = product.ProductCode;

        // colocar productCodHasSalesforce em uma cumstom setting
        if(opportunity.IntegrationType__c != null &&
          ((!opportunity.IntegrationType__c.toLowerCase().contains('salesforce') && product.ProductCode.contains('_SF')) ||
           (opportunity.IntegrationType__c.toLowerCase().contains('salesforce') && productCodHasSalesforce.contains(product.ProductCode)))){
            return true;
        }

        String paymentMethod = getPaymentMethod(opportunity);

        System.debug('paymentMethod: ' + paymentMethod);

        if((productCode.contains(DEBITO) && !paymentMethod.contains(DEBITO)) ||
           (productCode.contains(PIX) && !paymentMethod.contains(PIX)) ||
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
            if(tax.Product__c != priceBookEntry.Product2Id){
                continue;
            }

            Boolean isTicketRange = tax.TicketInicial__c <= opportunity.AverageSalesTicket__c && (tax.TicketFinal__c >= opportunity.AverageSalesTicket__c || tax.TicketFinal__c == null);
            Boolean isReceitaRange = tax.ReceitaMensalInicial__c <= opportunity.previs_fat_rs__c && tax.ReceitaMensalFinal__c >= opportunity.previs_fat_rs__c;

            switch on tax.RecordTypeName__c {
                when 'TaxaBaseAntecipacao' {
                    if(isReceitaRange){
                        percentValue = tax.PercentValue__c;
                        isTaxMain = true;
                        taxId = tax.Id;
                        break;
                    }
                }
                when 'TaxaProcessamento' {
                     if(isReceitaRange && (
                       ((paymentMethod.contains(BOLETO) || paymentMethod.contains(PIX) || paymentMethod.contains(CREDIT_CARD) || paymentMethod.contains(DEBITO)) && tax.TaxRegion__c == 'Crossborder') ||
                       ((paymentMethod.contains(BOLETO) || paymentMethod.contains(PIX)) && isTicketRange) ||
                       ((paymentMethod.contains(DEBITO) || paymentMethod.contains(CREDITO)) && tax.ProductClass__c == opportunity.ProductClass__c))
                    ){
                        percentValue = tax.PercentValue__c;
                        isTaxMain = true;
                        taxId = tax.Id;
                        this.addOtherTaxRanges(taxes, tax, quote, priceBookEntry, quoteLineItems);
                        break;
                    }
                }
                when 'TaxaSolucaoPagBrasil' {
                    if(isReceitaRange && (
                        opportunity.BusinessModel__c == 'Intermediation' ||
                        ((opportunity.BusinessModel__c == 'Intermediation;Gateway' || opportunity.BusinessModel__c == 'Gateway') && opportunity.IntegrationType__c != null && tax.IntegrationType__c != null && tax.IntegrationType__c.toLowerCase().contains(opportunity.IntegrationType__c.ToLowerCase())))){
                        percentValue = tax.PercentValue__c;
                        isTaxMain = true;
                        taxId = tax.Id;
                        this.addOtherTaxRanges(taxes, tax, quote, priceBookEntry, quoteLineItems);
                        break;
                    }
                }
                when 'TaxaGateway' {
                    if(isTicketRange){
                        unitPrice = tax.UnitPrice__c;
                        isTaxMain = true;
                        taxId = tax.Id;
                        break;
                    }
                }
            }
        }

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

    /**
    * @description Add other taxes ranges
    * @author Hersilio Belini de Oliveira | 2024-10-29
    * @param taxes
    * @param tax
    * @param quote
    * @param priceBookEntry
    * @param quoteLineItems
    **/
    private void addOtherTaxRanges(List<Taxes__c> taxes, Taxes__c tax, Quote quote, PricebookEntry priceBookEntry, List<QuoteLineItem> quoteLineItems){

        System.debug('tax: ' + tax);
        for(Taxes__c currentTax : taxes){

            Boolean isInsideRange = tax.RangeFaixaInicial__c >= currentTax.ReceitaMensalInicial__c || tax.RangeFaixaFinal__c >= currentTax.ReceitaMensalFinal__c;

            if(currentTax.RecordTypeName__c == tax.RecordTypeName__c &&
               currentTax.Product__c == tax.Product__c &&
               currentTax.TicketInicial__c == tax.TicketInicial__c &&
               currentTax.TicketFinal__c == tax.TicketFinal__c &&
               currentTax.ProductClass__c == tax.ProductClass__c &&
               currentTax.IntegrationType__c == tax.IntegrationType__c &&
               currentTax.Id != tax.Id &&
               isInsideRange){
                quoteLineItems.add(new QuoteLineItem(
                    PricebookEntryId = priceBookEntry.Id,
                    Product2Id = priceBookEntry.Product2Id,
                    Quantity = 1,
                    UnitPrice = currentTax.UnitPrice__c != null ? currentTax.UnitPrice__c : 0,
                    PercentValue__c  = currentTax.percentValue__c,
                    QuoteId = quote.Id,
                    UseTaxa__c = true,
                    IsMain__c = false,
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
}