trigger ContentDocumentTrigger on ContentDocument (before insert, before update, before delete) {
	System.debug('@@@ ContentDocument phase: ' + Trigger.operationType);
    if (Trigger.isDelete) {
        for (ContentDocument doc : Trigger.old) {
            List<ContentDocumentLink> links = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :doc.Id];
            for (ContentDocumentLink link : links) {
                System.debug('@@@ LinkedEntityId = ' + link.LinkedEntityId);
            }            
        }

    }
}