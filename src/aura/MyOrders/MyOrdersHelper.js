({

    showHelper: function (component, event) {
        var action = component.get("c.getOrders");
        action.setCallback(this, function (response) {
            var returnValue = response.getReturnValue();
            component.set("v.searchResult", returnValue);

            this.fetchUser(component);
            this.getCurrentDate(component);
        });
        $A.enqueueAction(action);

    },

    fetchUser : function(component) {
        var action = component.get("c.fetchUserName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                component.set("v.userInfo", returnValue);
//                console.log(returnValue);
            }
        });
        $A.enqueueAction(action);
    },

    getCurrentDate : function (component) {
        var today = new Date();
        var monthDigit = today.getUTCMonth() + 1;
        if (monthDigit <= 9) {
            monthDigit = '0' + monthDigit;
        }
        var dayDigit = today.getUTCDate();
        if(dayDigit <= 9){
            dayDigit = '0' + dayDigit;
        }
        var hoursDigit = today.getUTCHours();
        if(hoursDigit <= 9){
            hoursDigit = '0' + hoursDigit;
        }
        var minutesDigit = today.getUTCMinutes();
        if(minutesDigit <= 9){
            minutesDigit = '0' + minutesDigit;
        }
        component.set('v.currentDate',  monthDigit + "/" + dayDigit+ "/" + today.getUTCFullYear()
            + " " + hoursDigit + ":" + minutesDigit + " UTC");
    }

})