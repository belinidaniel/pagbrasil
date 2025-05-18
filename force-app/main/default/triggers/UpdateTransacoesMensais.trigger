trigger UpdateTransacoesMensais on Opportunity (before insert, before update) {
    for (Opportunity opp : Trigger.new) {
        if (opp.previs_fat_rs__c == 0 || opp.AverageSalesTicket__c == 0 || opp.previs_fat_rs__c == null || opp.AverageSalesTicket__c == null) {
            opp.Transacoes_Mensais__c = 0;
        } else {
            opp.Transacoes_Mensais__c = Math.round(opp.previs_fat_rs__c / opp.AverageSalesTicket__c);
        }
    }
}