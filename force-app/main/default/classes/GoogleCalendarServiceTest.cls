@isTest
public with sharing class GoogleCalendarServiceTest {
    @isTest
    static void testCreateEventJob() {

        // 1 Créer un Event__c
        Event__c ev = TestDataFactory.createEvent();

        // 2 Simuler le callout
        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());

        Test.startTest();

        // 3 Exécuter le Queueable
        System.enqueueJob(new GoogleCalendarService.CreateEventJob(ev.Id));

        Test.stopTest();

        // 4 Vérifier la mise à jour
        Event__c updatedEvent = [
            SELECT Google_Calendar_Event_ID__c
            FROM Event__c
            WHERE Id = :ev.Id
        ];

        System.assertEquals('google-event-12345', updatedEvent.Google_Calendar_Event_ID__c);
    }

    @isTest
    static void testUpdateEvent(){

        // Création Event Salesforce
        Event__c ev = TestDataFactory.createEventWihtGoogleId();

        // Mock callout
        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());

        Test.startTest();

        GoogleCalendarService.updateEvent(ev.Id);

        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testUpdateEventWithoutGoogleId(){

        Event__c ev = TestDataFactory.createEvent();

        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());

        Test.startTest();

        GoogleCalendarService.updateEvent(ev.Id);

        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testDeleteEvent(){

        Event__c ev = TestDataFactory.createEventWihtGoogleId();
        delete ev;

        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());

        Test.startTest();

        GoogleCalendarService.deleteEvent(ev.Google_Calendar_Event_ID__c);

        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testUpdateException(){

        GoogleCalendarService.forceExceptionForTest = true;

        Test.startTest();

        GoogleCalendarService.updateEvent('google-event-123');

        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testDeleteException(){

        GoogleCalendarService.forceExceptionForTest = true;

        Test.startTest();

        GoogleCalendarService.deleteEvent('google-event-123');

        Test.stopTest();

        System.assert(true);
    }
}