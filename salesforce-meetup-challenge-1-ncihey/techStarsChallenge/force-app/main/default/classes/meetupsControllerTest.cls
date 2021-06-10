@isTest
public with sharing class meetupsControllerTest {
    @TestSetup
    static void makeData(){
        List<Meetup__c> testMeetups = new List<Meetup__c>();
        for (integer i=0; i<2; i++){
            testMeetups.add(new Meetup__c(Name = 'Meet '+ i, RegistrationLimit__c = i+1));
        }
        insert testMeetups;
    }
    @isTest
    static void getMeetupsRecordTest(){
        String regCode = [SELECT RegistrationCode__c FROM Meetup__c LIMIT 1].RegistrationCode__c;
        String Id = [SELECT Id, RegistrationCode__c FROM Meetup__c WHERE RegistrationCode__c=: regCode].Id;
        Test.startTest();
        String meetUpsId = meetupsController.getMeetupsRecord(regCode);
        Test.stopTest();
        System.assertEquals(meetUpsId, Id);
    }
    @isTest
    static void registerMeetupsTest1(){  
        Meetup__c m = [SELECT Id, RegistrationLimit__c, TotalRegistered__c, Status__c FROM Meetup__c LIMIT 1];
        m.Status__c = 'Closed';
        Test.startTest();
        update m;
        Test.stopTest();
        String ret = meetupsController.registerMeetups('firstName', 'lastName', 'abc@yahoo.com', m.Id);
        System.assertEquals(ret, 'Meetup status must be open');
    }
    @isTest
    static void registerMeetupsTest2(){  
        Meetup__c m = [SELECT Id, RegistrationLimit__c, TotalRegistered__c, Status__c FROM Meetup__c WHERE Name = 'Meet 1'];
        m.Status__c = 'Open';
        Test.startTest();
        update m;
        Test.stopTest();
        String ret = meetupsController.registerMeetups('firstName', 'lastName', 'abc@yahoo.com', m.Id);
        System.assertEquals(ret, '');
    }
    @isTest
    static void registerMeetupsTest3(){  
        Meetup__c m = [SELECT Id, RegistrationLimit__c, TotalRegistered__c, Status__c FROM Meetup__c WHERE Name = 'Meet 1'];
        m.Status__c = 'Open';
        Test.startTest();
        update m;
        List<MeetupRegistration__c> mrs = new List<MeetupRegistration__c>();
        for (integer i=0; i<1; i++){
            mrs.add(new MeetupRegistration__c(FirstName__c = 'f', LastName__c = 'l', Meetup__c = m.Id, Email__c='abc@yahoo.com'));
        }
        insert mrs;
        Test.stopTest();
        try{
            String ret = meetupsController.registerMeetups('firstName', 'lastName', 'abc@yahoo.com', m.Id);
        }
        catch(Exception e){
            Boolean expectedExceptionThrown = true;
            if (e.getMessage() != null){
                expectedExceptionThrown = true;
            }
            else {
                expectedExceptionThrown = false;
            }
            System.assertEquals(expectedExceptionThrown, true);
        }  
    }
    @isTest
    static void registerMeetupsTest4(){  
        Meetup__c m = [SELECT Id, RegistrationLimit__c, TotalRegistered__c, Status__c FROM Meetup__c WHERE Name = 'Meet 1'];
        m.Status__c = 'Open';
        Test.startTest();

        update m;
        List<MeetupRegistration__c> mrs = new List<MeetupRegistration__c>();
        for (integer i=0; i<2; i++){
            mrs.add(new MeetupRegistration__c(FirstName__c = 'f', LastName__c = 'l', Meetup__c = m.Id, Email__c='abc'+i+'@yahoo.com'));
        }
        insert mrs;

        Test.stopTest();
        String ret = meetupsController.registerMeetups('firstName', 'lastName', 'abc@yahoo.com', m.Id);
        System.assertEquals(ret, 'Total # of registrations exceed the registration limit for this Meetup');
    }
}
