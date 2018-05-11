({

    doInit: function (component, event, helper) {
        helper.showHelper(component, event);
    },

    navigateToProductComponent: function (component, event, helper) {
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var order = component.get("v.searchResult")[index];
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:Products",
            componentAttributes: {
                recordId: order.Id
            }
        });
        evt.fire();
    }
})