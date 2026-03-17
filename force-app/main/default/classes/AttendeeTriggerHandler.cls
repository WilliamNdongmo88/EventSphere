public with sharing class AttendeeTriggerHandler {

    // Flag pour contrôler le trigger
    public static Boolean disableAttendeeTrigger = false;

    public static void handlerBeforeInsert(List<Attendee__c> attendees) {
        if (disableAttendeeTrigger) {
            return;
        }

        Set<Id> eventIds = new Set<Id>();
        for( Attendee__c attendee : attendees) {
            if(attendee.Event__c != null){
                eventIds.add(attendee.Event__c);
            }
        }

        Map<Id, Event__c> eventMap = new Map<Id, Event__c>(
            [SELECT Id, Status__c FROM Event__c WHERE Id IN: eventIds]
        );
        
        for (Attendee__c attendee : attendees) {
            Event__c event = eventMap.get(attendee.Event__c);
            if(event != null && event.Status__c != 'Complet'){
                if(String.isBlank(attendee.Registration_Status__c)){
                    attendee.Registration_Status__c = 'Inscrit';
                }
            }else {
                attendee.addError('L\'événement est déjà complet');
            }
        }
    }
}