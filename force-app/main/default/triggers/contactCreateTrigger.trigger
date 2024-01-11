trigger contactCreateTrigger on Order__c (before insert) {
       ContactService.createContact(Trigger.new);
}