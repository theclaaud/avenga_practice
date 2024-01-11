public class IngredientAmountValidation {
    public static void IngredientAmountValidation(List<OrderItem__c> orderIds) {
        Map<Id, OrderItem__c> incomingOrders = new Map<Id, OrderItem__c>();
        for (OrderItem__c order_t : orderIds) {
            incomingOrders.put(order_t.Recipe__c, order_t);
        }
    
        if (!incomingOrders.isEmpty()) {
            Map<Id,Decimal> ingredientQuantities = new Map<Id,Decimal>();
            for (RecipeItem__c recipe: [SELECT Ingredient__c, Quantity__c, Recipe__c FROM RecipeItem__c WHERE Recipe__c IN :incomingOrders.keySet()]){
                if (ingredientQuantities.get(recipe.Ingredient__c) != null){
                    ingredientQuantities.put(recipe.Ingredient__c,ingredientQuantities.get(recipe.Ingredient__c)+recipe.Quantity__c*incomingOrders.get(recipe.Recipe__c).Quantity__c);
                }else{
                    ingredientQuantities.put(recipe.Ingredient__c,recipe.Quantity__c*incomingOrders.get(recipe.Recipe__c).Quantity__c);
                }
            }
            
            Map<Id, Storage__c> storages = new Map<Id, Storage__c>();
            List<Id> storageWorkshifts = new List<Id>();

            Map<Id, Id> ordersIds = new Map<Id, Id>();
            for (Id order: incomingOrders.keySet()){
                OrderItem__c orderId = incomingOrders.get(order);
                ordersIds.put(orderId.Recipe__c, orderId.Order__c);
            }
            for (Order__c order: [SELECT WorkShift__c FROM Order__c WHERE Id IN :ordersIds.values()]){
                storageWorkshifts.add(order.WorkShift__c);
            }

            for(Storage__c storage: [SELECT Ingredient__c, BeginQuantity__c, UsedQuantity__c FROM Storage__c WHERE WorkShift__c IN :storageWorkshifts]){
                storages.put(storage.Ingredient__c,storage);
            }

            for (Id ingredient: ingredientQuantities.keySet()){
                if (storages.get(ingredient) != null){
                    if (ingredientQuantities.get(ingredient)+storages.get(ingredient).UsedQuantity__c < storages.get(ingredient).BeginQuantity__c){
                        Decimal newQuantity = storages.get(ingredient).UsedQuantity__c+ingredientQuantities.get(ingredient);
                    }else{
                        throw new MyException('not enough ingredients in storage');
                    }
                }else{
                    throw new MyException('not enough ingredients in storage');
                }
            }
        }
    }
    public class MyException extends Exception {}
}