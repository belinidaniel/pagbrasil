@isTest
private class ContentDocumentLinkHandlerTest {
	private static Id nationalRecordTypeId;
	private static Id nonNationalRecordTypeId;
	private static Opportunity nationalOpp;
	private static Opportunity otherOpp;
	private static Id docId1;
	private static Id docId2;

	@testSetup
	static void setupData() {
		Account acct = new Account(Name = 'Test Account', Type = 'Customer');
		insert acct;

		List<RecordType> rts = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Opportunity'];
		for (RecordType rt : rts) {
			if (rt.Name == 'National') {
				nationalRecordTypeId = rt.Id;
			} else {
				nonNationalRecordTypeId = rt.Id;
			}
		}

		nationalOpp = new Opportunity(
			Name = 'National Opp',
			StageName = 'Prospecting',
			CloseDate = Date.today(),
			ForecastCategoryName = 'Pipeline',
			CurrencyIsoCode = UserInfo.getDefaultCurrency(),
			Probability = 10,
			AccountId = acct.Id,
			AverageSalesTicket__c = 1000,
			nb_receita_mensal__c = 50000,
			previs_fat_rs__c = 40000,
			Antecipation_Frequency_1__c = 'Weekly',
			Antecipation_Frequency_2__c = 'Monthly',
			Settlement_Frequency_1__c = 'Weekly',
			Settlement_Frequency_2__c = 'Monthly',
			Segmento__c = 'Gaming',
			Product_Type__c = 'Digital',
			BusinessModel__c = 'Intermediation',
			BusinessModelType__c = 'B2C',
			NationalPaymentMethod__c = 'Pix',
			PaymentRecurrence__c = 'Sim',
			IntegrationType__c = 'API',
			RecordTypeId = nationalRecordTypeId
        );

		otherOpp = nationalOpp.clone(false);
		otherOpp.Name = 'Other Opp';
		otherOpp.RecordTypeId = nonNationalRecordTypeId;
		insert new List<Opportunity>{ nationalOpp, otherOpp };

		ContentVersion cv1 = new ContentVersion(Title = 'Doc 1', PathOnClient = 'doc1.pdf', VersionData = Blob.valueOf('content1'));
		ContentVersion cv2 = new ContentVersion(Title = 'Doc 2', PathOnClient = 'doc2.pdf', VersionData = Blob.valueOf('content2'));
		insert new List<ContentVersion>{ cv1, cv2 };

        docId1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv1.Id].ContentDocumentId;
        docId2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv2.Id].ContentDocumentId;
    }

	@isTest
	static void testAfterInsert_WithNational() {
		Id oppId = [SELECT Id FROM Opportunity WHERE Name = 'National Opp' LIMIT 1].Id;
		Id docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Title = 'Doc 1' LIMIT 1].ContentDocumentId;
		ContentDocumentLink link = new ContentDocumentLink(ContentDocumentId = docId, LinkedEntityId = oppId, ShareType = 'V', Visibility = 'AllUsers');
		insert link;

		Map<Id, ContentDocumentLink> newMap = new Map<Id, ContentDocumentLink>{ link.Id => link };
		Test.startTest();
		ContentDocumentLinkHandler.afterInsert(newMap);
		Test.stopTest();
	}

	@isTest
	static void testAfterInsert_WithNonNational() {
		Id oppId = [SELECT Id FROM Opportunity WHERE Name = 'Other Opp' LIMIT 1].Id;
		Id docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Title = 'Doc 2' LIMIT 1].ContentDocumentId;
		ContentDocumentLink link = new ContentDocumentLink(ContentDocumentId = docId, LinkedEntityId = oppId, ShareType = 'V', Visibility = 'AllUsers');
		insert link;

		Map<Id, ContentDocumentLink> newMap = new Map<Id, ContentDocumentLink>{ link.Id => link };
		Test.startTest();
		ContentDocumentLinkHandler.afterInsert(newMap);
		Test.stopTest();
	}

	@isTest
	static void testAfterInsert_EmptyMap() {
		Test.startTest();
		ContentDocumentLinkHandler.afterInsert(new Map<Id, ContentDocumentLink>());
		Test.stopTest();
	}
    
    @isTest
    static void testReturnEarly() {
        // contentDocumentIds vazio
        Set<Id> emptyContentDocumentIds = new Set<Id>();
        Set<Id> validOpportunityIds = new Set<Id>{'001000000000000AAA'};

        // validOpportunityIds vazio
        Set<Id> contentDocumentIds = new Set<Id>{'069000000000000AAA'};
        Set<Id> emptyValidOpportunityIds = new Set<Id>();
        
        Test.startTest();
        ContentDocumentLinkService.sendDocumentWhitDocusing(contentDocumentIds, emptyValidOpportunityIds);
        ContentDocumentLinkService.sendDocumentWhitDocusing(emptyContentDocumentIds, validOpportunityIds);
        Test.stopTest();
    }
    
    @isTest
    static void testHandleOrderCompleteCalled() {
        // Criação de conta e oportunidade com todos os campos preenchidos
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

        // Criação de ContentVersion e obtenção do ContentDocumentId
        ContentVersion cv = new ContentVersion(
            Title = 'ContractNacionalPage Document',
            PathOnClient = 'contract.pdf',
            VersionData = Blob.valueOf('Test content')
        );
        insert cv;

        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        Set<Id> contentDocumentIds = new Set<Id>{contentDocId};
        Set<Id> validOpportunityIds = new Set<Id>{opp.Id};

        Test.startTest();
        ContentDocumentLinkService.sendDocumentWhitDocusing(contentDocumentIds, validOpportunityIds);
        Test.stopTest();
    }
}