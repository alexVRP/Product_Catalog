@IsTest
private class MyOrdersControllerTest {


    @IsTest
    static void test_getOrders() {

        Order__c order = new Order__c(Status__c = 'Open');
        insert order;

        Product__c product = new Product__c(Name = 'Test Product',
                Description__c = 'Test Description', Price__c = 10, Total_Inventory__c = 5);
        insert product;

        Product_Order__c productOrder = new Product_Order__c(Product__c = product.Id,
                Order__c = order.Id, Quantity__c = 2);
        insert productOrder;

        Test.startTest();

        List<Order__c> lstOrderResult = new List<Order__c>();

        lstOrderResult = MyOrdersController.getOrders();

        Test.stopTest();

        System.debug('=================== ' + lstOrderResult);
        System.assertNotEquals(null, lstOrderResult);

    }

    @IsTest
    static void test_getUserName() {
        String user;

        Test.startTest();

        user = MyOrdersController.fetchUserName();

        Test.stopTest();

        System.debug('=================== ' + user);
        System.assertNotEquals(null, user);


    }
}