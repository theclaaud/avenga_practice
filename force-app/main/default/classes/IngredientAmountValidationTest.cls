@isTest
public class IngredientAmountValidationTest {
    @isTest
    static void testIngredientAmountValidation() {
        RecipeItem__c testRecipeItem = new RecipeItem__c(Ingredient__c = 'a010700000ARBlmAAH', Quantity__c = 5,Unit__c = 'Gram', Recipe__c = 'a030700000FGIvuAAH');
        insert testRecipeItem;

        OrderItem__c testOrderItem = new OrderItem__c(Recipe__c = testRecipeItem.Recipe__c, Quantity__c = 2);
        insert testOrderItem;

        Storage__c testStorage = new Storage__c(Ingredient__c = testRecipeItem.Ingredient__c, BeginQuantity__c = 10, UsedQuantity__c = 5, WorkShift__c = 'a0007000004dLnCAAU');
        insert testStorage;

        Test.startTest();
        List<OrderItem__c> testOrderItemsList = [SELECT Id, Recipe__c, Quantity__c FROM OrderItem__c WHERE Id = :testOrderItem.Id];
        if (!testOrderItemsList.isEmpty()) {
            IngredientAmountValidation.IngredientAmountValidation(testOrderItemsList);
        }
        Test.stopTest();

        System.assertEquals(15, testStorage.UsedQuantity__c, 'UsedQuantity should be updated');
    }
}
