/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 07-31-2025
 * @last modified by  : Daniel Belini
**/
public with sharing class QuoteTriggerHelper {

    
    private static final String BOLETO = 'BOLETO';
    private static final String CREDITO = 'CREDITO';
    private static final String CREDIT_CARD = 'CREDIT_CARD';
    private static final String PIX = 'PIX';
    private static final String PIX_AUTO = 'PIX_AUTO';
    private static final String DEBITO = 'DEBITO';
    private static final String INTERMEDIATION = 'Intermediation';

    public static Decimal applyDiscount(Opportunity opportunity, PricebookEntry priceBookEntry, List<String> integrations) {
        if(opportunity.IntegrationType__c != null && integrations.contains(opportunity.IntegrationType__c.toLowerCase()) && priceBookEntry.Product2.ProductCode.contains('PACOTE')){
            return 100;
        }
        return null;
    }

    public static Boolean byPassProduct(Opportunity opportunity, Product2 product) {
        if(String.isBlank(product.ProductCode)){
            return true;
        }

        // // não ignorar no cross esse produtos
        // if(new List<String>{'REFUND_CARD_ACQUIRER_PIX', 'RECURRING_PIX', 'ZERO_AUTH_CREDIT_CARD' }.contains(product.ProductCode)){
        //     return false;
        // }


        String productCode = product.ProductCode;
        List<String>  productCodHasSalesforce =  new List<String>{ 'TAXA_MIN_MANUTENCAO', 'TAXA_INSTALACAO',  'TAXA_ENCERRAMENTO' };
        List<String> integrations = new List<string>{ 'shopify','shopify with buda','shopify with yampi','shopify with cart panda','woocommerce','salesforce cc','salesforce' };

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

        if(opportunity.RecordType.DeveloperName.toLowerCase() == 'national' && !opportunity.Payout__c && product.Family == 'Payout'){
            return true;
        }

        if(productCode.contains('PACKAGE_') && opportunity.RecordType.DeveloperName.toLowerCase() != 'national'
            && (opportunity.IntegrationType__c == null || integrations.contains(opportunity.IntegrationType__c.toLowerCase()))){
            return true;
        }

        return false;
    }

    public static String getPaymentMethod(Opportunity opp) {
        return opp.nationalPaymentMethod__c != null
                ? StringUtil.removeAccents(opp.nationalPaymentMethod__c.toUpperCase())
                : '';
    }

    public static List<PricebookEntry> getPriceBookByBusinessModel(String businessModel, Boolean isCrossBoard ) {
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

    public static Boolean hasGatewayAndIntermediation(String businessModel) {
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

    public static Boolean isPlugin(String integrationType) {
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
     * @description Determines if a PricebookEntry should be skipped for a given Opportunity and Quote, based on business rules.
     * @param opportunity The Opportunity record
     * @param priceBookEntry The PricebookEntry record
     * @param quote The Quote record (optional, only needed for debug)
     * @return Boolean - true if the product should be skipped, false otherwise
     */
    public static Boolean skipIfProductCodeHasSalesforce(Opportunity opportunity, PricebookEntry priceBookEntry, Quote quote) {
        Boolean isClossBoard = opportunity.RecordType.DeveloperName.toLowerCase() == 'Crossborder'; // pode ser Crossborder ou national
        Boolean isGatewayAndIntermediation = QuoteTriggerHelper.hasGatewayAndIntermediation(opportunity.BusinessModel__c);
        Boolean isIntermediation = opportunity.BusinessModel__c == 'Intermediation';
        Boolean isGateway = opportunity.BusinessModel__c == 'Gateway';
        Boolean isPixAutomatic = priceBookEntry.Product2.ProductCode.contains('PIX_AUTO');
        Boolean isPagstreamMaintenance = priceBookEntry.Product2.ProductCode.contains('PAGSTREAM_MAINTENANCE_MINIMUM_FEE');
        Boolean isPackage = priceBookEntry.Product2.ProductCode.contains('SMS') || priceBookEntry.Product2.ProductCode.contains('EMAILS');
        Boolean isTaxaParcela2a6 = priceBookEntry.Product2.ProductCode.contains('TAXA_PARC_2A6'); //added
        Boolean isTaxaParcela7a12 = priceBookEntry.Product2.ProductCode.contains('TAXA_PARC_7A12'); //added
        Boolean isTaxaAntecipacao = priceBookEntry.Product2.ProductCode.contains('TAXA_ANTECIPACAO') || priceBookEntry.Product2.ProductCode.contains('ANTECIPATION_FEES'); //alterado
        Boolean isTaxaChargeback = priceBookEntry.Product2.ProductCode.contains('TAXA_CHARGEBACK');
        Boolean isTaxaExcessoChargeback = priceBookEntry.Product2.ProductCode.contains('TAXA_EXCESSO_CHARGEBACK'); //added
        Boolean isCarteiraDigital = priceBookEntry.Product2.ProductCode.contains('CARTEIRA_DIGITAL'); //added
        Boolean isPagshield = priceBookEntry.Product2.ProductCode.contains('CUSTO_PAGSHIELD'); // CUSTO_PAGSHIELD
        Boolean isPagshieldPremiumVar = priceBookEntry.Product2.ProductCode.contains('TAXA_VAR_PAGSHIELD') ||  priceBookEntry.Product2.ProductCode.contains('PAGSHIELD_PREMIUM_VARIABLE_FEE') ; // TAXA_VAR_PAGSHIELD
        Boolean isPagshieldPremiumFixa = priceBookEntry.Product2.ProductCode.contains('TAXA_FIX_PAGSHIELD')  ||  priceBookEntry.Product2.ProductCode.contains('PAGSHIELD_PREMIUM_FIXED_FEE'); // TAXA_FIXA_PAGSHIELD
        Boolean isPagshieldOnDemandVar = priceBookEntry.Product2.ProductCode.contains('TAXA_VARIAVEL_PAGSHIELD_ON_DEMAND'); // TAXA_VARIAVEL_PAGSHIELD_ON_DEMAND
        Boolean isPagshieldOnDemandFixa = priceBookEntry.Product2.ProductCode.contains('TAXA_FIXA_PAGSHIELD_ON_DEMAND'); // TAXA_FIXA_PAGSHIELD_ON_DEMAND
        Boolean isZeroAuth = priceBookEntry.Product2.ProductCode.contains('ZERO_AUTH_'); //added
        Boolean is3DS = priceBookEntry.Product2.ProductCode.contains('3DS_CREDIT_CARD'); //added
        Boolean isPagstreamTax = priceBookEntry.Product2.ProductCode.contains('TAXA_PAGSTREAM'); //added
        Boolean isPagstreamMin = priceBookEntry.Product2.ProductCode.contains('TAXA_MIN_PAGSTREAM'); //added
        Boolean isRemittanceFee = priceBookEntry.Product2.ProductCode.contains('REMITTANCE_FEE');
        Boolean isOnePixVariable = priceBookEntry.Product2.ProductCode.contains('ONE_PIX_VARIABLE_FEE');
        Boolean isOnePixFixed = priceBookEntry.Product2.ProductCode.contains('ONE_PIX_FIXED_FEE');
        Boolean isProcessTax = priceBookEntry.Product2.ProductCode.contains('TAXA_PAGBRASIL'); //added
        String paymentMethod = getPaymentMethod(opportunity);// pode ser Boleto Flash, Pix, CARTAO DE CREDITO, Débito Flash

        System.debug('Payment Method: ' + paymentMethod);
        // Regras para CARTAO DE CREDITO
        // Taxa adicional de parcelamento: 2 a 6 parcelas (intermediation, nacional)
        if (isTaxaParcela2a6) { //added
            if ((!(isIntermediation && opportunity.RecordType.DeveloperName.toLowerCase() == 'national')) ||  !paymentMethod.contains('CARTAO DE CREDITO')) {
                return true; //added
            }
        }
        // Taxa adicional de parcelamento: 7 a 12 parcelas (intermediation, nacional)
        if (isTaxaParcela7a12) { //added
            if ((!(isIntermediation && opportunity.RecordType.DeveloperName.toLowerCase() == 'national')) ||  !paymentMethod.contains('CARTAO DE CREDITO')) {
                return true; //added
            }
        }
        // Taxa base de antecipação (intermediation, cross e nacional)

        if (isTaxaAntecipacao) { //alterado
            if (!paymentMethod.contains('CARTAO DE CREDITO')) {
                return true; //alterado
            }
        }
        // Taxa de Chargeback (intermediation, cross e nacional)
        if (isTaxaChargeback) { //alterado
            if (!paymentMethod.contains('CARTAO DE CREDITO')) {
                return true; //alterado
            }
        }
        // Taxa adicional de excesso de Chargebacks (intermediation, cross e nacional)
        if (isTaxaExcessoChargeback) { //added
            if (!paymentMethod.contains('CARTAO DE CREDITO')) {
                return true; //added
            }
        }
        // Solução de carteira digital (flag google pay/apple pay, intermediation/gateway, cross/nacional)
        if (isCarteiraDigital) { //added
            if ((!(opportunity.GooglePay__c || opportunity.ApplePay__c) || !(isIntermediation || isGateway)) ||  !paymentMethod.contains('CARTAO DE CREDITO')) { //alterado campo
                return true; //added
            }
        }


        //TO-DO: Verificar regra pagstream
        if(isPagshield) { //added
            if ((!opportunity.PagShield__c && !opportunity.PagShield_Premium__c && !opportunity.PagShield_Premium_On_Demand__c) || !paymentMethod.contains('CARTAO DE CREDITO')) { //alterado campo
                return true; //added
            }
        }

        if(isPagshieldPremiumFixa ){
            if (!opportunity.PagShield_Premium__c || !paymentMethod.contains('CARTAO DE CREDITO')) { //alterado campo
                return true; //added
            }
        }    
        
        if(isPagshieldPremiumVar){
            if (!opportunity.PagShield_Premium__c || !paymentMethod.contains('CARTAO DE CREDITO')) { //alterado campo
                return true; //added
            }
        }    
        if(isPagshieldOnDemandFixa || isPagshieldOnDemandVar){
            if (!opportunity.PagShield_Premium_On_Demand__c || !paymentMethod.contains('CARTAO DE CREDITO')) { //alterado campo
                return true; //added
            }
        }

        if(isPixAutomatic){
            if (!opportunity.Pix_Automatico__c || !paymentMethod.contains('PIX')) { //alterado campo
                return true; //added
            }
        }


        if(isPagstreamTax || isPagstreamMin || isPagstreamMaintenance || priceBookEntry.Product2.ProductCode == 'REMITTANCE_FEE_SUPPLIERS') { //added
            if (!opportunity.UsePagstream__c || !paymentMethod.contains('CARTAO DE CREDITO')) { //alterado campo
                return true; //added
            }
        }

        if(isPackage){
            if(isPlugin(opportunity.integrationType__c) && opportunity.IntegrationType__c != 'PB Checkout'){
                return true;
            }
        }

        if(isProcessTax && isIntermediation){
            if(!isPlugin(opportunity.integrationType__c)){
                return true;
            }
        }

        if(priceBookEntry.Product2.ProductCode == 'TAXA_PAGBRASIL' && isGateway) { //added
                return true;
        }

        if(priceBookEntry.Product2.ProductCode == 'TAXA_PAGBRASIL' && isGateway && isIntermediation) { //added
            if(!isPlugin(opportunity.integrationType__c)){
                return true;
            }
        }
        
        // Zero-auth CARTAO DE CREDITO (flag zero-auth, intermediation/gateway, cross/nacional)
        if (isZeroAuth) { //added
            if (opportunity.ZeroAuthCreditCard__c == false || !paymentMethod.contains('CARTAO DE CREDITO')) {
                return true; //added
            }
        }
        // 3DS for Credit Cards (flag 3ds, intermediation/gateway, cross/nacional)
        if (is3DS) { //added
            // Não existe campo para 3DS, ajuste conforme necessário
            if(!opportunity.ThreeDSCreditCard__c || !paymentMethod.contains('CARTAO DE CREDITO') ||  isClossBoard) {
                return true; //added
            }
        }
        // Regras para Pix
        // Taxa Gateway Pix (somente se for Pix, intermediation)
        if (priceBookEntry.Product2.ProductCode.contains('GATEWAY_PIX') &&  !paymentMethod.contains('PIX')) { //added
            if (!isIntermediation) {
                return true; //added
            }
        }

        // Taxa de Reembolso via adquirente ou Pix (intermediation)
        if (priceBookEntry.Product2.ProductCode.contains('TAXA_REEMBOLSO_PIX') || priceBookEntry.Product2.ProductCode.contains('REEMBOLSO_PIX')) { //added
            if (!isIntermediation) {
                return true; //added
            }
        }

        // Outras Taxas (Dependentes de Integração)
        // Taxa de repasse de fundos para Merchant (flag Payout, intermediation, cross e nacional, diferenciação EUR/USD em cross)
        if (priceBookEntry.Product2.ProductCode.contains('REPASSE_MERCHANT')) { //ajustado
            if (!opportunity.Payout__c) {
                return true;
            }
            if (isClossBoard) {
                if (opportunity.Moeda__c == 'EUR' && !priceBookEntry.Product2.ProductCode.contains('REPASSE_MERCHANT_EUR')) {
                    return true;
                }
                if (opportunity.Moeda__c == 'USD' && !priceBookEntry.Product2.ProductCode.contains('REPASSE_MERCHANT_USD')) {
                    return true;
                }
                if (opportunity.Moeda__c != 'EUR' && opportunity.Moeda__c != 'USD') {
                    return true;
                }
            }
        }

        if (priceBookEntry.Product2.ProductCode.contains('PAYOUT_SETUP_FEE') && isClossBoard) { //ajustado
            if (!opportunity.Payout__c) {
                return true;
            }
            if (isClossBoard) {
                if (opportunity.Moeda__c == 'EUR' && !priceBookEntry.Product2.ProductCode.contains('PAYOUT_SETUP_FEE_EUR')) {
                    return true;
                }
                if (opportunity.Moeda__c == 'USD' && !priceBookEntry.Product2.ProductCode.contains('PAYOUT_SETUP_FEE_USD')) {
                    return true;
                }
                if (opportunity.Moeda__c != 'EUR' && opportunity.Moeda__c != 'USD') {
                    return true;
                }
            }
        }

        if (priceBookEntry.Product2.ProductCode.contains('AMOUNT_WITHHELD_PROVISION') && isClossBoard) { //ajustado
            if (isClossBoard) {
                if (opportunity.Moeda__c == 'EUR' && !priceBookEntry.Product2.ProductCode.contains('AMOUNT_WITHHELD_PROVISION_EUR')) {
                    return true;
                }
                if (opportunity.Moeda__c == 'USD' && !priceBookEntry.Product2.ProductCode.contains('AMOUNT_WITHHELD_PROVISION_USD')) {
                    return true;
                }
                if (opportunity.Moeda__c != 'EUR' && opportunity.Moeda__c != 'USD') {
                    return true;
                }
            }
        }

        if (priceBookEntry.Product2.ProductCode.contains('REMITTANCE_FEE') && isClossBoard && priceBookEntry.Product2.ProductCode != 'REMITTANCE_FEE_SUPPLIERS') { //ajustado
            if (isClossBoard) {
                if (opportunity.Moeda__c == 'EUR' && !priceBookEntry.Product2.ProductCode.contains('REMITTANCE_FEE_EUR')) {
                    return true;
                }
                if (opportunity.Moeda__c == 'USD' && !priceBookEntry.Product2.ProductCode.contains('REMITTANCE_FEE_USD')) {
                    return true;
                }
                if (opportunity.Moeda__c != 'EUR' && opportunity.Moeda__c != 'USD') {
                    return true;
                }
            }
        }

        if (priceBookEntry.Product2.ProductCode.startsWith('SETUP_FEE') && isClossBoard) { //ajustado
            if (isClossBoard) {
                if (opportunity.Moeda__c == 'EUR' && !priceBookEntry.Product2.ProductCode.contains('SETUP_FEE_EUR')) {
                    return true;
                }
                if (opportunity.Moeda__c == 'USD' && !priceBookEntry.Product2.ProductCode.contains('SETUP_FEE_USD')) {
                    return true;
                }
                if (opportunity.Moeda__c != 'EUR' && opportunity.Moeda__c != 'USD') {
                    return true;
                }
            }
        }

        
        if (priceBookEntry.Product2.ProductCode.contains('PAYOUT_SETUP_FEE') && !isClossBoard) { //ajustado
            if (!opportunity.Payout__c) {
                return true;
            }
        }
        // Setup Fee Payout (flag Payout, intermediation, cross e nacional)
        if ((priceBookEntry.Product2.ProductCode.contains('SETUP_FEE_PAYOUT') || priceBookEntry.Product2.ProductCode.contains('PAYOUT_SERVICE_FEE')) && (!opportunity.Payout__c || !isIntermediation)) {
            return true;
        }
        // Taxa de processamento variável só aparece se existir ProductCode correspondente
        if (priceBookEntry.Product2.ProductCode.contains('TAXA_PROCESSAMENTO_VARIAVEL')) {
            if (!(paymentMethod.contains('PIX') || paymentMethod.contains('Boleto Flash') || paymentMethod.contains('CARTAO DE CREDITO') || paymentMethod.contains('Débito Flash'))) {
                return true;
            }
        }
        // Bloqueia Recurring Pix em qualquer cenário
        if (priceBookEntry.Product2.ProductCode.contains('RECURRING_PIX')) { //added
            return true;
        }
        // Taxa de repasse merchant para cross só aparece se ProductCode correto para moeda
        if (priceBookEntry.Product2.ProductCode.contains('REPASSE_MERCHANT')) { //ajustado
            if (!opportunity.Payout__c || !isIntermediation) {
                return true;
            }
            if (isClossBoard) {
                if (opportunity.Moeda__c == 'EUR' && !priceBookEntry.Product2.ProductCode.contains('REPASSE_MERCHANT_EUR')) {
                    return true;
                }
                if (opportunity.Moeda__c == 'USD' && !priceBookEntry.Product2.ProductCode.contains('REPASSE_MERCHANT_USD')) {
                    return true;
                }
                if (opportunity.Moeda__c != 'EUR' && opportunity.Moeda__c != 'USD') {
                    return true;
                }
            }
        }

        

        // Setup Fee Payout/Payout Service Fee só aparecem se Payout__c = true
        if ((priceBookEntry.Product2.ProductCode.contains('SETUP_FEE_PAYOUT') || priceBookEntry.Product2.ProductCode.contains('PAYOUT_SERVICE_FEE')) && (!opportunity.Payout__c || !isIntermediation)) {
            return true;
        }
        // Taxa de processamento variável só aparece se existir ProductCode correspondente
        if (priceBookEntry.Product2.ProductCode.contains('TAXA_PROCESSAMENTO_VARIAVEL')) {
            if (!(paymentMethod.contains('PIX') || paymentMethod.contains('Boleto Flash') || paymentMethod.contains('CARTAO DE CREDITO') || paymentMethod.contains('Débito Flash'))) {
                return true;
            }
        }

        if(isOnePixFixed || isOnePixVariable) {
            if (!paymentMethod.contains('PIX')) {
                return true;
            }
        }
        
        return false;
    }
}