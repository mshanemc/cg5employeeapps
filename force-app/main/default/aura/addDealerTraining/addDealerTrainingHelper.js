({
    inspectionInit : function(component) {
        var inspId = component.get("v.targetFields.Field_Inspection__c");

        component.find("frd").getNewRecord(
            "Recommended_Training__c", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                console.log("record is ready for creation.  fields :")
                console.log(component.get("v.targetFields"));
                if (inspId){
                    component.set("v.targetFields.Field_Inspection__c", inspId);
                }
            })
        );
    }
})
