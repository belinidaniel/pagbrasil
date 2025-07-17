/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 06-28-2025
 * @last modified by  : Daniel Belini
**/
public with sharing class OpportunityFieldsPageController {

    public OpportunityWrapper wrapper { get; private set; }
    public OpportunityWrapper.RccWrapper rccWrapper { get; private set; }
    public OpportunityWrapper.KycWrapper kycWrapper { get; private set; }

    public List<HomologationForm__c> homologationForms { get; private set; }

    public OpportunityFieldsPageController() {
		String opportunityId = ApexPages.currentPage().getParameters().get('id');
		String homologationId = ApexPages.currentPage().getParameters().get('homologationId');

        if (String.isNotBlank(opportunityId)) {
            Opportunity opp = OpportunitySelector.getCompleteOpportunityById(opportunityId);
            Rcc__c rcc = OpportunitySelector.getRccByOpportunityId(opportunityId);

            sObject kyc;

            if (opp.RecordType.Name == 'NaTional') {
            	kyc = OpportunitySelector.getKycByOpportunityId(opportunityId);
            } else {
            	kyc = OpportunitySelector.getKycXbByOpportunityId(opportunityId);
            }
			System.debug('controller kyc: ' + kyc);
            rccWrapper = new OpportunityWrapper.RccWrapper(rcc);
            kycWrapper = new OpportunityWrapper.KycWrapper(kyc);
            wrapper = new OpportunityWrapper(opp);

            if (String.isNotBlank(homologationId)) {
                homologationForms = new List<HomologationForm__c>{
                    OpportunitySelector.getHomologationById(homologationId)
                };
            } else {
                homologationForms = OpportunitySelector.getHomologationsByOpportunityId(opportunityId);
            }
        }
    }
}