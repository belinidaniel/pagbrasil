@RestResource(urlMapping='/integration/kyc/*')
global without sharing class KYCService {

	@HttpGet
	global static String getKYC() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		
		try {
			String requestURI = req.requestURI;
			String[] uriParts = requestURI.split('/');
			String recordId = uriParts[uriParts.size() - 1];
            List <KYC__c> kycList = [SELECT Id FROM KYC__c WHERE Unique_Link__c = :recordId];
			if (kycList.size() <= 0) {
				res.statusCode = 400;
				return JSON.serialize(new Map<String, Object>{ 'error' => 'Invalid or missing KYC record ID' });
			}
			String fields = String.join(new List<String>(Schema.getGlobalDescribe().get('KYC__c').getDescribe().fields.getMap().keySet()), ',');
            String contactFields = 'Id, Name, Email, Phone, Birthdate, Registration_Number__c, Role__c, KYC_Fiscal_Code__c, KYC_Role__c, MailingAddress, Nationality__c, Ownership_Percentage__c, Linkedin__c, Channel_URL__c';
			String query = 
                'SELECT ' + 
                fields + 
                ', Personal_Contact__r.KYC_Fiscal_Code__c, Personal_Contact__r.Email, Personal_Contact__r.Name, Personal_Contact__r.Phone, Personal_Contact__r.Registration_Number__c, Bank_Option__r.Description__c, Bank_Option__r.Number__c, Bank_Option__r.ISPB__c, (SELECT ' + 
                contactFields + 
                ' FROM KYC_Contacts__r ORDER BY CreatedDate) FROM KYC__c WHERE Unique_Link__c = :recordId LIMIT 1';
			KYC__c existingRecord = Database.query(query);
			System.debug(existingRecord);
			return JSON.serialize(existingRecord);
		} catch (Exception e) {
			res.statusCode = 500;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'An unexpected error occurred: ' + e.getMessage() });
		}
	}
	
	@HttpPost
	global static String createKYC() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

		try {
			Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
			KYC__c kycRecord = new KYC__c();
			for (String key : requestBody.keySet()) {
				if (Schema.sObjectType.KYC__c.fields.getMap().containsKey(key)) {
					if (key == 'Founding_Date__c') {
						String inputDate = String.valueOf(requestBody.get(key));
						List<String> dateParts = inputDate.split('/');
						String outputDate = dateParts[2] + '-' + dateParts[1] + '-' + dateParts[0];
						Date foundingDate = date.valueOf(outputDate);
						kycRecord.put(key, foundingDate);
						continue;
					}
					if (key == 'Personal_Contact__c') {
						Id personalId = Id.valueOf(String.valueOf(requestBody.get(key)));
						kycRecord.put(key, personalId);
						continue;
					}
					kycRecord.put(key, requestBody.get(key));
				}
			}
			insert as system kycRecord;
			res.statusCode = 201;
			return JSON.serialize(new Map<String, Object>{ 'id' => kycRecord.Id });
		} catch (JSONException e) {
			System.debug('JSON error: ' + e);
			res.statusCode = 400;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'Invalid JSON format: ' + e.getMessage() });
		} catch (DmlException e) {
			System.debug('DML error: ' + e);
			res.statusCode = 500;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'Database error: ' + e.getMessage() });
		} catch (Exception e) {
			System.debug('Unknown error: ' + e);
			res.statusCode = 500;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'An unexpected error occurred: ' + e.getMessage() });
		}
	}

	@HttpPatch
	global static String updateKYC() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
    System.debug('--- PATCH REQUEST START ---');
    System.debug('Request URI: ' + req.requestURI);
    System.debug('Request Body: ' + req.requestBody.toString());

		try {
			String requestURI = req.requestURI;
			String[] uriParts = requestURI.split('/');
			String recordId = uriParts[uriParts.size() - 1];
        System.debug('Parsed Record ID: ' + recordId);
			if (recordId == null) {
				res.statusCode = 400;
				return JSON.serialize(new Map<String, Object>{ 'error' => 'Invalid or missing KYC record ID' });
			}

			KYC__c existingRecord = [SELECT Id FROM KYC__c WHERE Unique_Link__c = :recordId WITH SYSTEM_MODE LIMIT 1];
            System.debug('Existing KYC record: ' + existingRecord);
			Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
            System.debug('Deserialized Request Body: ' + requestBody);
			for (String key : requestBody.keySet()) {
            System.debug('Processing field: ' + key + ' => ' + requestBody.get(key));
				if (Schema.sObjectType.KYC__c.fields.getMap().containsKey(key)) {
					if (key == 'Founding_Date__c') {
						String inputDate = String.valueOf(requestBody.get(key));
						List<String> dateParts = inputDate.split('/');
						String outputDate = dateParts[2] + '-' + dateParts[1] + '-' + dateParts[0];
						Date foundingDate = date.valueOf(outputDate);
						existingRecord.Founding_Date__c = foundingDate;
						continue;
					}
					if (key == 'Personal_Contact__c') {
						Id personalId = Id.valueOf(String.valueOf(requestBody.get(key)));
						existingRecord.Personal_Contact__c = personalId;
						continue;
					}
                    if (key == 'Stage_Number__c') {
						String value = String.valueOf(requestBody.get(key));
                        Integer stageNumber = Integer.valueOf(value);
                        System.debug(stageNumber);
						existingRecord.Stage_Number__c = stageNumber;
						continue;
                    }
                    if (key == 'Bank_Number__c') {
						String bankInfo = String.valueOf(requestBody.get(key));
						Decimal ispb = Decimal.valueOf(bankInfo);
                        System.debug('ispb');
                        System.debug(ispb);

						Bank_Option__c bankOption = [
    	               		SELECT Id FROM Bank_Option__c WHERE ISPB__c = :ispb LIMIT 1
						];
                        System.debug('bankOption');
                        System.debug(bankOption);
						
						if (bankOption != null) {
							existingRecord.Bank_Option__c = bankOption.Id;
						}
                        
                        existingRecord.Bank_Number__c = bankInfo;
						continue;
					}
					if (key == 'Conformity__c') {
						Boolean value = Boolean.valueOf(requestBody.get(key));
						existingRecord.Conformity__c = value;
                        continue;
					}
					existingRecord.put(key, requestBody.get(key));
				}
			}
        System.debug('Final updated KYC record: ' + existingRecord);
            System.debug(existingRecord);
			update as system existingRecord;
			res.statusCode = 200;
			return JSON.serialize(new Map<String, Object>{ 'id' => existingRecord.Id });
		} catch (JSONException e) {
        System.debug('JSONException: ' + e.getMessage());
			res.statusCode = 400;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'Invalid JSON format: ' + e.getMessage() });
		} catch (DmlException e) {
        System.debug('DmlException: ' + e.getMessage());
			res.statusCode = 500;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'Database error: ' + e.getMessage() });
		} catch (QueryException e) {
        System.debug('QueryException: ' + e.getMessage());
			res.statusCode = 400;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'Query error: ' + e.getMessage() });
		} catch (Exception e) {
        System.debug('Unexpected Exception: ' + e.getMessage());
			res.statusCode = 500;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'An unexpected error occurred: ' + e.getMessage() });
		}
	}
	
	@AuraEnabled(cacheable=true)
    public static String getKycIdByOpportunity(String opportunityId, String recordTypeName) {
        if (String.isBlank(opportunityId) || String.isBlank(recordTypeName)) {
            return null;
        }
        
        if (recordTypeName == 'National') {
            KYC__c kyc = [
                SELECT Id 
                FROM KYC__c 
                WHERE Opportunity__c = :opportunityId
                LIMIT 1
            ];
            return kyc != null ? kyc.Id : null;
        }
        
        if (recordTypeName == 'Crossborder') {
            KYC_XB__c kycXb = [
                SELECT Id 
                FROM KYC_XB__c 
                WHERE Opportunity__c = :opportunityId
                LIMIT 1
            ];
            return kycXb != null ? kycXb.Id : null;
        }
        
        return null;
    }
}