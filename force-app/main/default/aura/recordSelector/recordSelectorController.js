({
    doInit : function(component) {
        var columns=[{
            label: 'Dealer', fieldName: 'Name'
        }];

        component.set("v.columns", columns);

        var action = component.get("c.getDealers");
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a);
                component.set("v.dealers", a.getReturnValue());
            } else if (state === "ERROR") {
                console.log(a.getError());
            }
        });
        $A.enqueueAction(action);
    },

    selectedRecord : function(component, event) {
        //create an inspection that we can all be editing
        component.find("frd").getNewRecord(
            "Field_Inspection__c", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                //set the lookup to the dealer
                component.set("v.inspectionFields.Dealer__c", event.getParam('selectedRows')[0].Id);
                console.log("called back from new record");
                //save it
                component.find("frd").saveRecord(
                    $A.getCallback(function(saveResult){
                        console.log(saveResult);
                        if (saveResult.state === "SUCCESS"){
                            //happy logic here
                            //component.find("frd").reloadRecord();
                            $A.get("e.ltng:selectSObject").setParams({
                                "recordId" : component.get("v.inspectionFields.Id")
                            }).fire();
                        } else if (saveResult.state === "INCOMPLETE") {
                            console.log('User is offline, device doesn\'t support drafts.');
                        } else if (saveResult.state === "ERROR"){
                            console.log(saveResult.error);
                            //component.find("leh").passErrors(saveResult.error);
                        }
                    })
                );

            })
        );

    },

    assemble : function(component, event) {
        if (event.getParam("channel")==="inspectionAssembly"){
            console.log("assembly message received on the channel");
            console.log(event.getParam("message"));
        }
        var input = event.getParam("message")
        for (var key in input){
            console.log(key + '--' + input[key]);
            component.set("v.inspectionFields."+key, input[key]);
        }
        console.log(component.get("v.inspectionFields"));
    },

    submit : function(component, event, helper) {
        component.find("frd").saveRecord(
            $A.getCallback(function(saveResult){
                //console.log(saveResult);
                if (saveResult.state === "SUCCESS"){
                    //happy logic here
                    $A.get("e.force:showToast").setParams({"type" : "success", "message" : "Inspection Saved!"}).fire();

                } else if (saveResult.state === "INCOMPLETE") {
                    console.log('User is offline, device doesn\'t support drafts.');
                } else if (saveResult.state === "ERROR"){
                    component.find("leh").passErrors(saveResult.error);
                }
            })
        );
    },
})
