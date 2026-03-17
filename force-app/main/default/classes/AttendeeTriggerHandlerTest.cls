@isTest
public class AttendeeTriggerHandlerTest {

    // 🔹 Utilitaire : créer Event
    private static Event__c createEvent(String status){
        Event__c ev = new Event__c(
            Name = 'Test Event',
            Status__c = status,
            Start_DateTime__c = System.now().addDays(1),
            End_DateTime__c = System.now().addDays(1).addHours(2)
        );
        insert ev;
        return ev;
    }

    // 🔹 Utilitaire : créer Contact
    private static Contact createContact(){
        Contact c = new Contact(LastName = 'Test');
        insert c;
        return c;
    }

    // TEST 1 : statut auto = "Inscrit"
    @isTest
    static void testBeforeInsert_DefaultStatus(){

        Event__c ev = createEvent('Planifié');
        Contact c = createContact();

        Attendee__c att = new Attendee__c(
            Event__c = ev.Id,
            Contact__c = c.Id
        );

        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());

        Test.startTest();
        insert att; // ✅ laisse le trigger faire son travail
        Test.stopTest();

        Attendee__c inserted = [
            SELECT Registration_Status__c
            FROM Attendee__c
            WHERE Id = :att.Id
        ];

        System.assertEquals('Inscrit', inserted.Registration_Status__c);
    }

    // TEST 2 : event complet → erreur
    @isTest
    static void testBeforeInsert_EventFull(){

        EventTriggerHandler.disableGoogleCallout = true;

        Event__c ev = createEvent('Complet');
        Contact c = createContact();

        Attendee__c att = new Attendee__c(
            Event__c = ev.Id,
            Contact__c = c.Id
        );

        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());

        Test.startTest();

        try {
            insert att; // ✅ trigger lance addError
            System.assert(false, 'Erreur attendue');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('complet'));
        }

        Test.stopTest();
    }
}