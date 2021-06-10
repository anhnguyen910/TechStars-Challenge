trigger meetupsTrigger on Meetup__c (after insert) {
    List<Meetup__c> meetupsList = [SELECT Id, RegistrationCode__c FROM Meetup__c WHERE Id IN:Trigger.New];
    for (Meetup__c m: meetupsList){
        if(trigger.isAfter && trigger.isInsert){
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            String randomString = key.substring(0,8);
            m.RegistrationCode__c = randomString;
        }
    }
    update meetupsList;
}