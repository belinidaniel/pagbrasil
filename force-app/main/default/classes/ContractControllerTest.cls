/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 05-27-2025
 * @last modified by  : Daniel Belini
**/
@isTest
public class ContractControllerTest {

    @testSetup
    static void setup() {
        Account acct = new Account(
            Name = 'Conta teste',
            Filial_no_Brasil__c = 'Sim',
            Nome_Empresarial__c = 'Empresa X',
            BillingCountry = 'Brasil'
        );
        insert acct;

        Id nationalRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NaTional').getRecordTypeId();
        Id crossRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Crossborder').getRecordTypeId();

        Date datClose = Date.today().addDays(30);

        List<Opportunity> opps = new List<Opportunity>{
            // cenarios nacional
            new Opportunity(Name = 'Opp1', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', previs_fat_rs__c = 6000000, Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp2', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Gateway', RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', previs_fat_rs__c = 110000000, Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp3', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Gateway', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Pix', RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', previs_fat_rs__c = 9000000, Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp4', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Gateway', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Boleto Flash', RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', previs_fat_rs__c = 4000000, Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp5', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Gateway', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Cartão de Crédito', RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp6', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Gateway', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Débito Flash', RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp7', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Gateway', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Débito Flash', previs_fat_rs__c = 1, RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp7', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Gateway;Intermediation', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Débito Flash', previs_fat_rs__c = 1, RecordTypeId = nationalRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),

            // cenarios cross
            new Opportunity(Name = 'Opp8', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Pix', previs_fat_rs__c = 1, RecordTypeId = crossRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp9', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Cartão de Crédito', previs_fat_rs__c = 1, RecordTypeId = crossRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp10', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Débito Flash', previs_fat_rs__c = 1, RecordTypeId = crossRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp11', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Boleto Flash', previs_fat_rs__c = 1, RecordTypeId = crossRT, StageName = 'Contact', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'EUR'),

            // antecipação cenários

            new Opportunity(Name = 'Opp12', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Boleto Flash', previs_fat_rs__c = 1, RecordTypeId = nationalRT, StageName = 'Contact', Antecipation_Frequency_1__c = 'Daily', Settlement_Frequency_1__c = 'Daily', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp13', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Boleto Flash', previs_fat_rs__c = 1, RecordTypeId = nationalRT, StageName = 'Contact', Antecipation_Frequency_1__c = 'Weekly', Settlement_Frequency_1__c = 'Weekly', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp14', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Boleto Flash', previs_fat_rs__c = 1, RecordTypeId = nationalRT, StageName = 'Contact', Antecipation_Frequency_1__c = 'Biweekly', Settlement_Frequency_1__c = 'Biweekly', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD'),
            new Opportunity(Name = 'Opp15', CloseDate = datClose, AccountId = acct.Id, BusinessModel__c = 'Intermediation', IntegrationType__c = 'Salesforce', NationalPaymentMethod__c = 'Boleto Flash', previs_fat_rs__c = 1, RecordTypeId = nationalRT, StageName = 'Contact', Antecipation_Frequency_1__c = 'Monthly', Settlement_Frequency_1__c = 'Monthly', Product_or_service_website_URL__c = 'www.google.com', Moeda__c = 'USD')
        };

        insert opps;

        List<Product2> products = createProducts();

        createPriceBookEntry(Test.getStandardPricebookId(), products);

        List<PriceBook2> priceBooks = new List<Pricebook2>{
            new PriceBook2(Name = 'Test Pricebook int', IsActive = true, BusinessModel__c = 'Intermediation', IsCrossBoard__c = false),
            new PriceBook2(Name = 'Test Pricebook gat', IsActive = true, BusinessModel__c = 'Gateway', IsCrossBoard__c = false),
            new PriceBook2(Name = 'Test Pricebook int + gat', IsActive = true, BusinessModel__c = 'Intermediation;Gateway', IsCrossBoard__c = false),
            new PriceBook2(Name = 'Test Pricebook Cross', IsActive = true, BusinessModel__c = 'Intermediation', IsCrossBoard__c = true)
        };

        insert priceBooks;

        for(Pricebook2 priceBook : priceBooks){
            createPriceBookEntry(priceBook.Id, products);
        }

        List<Quote> quotes = new List<Quote>();

        for(Opportunity opp : opps){
            quotes.add(new Quote(OpportunityId = opp.Id, Name = '1234213678', Status = 'Draft'));
        }

        insert quotes;

        List<Taxes__c> taxes = new List<Taxes__c> {
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '1', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '2', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '3', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '4', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '5', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '6', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '7', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '8', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '9', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '10', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '11', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Daily', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '12', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '1', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Biweekly', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '1', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Monthly', TaxaBaseAntecipacao__c = '', InstallmentNumber__c = '1', PercentValue__c = 0, IsActive__c = true)
        };

        insert taxes;
    }

    @isTest
    static void testGetOpportunityDetails() {
        List<Opportunity> opps = getOpportunities();

        for(Opportunity opp : opps){
            ApexPages.StandardController sc = new ApexPages.StandardController(opp);

            PageReference pageRef = Page.ContractNacionalPage;

            pageRef.getparameters().put('recordId', opp.id);
            pageRef.getparameters().put('maintenanceDate', String.valueOf(Date.today()));

            Test.setCurrentPage(pageRef);

            ContractController controller = new ContractController(sc);
        }
    }

    @isTest
    static void testGetOpportunityNationalDetails() {

        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('NaTional').getRecordTypeId();

        List<Quote> quotes = [SELECT Id, Opportunity.Name, Opportunity.IntegrationType__c, Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c,
        Opportunity.Settlement_Frequency_Test__c, Opportunity.Payout__c, Opportunity.Antecipation_Frequency_1__c,
        Opportunity.Antecipation_Frequency_2__c, Opportunity.Settlement_Frequency_1__c, Opportunity.Settlement_Frequency_2__c,
        Opportunity.NationalPaymentMethod__c, Opportunity.TaxaBaseDeAntecipacao__c, Opportunity.UsePagstream__c,
        Account.Owner.Name, Account.Owner.Email, Account.Owner.MobilePhone FROM Quote WHERE Opportunity.RecordTypeId = :recordTypeId];

        for(Quote quote : quotes){

            ApexPages.StandardController sc = new ApexPages.StandardController(quote);

            PageReference pageRef = Page.ContractNacionalPage;

            pageRef.getparameters().put('recordId', quote.id);

            Test.setCurrentPage(pageRef);

            PropostaNacionalController controller = new PropostaNacionalController(sc);

            controller.populateOptionsController('Pix', 'Pix', 'Pix');
            controller.populateOptionsController('CreditCard', 'CreditCard', 'CreditCard');
            controller.populateOptionsController('DebitCard', 'DebitCard', 'DebitCard');
            controller.populateOptionsController('Boleto', 'Boleto', 'Boleto');

            //page 1
            controller.setDailyFrequencyPageOne('Daily');
            Assert.areEqual('D+0', controller.frequencyCardEligebleDatePageOne);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageOne);
            Assert.areEqual('diária', controller.antecipationFrequencyPageOne);

            controller.setDailyFrequencyPageOne('Weekly');
            Assert.areEqual('D+7', controller.frequencyCardEligebleDatePageOne);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageOne);
            Assert.areEqual('semanal', controller.antecipationFrequencyPageOne);

            controller.setDailyFrequencyPageOne('Biweekly');
            Assert.areEqual('D+15', controller.frequencyCardEligebleDatePageOne);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageOne);
            Assert.areEqual('bissemanal', controller.antecipationFrequencyPageOne);

            controller.setDailyFrequencyPageOne('Weekly');
            Assert.areEqual('D+7', controller.frequencyCardEligebleDatePageOne);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageOne);
            Assert.areEqual('semanal', controller.antecipationFrequencyPageOne);

            controller.setDailyFrequencyPageOne('Biweekly');
            Assert.areEqual('D+15', controller.frequencyCardEligebleDatePageOne);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageOne);
            Assert.areEqual('bissemanal', controller.antecipationFrequencyPageOne);

            controller.setDailyFrequencyPageOne('Monthly');
            Assert.areEqual('D+31', controller.frequencyCardEligebleDatePageOne);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageOne);
            Assert.areEqual('mensal', controller.antecipationFrequencyPageOne);

            controller.setWeeklyFrequencyPageOne('Monthly');
            Assert.areEqual('D+31', controller.frequencyCardEligebleDatePageOne);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageOne);
            Assert.areEqual('mensal', controller.antecipationFrequencyPageOne);

            // page 2

            controller.setDailyFrequencyPageTwo('Daily');
            Assert.areEqual('D+0', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('diária', controller.antecipationFrequencyPageTwo);

            controller.setDailyFrequencyPageTwo('Weekly');
            Assert.areEqual('D+7', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('semanal', controller.antecipationFrequencyPageTwo);

            controller.setDailyFrequencyPageTwo('Biweekly');
            Assert.areEqual('D+15', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('bissemanal', controller.antecipationFrequencyPageTwo);

            controller.setDailyFrequencyPageTwo('Monthly');
            Assert.areEqual('D+31', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('mensal', controller.antecipationFrequencyPageTwo);

            controller.setWeeklyFrequencyPageTwo('Weekly');
            Assert.areEqual('D+0', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('semanal', controller.antecipationFrequencyPageTwo);

            controller.setWeeklyFrequencyPageTwo('Biweekly');
            Assert.areEqual('D+15', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('bissemanal', controller.antecipationFrequencyPageTwo);

            controller.setWeeklyFrequencyPageTwo('Monthly');
            Assert.areEqual('D+31', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('mensal', controller.antecipationFrequencyPageTwo);

            controller.setBiweeklyFrequencyPageTwo('Biweekly');
            Assert.areEqual('D+0', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('bissemanal', controller.antecipationFrequencyPageTwo);

            controller.setBiweeklyFrequencyPageTwo('Monthly');
            Assert.areEqual('D+31', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('mensal', controller.antecipationFrequencyPageTwo);

            controller.setMonthlyFrequencyPageTwo('Monthly');
            Assert.areEqual('D+0', controller.frequencyCardEligebleDatePageTwo);
            Assert.areEqual('D+0', controller.frequencyPixBoletoDebitoFlashEligebleDatePageTwo);
            Assert.areEqual('mensal', controller.antecipationFrequencyPageTwo);
        }
    }

    @isTest
    static void testGetOpportunityCrossDetails() {

        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Crossborder').getRecordTypeId();

        List<Quote> quotes = [SELECT Id, Account.Name, Account.Website, Opportunity.Name, Opportunity.IntegrationType__c, Opportunity.BusinessModel__c, Opportunity.previs_fat_rs__c, Opportunity.Settlement_Frequency_Test__c,
        Opportunity.Product_Type__c, Opportunity.Payout__c, Opportunity.ApplePay__c, Opportunity.GooglePay__c, Opportunity.Antecipation_Frequency_1__c, Opportunity.Antecipation_Frequency_2__c,
        Opportunity.Settlement_Frequency_1__c, Opportunity.Settlement_Frequency_2__c, Opportunity.NationalPaymentMethod__c, Opportunity.TaxaBaseDeAntecipacao__c, Opportunity.UsePagstream__c,
        Opportunity.Moeda__c, Account.Owner.Name, Account.Owner.Email, Account.Owner.MobilePhone FROM Quote WHERE Opportunity.RecordTypeId = :recordTypeId];

        insert new List<Taxes__c>{
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '1', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '2', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '3', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '4', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '5', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '6', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '7', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '8', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '9', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '10', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '11', PercentValue__c = 0, IsActive__c = true),
            new Taxes__c(AntecipationFrequency__c = 'Weekly', TaxaBaseAntecipacao__c = '1.50', InstallmentNumber__c = '12', PercentValue__c = 0, IsActive__c = true)
        };

        for(Quote quote : quotes){

            ApexPages.StandardController sc = new ApexPages.StandardController(quote);

            PageReference pageRef = Page.ContractNacionalPage;

            pageRef.getparameters().put('recordId', quote.id);

            Test.setCurrentPage(pageRef);

            PropostaCrossController controller = new PropostaCrossController(sc);

            quote.Opportunity.Antecipation_Frequency_1__c = 'Weekly';
            quote.Opportunity.Settlement_Frequency_1__c = 'Weekly';
            controller.fieldsPopulation(quote);
            Assert.areEqual('0', controller.settlementFrequency);

            quote.Opportunity.Antecipation_Frequency_1__c = 'Biweekly';
            quote.Opportunity.Settlement_Frequency_1__c = 'Biweekly';
            controller.fieldsPopulation(quote);
            Assert.areEqual('0', controller.settlementFrequency);

            quote.Opportunity.Antecipation_Frequency_1__c = 'Monthly';
            quote.Opportunity.Settlement_Frequency_1__c = 'Monthly';
            controller.fieldsPopulation(quote);
            Assert.areEqual('0', controller.settlementFrequency);

            quote.Opportunity.previs_fat_rs__c = 6000000;
            controller.fieldsPopulation(quote);
            Assert.areEqual(true, controller.highlightLineTwo);

            quote.Opportunity.previs_fat_rs__c = 11000000;
            controller.fieldsPopulation(quote);
            Assert.areEqual(true, controller.highlightLineOne);

            controller.anticipationFees = '1.50';

            quote.Opportunity.Antecipation_Frequency_1__c = 'Weekly';
            controller.getParcelas(quote, 'One');
            Assert.areEqual(12, controller.frequencyOneValues.size());

            quote.Opportunity.Antecipation_Frequency_2__c = 'Weekly';
            controller.getParcelas(quote, 'Two');
            Assert.areEqual(12, controller.frequencyTwoValues.size());
        }
    }

    @isTest
    static void testGenerateAndSavePDF(){
        Opportunity opp = getOpportunities()[0];

        ContractController.generateAndSavePDF(opp.Id, 'May', String.valueOf(Date.today()), 'https://wwww.google.com', String.valueOf(Date.today()));
    }

    private static List<Opportunity> getOpportunities(){
        return [SELECT Id,
                Name,
                Country__c,
                Product_Type__c,
                ProductClass__c,
                WebSite__c,
                TierCS__c,
                Moeda__c,
                StageName,
                AntecipationFrequency__c,
                Settlement_Frequency_Test__c,
                DateAccountCreation__c,
                Product_or_service_website_URL__c,
                IntegrationType__c,
                SyncedQuoteId,
                Priority__c,
                Payout__c,
                Integracao__c,
                BusinessModel__c,
                NationalPaymentMethod__c,
                Settlement_Frequency_1__c,
                previs_fat_rs__c,
                AccountId,
                Account.Name,
                Account.Nome_Empresarial__c,
                Antecipation_Frequency_1__c,
                Account.Phone,
                Account.Website,
                Account.CNPJ__c,
                Account.VATCNPJ__c,
                Account.OrganizationId__c,
                RecordType.DeveloperName
            FROM Opportunity];
    }

    private static List<Product2> createProducts(){
        List<String> productCodes = new List<String>{
            'PAYOUT_SERVICE_FEE',
            'REMITTANCE_FEE_SUPPLIERS',
            'TAXA_PAGSTREAM_SERVICE_FEE',
            'RESERVE',
            'REMITTANCE_FEE_USD',
            'MINIMUM_TRANSFER_AMOUNT',
            'TERMINATION_FEE_CLOSING_ACCOUNT',
            'TAXA_INT_CARTAO',
            'TAXA_INSTALACAO_SF',
            'SETUP_FEE_USD',
            'SETUP_FEE_EUR',
            'TAXA_MIN_MANUTENCAO_SF',
            'MAINTENANCE_MINIMUM_FEE',
            'ANTICIPATION_FEES',
            'TAXA_TOKENIZACAO',
            'TAXA_GATEWAY_PIX',
            'PROCESSING_FEES_PIX',
            'TAXA_GATEWAY_CREDITO',
            'PROCESSING_FEES_CREDIT_CARD',
            'PAGBRASIL_SOLUTION_FEE',
            'TAXA_GATEWAY_DEBITO',
            'PROCESSING_FEES_DEBITO',
            'AMOUNT_WITHHELD_PROVISION_EUR',
            'REMITTANCE_FEE_SUPPLIERS',
            'TAXA_GATEWAY_BOLETO',
            'PROCESSING_FEES_BOLETO',
            'TAXA_PAYOUT',
            'REMITTANCE_FEE_SUPPLIERS',
            'TAXA_TRANSFER_FORNEC',
            'TAXA_PAGSTREAM',
            'RESERVA_GIRATORIA',
            'TAXA_TRANSFERENCIA',
            'VALOR_MIN_REPASSE',
            'TAXA_INSTALACAO',
            'TAXA_MIN_MANUTENCAO',
            'TAXA_ANTECIPACAO',
            'TAXA_PROCESS_PIX',
            'TAXA_PROCESS_CREDITO',
            'TAXA_PAGBRASIL',
            'TAXA_PROCESS_DEBITO',
            'TAXA_ENCERRAMENTO',
            'TAXA_MIN_PAGSTREAM',
            'CUSTO_PAGSHIELD',
            'TAXA_VAR_PAGSHIELD',
            'REMITTANCE_FEE_SUPPLIERS',
            'TAXA_REEMBOLSO_PIX',
            'TAXA_REEMBOLSO_TRANSF',
            'TAXA_CHARGEBACK',
            'TAXA_PARC_2A6',
            'TAXA_PARC_7A12',
            'CURRENCY_EXCHANGE_MARKUP_SPREAD',
            'IOF_TAX',
            'REMITTANCE_FEE_EUR',
            'REFUND_CARD_ACQUIRER_PIX',
            'REFUND_BANK_TRANSFER',
            'CHARGEBACK',
            'ADDITIONAL_CHARGEBACK_EXCESS_FEE',
            'AMOUNT_WITHHELD_PROVISION_USD',
            'PACKAGE_10000_SMS',
            'PACKAGE_10000_EMAILS',
            'ZERO_AUTH_CREDIT_CARD',
            'DIGITAL_WALLET_SOLUTION',
            'PAGBRASIL_CHECKOUT_SERVICE_FEE',
            'PAGSHIELD_FRAUD_PREVENTION',
            'PAGSHIELD_PREMIUM_FIXED_FEE',
            'PAGSHIELD_PREMIUM_VARIABLE_FEE',
            'PAGSTREAM_MAINTENANCE_MINIMUM_FEE',
            'RECURRING_PIX',
            'PAYOUT_SETUP_FEE_USD',
            'PAYOUT_SETUP_FEE_EUR',
            'REMITTANCE_FEE_SUPPLIERS',
            'TAXA_FIXA_PAGSHIELD',
            'TAXA_PROCESS_BOLETO'
        };

        List<Product2> prodsToInsert = new List<Product2>();

        for(String code : productCodes){
            prodsToInsert.add(new Product2(
                Name = code,
                ProductCode = code,
                IsActive = true
            ));
        }

        insert prodsToInsert;

        return prodsToInsert;
    }

    private static void createPriceBookEntry(Id priceBookId, List<Product2> products){

        List<PricebookEntry> pbesToInsert = new List<PricebookEntry>();

        for(Product2 prod : products){
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = priceBookId,
                Product2Id = prod.Id,
                UnitPrice = 100,
                IsActive = true
            );
            pbesToInsert.add(pbe);
        }

        insert pbesToInsert;
    }
}