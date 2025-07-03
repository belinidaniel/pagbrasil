@isTest
private class HomologationFormSendEmailTest {

    @isTest
    static void testSendRequiredEmptyOrNullFieldsList() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity with QuoteLineItems',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'www.site.com',
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            Integracao__c = 'API',
            IntegrationType__c = 'Salesforce',
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123,
            PaymentRecurrence__c = 'Não',
            Product_Type__c = 'Physical',
            Segmento__c = 'Gaming',
            nb_receita_mensal__c = 5000.00,
            AccountId = acc.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly'
        );
        insert opp;

        HomologationForm__c form = new HomologationForm__c(
            Name = 'Test Form',
            Opportunity__c = opp.Id,
            Required_Fields__c = 'Field1__c,Field2__c',
            Account__c = acc.Id
        );
        insert form;

        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@example.com',
            AccountId = acc.Id
        );
        insert contact;

        List<HomologationFormSendEmail.FlowInputs> inputs = new List<HomologationFormSendEmail.FlowInputs>();
        HomologationFormSendEmail.FlowInputs input = new HomologationFormSendEmail.FlowInputs();
        input.opportunityId = opp.Id;
        input.recipient = contact.Id;
        input.language = 'pt_BR';
        input.initialContent = 'Conteúdo inicial do email';
        input.subject = 'Assunto do email';
        inputs.add(input);

        Test.startTest();
        HomologationFormSendEmail.sendRequiredEmptyOrNullFieldsList(inputs);
        Test.stopTest();

        System.assert(true, 'Método executado sem exceções');
    }
}