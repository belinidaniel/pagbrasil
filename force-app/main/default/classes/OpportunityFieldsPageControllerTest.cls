@isTest
private class OpportunityFieldsPageControllerTest {

	@isTest
	static void testOpportunityFieldsPageController() {
		Opportunity opp = new Opportunity(
			Name = 'Test Opportunity',
			StageName = 'Negotiation',
			CloseDate = Date.today().addDays(30),
			BusinessModel__c = 'Intermediation',
			NationalPaymentMethod__c = 'Pix',
			Product_or_service_website_URL__c = 'www.site.com',
			Transacoes_Mensais__c = 4,
			AverageSalesTicket__c = 15000.00,
			ProductClass__c = '5331',
			previs_fat_rs__c = 5000.00,
			nb_receita_mensal__c = 50000,
			Integracao__c = 'Salesforce CC',
			Recorrencia__c = 'Yes',
			Ticket_Medio__c = 123,
			Product_Type__c = 'Digital',
			Antecipation_Frequency_1__c = 'Weekly',
			Antecipation_Frequency_2__c = 'Monthly',
			Settlement_Frequency_1__c = 'Weekly',
			Settlement_Frequency_2__c = 'Monthly',
			Segmento__c = 'Gaming',
			IntegrationType__c = 'API',
			PaymentRecurrence__c = 'Sim'
		);
		insert opp;

		Test.startTest();
		ApexPages.currentPage().getParameters().put('id', opp.Id);
		OpportunityFieldsPageController controller = new OpportunityFieldsPageController();
		Test.stopTest();

		System.assertNotEquals(null, controller.wrapper, 'Wrapper não deve ser nulo');
	}
}