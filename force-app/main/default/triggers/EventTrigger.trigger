trigger EventTrigger on Event__c (after insert, after update, before delete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            EventTriggerHandler.handleAfterInsert(Trigger.new);
        }

        if(Trigger.isUpdate){
            EventTriggerHandler.handleAfterUpdate(Trigger.new);
        }
    }

    if(Trigger.isBefore && Trigger.isDelete){
        System.debug('###Trigger.isDelete: '+ Trigger.old);
        EventTriggerHandler.handleBeforeDelete(Trigger.old);
    }
}