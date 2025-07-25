@isTest
public class ZendeskTicketWrapperTest {

    @isTest
    static void testZendeskTicketWrapperConstructor() {
        Account acct = new Account(
            Name = 'Conta teste',
            Filial_no_Brasil__c = 'Sim',
            Nome_Empresarial__c = 'Empresa X',
            BillingCountry = 'Brasil'
        );
        insert acct;

        Opportunity opp = new Opportunity(
            Name = 'Opportunity NB',
            TierCS__c = 'Top Tier',
            StageName = 'Discovery',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'www.site.com',
            BusinessModelType__c = 'B2B',
            AverageSalesTicket__c = 5000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            IntegrationType__c = 'Salesforce',
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123,
            PaymentRecurrence__c = 'Não',
            Product_Type__c = 'Physical',
            Segmento__c = 'Gaming',
            nb_receita_mensal__c = 5000.00,
            AccountId = acct.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly',
            Integracao__c = 'API'
        );
        insert opp;

        List<String> uploads = new List<String>{ 'token1', 'token2' };
        ZendeskTicketWrapper.TicketCheck ticketCheck = new ZendeskTicketWrapper.TicketCheck();
        ticketCheck.pagShieldActivationCheck = true;
        ticketCheck.paymentMethodsInFooter = false;
        ticketCheck.logoInsertionInBoleto = false;
        ticketCheck.reclameAqui = false;
        ticketCheck.pods = false;
        ticketCheck.visualIdentityManualRequest = false;
        ticketCheck.welcomeEmailAndTrainingLinks = false;
        ticketCheck.triggerIndication = 'SIM';

        Test.startTest();
        ZendeskTicketWrapper wrapper = new ZendeskTicketWrapper(opp, uploads, ticketCheck, '123456789');
        Test.stopTest();

        System.assertEquals('Solicitaçãode Go-Live - null', wrapper.ticket.subject, 'Ticket subject should match.');
        System.assertNotEquals(null, wrapper.ticket.comment.body, 'Comment body should not be null.');
    }
}