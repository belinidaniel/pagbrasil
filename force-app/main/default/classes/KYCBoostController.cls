public class KYCBoostController {
	public List<Big_Boost__c> bigBoosts { get; set; }
	public Map<String, Object> basicBB { get; set; }
	public Map<String, Object> kycBB { get; set; }
	public Map<String, Object> mediaBB { get; set; }
	public OwnerDataResponse.RootResponse ownersBB { get; set; }
	public Map<String, Object> phonesBB { get; set; }
	public List<Map<String, Object>> emailsBB { get; set; }
	public Map<String, Object> addressesBB { get; set; }
	public Map<String, Object> appsBB { get; set; }
	public AppsNetworksSummary appsSummary { get; set; }
	public List<Map<String, Object>> appProfiles { get; set; }
	public List<Map<String, Object>> searchEngineResults { get; set; }
	public Map<String, Object> domainsBB { get; set; }
	public List<Map<String, Object>> processesBB { get; set; }
	public Map<String, Object> lawsuits { get; set; }
	public IndicatorDataResponse.RootResponse activityBB { get; set; }
	public Map<String, Object> relationshipsBB { get; set; }
	public List<OwnerDataResponse.OwnerSummary> ownersList { get; set; }

	public Boolean hasBasicBB { get { return basicBB != null && !basicBB.isEmpty(); } }
	public Boolean hasKycBB { get { return kycBB != null && !kycBB.isEmpty(); } }
	public Boolean hasOwnersBB { get { return ownersBB != null && ownersBB.Result != null && !ownersBB.Result.isEmpty(); } }
	public Boolean hasEmailsBB { get; set; }
	public Boolean hasAppsBB { get; set; }
	public Boolean hasDomainsBB { get { return domainsBB != null && !domainsBB.isEmpty(); } }
	public Boolean hasProcessesBB { get; set; }
	public Boolean hasRelationshipsBB { get { return relationshipsBB != null && !relationshipsBB.isEmpty(); } }

	public Boolean getHasActivitiesBB() {
		try {
			return basicBB != null &&
				((Map<String, Object>)((Map<String, Object>)((List<Object>)basicBB.get('Result'))[0]).get('BasicData')).containsKey('Activities');
		} catch (Exception e) {
			return false;
		}
	}

	public Boolean getHasAddressesBB() {
		try {
			return addressesBB != null &&
				((Map<String, Object>)((Map<String, Object>)((List<Object>)addressesBB.get('Result'))[0]).get('ExtendedAddresses')).containsKey('Addresses');
		} catch (Exception e) {
			return false;
		}
	}

	public Boolean getHasPhonesBB() {
		try {
			return phonesBB != null &&
				((Map<String, Object>)((Map<String, Object>)((List<Object>)phonesBB.get('Result'))[0]).get('ExtendedPhones')).containsKey('Phones');
		} catch (Exception e) {
			return false;
		}
	}

	public Boolean getHasMediaBB() {
		try {
			return mediaBB != null &&
				((List<Object>)mediaBB.get('Result')).size() > 0;
		} catch (Exception e) {
			return false;
		}
	}

	public String getTaxIdNumber() {
		return getBasicDataStringValue('TaxIdNumber');
	}

	public String getTaxIdCountry() {
		return getBasicDataStringValue('TaxIdCountry');
	}

	public String getLegalNatureActivity() {
		try {
			Map<String, Object> basicData = getBasicData();

			if (basicData != null && basicData.containsKey('LegalNature')) {
				Map<String, Object> legalNature = (Map<String, Object>) basicData.get('LegalNature');

				if (legalNature != null && legalNature.containsKey('Activity')) {
					return (String) legalNature.get('Activity');
				}
			}
		} catch (Exception e) {
			return '';
		}

		return '';
	}

	public String getTaxIdStatus() {
		return getBasicDataStringValue('TaxIdStatus');
	}

	public String getOfficialName() {
		return getBasicDataStringValue('OfficialName');
	}

	public String getTradeName() {
		return getBasicDataStringValue('TradeName');
	}

	public String getFoundedDate() {
		return getBasicDataStringValue('FoundedDate');
	}

	public String getTaxRegime() {
		return getBasicDataStringValue('TaxRegime');
	}

	public String getCelebrityLevel() {
		try {
			Map<String, Object> mediaProfile = getMediaProfile();

			if (mediaProfile != null && mediaProfile.containsKey('CelebrityLevel')) {
				return String.valueOf(mediaProfile.get('CelebrityLevel'));
			}
		} catch (Exception e) {
			return '';
		}

		return '';
	}

	public String getMediaExposureLevel() {
		try {
			Map<String, Object> mediaProfile = getMediaProfile();

			if (mediaProfile != null && mediaProfile.containsKey('MediaExposureLevel')) {
				return String.valueOf(mediaProfile.get('MediaExposureLevel'));
			}
		} catch (Exception e) {
			return '';
		}

		return '';
	}

	public String getUnpopularityLevel() {
		try {
			Map<String, Object> mediaProfile = getMediaProfile();

			if (mediaProfile != null && mediaProfile.containsKey('UnpopularityLevel')) {
				return String.valueOf(mediaProfile.get('UnpopularityLevel'));
			}
		} catch (Exception e) {
			return '';
		}

		return '';
	}

	public KYCBoostController() {
		bigBoosts = new List<Big_Boost__c>();
		basicBB = new Map<String, Object>();
		kycBB = new Map<String, Object>();
		mediaBB = new Map<String, Object>();
		ownersBB = new OwnerDataResponse.RootResponse();
		phonesBB = new Map<String, Object>();
		addressesBB = new Map<String, Object>();
		appsBB = new Map<String, Object>();
		domainsBB = new Map<String, Object>();
		activityBB = new IndicatorDataResponse.RootResponse();
		relationshipsBB = new Map<String, Object>();
		ownersList = new List<OwnerDataResponse.OwnerSummary>();
		processesBB = new List<Map<String, Object>>();
		emailsBB = new List<Map<String, Object>>();
		lawsuits = new Map<String, Object>();

		Id recordId = ApexPages.currentPage().getParameters().get('id');

		if (recordId != null) {
			bigBoosts = [
				SELECT Name, CNPJ__c, Dataset__c, Query_Id__c, Result__c
				FROM Big_Boost__c
				WHERE KYC__c = :recordId
				ORDER BY Dataset__c ASC
			];

			processBigBoosts(bigBoosts);
		}

		updateOwnerTaxIds();
	}

	private void processBigBoosts(List<Big_Boost__c> bigBoosts) {
		for (Big_Boost__c bb : bigBoosts) {
			String dataset = bb.Dataset__c;
			String resultJson = bb.Result__c;

			if (String.isBlank(dataset) || String.isBlank(resultJson)) {
				continue;
			}

			if (dataset.contains('basic_data')) {
				basicBB = safeDeserialize(resultJson);
			} else if (dataset == 'kyc') {
				kycBB = safeDeserialize(resultJson);
			} else if (dataset.contains('media_profile_and_exposure')) {
				mediaBB = safeDeserialize(resultJson);
			} else if (dataset == 'owners_kyc') {
				processOwnersKyc(resultJson);
			} else if (dataset == 'phones_extended') {
				phonesBB = safeDeserialize(resultJson);
			} else if (dataset.contains('emails_extended')) {
				processEmailsExtended(resultJson);
			} else if (dataset == 'addresses_extended') {
				addressesBB = safeDeserialize(resultJson);
			} else if (dataset.contains('apps_networks_and_platforms')) {
				processApps(resultJson);
			} else if (dataset.contains('domains')) {
				domainsBB = safeDeserialize(resultJson);
			} else if (dataset.contains('processes')) {
				processProcesses(resultJson);
			} else if (dataset == 'activity_indicators') {
				try {
					activityBB = (IndicatorDataResponse.RootResponse) JSON.deserialize(resultJson, IndicatorDataResponse.RootResponse.class);
				} catch (Exception e) {
					System.debug('Error deserializing activity_indicators: ' + e.getMessage());
					activityBB = new IndicatorDataResponse.RootResponse();
				}
			} else if (dataset == 'relationships') {
				relationshipsBB = safeDeserialize(resultJson);
			}
		}
	}


	private Map<String, Object> getMediaProfile() {
		try {
			if (mediaBB != null && mediaBB.containsKey('Result')) {
				List<Object> results = (List<Object>) mediaBB.get('Result');

				if (!results.isEmpty()) {
					Map<String, Object> firstResult = (Map<String, Object>) results[0];

					if (firstResult.containsKey('MediaProfileAndExposure')) {
						return (Map<String, Object>) firstResult.get('MediaProfileAndExposure');
					}
				}
			}
		} catch (Exception e) {
			return null;
		}

		return null;
	}

	private Map<String, Object> safeDeserialize(String jsonString) {
		try {
			return (Map<String, Object>) JSON.deserializeUntyped(jsonString);
		} catch (Exception e) {
			System.debug('Error deserializing JSON: ' + e.getMessage());
			return new Map<String, Object>();
		}
	}

	private void processOwnersKyc(String resultJson) {
		try {
			ownersBB = (OwnerDataResponse.RootResponse) JSON.deserialize(resultJson, OwnerDataResponse.RootResponse.class);

			if (ownersBB != null && ownersBB.Result != null && !ownersBB.Result.isEmpty() && ownersBB.Result[0].OwnersKycData != null && ownersBB.Result[0].OwnersKycData.OwnersKycData != null) {
				for (String ownerId : ownersBB.Result[0].OwnersKycData.OwnersKycData.keySet()) {
					OwnerDataResponse.OwnerKycDataDetails ownerDetails = ownersBB.Result[0].OwnersKycData.OwnersKycData.get(ownerId);
					String taxId = (ownerDetails.PEPHistory != null && !ownerDetails.PEPHistory.isEmpty()) ? ownerDetails.PEPHistory[0].TaxId : '';

					OwnerDataResponse.OwnerSummary newOwner = new OwnerDataResponse.OwnerSummary(
						TaxId,
						ownerDetails.IsCurrentlyElectoralDonor,
						ownerDetails.IsCurrentlyPEP,
						ownerDetails.IsCurrentlySanctioned
					);

					ownersList.add(newOwner);
				}
			}
		} catch (Exception e) {
			System.debug('Error deserializing or processing owners_kyc: ' + e.getMessage());
			ownersBB = new OwnerDataResponse.RootResponse();
		}
	}

	private void processEmailsExtended(String resultJson) {
		hasEmailsBB = false;

		try {
			Map<String, Object> procResponse = safeDeserialize(resultJson);
			List<Object> resultList = (List<Object>) procResponse.get('Result');

			if (resultList == null || resultList.isEmpty()) {
				return;
			}

			Map<String, Object> firstResult = (Map<String, Object>) resultList[0];
			Map<String, Object> extendedEmails = (Map<String, Object>) firstResult.get('ExtendedEmails');

			if (extendedEmails == null || !extendedEmails.containsKey('Emails')) {
				return;
			}

			List<Object> emailsList = (List<Object>) extendedEmails.get('Emails');

			if (emailsList == null) {
				return;
			}

			for (Object emailObj : emailsList) {
				Map<String, Object> emailMap = (Map<String, Object>) emailObj;

				if (emailMap.containsKey('IsMainForEntity')) {
					emailsBB.add(emailMap);
				}
			}

			hasEmailsBB = true;
		} catch (Exception e) {
			System.debug('Error processing emails_extended: ' + e.getMessage());
			emailsBB = new List<Map<String, Object>>();
		}
	}

	private void processProcesses(String resultJson) {
		hasProcessesBB = false;

		try {
			Map<String, Object> procResponse = safeDeserialize(resultJson);
			List<Object> resultList = (List<Object>) procResponse.get('Result');

			if (resultList == null || resultList.isEmpty()) {
				return;
			}

			Map<String, Object> firstResult = (Map<String, Object>) resultList[0];
			lawsuits = (Map<String, Object>) firstResult.get('Lawsuits');

			if (lawsuits == null || !lawsuits.containsKey('Lawsuits')) {
				return;
			}

			List<Object> lawsuitsList = (List<Object>) lawsuits.get('Lawsuits');

			if (lawsuitsList == null) {
				return;
			}

			for (Object lawsuitObj : lawsuitsList) {
				Map<String, Object> lawsuitMap = (Map<String, Object>) lawsuitObj;

				if (lawsuitMap.containsKey('Type')) {
					processesBB.add(lawsuitMap);
				}
			}

			hasProcessesBB = true;
		} catch (Exception e) {
			System.debug('Error processing processes: ' + e.getMessage());
			processesBB = new List<Map<String, Object>>();
			hasProcessesBB = false;
		}
	}

	private void updateOwnerTaxIds() {
		if (relationshipsBB == null || !relationshipsBB.containsKey('Result')) {
			return;
		}

		List<Object> results = (List<Object>) relationshipsBB.get('Result');
		if (results == null || results.isEmpty()) {
			return;
		}

		Map<String, Object> firstResult = (Map<String, Object>) results[0];
		Map<String, Object> relationshipsMap = (Map<String, Object>) firstResult.get('Relationships');
		List<Object> relationships = (List<Object>) relationshipsMap.get('Relationships');

		if (relationships == null || ownersList == null || relationships.size() != ownersList.size()) {
			return;
		}

		for (Integer j = 0; j < ownersList.size(); j++) {
			OwnerDataResponse.OwnerSummary owner = ownersList[j];

			if (owner.TaxId == null) {
				Map<String, Object> dataMap = (Map<String, Object>) relationships[j];

				if (dataMap != null && dataMap.containsKey('RelatedEntityTaxIdNumber')) {
					owner.TaxId = (String) dataMap.get('RelatedEntityTaxIdNumber');
				}
			}
		}
	}

	public String getLastLawsuitDate() {
		if (lawsuits != null && lawsuits.containsKey('LastLawsuitDate')) {
			return (String) lawsuits.get('LastLawsuitDate');
		} else {
		return '';
		}
	}

	public String getFirstLawsuitDate() {
		if (lawsuits != null && lawsuits.containsKey('FirstLawsuitDate')) {
			return (String) lawsuits.get('FirstLawsuitDate');
		} else {
		return '';
		}
	}

	private Map<String, Object> getBasicData() {
		try {
			if (basicBB != null && basicBB.containsKey('Result')) {
				List<Object> results = (List<Object>) basicBB.get('Result');

				if (!results.isEmpty()) {
					Map<String, Object> firstResult = (Map<String, Object>) results[0];

					if (firstResult.containsKey('BasicData')) {
						return (Map<String, Object>) firstResult.get('BasicData');
					}
				}
			}
		} catch (Exception e) {
			return null;
		}

		return null;
	}

	private String getBasicDataStringValue(String key) {
		try {
			Map<String, Object> basicData = getBasicData();

			if (basicData != null && basicData.containsKey(key)) {
				return String.valueOf(basicData.get(key));
			}
		} catch (Exception e) {
			return '';
		}

		return '';
	}

	private void processApps(String resultJson) {
		appsBB = safeDeserialize(resultJson);
		hasAppsBB = true;
		appsSummary = new AppsNetworksSummary();

		try {
			if (!appsBB.containsKey('Result')) {
				return;
			}

			List<Object> resultList = (List<Object>) appsBB.get('Result');
			if (resultList == null || resultList.isEmpty()) {
				return;
			}

			Map<String, Object> firstResult = (Map<String, Object>) resultList[0];
			if (!firstResult.containsKey('AppsNetworksAndPlatforms')) {
				return;
			}

			Map<String, Object> appsNetworks = (Map<String, Object>) firstResult.get('AppsNetworksAndPlatforms');
			if (appsNetworks == null) {
				return;
			}

			appsSummary.totalSocialNetworks = appsNetworks.containsKey('TotalSocialNetworks') ? (Integer) appsNetworks.get('TotalSocialNetworks') : 0;
			appsSummary.totalSearchResults = appsNetworks.containsKey('TotalSearchResults') ? (Integer) appsNetworks.get('TotalSearchResults') : 0;
			appsSummary.totalSocialMediaPosts = appsNetworks.containsKey('TotalSocialMediaPosts') ? (Integer) appsNetworks.get('TotalSocialMediaPosts') : 0;
			appsSummary.followerToFollowingRatio = appsNetworks.containsKey('SocialMediaFollowerToFollowingRatio') ? (Decimal) appsNetworks.get('SocialMediaFollowerToFollowingRatio') : 0;

			appsSummary.hasFacebook = appsNetworks.containsKey('HasFacebookProfile') ? (Boolean) appsNetworks.get('HasFacebookProfile') : false;
			appsSummary.hasTwitter = appsNetworks.containsKey('HasTwitterProfile') ? (Boolean) appsNetworks.get('HasTwitterProfile') : false;
			appsSummary.hasLinkedIn = appsNetworks.containsKey('HasLinkedInProfile') ? (Boolean) appsNetworks.get('HasLinkedInProfile') : false;
			appsSummary.hasInstagram = appsNetworks.containsKey('HasInstagramProfile') ? (Boolean) appsNetworks.get('HasInstagramProfile') : false;
			appsSummary.hasOLX = appsNetworks.containsKey('HasOLXPresence') ? (Boolean) appsNetworks.get('HasOLXPresence') : false;
			appsSummary.hasMercadoLivre = appsNetworks.containsKey('HasMercadoLivrePresence') ? (Boolean) appsNetworks.get('HasMercadoLivrePresence') : false;

			if (appsNetworks.containsKey('AppProfiles')) {
				appProfiles = (List<Map<String, Object>>) appsNetworks.get('AppProfiles');
			}

			if (appsNetworks.containsKey('SearchEngineResults')) {
				searchEngineResults = (List<Map<String, Object>>) appsNetworks.get('SearchEngineResults');
			}

		} catch (Exception ex) {
			System.debug('Error extracting AppProfiles: ' + ex.getMessage());
		}
	}
}