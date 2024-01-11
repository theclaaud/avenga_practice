trigger totalcost_Edits on Order__c (before insert, before update) {
    for (Order__c record : Trigger.new) {
        if (record.TotalCost__c != null && Trigger.isUpdate) {
    Order__c oldRecord = Trigger.oldMap.get(record.Id);

    if (record.TotalCost__c != oldRecord.TotalCost__c && !TriggerContext.isInCalculateTotalCostContext) {
        record.TotalCost__c.addError('Редагування поля "TotalCost__c" заборонено.');
    }
}
        }
    }