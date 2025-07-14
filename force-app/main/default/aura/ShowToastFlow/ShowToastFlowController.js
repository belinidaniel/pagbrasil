({
    invoke : function(component, event, helper) {
        var title = component.get("v.title");
        var message = component.get("v.message");
        var type = component.get("v.type");
        var mode = component.get("v.mode");
        var duration = component.get("v.duration");
        var key = component.get("v.key");

        helper.showToast(title, message, type, mode, duration, key);
    }
})