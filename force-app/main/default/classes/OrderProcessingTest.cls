@isTest
public class OrderProcessingTest {

    @isTest
    static void testOrderProcess() {

        Recipe__c testRecipe = new Recipe__c(PizzaSize__c = '30 cm');  
        Order__c testOrder = new Order__c();
        
        insert testRecipe;
        insert testOrder;

        OrderItem__c newOrderItem = new OrderItem__c(
            Recipe__c = testRecipe.Id,
            Order__c = testOrder.Id,
            Quantity__c = 10 
        );

        
        Test.startTest();

        insert newOrderItem;

        Test.stopTest();

        OrderItem__c secondNewItem = new OrderItem__c(
            Recipe__c = testRecipe.Id,
            Order__c = testOrder.Id,
            Quantity__c = 5
        );

        insert secondNewItem;


        List<OrderItem__c> newOrderItems = [SELECT Id, Quantity__c FROM OrderItem__c WHERE Id = :newOrderItem.Id];
        System.assertEquals(10, newOrderItem.Quantity__c, 'Quantity__c should remain the same if no matching existing order');

        List<OrderItem__c> newAddedItems = [SELECT Id, Quantity__c FROM OrderItem__c WHERE Order__c = :testOrder.Id AND Recipe__c = :testRecipe.Id];
        System.assertEquals(15, newAddedItems[0].Quantity__c, 'Total quantity should be the sum of the two items');
    }

}