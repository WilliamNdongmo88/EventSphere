public with sharing class QRCodeService {

    // Génère URL personnalisée vers ta page Salesforce
    public static String generateEventUrl(Id eventId){
        return URL.getOrgDomainUrl().toExternalForm() 
            + '/lightning/cmp/c__eventDetails?c__eventId=' + eventId;
    }

    // Génère QR Code (base64 image)
    public static String generateQRCode(Id eventId){

        String url = generateEventUrl(eventId);
        String encodedUrl = EncodingUtil.urlEncode(url, 'UTF-8');

        String qrUrl = 'https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=' 
                        + encodedUrl;

        return qrUrl;
    }
}