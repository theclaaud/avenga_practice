public with sharing class pizzaOrderI {
    @AuraEnabled
    public static List<OrderItem__c> getOrderItems(Id recordId) {
        List<OrderItem__c> result = [SELECT Id, Recipe__r.PizzaSize__c, Quantity__c
                                     FROM OrderItem__c 
                                     WHERE Order__c = :recordId];
        return result;
    }
}