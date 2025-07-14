/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 07-13-2025
 * @last modified by  : Daniel Belini
**/
@IsTest
public class KYCBoostControllerTest {
    @TestSetup
    static void setupTestData() {
        KYC__c testKyc = new KYC__c(
            Legal_Name__c = 'Test KYC',
            Unique_Link__c = 'test-kyc-uuid'
        );
        insert testKyc;

        List<Big_Boost__c> bigBoosts = new List<Big_Boost__c>();

        bigBoosts.add(new Big_Boost__c(
            KYC__c = testKyc.Id,
            Dataset__c = 'basic_data',
            Result__c = '{"Result":[{"MatchKeys":"doc{14630124000165}","BasicData":{"TaxIdNumber":"14630124000165","TaxIdCountry":"Brazil","OfficialName":"PAGBRASIL PAGAMENTOS ELETRONICOS LTDA","TradeName":"PAGBRASIL","FoundedDate":"2011-11-17T00:00:00Z","TaxIdStatus":"ATIVA","TaxRegime":"LUCRO PRESUMIDO","Activities":[{"IsMain":true,"Code":"8299799","Activity":"OUTRAS ATIVIDADES DE SERVICOS PRESTADOS PRINCIPALMENTE AS EMPRESAS NAO ESPECIFICADAS ANTERIORMENTE"}],"LegalNature":{"Code":"2062","Activity":"SOCIEDADE EMPRESARIA LIMITADA"}}}],"QueryId":"f549b19d-ebd0-4f9b-8cdc-6ab7947c02d3","ElapsedMilliseconds":1498,"QueryDate":"2025-03-24T18:30:36.9529644Z","Status":{"basic_data":[{"Code":0,"Message":"OK"}]},"Evidences":{}}'
        ));

        bigBoosts.add(new Big_Boost__c(
            KYC__c = testKyc.Id,
            Dataset__c = 'kyc',
            Result__c = '{"Result":[{"MatchKeys":"doc{19100000000000}","KycData":{"PEPHistory":[],"IsCurrentlyPEP":false,"SanctionsHistory":[{"Source":"ofac","Type":"Money Laundering","StandardizedSanctionType":"FINANCIAL CRIMES","MatchRate":45,"NameUniquenessScore":0.2,"Details":{"OriginalName":"TESTE LTDA","SanctionName":"TESTE PVT LTD","SanctionAliases|MatchRate":"JAM ROLLED ICE CREAM|23;CAFE SHAZE|31","remarks":"(linked to: rauf, mohamed inthif)"},"NormalizedDetails":{"OriginalName":"TESTE NO BULE LTDA","SanctionName":"TESTE PVT LTD","SanctionAliasesAndMatchRate":"JAM ROLLED ICE CREAM|23;CAFE SHAZE|31"},"StartDate":"0001-01-01T00:00:00","EndDate":"9999-12-31T23:59:59.9999999","CreationDate":"2025-04-04T03:13:35.617","LastUpdateDate":"2025-04-04T03:13:35.617","IsCurrentlyPresentOnSource":true,"WasRecentlyPresentOnSource":true}],"IsCurrentlySanctioned":false,"WasPreviouslySanctioned":false,"Last30DaysSanctions":0,"Last90DaysSanctions":0,"Last180DaysSanctions":0,"Last365DaysSanctions":0,"LastYearPEPOccurence":0,"Last3YearsPEPOccurence":0,"Last5YearsPEPOccurence":0,"Last5PlusYearsPEPOccurence":0,"FirstSanctionDate":"0001-01-01T00:00:00","LastSanctionDate":"0001-01-01T00:00:00","IsCurrentlyElectoralDonor":false,"IsHistoricalElectoralDonor":false,"TotalElectoralDonationsLastTwoElections":0,"TotalElectoralDonations":0,"TotalElectoralDonationAmountLastTwoElections":0,"TotalElectoralDonationAmount":0}}],"QueryId":"d012c9d7-ec69-4c33-967f-910f86a35630","ElapsedMilliseconds":5409,"QueryDate":"2025-04-04T20:54:43.5395486Z","Status":{"kyc":[{"Code":0,"Message":"OK"}]},"Evidences":{}}'
        ));

        bigBoosts.add(new Big_Boost__c(
            KYC__c = testKyc.Id,
            Dataset__c = 'owners_kyc',
            Result__c = '{\"Result\":[{\"MatchKeys\":\"doc{19100000000000}\",\"OwnersKycData\":{\"OwnersKycData\":{\"19100000000000\":{\"PEPHistory\":[],\"IsCurrentlyPEP\":false,\"SanctionsHistory\":[],\"IsCurrentlySanctioned\":false,\"WasPreviouslySanctioned\":false,\"Last30DaysSanctions\":0,\"Last90DaysSanctions\":0,\"Last180DaysSanctions\":0,\"Last365DaysSanctions\":0,\"LastYearPEPOccurence\":0,\"Last3YearsPEPOccurence\":0,\"Last5YearsPEPOccurence\":0,\"Last5PlusYearsPEPOccurence\":0,\"IsCurrentlyElectoralDonor\":false,\"IsHistoricalElectoralDonor\":false,\"TotalElectoralDonationsLastTwoElections\":0,\"TotalElectoralDonations\":0,\"TotalElectoralDonationAmountLastTwoElections\":0,\"TotalElectoralDonationAmount\":0}},\"TotalCurrentlyPEP\":0,\"TotalHistoricallyPEP\":0,\"TotalCurrentlySanctioned\":0,\"TotalHistoricallySanctioned\":2,\"AverageSanctionsPerOwner\":12,\"PEPPercentage\":0,\"OwnerMaxSanctions\":30,\"OwnerMinSanctions\":0,\"Last30DaysSanctions\":0,\"Last90DaysSanctions\":0,\"Last180DaysSanctions\":0,\"Last365DaysSanctions\":0,\"LastYearPEPOccurence\":0,\"Last3YearsPEPOccurence\":0,\"Last5YearsPEPOccurence\":0,\"Last5PlusYearsPEPOccurence\":0,\"ActiveOwners\":[\"15296721000168\",\"15296720000113\",\"30673993825\"],\"InactiveOwners\":[\"25150157864\"]}}],\"QueryId\":\"9e974945-9df9-4e85-aeed-33d887522c5b\",\"ElapsedMilliseconds\":1513,\"QueryDate\":\"2025-04-04T20:29:02.753831Z\",\"Status\":{\"owners_kyc\":[{\"Code\":0,\"Message\":\"OK\"}]},\"Evidences\":{}}'
        ));

        String relationshipsJson = '{"Result":[{"Relationships":{"Relationships":[{"RelatedEntityTaxIdNumber":"123"}]}}]}';
        bigBoosts.add(new Big_Boost__c(
            KYC__c = testKyc.Id,
            Dataset__c = 'relationships',
            Result__c = relationshipsJson
        ));

        String processesJson = '{\"Result\":[{\"MatchKeys\":\"doc{19100000000000}\",\"Lawsuits\":{\"Lawsuits\":[{\"Number\":\"00153271020178160182\",\"Type\":\"Civil\",\"MainSubject\":\"4970 - CHEQUE\",\"Status\":\"REDISTRIBUIDO\",\"PublicationDate\":\"2020-03-31T00:00:00\"}],\"TotalLawsuits\":261,\"TotalLawsuitsAsAuthor\":39,\"TotalLawsuitsAsDefendant\":188,\"FirstLawsuitDate\":\"1993-02-03T00:00:00\",\"LastLawsuitDate\":\"2025-02-18T00:00:00\"}}],\"QueryId\":\"93d46896-b8b4-48ce-9d79-d571bc8e038c\",\"ElapsedMilliseconds\":6308,\"QueryDate\":\"2025-03-25T16:36:31.7906637Z\",\"Status\":{\"processes\":[{\"Code\":0,\"Message\":\"OK\"}]},\"Evidences\":{}}';
        bigBoosts.add(new Big_Boost__c(
            KYC__c = testKyc.Id,
            Dataset__c = 'processes',
            Result__c = processesJson
        ));

        String activityJson = '{\"Result\":[{\"MatchKeys\":\"doc*************07}\",\"ActivityIndicators\":{\"EmployeesRange\":\"020 A 049\",\"IncomeRange\":\"ACIMA DE 2.5MM ATE 5MM\",\"HasActivity\":false,\"ActivityLevel\":\"0,24691358\",\"FirstLevelEconomicGroupAverageActivityLevel\":\"0,24691358\",\"FirstLevelEconomicGroupMaxActivityLevel\":\"0,24691358\",\"FirstLevelEconomicGroupMinActivityLevel\":\"0,24691358\",\"ShellCompanyLikelyhood\":\"0,25\",\"HasRecentAddress\":false,\"HasRecentPhone\":false,\"HasRecentEmail\":false,\"HasRecentPassages\":true,\"HasActiveDomain\":true,\"HasActiveSSL\":false,\"HasCorporateEmail\":true,\"NumberOfBranches\":0}}],\"QueryId\":\"106d9bec-ee8c-40c9-8b4a-99d039783456\",\"ElapsedMilliseconds\":88,\"QueryDate\":\"2024-09-10T15:10:40.7035132Z\",\"Status\":{\"activity_indicators\":[{\"Code\":0,\"Message\":\"OK\"},{\"Code\":0,\"Message\":\"OK\"},{\"Code\":0,\"Message\":\"OK\"},{\"Code\":0,\"Message\":\"OK\"},{\"Code\":0,\"Message\":\"OK\"},{\"Code\":0,\"Message\":\"OK\"}]},\"Evidences\":{}}';
        bigBoosts.add(new Big_Boost__c(
            KYC__c = testKyc.Id,
            Dataset__c = 'activity_indicators',
            Result__c = activityJson
        ));
        
        String emailsJson = '{"Result":[{"ExtendedEmails":{"Emails":[{"Email":"test@example.com","IsMainForEntity":true}]}}]}';
        bigBoosts.add(new Big_Boost__c(
            KYC__c = testKyc.Id,
            Dataset__c = 'emails_extended',
            Result__c = emailsJson
        ));

        bigBoosts.add(new Big_Boost__c(
            KYC__c = testKyc.Id,
            Dataset__c = 'media_profile_and_exposure',
            Result__c = '{"Mentions":5,"Sentiment":"Positive"}'
        ));

        insert bigBoosts;
    }

    @IsTest
    static void testProcessEmailsExtended() {
        KYC__c testKyc = [SELECT Id FROM KYC__c LIMIT 1];
        Test.setCurrentPage(Page.KYCBoostPage);
        ApexPages.currentPage().getParameters().put('id', testKyc.Id);
        KYCBoostController controller = new KYCBoostController();
        System.assertEquals(true, controller.hasEmailsBB);
        System.assertEquals(1, controller.emailsBB.size());
        System.assertEquals('test@example.com', controller.emailsBB[0].get('Email'));
    }

    @IsTest
    static void testProcessProcesses() {
        KYC__c testKyc = [SELECT Id FROM KYC__c LIMIT 1];
        Test.setCurrentPage(Page.KYCBoostPage);
        ApexPages.currentPage().getParameters().put('id', testKyc.Id);
        KYCBoostController controller = new KYCBoostController();
        System.assertEquals(true, controller.hasProcessesBB);
        System.assertEquals(1, controller.processesBB.size());
        System.assertEquals('Civil', controller.processesBB[0].get('Type'));
    }

    @IsTest
    static void testBooleanProperties() {
        KYC__c testKyc = [SELECT Id FROM KYC__c LIMIT 1];
        System.debug(testKyc);
        Test.setCurrentPage(Page.KYCBoostPage);
        ApexPages.currentPage().getParameters().put('id', testKyc.Id);
        KYCBoostController controller = new KYCBoostController();
        System.assertEquals(true, controller.hasBasicBB);
    }
    
    @IsTest
    static void testOwners() {
        KYC__c testKyc = [SELECT Id FROM KYC__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', testKyc.Id);
        KYCBoostController controller = new KYCBoostController();
        System.assertEquals(true, controller.hasOwnersBB);
    }
    
	@IsTest
	static void testActivities() {
		KYC__c testKyc = [SELECT Id FROM KYC__c LIMIT 1];
		ApexPages.currentPage().getParameters().put('id', testKyc.Id);
		KYCBoostController controller = new KYCBoostController();
		System.assertEquals(true, controller.hasBasicBB);
		List<Object> resultList = (List<Object>)controller.basicBB.get('Result');
        System.debug(resultList);
		Map<String, Object> resultMap = (Map<String, Object>)resultList[0];
        System.debug(resultMap);
		Map<String, Object> basicData = (Map<String, Object>)resultMap.get('BasicData');
        System.debug(basicData);
		List<Object> rawActivities = (List<Object>)basicData.get('Activities');
		List<Map<String, Object>> activities = new List<Map<String, Object>>();
		for (Object item : rawActivities) {
			activities.add((Map<String, Object>)item);
		}
		Map<String, Object> firstActivity = activities[0];
		String firstCode = (String) firstActivity.get('Code');
	System.assertEquals('8299799', firstCode);
	}
}