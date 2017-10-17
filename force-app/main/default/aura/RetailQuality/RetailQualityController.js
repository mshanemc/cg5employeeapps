({
    doInit : function(component) {

    },

    setInsp : function(component, event) {
        var newRecordId = event.getParam("recordId");
        var frd = component.find("frd");
        frd.set("v.recordId", newRecordId);
        frd.reloadRecord();
    },

    updateMessage : function(component) {
        $A.get("e.ltng:sendMessage")
            .setParams({
                "channel" : "inspectionAssembly",
                "message" : component.get("v.targetFields")
            }).fire();
    },


})