({
    showToast: function(title, message, type, mode, duration, key) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration,
            "key": key
        });
        toastEvent.fire();
    }
})