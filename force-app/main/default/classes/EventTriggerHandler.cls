public with sharing class EventTriggerHandler {
    // Variable statique pour contrôler la récursivité.
    // Elle est 'false' par défaut. Une fois le trigger exécuté, on la met à 'true'.
    public static boolean hasAlreadyRun = false;

    // Flag pour contrôler l'intégration dans les tests
    public static Boolean disableGoogleCallout = false;

    public static void handleAfterInsert(List<Event__c> newEvents) {
        // On empêche l'appel API pendant les tests
        if (disableGoogleCallout) {
            return;
        }
        
        if (!hasAlreadyRun) {
            hasAlreadyRun = true; // On verrouille pour cette transaction
            for (Event__c newEvent : newEvents) {
                System.enqueueJob(new GoogleCalendarService.CreateEventJob(newEvent.Id));
            }
        }
    }

    public static void handleAfterUpdate(List<Event__c> updatedEvents) {

        if (!hasAlreadyRun) {
            hasAlreadyRun = true; // On verrouille pour cette transaction
            for (Event__c updatedEvent : updatedEvents) {
                if (String.isNotBlank(updatedEvent.Google_Calendar_Event_ID__c)) {
                    GoogleCalendarService.updateEvent(updatedEvent.Id);
                }
            }
        }
    }

    public static void handleBeforeDelete(List<Event__c> eventsToDeletes) {

        if (!hasAlreadyRun) {
            hasAlreadyRun = true; // On verrouille pour cette transaction
            for (Event__c eventsToDelete : eventsToDeletes) {
                if (String.isNotBlank(eventsToDelete.Google_Calendar_Event_ID__c)) {
                    GoogleCalendarService.deleteEvent(eventsToDelete.Google_Calendar_Event_ID__c);
                }
            }
        }
    }
}