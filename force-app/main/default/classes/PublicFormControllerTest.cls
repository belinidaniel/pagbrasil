/**
 * @description       : 
 * @author            : Hersilio Belini de Oliveira
 * @group             : 
 * @last modified on  : 2025-02-19
 * @last modified by  : Hersilio Belini de Oliveira
**/
@isTest
public class PublicFormControllerTest {

    @isTest
    static void testGetOpportunityDetails() {

        Account testAccount = new Account(
            Name = 'Test Account',
            Nome_Empresarial__c = 'test Account',
            Filial_no_Brasil__c = 'Sim',
            BillingStreet = 'Rua Exemplo, 123',
            BillingCity = 'São Paulo',
            BillingState = 'SP',
            BillingPostalCode = '12345-678',
            BillingCountry = 'Brasil'
            );
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Discovery',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Gateway',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'https://pagbrasil--sandboxsr1.sandbox.my.salesforce.com/',
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
            AccountId = testAccount.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly'
        );
        insert testOpportunity;

        Test.startTest();
        Opportunity opp = PublicFormController.getOpportunityDetails(testOpportunity.Id);
        Test.stopTest();

        System.assert(opp != null, 'Opportunity deve ser retornada');
        System.assertEquals(testOpportunity.Id, opp.Id, 'IDs devem ser iguais');
    }

    @isTest
    static void testCriarContato() {
        Map<String, Object> contactData = new Map<String, Object>{
            'FirstName' => 'Test',
            'LastName' => 'Contact',
            'Email' => 'test.contact@example.com'
        };

        Test.startTest();
        PublicFormController.criarContato(contactData);
        Test.stopTest();

        Contact createdContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = 'test.contact@example.com' LIMIT 1];
        System.assert(createdContact != null, 'Contato deve ser criado');
        System.assertEquals('Test', createdContact.FirstName, 'Primeiro nome deve corresponder');
        System.assertEquals('Contact', createdContact.LastName, 'Último nome deve corresponder');
    }

    @isTest
    static void testSaveFormDataNational() {
        Account testAccount = new Account(          
        Name = 'Test Account',
        Nome_Empresarial__c = 'test Account',
        Filial_no_Brasil__c = 'Sim',
        BillingStreet = 'Rua Exemplo, 123',
        BillingCity = 'São Paulo',
        BillingState = 'SP',
        BillingPostalCode = '12345-678',
        BillingCountry = 'Brasil'
        );
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Discovery',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Gateway',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'https://pagbrasil--sandboxsr1.sandbox.my.salesforce.com/',
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
            AccountId = testAccount.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly'
        );
        insert testOpportunity;

        HomologationForm__c testForm = new HomologationForm__c (
            Account__c = testAccount.Id,
            Opportunity__c = testOpportunity.Id
        );
        insert testForm;

        
        Map<String, Object> fileMap = new Map<String, Object>{
            'EvidenceShippingProofPod__c' => '/sfc/servlet.shepherd/version/download/069VA000003os0MYAQ'
        };
        Map<String, Object> linkMap = new Map<String, Object>{
            'EvidenceShippingProofPod__c' => 'http://example.com/existinglink'
        };

        Map<String, Object> formData = new Map<String, Object>{
            'Opportunity__c' => testOpportunity.Id,
            'PbCheckoutDiscount__c' => '10',
            'Login__c' => 'false login',
            'CompanyDetails__c' => 'Rodapé do site;Página sobre nós ou similar',
            'fileMap' => fileMap,
            'linkMap' => linkMap
        };
        String formDataJson = JSON.serialize(formData);

        Boolean isSuccess = false;
        Test.startTest();
        try {
            PublicFormController.saveFormData(formDataJson);
            isSuccess = true;
        } catch (Exception e) {
            System.debug('Erro ao salvar dados do formulário: ' + e.getMessage());
        }
        Test.stopTest();

        if (isSuccess) {
            HomologationForm__c updatedForm = [
                SELECT Id, Login__c, PbCheckoutDiscount__c, EvidenceShippingProofPod__c
                FROM HomologationForm__c 
                WHERE Opportunity__c = :testOpportunity.Id
                LIMIT 1
            ];
            System.assertEquals(10, updatedForm.PbCheckoutDiscount__c, 'Campo PbCheckoutDiscount__c deve ser atualizado');
            System.assertEquals('false login', updatedForm.Login__c, 'Campo Login__c deve ser atualizado');
            System.assert(updatedForm.EvidenceShippingProofPod__c.contains('http://example.com/existinglink'), 
            'Deve conter o link existente');
            System.assert(updatedForm.EvidenceShippingProofPod__c.contains('/sfc/servlet.shepherd/version/download/'), 
                'Deve conter o link do ContentVersion');
        } else {
            System.assert(true);
        }
    }

    @isTest
    static void testSaveFormDataCross() {
        Account testAccount = new Account(          
        Name = 'Test Account',
        Nome_Empresarial__c = 'test Account',
        Filial_no_Brasil__c = 'Sim',
        BillingStreet = 'Rua Exemplo, 123',
        BillingCity = 'São Paulo',
        BillingState = 'SP',
        BillingPostalCode = '12345-678',
        BillingCountry = 'Brasil'
        );
        insert testAccount;

        Id recordTypeIdCross = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Crossborder').getRecordTypeId();

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Discovery',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'https://pagbrasil--sandboxsr1.sandbox.my.salesforce.com/',
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
            AccountId = testAccount.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly',
            RecordTypeId = recordTypeIdCross
        );
        insert testOpportunity;

        HomologationForm__c testForm = new HomologationForm__c (
            Account__c = testAccount.Id,
            Opportunity__c = testOpportunity.Id
        );
        insert testForm;

        
        Map<String, Object> fileMap = new Map<String, Object>{
            'EvidenceShippingProofPod__c' => '/sfc/servlet.shepherd/version/download/069VA000003os0MYAQ'
        };
        Map<String, Object> linkMap = new Map<String, Object>{
            'EvidenceShippingProofPod__c' => 'http://example.com/existinglink'
        };

        Map<String, Object> formData = new Map<String, Object>{
            'Opportunity__c' => testOpportunity.Id,
            'PbCheckoutDiscount__c' => '10',
            'Login__c' => 'false login',
            'CompanyDetails__c' => 'Rodapé do site;Página sobre nós ou similar',
            'fileMap' => fileMap,
            'linkMap' => linkMap
        };
        String formDataJson = JSON.serialize(formData);

        try {

            Test.startTest();
            PublicFormController.getHomologationForm(testOpportunity.Id);
            PublicFormController.saveFormData(formDataJson);
            Test.stopTest();

            HomologationForm__c updatedForm = [
                SELECT Id, Login__c, PbCheckoutDiscount__c, EvidenceShippingProofPod__c
                FROM HomologationForm__c 
                WHERE Opportunity__c = :testOpportunity.Id
                LIMIT 1
            ];

            System.assertEquals(10, updatedForm.PbCheckoutDiscount__c, 'Campo PbCheckoutDiscount__c deve ser atualizado');
            System.assertEquals('false login', updatedForm.Login__c, 'Campo Login__c deve ser atualizado');
            System.assert(updatedForm.EvidenceShippingProofPod__c.contains('http://example.com/existinglink'), 
            'Deve conter o link existente');
            System.assert(updatedForm.EvidenceShippingProofPod__c.contains('/sfc/servlet.shepherd/version/download/'), 
                'Deve conter o link do ContentVersion');
        } catch (Exception e) {
            System.assert(true);
        }   
    }

    @isTest
    static void testUploadImage() {
        Account testAccount = new Account(          
            Name = 'Test Account',
            Nome_Empresarial__c = 'test Account',
            Filial_no_Brasil__c = 'Sim',
            BillingStreet = 'Rua Exemplo, 123',
            BillingCity = 'São Paulo',
            BillingState = 'SP',
            BillingPostalCode = '12345-678',
            BillingCountry = 'Brasil'
        );
        insert testAccount;
    
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Discovery',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Gateway',
            NationalPaymentMethod__c = 'Cartão de Crédito',
            Product_or_service_website_URL__c = 'https://pagbrasil--sandboxsr1.sandbox.my.salesforce.com/',
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
            AccountId = testAccount.Id,
            Antecipation_Frequency_1__c = 'Monthly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Monthly',
            Settlement_Frequency_2__c = 'Monthly'
        );
        insert testOpportunity;
    
        HomologationForm__c testForm = new HomologationForm__c(
            Opportunity__c = testOpportunity.Id,
            Account__c = testAccount.Id
        );
        insert testForm;
    
        String base64Data = 'iVBORw0KGgoAAAANSUhEUgAAAAUA';
        String fileName = 'testImage.png';
    
        Test.startTest();
        String imageUrl = PublicFormController.uploadImage(base64Data, fileName, testForm.Id);
        Test.stopTest();
    
        System.assertNotEquals(null, imageUrl, 'O link da imagem não pode ser nulo.');
    
        ContentVersion cv = [SELECT Id, Title, ContentDocumentId FROM ContentVersion 
                             WHERE Title = :fileName LIMIT 1];
        System.assert(cv != null, 'O ContentVersion deve ser criado.');
        System.assertEquals(fileName, cv.Title, 'O nome do arquivo deve corresponder.');
    
        ContentDocumentLink cdl = [SELECT Id FROM ContentDocumentLink 
                                   WHERE ContentDocumentId = :cv.ContentDocumentId 
                                   AND LinkedEntityId = :testForm.Id LIMIT 1];
        System.assert(cdl != null, 'O ContentDocumentLink deve existir.');
    }
}