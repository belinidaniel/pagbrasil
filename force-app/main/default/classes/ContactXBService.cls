@RestResource(urlMapping='/integration/contact-xb/*')
global class ContactXBService {
	@HttpGet
	global static String getSingleRecord() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

		try {
			String requestURI = req.requestURI;
			String[] urlParts = requestURI.split('/');
			String recordId = urlParts[urlParts.size() - 1];

			Contact existingRecord = [SELECT Id, Name, Phone, Email FROM Contact WHERE Id = :recordId LIMIT 1];

			res.statusCode = 200;
			return JSON.serialize(existingRecord);
		} catch (Exception e) {
			res.statusCode = 500;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'An unexpected error occurred: ' + e.getMessage() });
		}
	}

	@HttpPost
	global static String createContact() {
		System.debug('Post called. ');
		RestRequest request = RestContext.request;
		RestResponse response = RestContext.response;

		try {
			String requestURI = request.requestURI;
			String[] uriParts = requestURI.split('/');
			String kycUuid = uriParts[uriParts.size() - 1];
			Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
			Contact contactRecord = new Contact();
			Set<String> emailSet = new Set<String>();
			KYC_XB__c kycRecord;

			if (kycUuid != null) {
				System.debug('kycUuid: ' + kycUuid);
				kycRecord = [SELECT Id FROM KYC_XB__c WHERE Unique_Link__c = :kycUuid LIMIT 1];
				contactRecord.put('Related_KYC_XB__c', kycRecord.Id);
			}

			for (String key : requestBody.keySet()) {
				System.debug('key: ' + key);
				System.debug('value: ' + requestBody.get(key));
				if (Schema.sObjectType.Contact.fields.getMap().containsKey(key)) {
					if (key == 'Related_KYC_XB__c') {
						Id personalId = Id.valueOf(String.valueOf(requestBody.get(key)));
						contactRecord.put(key, personalId);
						continue;
					}

					if (key == 'Ownership_Percentage__c') {
						Decimal personalId = Decimal.valueOf(String.valueOf(requestBody.get(key)));
						contactRecord.put(key, personalId);
						continue;
					}

					if (key == 'Birthdate') {
						String inputDate = String.valueOf(requestBody.get(key));
						List<String> dateParts = inputDate.split('/');
						String outputDate = dateParts[2] + '-' + dateParts[1] + '-' + dateParts[0];
						Date foundingDate = date.valueOf(outputDate);
						contactRecord.put(key, foundingDate);
						continue;
					}
					contactRecord.put(key, requestBody.get(key));
				}
			}
			System.debug('email: ' + contactRecord.Email + ' <|-|> role: ' + contactRecord.KYC_Role__c);
			if (String.isNotBlank(contactRecord.Email) && String.isNotBlank(contactRecord.KYC_Role__c)) {
                System.debug('contactRecord: ' + contactRecord);
				List<Contact> existingContact = [
					SELECT Email, Id, Name FROM Contact 
					WHERE Email = :contactRecord.Email 
					AND KYC_Role__c = :contactRecord.KYC_Role__c
					AND Related_KYC_XB__c = :kycRecord.Id
				];
				System.debug('existingContact: ' + existingContact);
				if (existingContact.size() == 1) {
					if (existingContact[0].Email == contactRecord.Email) {
						contactRecord.Id = existingContact[0].Id;
						try {
							update contactRecord;
							response.statusCode = 200;
							return JSON.serialize(new Map<String, Object>{ 'id' => contactRecord.Id });
						} catch (DmlException e) {
							response.statusCode = 500;
							return JSON.serialize(new Map<String, Object>{ 'error' => e.getMessage() });
						}
					}
				}
			}

			insert as system contactRecord;
			response.statusCode = 200;
			return JSON.serialize(new Map<String, Object>{ 'id' => contactRecord.Id });
		} catch (JSONException je) {
			System.debug('Failed to deserialize the request body. Error is: ' + je.getMessage());
			response.statusCode = 400;
			return je.getMessage();
		} catch (DmlException dmle) {
			System.debug('Failed to create records: ' + dmle.getMessage());
			response.statusCode = 400;
			return dmle.getMessage();
		} catch (Exception e) {
			System.debug('Unknown error: ' + e.getMessage());
			response.statusCode = 500;
			return e.getMessage();
		}
	}

	@HttpPut
	global static String parseAndCreateNewContacts() {
		System.debug('Put called. ');
		RestRequest request = RestContext.request;
		RestResponse response = RestContext.response;

		try {
			String requestURI = request.requestURI;
			String[] uriParts = requestURI.split('/');
			String kycUuid = uriParts[uriParts.size() - 1];
			String requestBody = request.requestBody.toString();
			List<Contact> contactRecords = (List<Contact>) JSON.deserialize(
				requestBody,
				List<Contact>.class
			);

			if (contactRecords.isEmpty()) {
				response.statusCode = 400;
				response.responseBody = Blob.valueOf('{"error": "Request body cannot be empty"}');
				return 'No contact was created';
			}

			List<Contact> newContacts = new List<Contact>();
			for (Contact c : contactRecords) {
					newContacts.add(c);
				}

			if (!newContacts.isEmpty()) {
				insert newContacts;
				response.statusCode = 200;
			}
			return 'Contacts synced successfully';
		} catch (JSONException je) {
			System.debug('Failed to deserialize the request body. Error is: ' + je.getMessage());
			response.statusCode = 400;
			return je.getMessage();
		} catch (DmlException dmle) {
			System.debug('Failed to create records: ' + dmle.getMessage());
			response.statusCode = 400;
			return dmle.getMessage();
		} catch (Exception e) {
			System.debug('Unknown error: ' + e.getMessage());
			response.statusCode = 500;
			return e.getMessage();
		}
	}

	@HttpDelete
	global static String deleteContact() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

		try {
			String requestURI = req.requestURI;
			String[] uriParts = requestURI.split('/');
			String recordId = uriParts[uriParts.size() - 1];

			if (recordId == 'contact-xb') {
				res.statusCode = 400;
				return JSON.serialize(new Map<String, Object>{ 'error' => 'Missing contact ID' });
			}

			Contact contactToDelete = [SELECT Id FROM Contact WHERE Id = :recordId LIMIT 1];
			delete contactToDelete;

			res.statusCode = 204;
			return null;
		} catch (QueryException qe) {
			res.statusCode = 404;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'Contact not found with ID: ' + qe.getMessage() });
		} catch (Exception e) {
			res.statusCode = 500;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'An unexpected error occurred: ' + e.getMessage() });
		}
	}
}