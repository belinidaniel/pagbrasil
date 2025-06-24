public class BigBoostService {
    @AuraEnabled 
    @Future(callout=true)
	public static void getCompanyReportDataset(String dataset, String cnpj, Id kycId) {
		// Data de expiração destes tokens abaixo: 01/03/2033
		BigBoost_Configuration__mdt config = [
			SELECT Access_Token__c, Token_Id__c 
			FROM BigBoost_Configuration__mdt 
			WHERE DeveloperName = 'Primary_Configuration' 
			LIMIT 1
		];

		String API_BIGBOOST_ACCESS_TOKEN = config.Access_Token__c;
		String API_BIGBOOST_TOKEN_ID = config.Token_Id__c;

		dataset += getDatasetQueryFilter(dataset);

		String url = 'https://plataforma.bigdatacorp.com.br/empresas';

        Map<String, Object> body = new Map<String, Object>{
			'Datasets' => dataset,
			'q' => 'doc{' + cnpj + '}'
		};
            
		if (dataset == 'processes') {
            Boolean returnUpdates = false;
            body.put('q', 'doc{' + cnpj + '},returnupdates{' + returnUpdates + '}');
		}

		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept', 'application/json');
		req.setHeader('Authorization', 'Bearer ' + API_BIGBOOST_ACCESS_TOKEN);
		req.setHeader('TokenId', API_BIGBOOST_TOKEN_ID);
		req.setHeader('AccessToken', API_BIGBOOST_ACCESS_TOKEN);
		req.setBody(JSON.serialize(body));
		req.setTimeout(120000);

		Http http = new Http();
		HttpResponse res;

		try {
			res = http.send(req);
			if (res.getStatusCode() != 200) {
				System.debug('HTTP Request Failed: ' + res.getBody());
				throw new CalloutException('Error: ' + res.getBody());
			}
		} catch (Exception e) {
			System.debug('HTTP Request Failed: ' + e.getMessage());
			throw new CalloutException('HTTP Request Failed: ' + e.getMessage());
		}
        
		System.enqueueJob(new InsertBigBoostJob(kycId, cnpj, dataset, res.getBody()));
	}

	public static String getDatasetQueryFilter(String dataset) {
		switch on dataset {
			when 'basic_data' {
				return '{TaxIdNumber,OfficialName,TaxIdCountry,TaxIdStatus,FoundedDate,TradeName,TaxRegime,LegalNature.Code,LegalNature.Activity,Activities.Code,Activities.IsMain,Activities.Activity}';
			}
			when 'media_profile_and_exposure' {
				return '{NewsItems.Title,NewsItems.Url,NewsItems.PublicationDate,MediaExposureLevel,CelebrityLevel,UnpopularityLevel}.filter(Label=NEGATIVE)';
			}
			when 'domains' {
				return '{HostName,DomainName,DomainClass,DomainMainSegment,VisitorRange,IspCountry,IspRegion,IspCity,CaptureDate,RegistrationDate,ExpirationDate,IsActive}';
			}
			when 'emails' {
				return '{EmailAddress,UserName,Type,IsMainForEntity,IsRecentForEntity,IsActive,ValidationStatus}';
			}
            when 'processes' {
                return '{TotalLawsuits,TotalLawsuitsAsAuthor,TotalLawsuitsAsDefendant,LastLawsuitDate,FirstLawsuitDate,Lawsuits.Number,Lawsuits.Type,Lawsuits.MainSubject,Lawsuits.Status,Lawsuits.PublicationDate}';
            }
			when else {
				return '';
			}
		}
	}
}