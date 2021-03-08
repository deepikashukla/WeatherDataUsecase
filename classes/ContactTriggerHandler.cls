public class ContactTriggerHandler {
	public static void onAfterInsert(List<Contact> newList){
        Weather_API__mdt config = [SELECT Endpoint__c,Key__c 
                                   FROM Weather_API__mdt 
                                   WHERE DeveloperName =:'Weather_By_Zipcode' limit 1];
        for(Contact con:newList){
            CurrentLocationController.setWeatherByZipcode(con.id,con.MailingPostalCode,config.Endpoint__c,config.Key__c);
        }
        
    }
}