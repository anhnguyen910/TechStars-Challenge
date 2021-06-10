@isTest
public with sharing class meetupsTriggerTest {
    @isTest
    static void test(){
        List<Meetup__c> testMeetups = new List<Meetup__c>();
        for (integer i=0; i<2; i++){
            testMeetups.add(new Meetup__c(Name = 'Meet '+ i, RegistrationLimit__c = i+1));
        }
        insert testMeetups;
        Meetup__c m = [SELECT Id, RegistrationCode__c FROM Meetup__c LIMIT 1];
        System.assertNotEquals(m.RegistrationCode__c,null);
    }
}
