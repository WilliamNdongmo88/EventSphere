public with sharing class QRCodeService {

    public class QRRequest {
        public String attendeeId;
        public String logoFileName;
    }

    public class QRResponse {
        public String qrUrl;
    }

    @future(callout=true)
    public static void generateAttendeeQrAsync(Id attendeeId, String logoFileName){

        try {
            QRResponse response = generateAttendeeQr(attendeeId, logoFileName);
            System.debug('### QRResponse: ' + response);
            // 👉 Exemple : sauvegarder sur un champ
            if(response != null && String.isNotBlank(response.qrUrl)){
                
                // ⚠️ adapte l’objet selon ton modèle
                Attendee__c attendee = new Attendee__c(
                    Id = attendeeId,
                    QR_Code_URL__c = response.qrUrl
                );

                update attendee;
                System.debug('### attendee :1: ' + attendee);
            }

        } catch (Exception e) {
            System.debug('Erreur Async QR: ' + e.getMessage());
        }
    }

    public static QRResponse generateAttendeeQr(Id attendeeId, String logoFileName){

        System.debug(' -----:Callout:----- ');

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint('https://api.smart-invite.com/api/invitation/attendee-qr');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        QRRequest body = new QRRequest();
        body.attendeeId = String.valueOf(attendeeId);
        body.logoFileName = logoFileName;

        req.setBody(JSON.serialize(body));

        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200 || res.getStatusCode() == 201){

            QRResponse response = (QRResponse) JSON.deserialize(
                res.getBody(),
                QRResponse.class
            );

            return response;

        } else {
            throw new CalloutException(
                'Erreur API QR: ' + res.getStatusCode() + ' - ' + res.getBody()
            );
        }
    }
}