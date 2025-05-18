/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-04-22
 * @last modified by  : luis.tavares
**/
trigger OpportuntyTrigger on Opportunity (before insert, before update, after update) {
    new OpportunityTriggerHandler().run();
}