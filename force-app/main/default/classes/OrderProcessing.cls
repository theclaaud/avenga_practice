public class OrderProcessing {

    public static void orderProcess(List<OrderItem__c> newOrderItems) {
        Set<Id> recipeIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        for (OrderItem__c newOrderItem : newOrderItems) {
            recipeIds.add(newOrderItem.Recipe__c);
            orderIds.add(newOrderItem.Order__c);
        }
        
        List<OrderItem__c> existingOrders = [SELECT Recipe__c, Quantity__c, Order__c FROM OrderItem__c WHERE Recipe__c IN :recipeIds AND Order__c IN: orderIds ];
        Map<Id, Map<Id, OrderItem__c>> receiptsToOrder= new Map<Id, Map<Id, OrderItem__c>>();
        List<OrderItem__c> itemsToDelete = new List<OrderItem__c>();
        List<OrderItem__c> itemsToUpdate = new List<OrderItem__c>();

        for (OrderItem__c existingOrder : existingOrders) {
            if (!receiptsToOrder.containsKey(existingOrder.Recipe__c)) {
                receiptsToOrder.put(existingOrder.Recipe__c, new Map<Id, OrderItem__c>());
            }
            receiptsToOrder.get(existingOrder.Recipe__c).put(existingOrder.Order__c, existingOrder);
        }

        for (OrderItem__c newOrderItem : newOrderItems) {
            Id orderId = newOrderItem.Order__c;
            Id recipeId = newOrderItem.Recipe__c;
            if (receiptsToOrder.containsKey(recipeId) && receiptsToOrder.get(recipeId).containsKey(orderId)) {
                OrderItem__c existingOrder = receiptsToOrder.get(recipeId).get(orderId);
                newOrderItem.Quantity__c += existingOrder.Quantity__c;
                itemsToDelete.add(existingOrder);
            }
        }

        if (!itemsToDelete.isEmpty()) {
            delete itemsToDelete;
        }
    }
}