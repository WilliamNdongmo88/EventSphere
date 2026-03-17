@isTest
private class AttendeeBadgeControllerTest {

    @isTest
    static void testControllerLoadsAttendeeData(){

        // 1 Créer Event
        Event__c ev = TestDataFactory.createEvent();

        // 2 Créer Contact
        Contact c = new Contact(
            LastName = 'Ndongmo'
        );
        insert c;

        // 3 Créer Attendee
        Attendee__c att = new Attendee__c(
            Event__c = ev.Id,
            Contact__c = c.Id
        );
        insert att;

        // 4 Simuler l’URL
        PageReference pageRef = new PageReference('/apex/AttendeeBadge');
        pageRef.getParameters().put('id', att.Id);

        Test.setCurrentPage(pageRef);

        // 5 Exécuter le controller
        AttendeeBadgeController controller = new AttendeeBadgeController();

        // 6 Vérifications
        System.assertNotEquals(null, controller.attendee);
        System.assertEquals(att.Id, controller.attendee.Id);

        System.assertEquals('Ndongmo', controller.attendee.Contact__r.Name);
        System.assertEquals('Salesforce Conference', controller.attendee.Event__r.Name);
    }

    @isTest
    static void testControllerWithoutId(){

        PageReference pageRef = new PageReference('/apex/AttendeeBadge');
        Test.setCurrentPage(pageRef);

        AttendeeBadgeController controller = new AttendeeBadgeController();

        System.assertEquals(null, controller.attendee);
    }

    @isTest
    static void testCatchBlock(){

        Test.startTest();

        // ID qui n'existe pas
        Id fakeId = 'a00000000000000AAA';

        // Simuler l’URL
        PageReference pageRef = new PageReference('/apex/AttendeeBadge');
        pageRef.getParameters().put('id', fakeId);

        Test.setCurrentPage(pageRef);

        // Exécuter le controller
        AttendeeBadgeController controller = new AttendeeBadgeController();

        Test.stopTest();
    }
}