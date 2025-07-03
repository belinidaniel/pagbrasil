@isTest
public class RecursionControlTest {
	@isTest
    static void varsTest() {
        System.assertEquals(false, RecursionControl.isAccountTriggerRunning);
        System.assertEquals(false, RecursionControl.isOpportunityTriggerRunning);
        
        RecursionControl.isAccountTriggerRunning = true;
        RecursionControl.isOpportunityTriggerRunning = true;
        
        System.assertEquals(true, RecursionControl.isAccountTriggerRunning);
        System.assertEquals(true, RecursionControl.isOpportunityTriggerRunning);
        
        RecursionControl.isAccountTriggerRunning = true;
        RecursionControl.isOpportunityTriggerRunning = true;
    }
}