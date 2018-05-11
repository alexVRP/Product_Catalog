({
    showHelper: function (component, event) {
        var action = component.get("c.getCategory");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {

            console.log(component.get("v.recordId"));

            var returnValue = response.getReturnValue();
            component.set("v.searchResult", JSON.parse(returnValue));

            var countProducts = 0;

            JSON.parse(returnValue).forEach(function (item) {
                countProducts += item.productItems.length;
            });
            component.set("v.count", countProducts);
        });
        $A.enqueueAction(action);
    },

    sortBy: function (component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.searchResult");

        sortAsc = field == sortField ? !sortAsc : true;
        console.log(records);
        records.forEach(function (productItem) {
            productItem.productItems.sort(function (a, b) {
                var t1 = a.product[field] == b.product[field],
                    t2 = a.product[field] > b.product[field];
                return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? -1 : 1);
            });
        });
        records = records.map(function (recordItem) {
            return Object.assign({}, recordItem);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.searchResult", records);
    },

    addProductToCart: function (component, index1, index2) {
        var searchResult = component.get("v.searchResult");
        var product = searchResult[index1].productItems[index2].product;
        var total = searchResult[index1].productItems[index2].total;

        console.log(total);
        // console.log(product);
        // console.log(product.Id);
        console.log(component.get("v.recordId"));

        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.addProduct");
        action.setParams({
            "productId": product.Id,
            "recordId": component.get("v.recordId"),
            "total": total
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            console.log(state);

            if (state === "SUCCESS") {
                toastEvent.setParams({
                    "message": "You add " + searchResult[index1].productItems[index2].product.Name
                    + " to cart.",
                    "type": "success",
                    "key": "info",
                    "mode": "dismissible"
                });
                toastEvent.fire();
                searchResult[index1].productItems[index2].state = !searchResult[index1].productItems[index2].state;
                component.set("v.searchResult", searchResult);
                component.set("v.recordId", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    removeProductFromCart: function (component, index1, index2) {
        var searchResult = component.get("v.searchResult");

        var product = searchResult[index1].productItems[index2].product;
        var total = searchResult[index1].productItems[index2].total;

        console.log(searchResult[index1].productItems[index2].total);
        console.log(product);

        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.removeProduct");
        action.setParams({
            "productId": product.Id,
            "recordId": component.get("v.recordId"),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            console.log(state);

            if (state === "SUCCESS") {
                toastEvent.setParams({
                    "message": "You remove " + searchResult[index1].productItems[index2].product.Name
                    + " from cart.",
                    "type": "other",
                    "key": "delete",
                    "mode": "dismissible"
                });
                toastEvent.fire();
                searchResult[index1].productItems[index2].state = !searchResult[index1].productItems[index2].state;
                component.set("v.searchResult", searchResult);
                console.log(total);
                console.log(total);
            }
        });
        $A.enqueueAction(action);
    },

    submitOrderToApprove: function (component, event) {
        var toastEvent = $A.get("e.force:showToast");
        if (component.get("v.recordId") != null) {
            var action = component.get("c.submitOrderApproval");
            action.setParams({
                "recordId": component.get("v.recordId"),
            });
            action.setCallback(this, function (response) {
                var state = response.getState();

                console.log(state);

                if (state === "SUCCESS") {
                    toastEvent.setParams({
                        "message": "Thank for buying! Your Order is processed by the manager. Please wait for approval",
                        "type": "success",
                        "key": "info",
                        "mode": "dismissible"
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        } else {
            toastEvent.setParams({
                "message": "Please add a product to cart before you press tre Submit button",
                "type": "warning",
                "key": "info",
                "mode": "dismissible"
            });
            toastEvent.fire();
        }
    },
})