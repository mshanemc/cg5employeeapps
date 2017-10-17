({
    doInit : function(component, event, helper) {
        var choicesRaw = component.get("v.choices").split(',');
        choicesRaw.forEach(function(item){
            item.trim();
        })
        component.set("v.choicesArray",choicesRaw);
    },

    setValue : function(component, event, helper) {
        component.set("v.value", event.getSource().get("v.label"))
    }
})
