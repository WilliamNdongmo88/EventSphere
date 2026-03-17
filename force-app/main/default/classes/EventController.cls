public with sharing class EventController {

    // Flag utilisé uniquement dans les tests
    public static Boolean forceExceptionForTest = false;

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getUpcomingEvents(){
        try {
            if(forceExceptionForTest){
                throw new CalloutException('Forced exception for test');
            }
            
            List<Event__c> events = [
                SELECT Id, Name, Status__c, Start_DateTime__c, End_DateTime__c 
                FROM Event__c 
                WHERE Status__c IN ('Planifié','Ouvert aux inscriptions')
                AND Start_DateTime__c > :DateTime.now()
                ORDER BY Start_DateTime__c ASC
                LIMIT 5
            ];

            Set<Id> eventsId = new Map<Id, Event__c>(events).keySet();

            Map<Id, List<Attendee__c>> attendeesMap = new Map<Id, List<Attendee__c>>();

            for (Attendee__c att : [
                SELECT Id, Contact__r.Name, Event__c, Registration_Status__c
                FROM Attendee__c
                WHERE Event__c IN :eventsId
            ]) {
                if (!attendeesMap.containsKey(att.Event__c)) {
                    attendeesMap.put(att.Event__c, new List<Attendee__c>());
                }
                attendeesMap.get(att.Event__c).add(att);
            }

            Map<String, Object> result = new Map<String, Object>();

            result.put('events', events);
            result.put('attendees', attendeesMap);

            return result;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}