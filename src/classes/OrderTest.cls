

@isTest
private class OrderTest {
    @isTest
    static void test_handleAfterInsertUpdate() {

        Order__c order = new Order__c(Status__c = 'Open');
        insert order;

        Product__c product = new Product__c(Name = 'Test Product',
                Description__c = 'Test Description', Price__c = 10000, Total_Inventory__c = 5);
        insert product;

        Product_Order__c productOrder = new Product_Order__c(Product__c = product.Id,
                Order__c = order.Id, Quantity__c = 2);
        insert productOrder;

        Test.startTest();

        try {
            order.Status__c = 'Pending';
            update order;
            order.Status__c = 'Closed';
            update order;
            // test

        } catch (DmlException e) {
            System.debug(e.getMessage());
        }

        Test.stopTest();

        List<Product__c> testProducts = new List<Product__c>([
                SELECT Total_Inventory__c
                FROM Product__c
                WHERE Name = : product.Name
        ]);

        System.debug('=================== ' + testProducts[0].Total_Inventory__c);
        System.assertEquals(3, testProducts[0].Total_Inventory__c);

    }
}