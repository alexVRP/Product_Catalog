public with sharing class MyOrdersController {
    @AuraEnabled
    public static List<Order__c> getOrders() {
        return [
                Select Id, Name, Order_Amount__c, CreatedDate, OwnerId, Status__c, (
                        SELECT Name, Product__r.Name, Quantity__c, Total_Price__c, Total_Price_With_Discount__c,
                                Unit_Price__c, Discount__c, CreatedDate
                        FROM Product_Orders__r
                )
                From Order__c
                WHERE OwnerId = :UserInfo.getUserId()
        ];
    }

    @AuraEnabled
    public static String fetchUserName() {
        return UserInfo.getName();
    }
}