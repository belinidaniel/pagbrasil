/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-03-03
 * @last modified by  : Hersilio Belini de Oliveira
**/
@isTest
public class RccServiceTest {

    @testSetup
    static void setup() {
        Account acct = new Account(
            Name = 'Conta teste',
            Filial_no_Brasil__c = 'Sim',
            Nome_Empresarial__c = 'Empresa X',
            BillingCountry = 'Brasil'
        );
        insert acct;

        Id nationalRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NaTional').getRecordTypeId();

        Date datClose = Date.today().addDays(30);

        List<Opportunity> opps = new List<Opportunity>{
			new Opportunity(
				Name = 'Opp1',
				CloseDate = datClose,
				AccountId = acct.Id,
				RecordTypeId = nationalRT,
				StageName = 'Contact',
				Product_or_service_website_URL__c = 'www.google.com',
				Transacoes_Mensais__c = 1213,
				BusinessModel__c = 'Intermediation',
				NationalPaymentMethod__c = 'Pix',
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
			)
		};

        insert opps;
    }

    @isTest
    static void testGetResult() {
        // Positive test case
        RccService.FlowInput input = new RccService.FlowInput();
        input.questionsAndResponse = new List<String>{'Question|Sim', 'Question 2|Não', 'Question 3|Em Partes'};
        input.responseOne = 'Response 1';
        input.responseTwo = 'Response 2';
        input.responseThree = 'Response 3';
        input.opp = [SELECT Id FROM Opportunity LIMIT 1];
        input.segmentRisk = 10;

        List<RccService.FlowOutput> result = RccService.getResult(new List<RccService.FlowInput>{input});

        // Negative test case
        RccService.FlowInput inputNegative = new RccService.FlowInput();
        inputNegative.questionsAndResponse = new List<String>{'-', 'Question 2|Não', 'Question 3|Não'};
        inputNegative.responseOne = 'Response 1';
        inputNegative.responseTwo = 'Response 2';
        inputNegative.responseThree = 'Response 3';
        inputNegative.opp = [SELECT Id FROM Opportunity LIMIT 1];
        inputNegative.segmentRisk = 10;

        List<RccService.FlowOutput> resultNegative = RccService.getResult(new List<RccService.FlowInput>{inputNegative});
    }
}