trigger AttendeeTrigger on Attendee__c (before insert) {

    if(Trigger.isBefore){
        AttendeeTriggerHandler.handlerBeforeInsert(Trigger.new);
    }
}