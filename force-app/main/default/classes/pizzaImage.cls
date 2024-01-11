public with sharing class pizzaImage {
     @AuraEnabled
    public static List<Recipe__c> getOrderItems(Id recordId) {
        List<Recipe__c> dataResult = [SELECT Name, Pizza_img__c FROM Recipe__c];
        return dataResult;
    }
}