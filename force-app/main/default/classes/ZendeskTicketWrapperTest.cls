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
            Name = 'Opp teste',
            AccountId = acct.Id,
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(30),
            ApplePay__c = false,
            Product_or_service_website_URL__c = 'https://www.google.com.br/',
            Transacoes_Mensais__c = 1213,
            BusinessModel__c = 'Intermediation',
            Priority__c = 'P2',
            DateAccountCreation__c = System.today()
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

        System.assertEquals('Solicitaçãode Go-Live - P2', wrapper.ticket.subject, 'Ticket subject should match.');
        System.assertNotEquals(null, wrapper.ticket.comment.body, 'Comment body should not be null.');
    }
}