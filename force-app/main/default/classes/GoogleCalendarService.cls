public with sharing class GoogleCalendarService {

    // Flag utilisé uniquement dans les tests
    public static Boolean forceExceptionForTest = false;

    public class CreateEventJob implements Queueable, Database.AllowsCallouts {
        private Id eventId;

        public CreateEventJob(Id sfEventId) {
            this.eventId = sfEventId;
        }

        public void execute(QueueableContext context) {
            // La logique de création est maintenant ici
            Event__c sfEvent = [SELECT Name, Location__c, Start_DateTime__c, End_DateTime__c, Description__c FROM Event__c WHERE Id = :this.eventId LIMIT 1];
            String endpoint = 'callout:GoogleCalenderApi/events';
            String jsonBody = JSON.serialize(new Map<String, Object>{
                'summary' => sfEvent.Name, 
                'description' => sfEvent.Description__c,
                'location' => sfEvent.Location__c,
                'start' => new Map<String, Object>{'dateTime' => sfEvent.Start_DateTime__c.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''), 'timeZone' => 'UTC'},
                'end' => new Map<String, Object>{'dateTime' => sfEvent.End_DateTime__c.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''), 'timeZone' => 'UTC'}
            });

            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(jsonBody);

            Http http = new Http( );
            HttpResponse response = http.send(request );

            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                System.debug('SUCCÈS : Événement créé sur Google Calendar. Réponse : ' + response.getBody());
                Map<String, Object> googleEvent = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String googleEventId = (String) googleEvent.get('id');

                if (String.isNotBlank(googleEventId)) {
                    // IMPORTANT : La mise à jour se fait dans un contexte séparé, il n'y a plus de récursivité asynchrone.
                    Event__c eventToUpdate = new Event__c(Id = this.eventId, Google_Calendar_Event_ID__c = googleEventId);
                    Database.update(eventToUpdate, false);
                }
            } else {
                System.debug('ERREUR lors de la création de l\'événement Google. Statut: ' + response.getStatusCode() + ' Body: ' + response.getBody());
            }
        }
    }

    @future(callout=true)
    public static void updateEvent(String eventId){
        try {
            if(forceExceptionForTest){
                throw new CalloutException('Forced exception for test');
            }

            Event__c sfEvent = [
                SELECT Id, Name, Description__c, Start_DateTime__c, End_DateTime__c,
                    Location__c, Google_Calendar_Event_ID__c
                FROM Event__c
                WHERE Id = :eventId
                LIMIT 1
            ];

            if(sfEvent.Google_Calendar_Event_ID__c == null){
                return;
            }

            Map<String, Object> body = new Map<String, Object>{
                'summary' => sfEvent.Name,
                'description' => sfEvent.Description__c,
                'location' => sfEvent.Location__c,
                'start' => new Map<String, Object>{
                    'dateTime' => sfEvent.Start_DateTime__c.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),
                    'timeZone' => 'UTC'
                },
                'end' => new Map<String, Object>{
                    'dateTime' => sfEvent.End_DateTime__c.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''),
                    'timeZone' => 'UTC'
                }
            };

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:GoogleCalenderApi/events/' + sfEvent.Google_Calendar_Event_ID__c);
            req.setMethod('PUT');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(body));

            Http http = new Http();
            HttpResponse res = http.send(req);

            if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
                System.debug('Evénement mis a jour dans google calender avec succès');
            }
            else{
                System.debug('Google API Error: ' + res.getBody());
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }

    @future(callout=true)
    public static void deleteEvent(String googleEventId){
        try {
            if(forceExceptionForTest){
                throw new CalloutException('Forced exception for test');
            }
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:GoogleCalenderApi/events/' + googleEventId);
            req.setMethod('DELETE');
            req.setHeader('Content-Type', 'application/json');

            Http http = new Http();
            HttpResponse res = http.send(req);

            if(res.getStatusCode() == 204){
                System.debug('Evénement supprimé dans google calender avec succès');
            }
            else{
                System.debug('Google API Error: ' + res.getBody());
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}