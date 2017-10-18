({
    doInit : function(component, event, helper) {
        var trails=[
            {
                "id" : "0",
                "name" : "Service",
                "image" : "https://raw.githubusercontent.com/mshanemc/cg5employeeapps/master/assets/trail-checklist.png",
                "highlighted" : false
            },
            {
                "id" : "1",
                "name" : "Engage",
                "image" : "https://raw.githubusercontent.com/mshanemc/cg5employeeapps/master/assets/trail-contacts.png",
                "highlighted" : false
            },
            {
                "id" : "2",
                "name" : "Brand Display",
                "image" : "https://raw.githubusercontent.com/mshanemc/cg5employeeapps/master/assets/trail-grid.png",
                "highlighted" : false
            },
        ];
        component.set("v.trails", trails);
        helper.inspectionInit(component);
    },

    setInsp : function(component, event) {
        var newRecordId = event.getParam("recordId");
        console.log("Training: setting inspection to " + event.getParam("recordId"));
        component.set("v.targetFields.Field_Inspection__c", newRecordId);
        console.log("Training: inspection id is " + component.get("v.targetFields.Field_Inspection__c"));

    },

    selectTrail : function(component, event, helper) {
        console.log(event.target.id);
        var trails = component.get("v.trails");
        trails[event.target.id].highlighted = !trails[event.target.id].highlighted;
        if (trails[event.target.id].highlighted){

            //set the name
            component.set("v.targetFields.Name", trails[event.target.id].name);

            component.find("frd").saveRecord(
                $A.getCallback(function(saveResult){
                    console.log(saveResult);
                    helper.inspectionInit(component);

                    if (saveResult.state === "SUCCESS"){
                    } else if (saveResult.state === "INCOMPLETE") {
                        console.log('User is offline, device doesn\'t support drafts.');
                    } else if (saveResult.state === "ERROR"){
                        console.log(saveResult.error);
                    }
                })
            );

        } else {
            //we're deleting an existing record
        }
        component.set("v.trails", trails);
    },
})
