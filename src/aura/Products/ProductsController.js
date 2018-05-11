({
    // Load products from Salesforce
    doInit: function (component, event, helper) {
        helper.showHelper(component, event);
    },

    gotoURL : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "https://alexkorovin-dev-ed.lightning.force.com/one/one.app#/n/My_Orders"
        });
        urlEvent.fire();
    },

    // Sort record list by name
    sortByName: function (component, event, helper) {
        helper.sortBy(component, "Name");
    },

    // Add product to Cart
    addToCart: function (component, event, helper) {
        var index1 = event.currentTarget.dataset.index1;
        var index2 = event.currentTarget.dataset.index2;
        helper.addProductToCart(component, index1, index2);
    },

    // Remove product from Cart
    removeFromCart: function (component, event, helper) {
        var index1 = event.currentTarget.dataset.index1;
        var index2 = event.currentTarget.dataset.index2;
        helper.removeProductFromCart(component, index1, index2);
    },

    // Submit Order for Approve
    submitOrder: function (component, event, helper) {
        helper.submitOrderToApprove(component, event);
    },
})