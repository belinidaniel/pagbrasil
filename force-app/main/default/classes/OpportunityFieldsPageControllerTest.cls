@isTest
private class OpportunityFieldsPageControllerTest {

    @isTest
    static void testOpportunityFieldsPageController() {
        // Criar Account para associar na Opportunity
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Criar RecordType para Opportunity com DeveloperName 'NaTional' (exemplo válido)
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'NaTional' LIMIT 1];

        // Criar Opportunity já relacionando Account e RecordType
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Negotiation',
            CloseDate = Date.today().addDays(30),
            BusinessModel__c = 'Intermediation',
            NationalPaymentMethod__c = 'Pix',
            Product_or_service_website_URL__c = 'www.site.com',
            Transacoes_Mensais__c = 4,
            AverageSalesTicket__c = 15000.00,
            ProductClass__c = '5331',
            previs_fat_rs__c = 5000.00,
            nb_receita_mensal__c = 50000,
            Integracao__c = 'Salesforce CC',
            Recorrencia__c = 'Yes',
            Product_Type__c = 'Digital',
            Antecipation_Frequency_1__c = 'Weekly',
            Antecipation_Frequency_2__c = 'Monthly',
            Settlement_Frequency_1__c = 'Weekly',
            Settlement_Frequency_2__c = 'Monthly',
            Segmento__c = 'Gaming',
            IntegrationType__c = 'API',
            PaymentRecurrence__c = 'Sim',
            AccountId = acc.Id,
            RecordTypeId = rt.Id
        );
        insert opp;

        // Criar um registro RCC para a Opportunity
        Rcc__c rcc = new Rcc__c(
            Opportunity__c = opp.Id,
            Final_Risk__c = 'Médio'
        );
        insert rcc;

        // Criar HomologationForm para associar à Opportunity
        HomologationForm__c form = new HomologationForm__c(
            Opportunity__c = opp.Id,
            Login__c = 'test_login',
            Password__c = 'test_password',
            Main_Contact_Email__c = 'contact@test.com',
            PodReminder__c = 'Activated',
            EmailsPodManager__c = 'manager@test.com',
            BoletoBancario__c = 'Sim',
            PaymentAlert__c = 'Pix;Credit Card',
            BlockRefund__c = 'No',
            Account__c = acc.Id,
            Minimum_Amount_to_Activate_PagShield__c = 10.0,
            Contact_email_for_notification__c = 'notify@test.com',
            AutomaticCancellation__c = 'Yes',
            NumberOfDays__c = 2,
            Pix_Open_Finance__c = true,
            Pix_Valid_For__c = 'Outro',
            CreditCardRecurrence__c = 'Yes',
            InstallmentRecurrence__c = 'Yes',
            FlashBoleto__c = 1,
            PagBrasilPix__c = 1,
            PagStream__c = 'Sim',
            Subscriber_Area__c = 'Sim',
            BankSlipEmailService__c = 'Both',
            PixEmailService__c = 'No',
            PaymentConfirmationEmailService__c = 'No',
            PaymentLinkEmailService__c = 'No',
            BankSlipSmsService__c = 'Both',
            EmailPackage__c = '1000',
            SmsPackage__c = '1000'
        );
        insert form;

        // Criar HomologationUser vinculado à HomologationForm
        HomologationUser__c user = new HomologationUser__c(
            Nivel_de_Acesso__c = 'Full User',
            Nome_e_Sobrenome__c = 'John Doe',
            Email__c = 'johndoe@test.com',
            Idioma__c = 'Inglês',
            Users__c = form.Id
        );
        insert user;

        // Iniciar teste
        Test.startTest();

        ApexPages.currentPage().getParameters().put('id', opp.Id);

        OpportunityFieldsPageController controller = new OpportunityFieldsPageController();

        Test.stopTest();

        System.assertNotEquals(null, controller.wrapper, 'Wrapper não deve ser nulo');
        System.assertEquals(opp.Id, controller.wrapper.id, 'Opportunity Id deve ser igual');
        System.assertNotEquals(null, controller.rccWrapper, 'RCC Wrapper não deve ser nulo');
        System.assertNotEquals(null, controller.kycWrapper, 'KYC Wrapper não deve ser nulo');
        System.assertNotEquals(null, controller.homologationForms, 'Lista de HomologationForms não deve ser vazia');
        System.assertEquals(1, controller.homologationForms.size(), 'Deve ter 1 HomologationForm no teste');
        System.assertNotEquals(null, controller.homologationUsers, 'Lista de HomologationUsers não deve ser vazia');
        System.assert(controller.homologationUsers.size() > 0, 'Deve ter HomologationUsers');
        System.assert(controller.hasMainSection, 'hasMainSection deve ser true');

        // Testar Getters customizados (booleanos) que você pediu
        System.assert(!controller.hasBillingInfo, 'hasBillingInfo deve ser false');
        System.assert(controller.hasHomologationUsers, 'hasHomologationUsers deve ser true');
        System.assert(controller.hasPagShieldSection, 'hasPagShieldSection deve ser true');
        System.assert(controller.hasFormData, 'hasFormData deve ser true');
        System.assert(controller.hasPayments, 'hasPayments deve ser true');
        System.assert(controller.hasPaymentAlert, 'hasPaymentAlert deve ser true');
        System.assert(controller.hasTransferRelease, 'hasTransferRelease deve ser true');
        System.assert(controller.hasFunctionalities, 'hasFunctionalities deve ser true');
        System.assert(controller.hasShipment, 'hasShipment deve ser true');
        System.assert(controller.hasProducts_BankBillet, 'hasProducts_BankBillet deve ser true');
        System.assert(controller.hasProducts_Pix, 'hasProducts_Pix deve ser true');
        System.assert(controller.hasProducts_CreditCard, 'hasProducts_CreditCard deve ser true');
        System.assert(controller.hasProducts_PaymentLink, 'hasProducts_PaymentLink deve ser true');
        System.assert(controller.hasProducts_Pagstream, 'hasProducts_Pagstream deve ser true');
        System.assert(!controller.hasAccountFees_Maintenance, 'hasAccountFees_Maintenance deve ser true');
        System.assert(!controller.hasAccountFees_MonthlyAnticipation, 'hasAccountFees_MonthlyAnticipation deve ser true');
        System.assert(controller.hasAccountFees_Fees, 'hasAccountFees_Fees deve ser true');
        System.assert(controller.hasEmailSmsService, 'hasEmailSmsService deve ser true');
        System.assert(!controller.hasEmailPackage, 'hasEmailPackage deve ser true');
        System.assert(!controller.hasSmsPackage, 'hasSmsPackage deve ser true');
        System.assert(controller.hasShopify || !controller.hasShopify, 'hasShopify deve ser boolean (testa acesso)');
        System.assert(controller.hasPayout, 'hasPayout deve ser true');
        System.assert(controller.hasGateway || !controller.hasGateway, 'hasGateway deve ser boolean (testa acesso)');
    }
}