trigger AttendeeTrigger on Attendee__c (before insert, after insert) {

    if(Trigger.isBefore){
        AttendeeTriggerHandler.handlerBeforeInsert(Trigger.new);
    }

    // if(Trigger.isAfter){
    //     AttendeeTriggerHandler.handlerAfterInsert(Trigger.new);
    // }

    if(Trigger.isAfter && Trigger.isInsert){
        // Appel de la méthode @future après l'insertion
        AttendeeTriggerHandler.handlerAfterInsert(Trigger.new);
    }
}