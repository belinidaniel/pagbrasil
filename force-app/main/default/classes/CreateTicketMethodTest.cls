/**
 * @description      : Classe de teste para a classe CreateTicketMethod.
 * Cobre os principais cenários de sucesso e de falha, além de mockar
 * as chamadas externas (callouts) para o Zendesk.
 * @author           : Gemini AI
 * @group            : Test
 * @last modified on : 07-01-2025
**/
@isTest
private class CreateTicketMethodTest {

    @testSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Account',
            OrganizationId__c = 'ORG123'
        );
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addMonths(1)
        );
        insert opp;

        HomologationForm__c homologation = new HomologationForm__c(
            Name = 'homolog.subdomain.com',
            Opportunity__c = opp.Id
        );
        insert homologation;
    }

    @isTest
    static void testCreateTicketSuccess() {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new ZendeskCalloutMock());

        List<CreateTicketMethod.FlowInputs> flowInputsList = new List<CreateTicketMethod.FlowInputs>();
        CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
        input.idOpportunity = opp.Id;
        input.priority = 'High';
        input.organizationId = 'ORG123_CHILD';
        input.dataCreateAccount = Date.today();
        input.pagShieldActivationCheck = true;
        flowInputsList.add(input);

        // Definir a página atual para o contexto do Visualforce
        PageReference pageRef = Page.OpportunityFields;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        CreateTicketMethod.createTicket(flowInputsList);
        Test.stopTest();

        Opportunity updatedOpp = [SELECT TicketId__c, Priority__c, DateAccountCreation__c, TicketCreationDate__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('fakeTicketId123', updatedOpp.TicketId__c, 'O TicketId__c na Oportunidade não foi atualizado corretamente.');
        System.assertEquals('High', updatedOpp.Priority__c, 'A Prioridade na Oportunidade não foi atualizada.');
        System.assertNotEquals(null, updatedOpp.TicketCreationDate__c, 'A data de criação do ticket não foi preenchida.');

        List<Account> childAccounts = [SELECT Id, Name, ParentId FROM Account WHERE ParentId = :opp.AccountId];
        System.assertEquals(1, childAccounts.size(), 'A conta filha não foi criada.');
        System.assertEquals('subdomain', childAccounts[0].Name, 'O nome da conta filha está incorreto.');

        List<ContentDocumentLink> cdls = [SELECT ContentDocument.Title, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId = :opp.Id];
        System.assertEquals(2, cdls.size(), 'Deveriam haver 2 arquivos (JSON e PDF) ligados à oportunidade.');
    }

    @isTest
    static void testCreateTicket_NoOpportunityId_ThrowsException() {
        List<CreateTicketMethod.FlowInputs> flowInputsList = new List<CreateTicketMethod.FlowInputs>();
        CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
        input.idOpportunity = null;
        input.priority = 'High';
        flowInputsList.add(input);

        try {
            Test.startTest();
            CreateTicketMethod.createTicket(flowInputsList);
            Test.stopTest();
            System.assert(false, 'A exceção para ID de oportunidade nulo não foi lançada.');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('Opportunity Id is required.'), 'A mensagem de erro está incorreta.');
        }
    }

    @isTest
    static void testCreateTicket_NoPriority_ThrowsException() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];

        List<CreateTicketMethod.FlowInputs> flowInputsList = new List<CreateTicketMethod.FlowInputs>();
        CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
        input.idOpportunity = opp.Id;
        input.priority = '';
        flowInputsList.add(input);

        try {
            Test.startTest();
            CreateTicketMethod.createTicket(flowInputsList);
            Test.stopTest();
            System.assert(false, 'A exceção para prioridade nula não foi lançada.');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('Priority is required.'), 'A mensagem de erro está incorreta.');
        }
    }

    @isTest
    static void testSendIntegration_NoHomologations_ThrowsException() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Opportunity oppWithoutHomologation = new Opportunity(
            Name = 'Opp Without Homologation',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addMonths(1)
        );
        insert oppWithoutHomologation;
        
        CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
        input.idOpportunity = oppWithoutHomologation.Id;
        
        try {
            Test.startTest();
            CreateTicketMethod.sendIntegration(input);
            Test.stopTest();
            System.assert(false, 'A exceção para falta de homologação não foi lançada.');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('No HomologationForm__c found'), 'A mensagem de erro está incorreta.');
        }
    }

    @isTest
    static void testExtractNameFromUrl() {
        System.assertEquals('subdominio', CreateTicketMethod.extractNameFromUrl('primeiro.subdominio.com'));
        System.assertEquals('teste', CreateTicketMethod.extractNameFromUrl('site.teste.net'));
        System.assertEquals('', CreateTicketMethod.extractNameFromUrl('invalido'));
        System.assertEquals('', CreateTicketMethod.extractNameFromUrl('invalido.'));
        System.assertEquals('', CreateTicketMethod.extractNameFromUrl(null));
    }
    
    public class ZendeskCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            if (req.getEndpoint().contains('/api/v2/uploads.json')) {
                res.setBody('{"upload": {"token": "fakeUploadToken123"}}');
                res.setStatusCode(201);
            }
            else if (req.getEndpoint().contains('/api/v2/tickets.json')) {
                 res.setBody('{"ticket": {"id": "fakeTicketId123"}}');
                 res.setStatusCode(201);
            }
            else {
                res.setStatusCode(404);
            }
            return res;
        }
    }
}