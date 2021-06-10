public with sharing class meetupsController {

    @AuraEnabled(cacheable=true)
    public static String getMeetupsRecord(String regCode) {
        String m = [SELECT Id, RegistrationCode__c FROM Meetup__c WHERE RegistrationCode__c=: regCode].Id;
        return m;
    }
    @AuraEnabled
    public static String registerMeetups(String firstName, String lastName, String emailAddress, String meetupId){
       
        Meetup__c m = [SELECT Id, RegistrationLimit__c, TotalRegistered__c, Status__c FROM Meetup__c WHERE Id=: meetupId];
        If (m.Status__c == 'Open'){
            If (m.TotalRegistered__c < m.RegistrationLimit__c) {
                MeetupRegistration__c mr = new MeetupRegistration__c (FirstName__c = firstName, LastName__c = lastName, Email__c = emailAddress, Meetup__c = meetupId);
                try{
                    insert mr;
                }catch (Exception e) {
                    String errorMsg = e.getMessage();
                    String pureErrorMsg = errorMsg.substringAfter('_VALUE,');
                    pureErrorMsg = pureErrorMsg.Substring(0, (pureErrorMsg.length()-29));
                    throw new AuraHandledException(pureErrorMsg);
                }
                return '';
            }
            else {
                return('Total # of registrations exceed the registration limit for this Meetup');
            }
        }
        else {
            return ('Meetup status must be open');
        } 
    }
}