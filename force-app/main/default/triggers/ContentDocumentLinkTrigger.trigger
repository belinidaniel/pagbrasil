trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
			//ContentDocumentLinkHandler.afterInsert(Trigger.newMap);
        }     
    }
}