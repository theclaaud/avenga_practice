trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert, before update, before delete) {
	System.debug('@@@ ContentDocumentLink phase: ' + Trigger.operationType);
}