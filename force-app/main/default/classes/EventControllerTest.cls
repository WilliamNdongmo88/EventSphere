@isTest
public with sharing class EventControllerTest {
    @isTest
    static void testGetUpcomingEvents(){

        AttendeeTriggerHandler.disableAttendeeTrigger = true;
        EventTriggerHandler.disableGoogleCallout = true;

        // Création Event
        Event__c ev = new Event__c(
            Name = 'Event Test',
            Status__c = 'Planifié',
            Start_DateTime__c = System.now().addDays(1),
            End_DateTime__c = System.now().addDays(1).addHours(2)
        );
        insert ev;

        // Création Contact
        Contact con = new Contact(
            LastName = 'Will'
        );
        insert con;

        // Création Attendee
        Attendee__c att = new Attendee__c(
            Contact__c = con.Id,
            Event__c = ev.Id
        );
        insert att;

        Test.startTest();

        Map<String, Object> result = EventController.getUpcomingEvents();

        Test.stopTest();

        System.assertNotEquals(null, result);

        List<Event__c> events = (List<Event__c>) result.get('events');
        Map<Id, List<Attendee__c>> attendees = (Map<Id, List<Attendee__c>>) result.get('attendees');

        System.assertEquals(1, events.size());
        System.assert(attendees.containsKey(ev.Id));
    }

    @isTest
    static void testAttendeesMapCondition() {

        AttendeeTriggerHandler.disableAttendeeTrigger = true;
        EventTriggerHandler.disableGoogleCallout = true;

        // 1 Créer un Event futur
        Event__c ev = new Event__c(
            Name = 'Event Test',
            Status__c = 'Planifié',
            Start_DateTime__c = System.now().addDays(1),
            End_DateTime__c = System.now().addDays(1).addHours(2)
        );
        insert ev;

        // 2 Créer Contact
        Contact c = new Contact(
            LastName = 'Participant'
        );
        insert c;

        // 3 Créer Attendee
        Attendee__c att = new Attendee__c(
            Event__c = ev.Id,
            Contact__c = c.Id
        );
        insert att;

        Test.startTest();

        Map<String,Object> result = EventController.getUpcomingEvents();

        Test.stopTest();

        // 4️⃣ Vérification
        Map<Id, List<Attendee__c>> attendees = (Map<Id, List<Attendee__c>>) result.get('attendees');

        System.assert(attendees.containsKey(ev.Id));
        System.assertEquals(1, attendees.get(ev.Id).size());
    }

        @isTest
    static void testAttendeesCatch() {

        EventController.forceExceptionForTest = true;

        Test.startTest();

        Map<String,Object> result = EventController.getUpcomingEvents();

        Test.stopTest();
    }
}