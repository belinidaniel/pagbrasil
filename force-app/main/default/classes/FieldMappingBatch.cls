global class FieldMappingBatch implements Database.Batchable<sObject> {
    private String objectName;
    private String sourceField;
    private String targetField;
    
    public FieldMappingBatch(String objectName, String sourceField, String targetField) {
        this.objectName = objectName;
        this.sourceField = sourceField;
        this.targetField = targetField;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, ' + sourceField + ' FROM ' + objectName);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<sObject> recordsToUpdate = new List<sObject>();
        
        for (sObject record : scope) {
            record.put(targetField, record.get(sourceField));
            recordsToUpdate.add(record);
        }

        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
    }

    global void finish(Database.BatchableContext BC) {}
}