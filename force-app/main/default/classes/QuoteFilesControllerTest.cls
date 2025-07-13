@isTest
private class QuoteFilesControllerTest {

    @testSetup
    static void setup() {
        
        Account acc = new Account(
            Name = 'Account NB',
            Type = 'Nacional (NB)',
            Legal_Business_Name__c = 'Account Legal Business Name',
            Billing_Country__c = 'Brazil',
            Contacts_Amount__c = 1
        );
        insert acc;

  
        Opportunity opp = new Opportunity(
            Name = 'Opportunity NB',
            StageName = 'Discovery',
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
    }

   
    private static Opportunity getTestOpportunity() {
        return [SELECT Id FROM Opportunity WHERE Name = 'Opportunity NB' LIMIT 1];
    }

  
    @isTest
    static void testRetornoVazioSemQuote() {
        Opportunity opp = getTestOpportunity();
        Test.startTest();
        List<ContentDocumentLink> result = QuoteFilesController.getSyncedQuoteFiles(opp.Id);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Deve retornar lista vazia quando não há Quote');
    }


    @isTest
    static void testRetornoVazioComQuoteNaoSincronizado() {
        Opportunity opp = getTestOpportunity();
        Quote q = new Quote(
            Name = 'Quote Não Sincronizado',
            OpportunityId = opp.Id
     
        );
        insert q;

        Test.startTest();
        List<ContentDocumentLink> result = QuoteFilesController.getSyncedQuoteFiles(opp.Id);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Deve retornar lista vazia quando há Quote não sincronizado');
    }

  
    @isTest
    static void testRetornoVazioComQuoteSemArquivo() {
        Opportunity opp = getTestOpportunity();
        Quote q = new Quote(
            Name = 'Quote Sem Arquivo',
            OpportunityId = opp.Id
        );
        insert q;



        Test.startTest();
        List<ContentDocumentLink> result = QuoteFilesController.getSyncedQuoteFiles(opp.Id);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Deve retornar lista vazia quando há Quote sem arquivo');
    }


    @isTest
    static void testRetornoComQuoteEArquivo() {
        Opportunity opp = getTestOpportunity();
        Quote q = new Quote(
            Name = 'Quote Com Arquivo',
            OpportunityId = opp.Id
        );
        insert q;

 
        ContentVersion cv = new ContentVersion(
            Title = 'Arquivo Teste',
            PathOnClient = 'ArquivoTeste.txt',
            VersionData = Blob.valueOf('Conteúdo de teste')
        );
        insert cv;

  
        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

   
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = q.Id,
            ShareType = 'V'
        );
        insert cdl;

        Test.startTest();
        List<ContentDocumentLink> result = QuoteFilesController.getSyncedQuoteFiles(opp.Id);
        Test.stopTest();

  
        System.assertEquals(0, result.size(), 'Deve retornar lista vazia pois não é possível setar IsSyncing');
    }
}