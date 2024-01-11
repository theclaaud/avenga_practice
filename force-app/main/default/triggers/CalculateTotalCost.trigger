trigger CalculateTotalCost on OrderItem__c (after insert, after update) {
    Set<Id> orderIdsToUpdate = new Set<Id>();

    if ((Trigger.isInsert || Trigger.isUpdate) && Trigger.new != null) {
        for (OrderItem__c orderItem : Trigger.new) {
            orderIdsToUpdate.add(orderItem.Order__c);
        }
    }

    if (!orderIdsToUpdate.isEmpty()) {
        List<Order__c> ordersToUpdate = [SELECT Id, (SELECT Cost__c FROM OrderItems__r) FROM Order__c WHERE Id IN :orderIdsToUpdate];
        Map<Id, Decimal> costOrders = new Map<Id, Decimal>();

        for (Order__c order : ordersToUpdate) {
            Decimal totalCost = 0;

            for (OrderItem__c orderItem : order.OrderItems__r) {
                totalCost += orderItem.Cost__c;
            }

            costOrders.put(order.Id, totalCost);
        }

        for (Order__c order : ordersToUpdate) {
            order.TotalCost__c = costOrders.get(order.Id);
        }

        TriggerContext.isInCalculateTotalCostContext = true;

        update ordersToUpdate;

        TriggerContext.isInCalculateTotalCostContext = false;
    }
}