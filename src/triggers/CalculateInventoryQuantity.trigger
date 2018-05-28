
trigger CalculateInventoryQuantity on Order__c (after insert, after update) {

    Set<Id> ordIds = new Set<Id>();
    Set<Id> prodIds = new Set<Id>();

    if (Trigger.isUpdate || Trigger.isInsert) {
        for (Order__c order : Trigger.new) {
            if (Trigger.newMap.get(order.Id).Status__c == 'Closed') {
                ordIds.add(order.Id);
            }
        }

        List<Product_Order__c> lstProductsOrders = new List<Product_Order__c>([
                SELECT Product__r.Total_Inventory__c, Quantity__c
                FROM Product_Order__c
                WHERE Order__r.Id IN :ordIds
        ]);

        for (Product_Order__c productOrder : lstProductsOrders) {
            prodIds.add(productOrder.Product__r.Id);
        }

        Map<Id, Product__c> mapProducts = new Map<Id, Product__c>([
                SELECT Product__c.Total_Inventory__c
                FROM Product__c
                WHERE Product__c.Id IN :prodIds
        ]);

        for (Product_Order__c productOrder : lstProductsOrders) {
            mapProducts.get(productOrder.Product__r.Id).Total_Inventory__c -= productOrder.Quantity__c;
        }
        update mapProducts.values();
    }
}

