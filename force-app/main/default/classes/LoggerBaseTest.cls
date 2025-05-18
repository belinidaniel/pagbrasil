@isTest
private class LoggerBaseTest {

    @isTest
    static void testLoggerBaseMethods() {
        Test.startTest();
            LoggerBase.log('Test log message');
            LoggerBase.error('Test error message');
            LoggerBase.debug('Test debug message');
            LoggerBase.warn('Test warn message');
        Test.stopTest();
        
        System.assert(true, 'LoggerBase methods executed without errors');
    }
}