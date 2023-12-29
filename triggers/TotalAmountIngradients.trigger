trigger TotalAmountIngradients on Order__c (before update) {
    IngradientTotalAmount.IngradientTotalAmount(Trigger.new);
}