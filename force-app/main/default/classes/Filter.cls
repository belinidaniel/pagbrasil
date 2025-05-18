/**
 * @description       : 
 * @author            : Hersilio Belini de Oliveira
 * @group             : 
 * @last modified on  : 2024-10-23
 * @last modified by  : Hersilio Belini de Oliveira
**/
public virtual without sharing class Filter {

    /**
     * Filter newRecords by Changed field with specific Value
     * @param  newRecords  Trigger.new
     * @param  oldRecords  Trigger.oldMap
     * @param  changedField
     * @param  changedValue
     * @return filtered records
     */
    public List<SObject> relevantChangeRecordsFilter (List<SObject> newRecords, Map<Id, SObject> oldRecords, String changedField, String changedValue) { //NOPMD

        List<SObject> changedRecords = relevantChangeRecordsFilter (newRecords, oldRecords, new String[] {changedField} );

        List<SObject> changedRecordsWithValue = new List<SObject>();

        for (SObject record : changedRecords ) {

            String recordValue = '' + record.get(changedField);
            String receivedValue = '' + changedValue;

            if ( recordValue == receivedValue ) {
                changedRecordsWithValue.add(record);
            }


        }

        return changedRecordsWithValue;

    }

    /**
     * Provide helper method to filter change by relevant fields
     * @author ercarval
     * @param  newRecords    Trigger.new
     * @param  oldRecords    Trigger.oldMap
     * @param  changedFiedls changeableField separed by comma
     * @return New List of Only Relevant changes
     */
    public List<SObject> relevantChangeRecordsFilter (List<SObject> newRecords
            , Map<Id, SObject> oldRecords
            , List<String> changedFiedls ) {

        List<SObject> relevantChanges = new List<SObject>();

        if ( newRecords == null || newRecords.isEmpty() ) return relevantChanges;

        if ( oldRecords == null || oldRecords.isEmpty() ) return newRecords;

        for ( SObject record : newRecords  ) {

            SObject oldRecord = oldRecords.get( (Id) record.get('Id') ) ;

            if ( hasRelevantChanges (record, oldRecord, changedFiedls) ) {
                relevantChanges.add (record);
            }

        }

        return relevantChanges;

    }


    private boolean hasRelevantChanges (SObject changed , SObject old , List<String> changedFiedls ) {

        //is new
        if (old == null) return true;

        for (String field : changedFiedls) {

            if ( changed.get(field)  !=  old.get(field) ) return true;

        }

        return false;
    }
}