public class IngradientTotalAmount {
    public static void IngradientTotalAmount(List<Order__c> orderIds) {
        Set<Id> incomingOrderIds = new Set<Id>();

        for (Order__c order_t : orderIds) {
            if (order_t.Status__c == 'Cooking') {
                incomingOrderIds.add(order_t.Id);
            }
        }
    
        if (!incomingOrderIds.isEmpty()) {
            // get orders
            List<OrderItem__c> orderItems = [SELECT Recipe__c, Quantity__c, Order__r.WorkShift__c FROM OrderItem__c WHERE Order__c IN :incomingOrderIds];
            List<OrderIngredient__c> orderIngredients = [SELECT Ingredient__c, Quantity__c, Order__r.WorkShift__c FROM OrderIngredient__c WHERE Order__c IN :incomingOrderIds];

            // orders recipes and workshifts
            Map<Id,Decimal> recipeQuantitys = new Map<Id,Decimal>();
            Map<Id,Id> recipeWorkshifts = new Map<Id,Id>();

            // put quantity and workshifts to map
            if (!orderItems.isEmpty()) {
                for (OrderItem__c orderItem: orderItems){
                    recipeQuantitys.put(orderItem.Recipe__c,orderItem.Quantity__c);
                    recipeWorkshifts.put(orderItem.Recipe__c, orderItem.Order__r.WorkShift__c);
                }

                // calculacting quantity summ and save in map
                Map<Id,Decimal> ingredientQuantities = new Map<Id,Decimal>();
                for (RecipeItem__c recipe: [SELECT Ingredient__c, Quantity__c, Recipe__c FROM RecipeItem__c WHERE Recipe__c IN :recipeQuantitys.keySet()]){
                    if (ingredientQuantities.get(recipe.Ingredient__c) != null){
                        ingredientQuantities.put(recipe.Ingredient__c,ingredientQuantities.get(recipe.Ingredient__c)+recipe.Quantity__c*recipeQuantitys.get(recipe.Recipe__c));
                    }else{
                        ingredientQuantities.put(recipe.Ingredient__c,recipe.Quantity__c*recipeQuantitys.get(recipe.Recipe__c));
                    }
                }
                // add order ingredients to map
                for (OrderIngredient__c ingredient: orderIngredients){
                    if (ingredientQuantities.get(ingredient.Ingredient__c) != null){
                        ingredientQuantities.put(ingredient.Ingredient__c,ingredientQuantities.get(ingredient.Ingredient__c)+ingredient.Quantity__c);
                    }else{
                        ingredientQuantities.put(ingredient.Ingredient__c,ingredient.Quantity__c);
                    }
                }
                
                
                // get storage and take ingredients from storage
                List<Storage__c> storageToUpdate = new List<Storage__c>();

                Map<Id, Storage__c> storages = new Map<Id, Storage__c>();
                for(Storage__c storage: [SELECT Ingredient__c, BeginQuantity__c, UsedQuantity__c FROM Storage__c WHERE WorkShift__c IN :recipeWorkshifts.values()]){
                    storages.put(storage.Ingredient__c,storage);
                }

                for (Id ingredient: ingredientQuantities.keySet()){
                    if (storages.get(ingredient) != null){
                        if (ingredientQuantities.get(ingredient)+storages.get(ingredient).UsedQuantity__c < storages.get(ingredient).BeginQuantity__c){
                            Decimal newQuantity = storages.get(ingredient).UsedQuantity__c+ingredientQuantities.get(ingredient);
    
                            storages.get(ingredient).UsedQuantity__c = newQuantity;
                            storageToUpdate.add(storages.get(ingredient));
                        }else{
                            throw new MyException('not enough ingredients in storage');
                        }
                    }else{
                        throw new MyException('not enough ingredients in storage');
                    }
                }

                if (!storageToUpdate.isEmpty()) {
                    update storageToUpdate;
                }
            }
        }
    }
    public class MyException extends Exception {}
}