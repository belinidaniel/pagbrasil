@IsTest
private class BigBoostServiceTest {
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success": true}');
            res.setStatusCode(200);
            return res;
        }
    }

    @IsTest
    static void testGetCompanyReportDataset() {
        KYC__c kyc = new KYC__c(
            Unique_Link__c = 'unique123',
            Legal_Name__c = 'Test Legal Name'
        );
        insert kyc;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        String dataset = 'basic_data';
        String cnpj = '12345678000195';
        Id kycId = kyc.Id;

        Test.startTest();
        BigBoostService.getCompanyReportDataset(dataset, cnpj, kycId);
        Test.stopTest();

        System.assert(true, 'Callout completed without exception.');
    }

    @IsTest
    static void testGetDatasetQueryFilter() {
        System.assertEquals(
            '{TaxIdNumber,OfficialName,TaxIdCountry,TaxIdStatus,FoundedDate,TradeName,TaxRegime,LegalNature.Code,LegalNature.Activity,Activities.Code,Activities.IsMain,Activities.Activity}',
            BigBoostService.getDatasetQueryFilter('basic_data')
        );
        System.assertEquals(
            '{NewsItems.Title,NewsItems.Url,NewsItems.PublicationDate,MediaExposureLevel,CelebrityLevel,UnpopularityLevel}.filter(Label=NEGATIVE)',
            BigBoostService.getDatasetQueryFilter('media_profile_and_exposure')
        );
        System.assertEquals(
            '{HostName,DomainName,DomainClass,DomainMainSegment,VisitorRange,IspCountry,IspRegion,IspCity,CaptureDate,RegistrationDate,ExpirationDate,IsActive}',
            BigBoostService.getDatasetQueryFilter('domains')
        );
        System.assertEquals(
            '{EmailAddress,UserName,Type,IsMainForEntity,IsRecentForEntity,IsActive,ValidationStatus}',
            BigBoostService.getDatasetQueryFilter('emails')
        );
        System.assertEquals(
            '{TotalLawsuits,TotalLawsuitsAsAuthor,TotalLawsuitsAsDefendant,LastLawsuitDate,FirstLawsuitDate,Lawsuits.Number,Lawsuits.Type,Lawsuits.MainSubject,Lawsuits.Status,Lawsuits.PublicationDate}',
            BigBoostService.getDatasetQueryFilter('processes')
        );
        System.assertEquals(
            '',
            BigBoostService.getDatasetQueryFilter('unknown_dataset')
        );
    }
}