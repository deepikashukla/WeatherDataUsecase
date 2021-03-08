({
	 getContactById: function (cmp,event,helper) {
        var action = cmp.get("c.getContact");
        action.setParams({"conId": cmp.get("v.recordId")});
 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                cmp.set("v.contactRec", response.getReturnValue());
                helper.setMapMarker(cmp,event,helper);
            } else {
                console.log('Problem getting Contact, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    setMapMarker: function(cmp,event,helper){
        var rec = cmp.get("v.contactRec");
        console.log('rec------->',rec);
         cmp.set('v.mapMarkers', [
            {
                location: {
                    Street: rec.MailingStreet,
                    City: rec.MailingCity,
                    State: rec.MailingState,
                    PostalCode: rec.MailingPostalCode,
                    Country:rec.MailingCountry
                },

                title:rec.Name,
                description: 'This is Mailing Address of the contact'
            }
        ]);
        
        console.log('---->',response.getReturnValue());
    }
})