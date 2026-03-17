@isTest
public with sharing class EventTriggerHandlerTest {
    
    @isTest
    static void testHandleAfterInsert() {
        Event__c ev = TestDataFactory.createEvent();

        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());
        Test.startTest();
        EventTriggerHandler.handleAfterInsert(new List<Event__c>{ev});
        Test.stopTest();
    }

    @isTest
    static void testHandleAfterUpdate() {
        Event__c ev = TestDataFactory.createEventWihtGoogleId();

        EventTriggerHandler.hasAlreadyRun = false;

        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());
        
        Test.startTest();
        ev.Location__c = 'Yaoundé';
        update ev;
        EventTriggerHandler.handleAfterUpdate(new List<Event__c>{ev});
        Test.stopTest();
    }

    @isTest
    static void testHandleBeforeDelete() {
        Event__c ev = TestDataFactory.createEventWihtGoogleId();

        EventTriggerHandler.hasAlreadyRun = false;

        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());
        
        Test.startTest();
        EventTriggerHandler.handleBeforeDelete(new List<Event__c>{ev});
        Test.stopTest();
    }
}