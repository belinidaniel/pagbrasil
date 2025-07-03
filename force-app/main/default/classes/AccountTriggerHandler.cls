public class AccountTriggerHandler {
    public static void handleBeforeInsert(List<Account> newAccounts) {
        for (Account acc : newAccounts) {
            if (acc.Lead_Expected_Record_Type__c == 'Nacional (NB)') {
                acc.Type = 'Nacional (NB)';
            } else if (acc.Lead_Expected_Record_Type__c == 'Cross Border (XB)') {
                acc.Type = 'Cross Border (XB)';
            }
        }
    }

    public static void handleUpdate(List<Account> newAccounts, Map<Id, Account> oldMap) {
        if (RecursionControl.isAccountTriggerRunning) return;
        RecursionControl.isAccountTriggerRunning = true;
        
        List<Opportunity> newOpportunities = new List<Opportunity>();
        Set<Id> accountIds = new Set<Id>();
        
        for(Account acc : newAccounts) {
            if(acc.Type != oldMap.get(acc.Id).Type) {
            	accountIds.add(acc.Id);
            }
        }
        
        if(!accountIds.isEmpty()) {
            String query = 'SELECT ' + String.join(getAllOpportunityFields(), ',') + 
                         ' FROM Opportunity WHERE AccountId IN :accountIds ORDER BY CreatedDate DESC';
            
            Map<Id, Opportunity> lastOppsMap = new Map<Id, Opportunity>();
            for(Opportunity opp : Database.query(query)) {
                if(!lastOppsMap.containsKey(opp.AccountId)) {
                    lastOppsMap.put(opp.AccountId, opp);
                }
            }
            
            for(Account acc : newAccounts) {
                if(acc.Type != oldMap.get(acc.Id).Type) {
                    Opportunity templateOpp = lastOppsMap.get(acc.Id);
                    
                    Lead sourceLead = [
                        SELECT
                            Use_One_Click_Pix__c,
                            Ag_ncia__c,
                            Anticipation__c,
                            Use_Apple_Pay__c,
                            AtendimentoWhatsApp__c,
                            AverageSalesTicket__c,
                            Boleto_Share__c,
                            Business_Model_Type__c,
                            CheckoutTransparente__c,
                            LinkedIn__c,
                            LinkedInContato__c,
                            Cartao_Credito_Mensal__c,
                            Integracao__c,
                            DataAgendamento__c,
                            Data_de_indicacao__c,
                            Cartao_Debito_Mensal__c,
                            Desired_Business_Model__c,
                            Descricao_Empresa__c,
                            Filial_no_Brasil_c__c,
                            Use_Google_Pay__c,
                            Segmento__c,
                            SeguidoresInstagram__c,
                            Integration_Type__c,
                            LossReason__c,
                            Mensagem__c,
                            Receita_Mensal__c,
                            Metodos_Pagamento__c,
                            NotaReclameAqui__c,
                            Monthly_Transactions__c,
                            Operacao__c,
                            Use_Pagshield__c,
                            Use_Pagshield_Premium__c,
                            Use_Pagshield_Premium_on_Demand__c,
                            Use_Pagstream__c,
                            Payment_Methods__c,
                            Use_Payout__c,
                            PixMensal__c,
                            PIXmanualOuQRCode__c,
                            Possui_CNPJ__c,
                            Product_Category__c,
                            Product_or_service_website_URL__c,
                        	Product_Type__c,
                            TeseProspeccao__c,
                            PSP__c,
                            Qualificador__c,
                            Receita_Global__c,
                            Recurring_Payments__c,
                            Sede_da_Empresa__c,
                            Telefone__c,
                            TemAutocompleteCEP__c,
                            TemValidadeCPF__c,
                            previs_fat_rs__c,
                            TPV_Potencial__c,
                            Vender_ao_Brasil__c
                        FROM Lead
                        WHERE IsConverted = true AND ConvertedAccountId = :acc.Id
                        LIMIT 1
                    ];
                    
                    Opportunity newOpp = new Opportunity(
                        PixOneClick__c = sourceLead.Use_One_Click_Pix__c,
                        Ag_ncia__c = sourceLead.Ag_ncia__c,
                        Antecipation__c = sourceLead.Anticipation__c,
                        ApplePay__c = sourceLead.Use_Apple_Pay__c,
                        Atendimento_por_Whatsapp__c = sourceLead.AtendimentoWhatsApp__c,
                        AverageSalesTicket__c = sourceLead.AverageSalesTicket__c,
                        Boleto_Share__c = sourceLead.Boleto_Share__c,
                        BusinessModelType__c = sourceLead.Business_Model_Type__c,
                        CheckoutTransparente__c = sourceLead.CheckoutTransparente__c,
                        LinkedIn__c = sourceLead.LinkedIn__c,
                        LinkedInContato__c = sourceLead.LinkedInContato__c,
                        Cartao_Credito_Mensal__c = sourceLead.Cartao_Credito_Mensal__c,
                        Current_Platform__c = sourceLead.Integracao__c,
                        DataAgendamento__c = sourceLead.DataAgendamento__c,
                        Data_de_indicacao__c = sourceLead.Data_de_indicacao__c,
                        Cartao_Debito_Mensal__c = sourceLead.Cartao_Debito_Mensal__c,
                        BusinessModel__c = sourceLead.Desired_Business_Model__c,
                        Descricao_Empresa__c = sourceLead.Descricao_Empresa__c,
                        PCI_DSS__c = sourceLead.Filial_no_Brasil_c__c,
                        GooglePay__c = sourceLead.Use_Google_Pay__c,
                        Segmento__c = sourceLead.Segmento__c,
                        SeguidoresInstagram__c = sourceLead.SeguidoresInstagram__c,
                        IntegrationType__c = sourceLead.Integration_Type__c,
                        Loss_Reason__c = sourceLead.LossReason__c,
                        Mensagem__c = sourceLead.Mensagem__c,
                        Receita_Mensal__c = sourceLead.Receita_Mensal__c,
                        Metodos_Pagamento__c = sourceLead.Metodos_Pagamento__c,
                        NotaReclameAqui__c = sourceLead.NotaReclameAqui__c,
                        Transacoes_Mensais__c = sourceLead.Monthly_Transactions__c,
                        Operacao__c = sourceLead.Operacao__c,
                        PagShield__c = sourceLead.Use_Pagshield__c,
                        PagShield_Premium__c = sourceLead.Use_Pagshield_Premium__c,
                        PagShield_Premium_On_Demand__c = sourceLead.Use_Pagshield_Premium_on_Demand__c,
                        UsePagstream__c = sourceLead.Use_Pagstream__c,
                        NationalPaymentMethod__c = sourceLead.Payment_Methods__c,
                        Payout__c = sourceLead.Use_Payout__c,
                        PixMensal__c = sourceLead.PixMensal__c,
                        PIXmanualOuQRCode__c = sourceLead.PIXmanualOuQRCode__c,
                        Possui_CNPJ__c = sourceLead.Possui_CNPJ__c,
                        ProductClass__c = sourceLead.Product_Category__c,
                        Product_or_service_website_URL__c = sourceLead.Product_or_service_website_URL__c,
                        Product_Type__c = sourceLead.Product_Type__c,
                        TeseProspeccao__c = sourceLead.TeseProspeccao__c,
                        PSP__c = sourceLead.PSP__c,
                        Qualificador__c = sourceLead.Qualificador__c,
                        Receita_Global__c = sourceLead.Receita_Global__c,
                        PaymentRecurrence__c = sourceLead.Recurring_Payments__c,
                        Sede_da_Empresa__c = sourceLead.Sede_da_Empresa__c,
                        Telefone__c = sourceLead.Telefone__c,
                        TemAutocompliteCEP__c = sourceLead.TemAutocompleteCEP__c,
                        TemValidadeCPF__c = sourceLead.TemValidadeCPF__c,
                        previs_fat_rs__c = sourceLead.previs_fat_rs__c,
                        nb_receita_mensal__c = sourceLead.TPV_Potencial__c,
                        Vender_ao_Brasil__c = sourceLead.Vender_ao_Brasil__c
                    );
                    
                    newOpp.Name = templateOpp.Name;
                    newOpp.StageName = 'Discovery';
                    newOpp.CloseDate = Date.today().addDays(90);
                    newOpp.RecordTypeId = getRecordTypeIdByAccountType(acc.Type);
                    newOpp.AccountId = acc.Id;
                    
                    newOpportunities.add(newOpp);
                }
            }
            
            if(!newOpportunities.isEmpty()) {
                insert newOpportunities;
            }
        }
        
        RecursionControl.isAccountTriggerRunning = false;
    }
    
    @TestVisible
    private static List<String> getAllOpportunityFields() {
        List<String> fields = new List<String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Opportunity.fields.getMap();
        
        for(String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
            if(dfr.isAccessible() && dfr.isCreateable()) {
                fields.add(fieldName);
            }
        }
        return fields;
    }

    @TestVisible
    private static Id getRecordTypeIdByAccountType(String accountType) {
        String devName = (accountType == 'Nacional (NB)') ? 'NaTional' : 'Crossborder';
        return Schema.SObjectType.Opportunity
            .getRecordTypeInfosByDeveloperName()
            .get(devName)
            .getRecordTypeId();
    }
}