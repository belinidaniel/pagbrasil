@isTest
private class AccountTriggerHandlerTest {
	@testSetup
    static void testHandleBeforeInsertSetsType() {
        Account accNB = new Account(
            Name                          = 'Teste NB',
            Lead_Expected_Record_Type__c = 'Nacional (NB)'
        );
        Account accXB = new Account(
            Name                          = 'Teste XB',
            Lead_Expected_Record_Type__c = 'Cross Border (XB)'
        );
        List<Account> newAccounts = new List<Account>{ accNB, accXB };

        Test.startTest();
            AccountTriggerHandler.handleBeforeInsert(newAccounts);
        Test.stopTest();

        System.assertEquals('Nacional (NB)',   accNB.Type, 'NB deveria ficar com Type = Nacional (NB)');
        System.assertEquals('Cross Border (XB)', accXB.Type, 'XB deveria ficar com Type = Cross Border (XB)');
    }

    @isTest
    static void testHandleUpdateCreatesOpportunityOnTypeChange() {
        // 1. Criar Lead NB via TestDataFactory
        Lead nbLead = TestDataFactory.createAndInsertLeadNB();
        
        // 2. Converter Lead
        String convertedStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1].MasterLabel;
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(nbLead.Id);
        lc.setConvertedStatus(convertedStatus);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        // 3. Obter Account
        Account acc = [SELECT Id, Type FROM Account WHERE Id = :lcr.getAccountId()];
        
        // 4. Contar Opportunity inicial (deve ser 1)
        Integer beforeCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :acc.Id];
        System.assertEquals(1, beforeCount, 'Deveria haver 1 Opportunity após conversão');
        
        // 5. Atualizar Type e executar o trigger VIA UPDATE REAL
        acc.Type = 'Cross Border (XB)';
        acc.Billing_Country__c = 'United States of America';
        Test.startTest();
            update acc;
        Test.stopTest();
        
        // 6. Verificar nova Opportunity
        Integer afterCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :acc.Id];
        System.assertEquals(2, afterCount, 'Deveriam existir 2 Opportunities após mudança de Type');
    }

	@isTest
	static void testGetAllOpportunityFields() {
		List<String> fields = AccountTriggerHandler.getAllOpportunityFields();

		System.assert(fields.contains('pixoneclick__c'), 'A lista deve conter o campo pixoneclick__c');
		System.assert(fields.contains('acceptable_proposal__c'), 'A lista deve conter o campo acceptable_proposal__c');
		System.assert(fields.contains('account_billing_country__c'), 'A lista deve conter o campo account_billing_country__c');
		System.assert(fields.contains('accountid'), 'A lista deve conter o campo accountid');
		System.assert(fields.contains('agency__c'), 'A lista deve conter o campo agency__c');
		System.assert(fields.contains('amount'), 'A lista deve conter o campo amount');
		System.assert(fields.contains('answered_confirmation_form__c'), 'A lista deve conter o campo answered_confirmation_form__c');
		System.assert(fields.contains('antecipacao__c'), 'A lista deve conter o campo antecipacao__c');
		System.assert(fields.contains('antecipationfrequency__c'), 'A lista deve conter o campo antecipationfrequency__c');
		System.assert(fields.contains('antecipation_frequency_1__c'), 'A lista deve conter o campo antecipation_frequency_1__c');
		System.assert(fields.contains('antecipation_frequency_2__c'), 'A lista deve conter o campo antecipation_frequency_2__c');
		System.assert(fields.contains('antecipation__c'), 'A lista deve conter o campo antecipation__c');
		System.assert(fields.contains('applepay__c'), 'A lista deve conter o campo applepay__c');
		System.assert(fields.contains('metodos_pagamento__c'), 'A lista deve conter o campo metodos_pagamento__c');
		System.assert(fields.contains('pci_dss__c'), 'A lista deve conter o campo pci_dss__c');
		System.assert(fields.contains('averagesalesticket__c'), 'A lista deve conter o campo averagesalesticket__c');
		System.assert(fields.contains('b2b_business_to_business__c'), 'A lista deve conter o campo b2b_business_to_business__c');
		System.assert(fields.contains('b2b__c'), 'A lista deve conter o campo b2b__c');
		System.assert(fields.contains('b2b2c__c'), 'A lista deve conter o campo b2b2c__c');
		System.assert(fields.contains('b2c_business_to_consumer__c'), 'A lista deve conter o campo b2c_business_to_consumer__c');
		System.assert(fields.contains('b2c__c'), 'A lista deve conter o campo b2c__c');
		System.assert(fields.contains('boleto_share__c'), 'A lista deve conter o campo boleto_share__c');
		System.assert(fields.contains('budget_confirmed__c'), 'A lista deve conter o campo budget_confirmed__c');
		System.assert(fields.contains('businessmodeltype__c'), 'A lista deve conter o campo businessmodeltype__c');
		System.assert(fields.contains('checkouttransparente__c'), 'A lista deve conter o campo checkouttransparente__c');
		System.assert(fields.contains('closedate'), 'A lista deve conter o campo closedate');
		System.assert(fields.contains('closurestatusdate__c'), 'A lista deve conter o campo closurestatusdate__c');
		System.assert(fields.contains('sede_da_empresa__c'), 'A lista deve conter o campo sede_da_empresa__c');
		System.assert(fields.contains('contractid'), 'A lista deve conter o campo contractid');
		System.assert(fields.contains('contract_file_id__c'), 'A lista deve conter o campo contract_file_id__c');
		System.assert(fields.contains('contract_start_fee_date__c'), 'A lista deve conter o campo contract_start_fee_date__c');
		System.assert(fields.contains('country__c'), 'A lista deve conter o campo country__c');
		System.assert(fields.contains('cartao_credito_mensal__c'), 'A lista deve conter o campo cartao_credito_mensal__c');
		System.assert(fields.contains('cartao_de_credito__c'), 'A lista deve conter o campo cartao_de_credito__c');
		System.assert(fields.contains('chargeback__c'), 'A lista deve conter o campo chargeback__c');
		System.assert(fields.contains('current_platform__c'), 'A lista deve conter o campo current_platform__c');
		System.assert(fields.contains('reembolso__c'), 'A lista deve conter o campo reembolso__c');
		System.assert(fields.contains('dataagendamento__c'), 'A lista deve conter o campo dataagendamento__c');
		System.assert(fields.contains('dateaccountcreation__c'), 'A lista deve conter o campo dateaccountcreation__c');
		System.assert(fields.contains('cartao_debito_mensal__c'), 'A lista deve conter o campo cartao_debito_mensal__c');
		System.assert(fields.contains('businessmodel__c'), 'A lista deve conter o campo businessmodel__c');
		System.assert(fields.contains('descricao_empresa__c'), 'A lista deve conter o campo descricao_empresa__c');
		System.assert(fields.contains('discovery_completed__c'), 'A lista deve conter o campo discovery_completed__c');
		System.assert(fields.contains('date_discovery_meeting__c'), 'A lista deve conter o campo date_discovery_meeting__c');
		System.assert(fields.contains('possui_cnpj__c'), 'A lista deve conter o campo possui_cnpj__c');
		System.assert(fields.contains('first_appointment_status__c'), 'A lista deve conter o campo first_appointment_status__c');
		System.assert(fields.contains('gclid__c'), 'A lista deve conter o campo gclid__c');
		System.assert(fields.contains('receita_global__c'), 'A lista deve conter o campo receita_global__c');
		System.assert(fields.contains('googlepay__c'), 'A lista deve conter o campo googlepay__c');
		System.assert(fields.contains('hibernate__c'), 'A lista deve conter o campo hibernate__c');
		System.assert(fields.contains('segmento__c'), 'A lista deve conter o campo segmento__c');
		System.assert(fields.contains('segmento_outros__c'), 'A lista deve conter o campo segmento_outros__c');
		System.assert(fields.contains('integracao__c'), 'A lista deve conter o campo integracao__c');
		System.assert(fields.contains('integrationtype__c'), 'A lista deve conter o campo integrationtype__c');
		System.assert(fields.contains('integrationtypespecify__c'), 'A lista deve conter o campo integrationtypespecify__c');
		System.assert(fields.contains('is_opportunity_valid__c'), 'A lista deve conter o campo is_opportunity_valid__c');
		System.assert(fields.contains('kyc_nb_number__c'), 'A lista deve conter o campo kyc_nb_number__c');
		System.assert(fields.contains('kyc_xb_number__c'), 'A lista deve conter o campo kyc_xb_number__c');
		System.assert(fields.contains('linkedin__c'), 'A lista deve conter o campo linkedin__c');
		System.assert(fields.contains('linkedincontato__c'), 'A lista deve conter o campo linkedincontato__c');
		System.assert(fields.contains('loss_reason__c'), 'A lista deve conter o campo loss_reason__c');
		System.assert(fields.contains('marketing__c'), 'A lista deve conter o campo marketing__c');
		System.assert(fields.contains('preco_maximo__c'), 'A lista deve conter o campo preco_maximo__c');
		System.assert(fields.contains('mensagem__c'), 'A lista deve conter o campo mensagem__c');
		System.assert(fields.contains('preco_minimo__c'), 'A lista deve conter o campo preco_minimo__c');
		System.assert(fields.contains('receita_mensal__c'), 'A lista deve conter o campo receita_mensal__c');
		System.assert(fields.contains('nb_previsao_faturamento__c'), 'A lista deve conter o campo nb_previsao_faturamento__c');
		System.assert(fields.contains('nextstep'), 'A lista deve conter o campo nextstep');
		System.assert(fields.contains('notareclameaqui__c'), 'A lista deve conter o campo notareclameaqui__c');
		System.assert(fields.contains('transacoes_mensais__c'), 'A lista deve conter o campo transacoes_mensais__c');
		System.assert(fields.contains('operacao__c'), 'A lista deve conter o campo operacao__c');
		System.assert(fields.contains('opportunitykyclegalapprovalstatus__c'), 'A lista deve conter o campo opportunitykyclegalapprovalstatus__c');
		System.assert(fields.contains('name'), 'A lista deve conter o campo name');
		System.assert(fields.contains('ownerid'), 'A lista deve conter o campo ownerid');
		System.assert(fields.contains('opportunityrcclegalapprovalstatus__c'), 'A lista deve conter o campo opportunityrcclegalapprovalstatus__c');
		System.assert(fields.contains('recordtypeid'), 'A lista deve conter o campo recordtypeid');
		System.assert(fields.contains('integracao_outra__c'), 'A lista deve conter o campo integracao_outra__c');
		System.assert(fields.contains('other_platform__c'), 'A lista deve conter o campo other_platform__c');
		System.assert(fields.contains('previs_fat_rs__c'), 'A lista deve conter o campo previs_fat_rs__c');
		System.assert(fields.contains('pagshield__c'), 'A lista deve conter o campo pagshield__c');
		System.assert(fields.contains('pagshield_premium__c'), 'A lista deve conter o campo pagshield_premium__c');
		System.assert(fields.contains('pagshield_premium_on_demand__c'), 'A lista deve conter o campo pagshield_premium_on_demand__c');
		System.assert(fields.contains('usepagstream__c'), 'A lista deve conter o campo usepagstream__c');
		System.assert(fields.contains('nationalpaymentmethod__c'), 'A lista deve conter o campo nationalpaymentmethod__c');
		System.assert(fields.contains('payout__c'), 'A lista deve conter o campo payout__c');
		System.assert(fields.contains('telefone__c'), 'A lista deve conter o campo telefone__c');
		System.assert(fields.contains('pixmensal__c'), 'A lista deve conter o campo pixmensal__c');
		System.assert(fields.contains('pixmanualouqrcode__c'), 'A lista deve conter o campo pixmanualouqrcode__c');
		System.assert(fields.contains('nb_receita_mensal__c'), 'A lista deve conter o campo nb_receita_mensal__c');
		System.assert(fields.contains('pricebook2id'), 'A lista deve conter o campo pricebook2id');
		System.assert(fields.contains('campaignid'), 'A lista deve conter o campo campaignid');
		System.assert(fields.contains('priority__c'), 'A lista deve conter o campo priority__c');
		System.assert(fields.contains('dataconversaoprocessing__c'), 'A lista deve conter o campo dataconversaoprocessing__c');
		System.assert(fields.contains('categoria_de_produto__c'), 'A lista deve conter o campo categoria_de_produto__c');
		System.assert(fields.contains('productclass__c'), 'A lista deve conter o campo productclass__c');
		System.assert(fields.contains('product_type__c'), 'A lista deve conter o campo product_type__c');
		System.assert(fields.contains('teseprospeccao__c'), 'A lista deve conter o campo teseprospeccao__c');
		System.assert(fields.contains('psp__c'), 'A lista deve conter o campo psp__c');
		System.assert(fields.contains('qualificador__c'), 'A lista deve conter o campo qualificador__c');
		System.assert(fields.contains('receita_mensal_cross_border__c'), 'A lista deve conter o campo receita_mensal_cross_border__c');
		System.assert(fields.contains('paymentrecurrence__c'), 'A lista deve conter o campo paymentrecurrence__c');
		System.assert(fields.contains('data_de_indicacao__c'), 'A lista deve conter o campo data_de_indicacao__c');
		System.assert(fields.contains('relatedkycsendstatus__c'), 'A lista deve conter o campo relatedkycsendstatus__c');
		System.assert(fields.contains('relatorio_reconciliacao__c'), 'A lista deve conter o campo relatorio_reconciliacao__c');
		System.assert(fields.contains('moeda__c'), 'A lista deve conter o campo moeda__c');
		System.assert(fields.contains('requestchangeclause__c'), 'A lista deve conter o campo requestchangeclause__c');
		System.assert(fields.contains('previs_o_de_faturamento__c'), 'A lista deve conter o campo previs_o_de_faturamento__c');
		System.assert(fields.contains('roi_analysis_completed__c'), 'A lista deve conter o campo roi_analysis_completed__c');
		System.assert(fields.contains('segmentooutrosspecify__c'), 'A lista deve conter o campo segmentooutrosspecify__c');
		System.assert(fields.contains('seguidoresinstagram__c'), 'A lista deve conter o campo seguidoresinstagram__c');
		System.assert(fields.contains('vender_ao_brasil__c'), 'A lista deve conter o campo vender_ao_brasil__c');
		System.assert(fields.contains('settlementfrequency__c'), 'A lista deve conter o campo settlementfrequency__c');
		System.assert(fields.contains('settlement_frequency_1__c'), 'A lista deve conter o campo settlement_frequency_1__c');
		System.assert(fields.contains('settlement_frequency_2__c'), 'A lista deve conter o campo settlement_frequency_2__c');
		System.assert(fields.contains('settlement_frequency_test__c'), 'A lista deve conter o campo settlement_frequency_test__c');
		System.assert(fields.contains('stagename'), 'A lista deve conter o campo stagename');
		System.assert(fields.contains('atendimento_por_whatsapp__c'), 'A lista deve conter o campo atendimento_por_whatsapp__c');
		System.assert(fields.contains('syncedquoteid'), 'A lista deve conter o campo syncedquoteid');
		System.assert(fields.contains('taxabasedeantecipacao__c'), 'A lista deve conter o campo taxabasedeantecipacao__c');
		System.assert(fields.contains('temautocomplitecep__c'), 'A lista deve conter o campo temautocomplitecep__c');
		System.assert(fields.contains('temvalidadecpf__c'), 'A lista deve conter o campo temvalidadecpf__c');
		System.assert(fields.contains('tempnbvalue__c'), 'A lista deve conter o campo tempnbvalue__c');
		System.assert(fields.contains('tempxbvalue__c'), 'A lista deve conter o campo tempxbvalue__c');
		System.assert(fields.contains('ticketcreationdate__c'), 'A lista deve conter o campo ticketcreationdate__c');
		System.assert(fields.contains('ticketid__c'), 'A lista deve conter o campo ticketid__c');
		System.assert(fields.contains('tiercs__c'), 'A lista deve conter o campo tiercs__c');
		System.assert(fields.contains('type'), 'A lista deve conter o campo type');
		System.assert(fields.contains('was_contract_pdf_generated__c'), 'A lista deve conter o campo was_contract_pdf_generated__c');
		System.assert(fields.contains('website__c'), 'A lista deve conter o campo website__c');
		System.assert(fields.contains('product_or_service_website_url__c'), 'A lista deve conter o campo product_or_service_website_url__c');
		System.assert(fields.contains('conversa_de_whatsapp__c'), 'A lista deve conter o campo conversa_de_whatsapp__c');
		System.assert(fields.contains('qual_cliente_indicou__c'), 'A lista deve conter o campo qual_cliente_indicou__c');
		System.assert(fields.contains('which_platform__c'), 'A lista deve conter o campo which_platform__c');
	}

	@isTest
	static void testGetRecordTypeIdByAccountType() {
		String nationalDevName = 'NaTional';
		String crossBorderDevName = 'Crossborder';

		Map<String, Schema.RecordTypeInfo> oppRecordTypes = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();

		System.assert(oppRecordTypes.containsKey(nationalDevName), 'RecordType NaTional deve existir');
		System.assert(oppRecordTypes.containsKey(crossBorderDevName), 'RecordType Crossborder deve existir');

		Id nationalId = AccountTriggerHandler.getRecordTypeIdByAccountType('Nacional (NB)');
		Id crossBorderId = AccountTriggerHandler.getRecordTypeIdByAccountType('Cross Border (XB)');

		System.assertEquals(oppRecordTypes.get(nationalDevName).getRecordTypeId(), nationalId, 'Deve retornar o RecordTypeId correto para Nacional (NB)');
		System.assertEquals(oppRecordTypes.get(crossBorderDevName).getRecordTypeId(), crossBorderId, 'Deve retornar o RecordTypeId correto para Cross Border (XB)');
	}
}