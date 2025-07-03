@isTest
private class FieldMappingBatchTest {

    // Método de Setup: cria os dados de teste uma única vez.
    @testSetup
    static void makeData(){
        List<Clauses__c> testClauses = new List<Clauses__c>();
        for(Integer i = 0; i < 200; i++){
            Clauses__c clause = new Clauses__c(
                Name = 'Cláusula de Teste ' + i,
                ClauseText__c = null
            );
            testClauses.add(clause);
        }
        
        insert testClauses;
    }

    @isTest
    static void testBatchCopiesClauseNameSuccessfully() {

        String objectName = 'Clauses__c';
        String sourceField = 'Name';
        String targetField = 'ClauseText__c';

        Test.startTest();
        
        FieldMappingBatch batch = new FieldMappingBatch(objectName, sourceField, targetField);
        Database.executeBatch(batch);
        
        Test.stopTest();

        List<Clauses__c> updatedClauses = [
            SELECT Name, ClauseText__c 
            FROM Clauses__c 
            WHERE Name LIKE 'Cláusula de Teste %'
        ];

        System.assertEquals(200, updatedClauses.size(), 'O batch deveria ter processado 200 cláusulas.');

        for(Clauses__c clause : updatedClauses){
            System.assertEquals(clause.Name, clause.ClauseText__c, 
                'O valor do campo de destino (ClauseText__c) deveria ter sido atualizado com o valor do campo de origem (Name).');
        }
    }
}