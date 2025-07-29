@isTest
private class CreateTicketMethodTest {

    @testSetup
    static void setupData() {
        Account acc = new Account(
            Name = 'Account NB',
            Type = 'Nacional (NB)',
            Legal_Business_Name__c = 'Legal Business Name'
        );
        insert acc;

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
            AccountId = acc.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly',
            Integracao__c = 'API'
        );
        insert opp;

        HomologationForm__c homog = new HomologationForm__c();
        homog.Name = 'homologation1.test.com';
        homog.Opportunity__c = opp.Id;
        homog.Account__c = acc.Id;
        insert homog;
    }

    // Mock para TODOS os callouts HTTP feitos pelo ZendeskService (incluindo uploads JSON e uploads de arquivo)
    private class ZendeskServiceMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String endpoint = req.getEndpoint();

            // Verifica se a requisição é upload de arquivo (sendFileRequest)
            if (endpoint != null && endpoint.contains('/uploads.json')) {
                res.setStatusCode(201);
                //Resposta para upload file, retornando token esperado
                res.setBody('{"upload": {"token": "mocked_token_123"}}');
            } 
            // Criação de ticket (POST /tickets.json)
            else if (endpoint != null && endpoint.contains('/tickets.json')) {
                res.setStatusCode(201);
                res.setBody('{"ticket": {"id": "12345"}}');
            } 
            // Resposta padrão para outras chamadas
            else {
                res.setStatusCode(200);
                res.setBody('{}');
            }

            return res;
        }
    }

    @isTest
    static void testCreateTicket_MetodoPrincipal() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        CreateTicketMethod.FlowInputs flowInput = new CreateTicketMethod.FlowInputs();
        flowInput.idOpportunity = opp.Id;
        flowInput.priority = 'P2';
        flowInput.dataCreateAccount = Date.today();
        flowInput.organizationId = '28452477875457';
        flowInput.pagShieldActivationCheck = true;
        flowInput.paymentMethodsInFooter = false;
        flowInput.logoInsertionInBoleto = true;
        flowInput.reclameAqui = false;
        flowInput.pods = true;
        flowInput.visualIdentityManualRequest = false;
        flowInput.welcomeEmailAndTrainingLinks = true;
        flowInput.triggerIndication = 'Indicação';

        // Configura o mock para TODOS os callouts HTTP
        Test.setMock(HttpCalloutMock.class, new ZendeskServiceMock());

        Test.startTest();
        CreateTicketMethod.createTicket(new List<CreateTicketMethod.FlowInputs>{flowInput});
        Test.stopTest();

        Opportunity updatedOpp = [SELECT Id, Priority__c, TicketId__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('P2', updatedOpp.Priority__c, 'Priority__c deveria ter sido atualizado');
        System.assertNotEquals(null, updatedOpp.TicketId__c, 'TicketId__c deveria estar preenchido');
    }

    @isTest
    static void testErroQuandoSemHomologacoes() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp = new Opportunity(
            Name = 'Opportunity NB 2',
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
            AccountId = acc.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly',
            Integracao__c = 'API'
        );
        insert opp;

        CreateTicketMethod.FlowInputs flowInput = new CreateTicketMethod.FlowInputs();
        flowInput.idOpportunity = opp.Id;
        flowInput.priority = 'P2';

        Test.setMock(HttpCalloutMock.class, new ZendeskServiceMock());

        try {
            Test.startTest();
            CreateTicketMethod.createTicket(new List<CreateTicketMethod.FlowInputs>{flowInput});
            Test.stopTest();
            System.assert(false, 'Deveria lançar exceção se não há homologações');
        } catch(Exception e) {
            System.assert(e.getMessage().contains('No HomologationForm__c found'), 'Mensagem de erro deve mencionar ausência de homologação');
        }
    }

    @isTest
    static void testExtractNameFromUrl() {
        String url = 'xyz.empresa.com';
        String nomeExtraido = CreateTicketMethod.extractNameFromUrl(url);
        System.assertEquals('empresa', nomeExtraido, 'Nome extraído deveria ser "empresa"');
    }
}