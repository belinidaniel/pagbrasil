trigger QuoteLineItemTrigger on QuoteLineItem (before update) {
  
    Set<Id> quoteIds = new Set<Id>();
    for (QuoteLineItem qli : Trigger.new) {
        quoteIds.add(qli.QuoteId);
    }
    
    
    Map<Id, Quote> quoteMap = new Map<Id, Quote>([SELECT Id, IsSyncing FROM Quote WHERE Id IN :quoteIds]);
    
 
    for (QuoteLineItem qli : Trigger.new) {
        Quote relatedQuote = quoteMap.get(qli.QuoteId);
        if (relatedQuote != null && relatedQuote.IsSyncing) {
            qli.addError('Stop syncing to release editing of opportunity products and quote line items');
        }
    }
}