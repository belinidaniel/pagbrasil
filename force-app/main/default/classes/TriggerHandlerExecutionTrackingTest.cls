@isTest
private class TriggerHandlerExecutionTrackingTest {

    @isTest
    static void testTriggerHandlerExecutionTracking() {
        Test.startTest();
            TriggerHandlerExecutionTracking tracker = new TriggerHandlerExecutionTracking();
            TriggerHandlerDependency dep1 = new MockTriggerHandlerDependency();
            TriggerHandlerDependency dep2 = new MockTriggerHandlerDependency();            
            
            tracker.appendExecution(dep1);
            tracker.appendExecution(dep2);
            
            System.assertEquals(dep1, tracker.executionOrder(0), 'O primeiro item deve ser dep1');
            System.assertEquals(dep2, tracker.executionOrder(1), 'O segundo item deve ser dep2');
            
            Boolean exceptionThrown = false;
            try {
                tracker.executionOrder(2);
            } catch (TriggerHandlerExecutionTracking.TriggerHandlerExecutionTrackingException e) {
                exceptionThrown = true;
            }
            
            System.assert(exceptionThrown, 'Exceção esperada para índice inválido');
        Test.stopTest();
    }

    public class MockTriggerHandlerDependency implements TriggerHandlerDependency {}
}