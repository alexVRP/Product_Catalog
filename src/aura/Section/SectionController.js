({
    onIconClick: function (component, event, helper) {
        var isShow = component.get("v.isShow");
        component.set("v.isShow", !isShow);
    }
});