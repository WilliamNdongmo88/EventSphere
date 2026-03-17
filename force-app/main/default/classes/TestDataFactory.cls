public with sharing class TestDataFactory {
    
    public static List<Event__c> createEvents(){
        List<Event__c> eventsToCreate = new List<Event__c>();
        for (Integer i = 1; i <= 7; i++) { 
            eventsToCreate.add(
                new Event__c(
                    Name = 'Future Event ' + i, 
                    Start_DateTime__c = System.now().addDays(i), 
                    End_DateTime__c = System.now().addDays(i).addHours(2), 
                    Status__c = 'Ouvert aux inscriptions'
                )
            ); 
        }
        eventsToCreate.add(
            new Event__c(
                Name = 'Past Event', 
                Start_DateTime__c = System.now().addDays(-10), 
                End_DateTime__c = System.now().addDays(-10).addHours(2), 
                Status__c = 'Terminé'
            )
        );
        eventsToCreate.add(
            new Event__c(
                Name = 'Cancelled Event', 
                Start_DateTime__c = System.now().addDays(5), 
                End_DateTime__c = System.now().addDays(5).addHours(2), 
                Status__c = 'Annulé'
            )
        );
        insert eventsToCreate;
        return eventsToCreate;
    }

    public static Event__c createEvent(){

        Event__c ev = new Event__c(
            Name = 'Salesforce Conference',
            Start_DateTime__c = System.now(),
            End_DateTime__c = System.now().addHours(2),
            Status__c = 'Ouvert aux inscriptions'
        );

        insert ev;
        return ev;
    }

    public static Event__c createEventWihtGoogleId(){
        Event__c ev = new Event__c(
            Name = 'Salesforce Conference',
            Start_DateTime__c = System.now(),
            End_DateTime__c = System.now().addHours(2),
            Status__c = 'Ouvert aux inscriptions',
            Google_Calendar_Event_ID__c = 'google-event-12345'
        );

        insert ev;
        return ev;
    }
}