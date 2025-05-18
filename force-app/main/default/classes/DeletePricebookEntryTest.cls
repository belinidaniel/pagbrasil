@isTest
private class DeletePricebookEntryTest {
    @isTest
    static void testDeleteEntries() {

        Id standardPricebookId = Test.getStandardPricebookId();
        
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;
        
        PricebookEntry testEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true);
        insert testEntry;
        
        System.assertEquals(1, [SELECT COUNT() FROM PricebookEntry]);
        
        Test.startTest();
            new DeletePricebookEntry().deleteEntries();
        Test.stopTest();
    }
}