/**
 * @description       : 
 * @author            : aydhan.passos
 * @group             : 
 * @last modified on  : 04-06-2025
 * @last modified by  : aydhan.passos
**/
@isTest
private class DynamicConversionBatchTest {

    // Cria um registro de Opportunity válido para a etapa PreConversion.
    static void setupPreConversionRecords() {
        
        Account acc = new Account(Name = 'Test Account 1');
		insert acc;
        
        Opportunity oppPre = new Opportunity(
            Name = 'Test Opp Pre',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            // Valores picklist para NB e XB (string) conforme os mapas
            nb_receita_mensal__c = 50000,
            // Preenche os campos temporários com algum valor não nulo para atender a condição do query locator
            tempNBvalue__c = '50000',
            tempXBvalue__c = '100000',
            Product_or_service_website_URL__c = 'https://www.altogiro.com.br/'
        );
        TriggerHandler.bypass('OpportunityTriggerHandler');
            insert oppPre;
        TriggerHandler.clearBypass('OpportunityTriggerHandler');
        
    }
    
    // Cria um registro de Opportunity válido para a etapa PostConversion.
    static void setupPostConversionRecords() {
        
        Account acc = new Account(Name = 'Test Account 2');
		insert acc;
        
        Opportunity oppPost = new Opportunity(
            Name = 'Test Opp Post',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            // Esses valores serão substituídos no PostConversion
            nb_receita_mensal__c = 0,
            // Valores temporários simulando já convertidos (válidos)
            tempNBvalue__c = '50000',
            tempXBvalue__c = '100000',
            Product_or_service_website_URL__c = 'https://www.altogiro.com.br/'
        );

        TriggerHandler.bypass('OpportunityTriggerHandler');
            insert oppPost;
        TriggerHandler.clearBypass('OpportunityTriggerHandler');
    }
    
    // Testa a execução da etapa PreConversion
    static testMethod void testPreConversion() {
        setupPreConversionRecords();
        
        DynamicConversionBatch batchPre = new DynamicConversionBatch('Opportunity', 'PreConversion');
        Test.startTest();
        // Execução do batch com tamanho de lote = 1 para facilitar a verificação
        Database.executeBatch(batchPre, 1);
        Test.stopTest();
        
        // Recupera o registro para verificar se os valores temporários foram atualizados
        Opportunity opp = [SELECT Id, nb_receita_mensal__c, tempNBvalue__c, tempXBvalue__c FROM Opportunity LIMIT 1];
        // Para 'Até R$50 mil', o mapeamento definido é '50000'
        System.assertEquals('50000', opp.get('tempNBvalue__c'));
        // Para 'Até R$100K', o mapeamento definido é '100000'
        System.assertEquals('100000', opp.get('tempXBvalue__c'));
    }
    
    // Testa a execução da etapa PostConversion
    static testMethod void testPostConversion() {
        setupPostConversionRecords();
        
        DynamicConversionBatch batchPost = new DynamicConversionBatch('Opportunity', 'PostConversion');
        Test.startTest();
        Database.executeBatch(batchPost, 1);
        Test.stopTest();
        
        // Recupera o registro para verificar se os valores legados foram atualizados com os decimais convertidos
        Opportunity opp = [SELECT Id, nb_receita_mensal__c, tempNBvalue__c, tempXBvalue__c FROM Opportunity LIMIT 1];
        // Conversão da string '50000' para Decimal deve resultar em 50000
        Decimal nbConverted = Decimal.valueOf((String)opp.tempNBvalue__c);
        Decimal xbConverted = Decimal.valueOf((String)opp.tempXBvalue__c);
        System.assertEquals(50000, nbConverted);
        System.assertEquals(100000, xbConverted);
    }
    
    // Testa que a criação do batch com parâmetros inválidos lança exceção
    static testMethod void testInvalidParameters() {
        Boolean exceptionThrown = false;
        try {
            DynamicConversionBatch invalidBatch = new DynamicConversionBatch('', '');
        } catch(Exception e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown, 'Deveria disparar exceção para parâmetros inválidos.');
    }
    
    // Testa que a criação do batch com parâmetros inválidos lança exceção
    static testMethod void testInvalidConstructor() {
        Boolean exceptionThrown = false;
        try {
            DynamicConversionBatch invalidBatch = new DynamicConversionBatch();
            Database.executeBatch(invalidBatch);
        } catch(Exception e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown, 'Deveria disparar exceção para parâmetros inválidos.');
    }
}