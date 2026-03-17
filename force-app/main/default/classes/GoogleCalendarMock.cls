@isTest
public class GoogleCalendarMock implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json');
        res.setStatusCode(200);

        if(req.getMethod() == 'POST'){
            res.setBody('{"id":"google-event-12345"}');
        }
        else if(req.getMethod() == 'PUT'){
            res.setBody('{"id":"google-event-12345"}');
        }
        else if(req.getMethod() == 'DELETE'){
            res.setStatusCode(204);
        }

        return res;
    }
}