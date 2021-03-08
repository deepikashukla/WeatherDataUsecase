public inherited sharing class CurrentLocationController {
    
    @AuraEnabled
    public static Contact getContact(Id conId){
        return [SELECT Id,Name,Weather_Description__c,Weather_Label__c,MailingPostalCode,MailingStreet,MailingState,MailingCity,MailingCountry
                FROM Contact
                WHERE ID=:conId
                WITH SECURITY_ENFORCED];
    }
    
    @future(callout=true)
    public static void setWeatherByZipcode(Id conId,String zipCode,String endpoint, String key){
        try{
            if(conId!=null && zipCode!=null && endpoint!=null && key!=null){
                Http h 			= new Http();
                HTTPRequest req = new HTTPRequest();
                String reqUrl 	= endpoint+'?zip='+zipCode+',de'+'&appid='+key;//COUNTRIES AND CODES CAN BE PUT IN A CUSTOM METADATA
                system.debug('reqUrl----->'+reqUrl);
                req.setEndpoint(reqUrl);
                req.setMethod('GET');
                req.setTimeout(5000);
                System.debug('req----->' + req);
                HttpResponse res = h.send(req);
                system.debug('res---->'+res);
                CurrentLocationController.processResponse(conId,res);
            }
        }catch(Exception ex){
            throw new CustomException(ex.getMessage());//THESE ERRORS CAN BE LOGGED TOO
        }
    }
    
    public static void processResponse(Id conId,HTTPResponse res){
        if(res!=null && res.getBody()!=null){
            Map<String,Object> responseMap =(Map<String,Object>)JSON.deserializeUntyped(res.getBody());
            if(responseMap!=null && responseMap.containsKey('weather')){
                Contact con				= [SELECT Id,Weather_Description__c,Weather_Label__c 
                                           FROM Contact 
                                           WHERE Id=:conId LIMIT 1];
                List<Object> weatherData = (List<Object>)responseMap.get('weather');
                Map<String,Object> weatherMap = (Map<String,Object>)weatherData[0];
                con.Weather_Description__c    = (String)weatherMap.get('description');
                con.Weather_Label__c		  = (String)weatherMap.get('main');
                if(!Trigger.isExecuting){
                   Database.update(con); 
                }
            }
        }
    }

}