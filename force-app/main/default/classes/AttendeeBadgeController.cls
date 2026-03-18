public with sharing class AttendeeBadgeController {

    public Attendee__c attendee {get;set;}
    public String qrCodeUrl {get;set;}

    public AttendeeBadgeController(){
        try {
            Id attendeeId = ApexPages.currentPage().getParameters().get('id');
            if(String.isNotBlank(attendeeId)){
                attendee = [
                    SELECT Id, 
                           Contact__r.Name, QR_Code_URL__c,
                           Event__r.Name, Event__r.Start_DateTime__c, Event__r.End_DateTime__c
                    FROM Attendee__c
                    WHERE Id = :attendeeId
                    LIMIT 1
                ];
                System.debug('Record attendee: ' + attendee);

                // Génération de l'URL QR Code
                String encodedData = EncodingUtil.urlEncode(attendee.Id, 'UTF-8');

                qrCodeUrl =
                    'https://api.qrserver.com/v1/create-qr-code/?data='
                    + encodedData +
                    '&size=100x100';

            } else {
                attendee = new Attendee__c();
            }
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}