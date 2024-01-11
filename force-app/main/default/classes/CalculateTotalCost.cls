public class CalculateTotalCost {
    // public static void updateTotalCost(Set<Id> orderIds) {
    //     List<Order__c> ordersToUpdate = [SELECT Id, TotalCost__c, (SELECT Cost__c FROM OrderItems__r) FROM Order__c WHERE Id IN :orderIds];
    //     Map<Id, Decimal> costOrders = new Map<Id, Decimal>();

    //     for (Order__c order : ordersToUpdate) {
    //         Decimal totalCost = 0;

    //         for (OrderItem__c orderItem : order.OrderItems__r) {
    //             totalCost += orderItem.Cost__c;
    //         }

    //         costOrders.put(order.Id, totalCost);
    //     }

    //     List<Order__c> ordersToUpdateAsync = new List<Order__c>();

    //     for (Order__c order : ordersToUpdate) {
    //         if (order.TotalCost__c != costOrders.get(order.Id)) {
    //             order.TotalCost__c = costOrders.get(order.Id);
    //             ordersToUpdateAsync.add(order);
    //         }
    //     }

    //     if (!ordersToUpdateAsync.isEmpty()) {
    //         try {
    //             update ordersToUpdateAsync;
    //         } catch (Exception e) {
    //             System.debug('Error updating orders: ' + e.getMessage());
    //         }
    //     }
    // }
}