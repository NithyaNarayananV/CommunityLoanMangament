@isTest
global class AnimalLocatorMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type','application/json');
        response.setBody('{"animals": ["majestic","fluffy","scarybear","chicken"]}');
        response.setStatusCode(200);
        return response;
    }
}