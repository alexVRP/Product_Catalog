public with sharing class ProductsController {

    private class CategoryResult {
        public Category__c category;
        public Boolean isShow;
        public List<ProductResult> productItems;

        public CategoryResult(Category__c category, Map<Id, Integer> productOrdersMap) {
            this.category = category;
            this.isShow = false;
            this.productItems = new List<ProductResult>();
            if (category.Product_Categories__r != null && !category.Product_Categories__r.isEmpty()) {
                for (Product_Category__c productCat : category.Product_Categories__r) {
                    this.productItems.add(new ProductResult((Product__c) productCat.getSObject('Product__r'), productOrdersMap.get(productCat.Product__c)));
                }
            }
        }
    }

    private class ProductResult {
        public Boolean state;
        public Integer total;
        public Product__c product;

        public ProductResult(Product__c product, Integer total) {
            this.total = (total != null) ? total : 0;
            this.product = product;
            this.state = (total != null) ? false : true;
        }
    }


    @AuraEnabled
    public static String getCategory(Id recordId) {

        List<CategoryResult> result = new List<CategoryResult>();
        Map<Id, Integer> productOrdersMap = new Map<Id, Integer>();

        for (Product_Order__c productOrder : [
                SELECT Quantity__c, Product__c
                FROM Product_Order__c
                WHERE Order__c = :recordId
        ]) {
            productOrdersMap.put(productOrder.Product__c, productOrder.Quantity__c.intValue());
        }

        if (recordId != null) {
            for (Category__c category : [
                    SELECT Id, Name, (
                            SELECT Product__r.Name, Product__r.Description__c, Product__r.Price__c, Product__r.Total_Inventory__c
                            FROM Product_Categories__r
                    )
                    FROM Category__c
            ]) {
                result.add(new CategoryResult(category, productOrdersMap));
            }
        } else {
            for (Category__c category : [
                    SELECT Id, Name, (
                            SELECT Product__r.Name, Product__r.Description__c, Product__r.Price__c, Product__r.Total_Inventory__c
                            FROM Product_Categories__r
                    )
                    FROM Category__c
            ]) {
                result.add(new CategoryResult(category, productOrdersMap));
            }
        }
        return JSON.serialize(result);
    }


    @AuraEnabled
    public static Id addProduct(Id productId, Id recordId, Integer total) {

        Order__c order;

        if (recordId != null) {
            order = [SELECT Id FROM Order__c WHERE Id = :recordId];
        } else {
            order = new Order__c();
            try {
                if (Schema.sObjectType.Order__c.isCreateable())
                    insert order;
            } catch (DmlException e) {
                throw new AuraHandledException('Unable to create record: ' + e.getMessage());
//                System.debug(e.getMessage());
            }
        }


        Product_Order__c productOrder = new Product_Order__c(Product__c = productId, Order__c = order.id, Quantity__c = total);
        try {
            if (Schema.sObjectType.Order__c.isCreateable())
                insert productOrder;
        } catch (DmlException e) {
            throw new AuraHandledException('Unable to create record: ' + e.getMessage());
//            System.debug(e.getMessage());
        }
        return order.Id;
    }


    @AuraEnabled
    public static Id removeProduct(Id productId, Id recordId) {

        List<Product_Order__c> lstProductOrdersToDelete = [
                SELECT Id, Product__c, Order__c
                FROM Product_Order__c
                WHERE Product__c = :productId
                AND Order__c = :recordId
        ];

        try {
            if (Schema.sObjectType.Order__c.isDeletable())
                delete lstProductOrdersToDelete;
        } catch (DmlException e) {
            throw new AuraHandledException('Unable to delete record: ' + e.getMessage());
//            System.debug(e.getMessage());
        }

        List<Product_Order__c> lstProductOrdersToCheck = [
                SELECT Id
                FROM Product_Order__c
                WHERE Order__c = :recordId
        ];

        if (lstProductOrdersToCheck != null && !lstProductOrdersToCheck.isEmpty()) {
            return recordId;
        } else {
            List<Order__c> lstOrdersToDelete = [
                    SELECT Id
                    FROM Order__c
                    WHERE Id = :recordId
            ];
            try {
                if (Schema.sObjectType.Order__c.isDeletable()) {
                    delete lstOrdersToDelete;
                    return null;
                }
            } catch (DmlException e) {
                throw new AuraHandledException('Unable to delete record: ' + e.getMessage());
//                System.debug(e.getMessage());
            }
        }
        return null;
    }

    @AuraEnabled
    public static void submitOrderApproval(Id recordId) {
        System.debug(recordId);

        List<Order__c> lstOrdersToApprove = [
                SELECT Id, Status__c
                FROM Order__c
                WHERE Id = :recordId
        ];

        try {
            for (Order__c order : lstOrdersToApprove) {
                order.Status__c = 'Pending';
                if (Schema.sObjectType.Order__c.isUpdateable())
                    update order;
                System.debug(order.Status__c);
            }
        } catch (DmlException e) {
            throw new AuraHandledException('Unable to update record: ' + e.getMessage());
//            System.debug(e.getMessage());
        }
    }
}