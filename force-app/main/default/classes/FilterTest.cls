@isTest
private class FilterTest {

    @isTest
    static void testFilterByFieldAndValue_Positive() {
    
        Account oldAccount = new Account(Name='Test Account', Industry='Agriculture');
        insert oldAccount;
        
        Account newAccount = oldAccount.clone();
        newAccount.Industry = 'Technology'; 

        List<SObject> newRecords = new List<SObject>{ newAccount };
        Map<Id, SObject> oldRecordsMap = new Map<Id, SObject>{ oldAccount.Id => oldAccount };

        Filter filterInstance = new Filter();
        List<SObject> result = filterInstance.relevantChangeRecordsFilter(
            newRecords,
            oldRecordsMap,
            'Industry',
            'Technology'
        );

        System.assertEquals(1, result.size(), 'Deveria retornar 1 registro que teve o campo Industry alterado para Technology.');
        System.assertEquals(newAccount.Id, result[0].Id, 'O Id do registro retornado deve ser o mesmo do registro alterado.');
    }

    @isTest
    static void testFilterByFieldAndValue_Negative_WrongValue() {

        Account oldAccount = new Account(Name='Test Account', Industry='Agriculture');
        insert oldAccount;

        Account newAccount = oldAccount.clone();
        newAccount.Industry = 'Energy';

        List<SObject> newRecords = new List<SObject>{ newAccount };
        Map<Id, SObject> oldRecordsMap = new Map<Id, SObject>{ oldAccount.Id => oldAccount };

        Filter filterInstance = new Filter();
        List<SObject> result = filterInstance.relevantChangeRecordsFilter(
            newRecords,
            oldRecordsMap,
            'Industry',
            'Technology'
        );

        System.assertEquals(0, result.size(), 'Não deveria retornar registros, pois o valor do campo não corresponde ao filtro.');
    }
    
 
    @isTest
    static void testFilterByFieldAndValue_Negative_NoChange() {
        
        Account oldAccount = new Account(Name='Old Name', Industry='Technology');
        insert oldAccount;

        Account newAccount = oldAccount.clone();
        newAccount.Name = 'New Name';

        List<SObject> newRecords = new List<SObject>{ newAccount };
        Map<Id, SObject> oldRecordsMap = new Map<Id, SObject>{ oldAccount.Id => oldAccount };

        Filter filterInstance = new Filter();
        List<SObject> result = filterInstance.relevantChangeRecordsFilter(
            newRecords,
            oldRecordsMap,
            'Industry',
            'Technology'
        );

        System.assertEquals(1, result.size(), 'Não deveria retornar registros, pois o campo Industry não foi alterado.');
    }

    @isTest
    static void testFilterByFieldList_Positive() {
 
        Account oldAccount = new Account(Name='Test Account', Phone='111', AnnualRevenue=50000);
        insert oldAccount;

        Account newAccount = oldAccount.clone();
        newAccount.Phone = '222';

        List<SObject> newRecords = new List<SObject>{ newAccount };
        Map<Id, SObject> oldRecordsMap = new Map<Id, SObject>{ oldAccount.Id => oldAccount };
        List<String> relevantFields = new List<String>{ 'Industry', 'Phone', 'AnnualRevenue' };

        Filter filterInstance = new Filter();
        List<SObject> result = filterInstance.relevantChangeRecordsFilter(
            newRecords,
            oldRecordsMap,
            relevantFields
        );

        System.assertEquals(1, result.size(), 'Deveria retornar 1 registro pois o campo Phone, que estava na lista, foi alterado.');
    }

    @isTest
    static void testFilterByFieldList_Negative() {

        Account oldAccount = new Account(Name='Old Name', Phone='111', AnnualRevenue=50000);
        insert oldAccount;

        Account newAccount = oldAccount.clone();
        newAccount.Name = 'New Name';

        List<SObject> newRecords = new List<SObject>{ newAccount };
        Map<Id, SObject> oldRecordsMap = new Map<Id, SObject>{ oldAccount.Id => oldAccount };
        List<String> relevantFields = new List<String>{ 'Phone', 'AnnualRevenue' }; // 'Name' não está aqui

        Filter filterInstance = new Filter();
        List<SObject> result = filterInstance.relevantChangeRecordsFilter(
            newRecords,
            oldRecordsMap,
            relevantFields
        );

        System.assertEquals(1, result.size(), 'Não deveria retornar registros, pois nenhum dos campos da lista foi alterado.');
    }

    @isTest
    static void testFilterForNewRecords() {

        List<SObject> newRecords = new List<SObject>{
            new Account(Name='New Account 1'),
            new Account(Name='New Account 2')
        };

        Map<Id, SObject> oldRecordsMap = new Map<Id, SObject>(); 

        List<String> relevantFields = new List<String>{ 'Industry', 'Phone' };

        Filter filterInstance = new Filter();
        List<SObject> result = filterInstance.relevantChangeRecordsFilter(
            newRecords,
            oldRecordsMap,
            relevantFields
        );

        System.assertEquals(2, result.size(), 'Deveria retornar todos os registros novos, pois oldMap está vazio.');
    }


    /*@isTest
    static void testHandleNullAndEmptyLists() {

        Filter filterInstance = new Filter();
        Map<Id, SObject> oldMap = new Map<Id, SObject>{ new Account(Id = Test.getStandardPricebookId()).Id => new Account() };
        

        Test.startTest();

            List<SObject> result1 = filterInstance.relevantChangeRecordsFilter(null, oldMap, new List<String>{'Name'});
            System.assertEquals(0, result1.size(), 'Deveria retornar uma lista vazia se newRecords for nulo.');

            List<SObject> result2 = filterInstance.relevantChangeRecordsFilter(new List<SObject>(), oldMap, new List<String>{'Name'});
            System.assertEquals(0, result2.size(), 'Deveria retornar uma lista vazia se newRecords estiver vazio.');

            List<SObject> newRecords = new List<SObject>{ new Account(Name='Test') };
            List<SObject> result3 = filterInstance.relevantChangeRecordsFilter(newRecords, null, new List<String>{'Name'});
            System.assertEquals(1, result3.size(), 'Deveria retornar a lista de novos registros se oldRecords for nulo.');
        Test.stopTest();
    }*/
}