
@isTest
private class ProductsControllerTest {

    @isTest
    static void test_getProducts() {

        Category__c testCategory = new Category__c(Name = 'Test Category');
        insert testCategory;

        Product__c testProduct = new Product__c(Name = 'Test Product',
                Description__c = 'Test Description ', Price__c = 10, Total_Inventory__c = 5);
        insert testProduct;

        Product_Category__c testProductCategory = new Product_Category__c(Category__c = testCategory.Id,
                Product__c = testProduct.Id);
        insert testProductCategory;

        Order__c testOrder = new Order__c(Status__c = 'Open');
        insert testOrder;

        Product_Order__c testProductOrder = new Product_Order__c(Product__c = testProduct.Id,
                Order__c = testOrder.Id, Quantity__c = 2);
        insert testProductOrder;


        Test.startTest();

        String lstCategoryResult;

        Id id;

        lstCategoryResult = ProductsController.getCategory(id);
        system.debug('=================== ' + lstCategoryResult);
        System.assertNotEquals(null, lstCategoryResult);

        Id recordId = testOrder.Id;

        lstCategoryResult = ProductsController.getCategory(recordId);
        system.debug('=================== ' + lstCategoryResult);
        System.assertNotEquals(null, lstCategoryResult);

        Test.stopTest();
    }


    @isTest
    static void test_addProduct() {

        Order__c testOrder = new Order__c();
        insert testOrder;
        Id recordId = testOrder.Id;

        Product__c testProduct = new Product__c(Name = 'Test Product',
                Description__c = 'Test Description', Price__c = 10, Total_Inventory__c = 15);
        insert testProduct;
        Id productId = testProduct.Id;

        Integer total = 5;

        Test.startTest();

        Id id;
        id = ProductsController.addProduct(productId, recordId, total);
        System.assertNotEquals(null, id);

        id = ProductsController.addProduct(productId, null, total);
        System.assertNotEquals(null, id);

        Test.stopTest();
    }

    @isTest
    static void test_removeProduct() {

        Order__c testOrder1 = new Order__c();
        insert testOrder1;
        Id recordId = testOrder1.Id;

        Product__c testProduct1 = new Product__c(Name = 'Test Product1',
                Description__c = 'Test Description', Price__c = 10, Total_Inventory__c = 15);
        insert testProduct1;
        Id productId1 = testProduct1.Id;

        Product__c testProduct2 = new Product__c(Name = 'Test Product2',
                Description__c = 'Test Description', Price__c = 10, Total_Inventory__c = 15);
        insert testProduct2;
        Id productId2 = testProduct2.Id;

        Product_Order__c testProductOrder1 = new Product_Order__c(Product__c = testProduct1.Id,
                Order__c = testOrder1.Id, Quantity__c = 5);
        insert testProductOrder1;

        Product_Order__c testProductOrder2 = new Product_Order__c(Product__c = testProduct2.Id,
                Order__c = testOrder1.Id, Quantity__c = 5);
        insert testProductOrder2;

        Test.startTest();

        Id id;
        id = ProductsController.removeProduct(productId1, recordId);
        System.assertNotEquals(null, id);

        id = ProductsController.removeProduct(productId2, recordId);
        System.assertEquals(null, id);

        Test.stopTest();
    }

    @isTest
    static void test_submitOrderApproval() {

        Order__c testOrder = new Order__c();
        insert testOrder;

        Id recordId1 = testOrder.Id;

        Test.startTest();

        ProductsController.submitOrderApproval(recordId1);

        Test.stopTest();
    }
}