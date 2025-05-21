trigger KYCTrigger on KYC__c (before update) {
    for (KYC__c record : Trigger.new) {
        KYC__c oldRecord = Trigger.oldMap.get(record.Id);

        if (record.Store_URL__c != oldRecord.Store_URL__c) {
            if (String.isNotBlank(record.Store_URL__c)) {
                List<String> rawUrls = record.Store_URL__c.split(';');
                List<String> cleanedUrls = new List<String>();

                for (String url : rawUrls) {
                    String trimmed = url.trim();
                    if (!String.isEmpty(trimmed)) {
                        cleanedUrls.add(trimmed);
                    }
                }

                record.URLs_Quantity__c = cleanedUrls.size();
            } else {
                record.URLs_Quantity__c = 0;
            }
        }
    }
}