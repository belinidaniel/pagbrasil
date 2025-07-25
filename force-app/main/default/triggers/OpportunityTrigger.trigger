trigger OpportunityTrigger on Opportunity (before insert, before update, after update, after insert) {
    new OpportunityTriggerHandler().run();
}