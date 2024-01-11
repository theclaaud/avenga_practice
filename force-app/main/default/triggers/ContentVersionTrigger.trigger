trigger ContentVersionTrigger on ContentVersion (before insert, before update) {
    System.debug('@@@ ContentVersion phase: ' + Trigger.operationType);
}