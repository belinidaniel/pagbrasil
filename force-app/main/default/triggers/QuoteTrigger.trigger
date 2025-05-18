/**
 * @description       : 
 * @author            : Hersilio Belini de Oliveira
 * @group             : 
 * @last modified on  : 2024-11-01
 * @last modified by  : Hersilio Belini de Oliveira
**/
trigger QuoteTrigger on Quote (before insert, after insert) {
    new QuoteTriggerHandler().run();
}