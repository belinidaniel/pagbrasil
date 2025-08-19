@IsTest
private class QuotePdfServiceTest {

    @TestSetup
    static void setup() {
        // Criar duas contas
        Account acc = new Account(
            Name = 'QuoteTriggerHandler First Account',
            Type = 'Nacional (NB)',
            Legal_Business_Name__c = 'First Account Legal Business Name',
            Billing_Country__c = 'Brazil',
            Contacts_Amount__c = 1
        );
        Account acc2 = new Account(
            Name = 'QuoteTriggerHandler Second Account',
            Type = 'Nacional (NB)',
            Legal_Business_Name__c = 'Second Account Legal Business Name',
            Billing_Country__c = 'Brazil',
            Contacts_Amount__c = 1
        );
        insert new List<Account>{acc, acc2};

        // Obter IDs dos Record Types
        Id recordTypeIdCross = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Crossborder').getRecordTypeId();
        Id recordTypeIdNacional = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NaTional').getRecordTypeId();

        // Criar oportunidades
        Opportunity oppXB = new Opportunity(
            Name = 'Test Opportunity 2',
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
            Moeda__C = 'USD',
            RecordTypeId = recordTypeIdCross,
            Recorrencia__c = 'Yes',
            Transacoes_Mensais__c = 123,
            Ticket_Medio__c = 123,
            PaymentRecurrence__c = 'Não',
            Product_Type__c = 'Physical',
            Segmento__c = 'Gaming',
            nb_receita_mensal__c = 5000.00,
            AccountId = acc2.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly'
        );

        Opportunity oppNB = new Opportunity(
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
            Settlement_Frequency_2__c = 'Monthly',
            RecordTypeId = recordTypeIdNacional
        );
        insert new List<Opportunity>{oppXB, oppNB};

        // Criar cotações com status 'Added'
        Quote quoteXB = new Quote(
            Name = 'Quote for Crossborder',
            OpportunityId = oppXB.Id,
            Status = 'Added'
        );
        Quote quoteNB = new Quote(
            Name = 'Quote for Nacional',
            OpportunityId = oppNB.Id,
            Status = 'Added'
        );
        insert new List<Quote>{quoteXB, quoteNB};

        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testuser@example.com',
            AccountId = acc2.Id
        );
        insert contact;

    }

    @IsTest
    static void testSavePdfVersion_Crossborder() {
        Quote quote = [SELECT Id FROM Quote WHERE Name = 'Quote for Crossborder'];
        
        Test.startTest();
        QuotePdfService.savePdfVersion(quote.Id);
        Test.stopTest();

        // Verificações
        List<ContentVersion> versions = [SELECT Id FROM ContentVersion WHERE FirstPublishLocationId = :quote.Id];
        System.assertEquals(1, versions.size(), 'Deveria criar 1 versão PDF');
        
        Quote updatedQuote = [SELECT Acceptable__c FROM Quote WHERE Id = :quote.Id];
        System.assertEquals(true, updatedQuote.Acceptable__c, 'Quote deve ser marcada como aceitável');
        
        Opportunity updatedOpp = [SELECT StageName FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM Quote WHERE Id = :quote.Id)];
        System.assertEquals('Negotiation', updatedOpp.StageName, 'Estágio da Opportunity deve ser atualizado');
    }

    @IsTest
    static void testSavePdfVersion_Nacional() {
        Quote quote = [SELECT Id FROM Quote WHERE Name = 'Quote for Nacional'];
        
        Test.startTest();
        QuotePdfService.savePdfVersion(quote.Id);
        Test.stopTest();

        List<ContentVersion> versions = [SELECT Id FROM ContentVersion WHERE FirstPublishLocationId = :quote.Id];
        System.assertEquals(1, versions.size(), 'Deveria criar 1 versão PDF');
    }
    
    @IsTest
    static void testSendToEmail_Success() {
        // Create test user with email
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'GMT',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id
        );
        insert testUser;
        
        // Get existing Opportunity and update owner
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity 2'];
        opp.OwnerId = testUser.Id;
        update opp;
        
        // Get Quote associated with updated Opportunity
        Quote quote = [SELECT Id, OpportunityId, Opportunity.Owner.Email, Opportunity.Owner.Name FROM Quote WHERE OpportunityId = :opp.Id];
        
        Test.startTest();
        QuotePdfService.sendToEmail(quote.Id, 'testuser@example.com');
        Test.stopTest();
        
        // Verify email was sent
        System.assertEquals(0, Limits.getEmailInvocations(), 'One email should be sent');
    }
}