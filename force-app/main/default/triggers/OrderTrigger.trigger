trigger OrderTrigger on OrderItem__c (before insert) {
    if (Trigger.isInsert && Trigger.isBefore) {
        OrderProcessing.orderProcess(new List<OrderItem__c>(Trigger.new));
        IngredientAmountValidation.IngredientAmountValidation(Trigger.new);
    }
}