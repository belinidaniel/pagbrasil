/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-09
 * @last modified by  : Hersilio Belini de Oliveira
**/
public with sharing class OpportunityFieldsPageController {

    public OpportunityWrapper wrapper { get; private set; }
    public OpportunityWrapper.RccWrapper rccWrapper { get; private set; }
    public OpportunityWrapper.KycWrapper kycWrapper { get; private set; }


    public OpportunityFieldsPageController() {
        // Get the Opportunity Id from the page parameters
        String opportunityId = ApexPages.currentPage().getParameters().get('id');

        if (String.isNotBlank(opportunityId)) {
            Opportunity opp = OpportunitySelector.getCompleteOpportunityById(opportunityId);
            Rcc__c rcc = OpportunitySelector.getRccByOpportunityId(opportunityId);
            Kyc__c kyc = OpportunitySelector.getKycByOpportunityId(opportunityId);

            rccWrapper = new OpportunityWrapper.RccWrapper(rcc);
            kycWrapper = new OpportunityWrapper.KycWrapper(kyc);
            wrapper = new OpportunityWrapper(opp);
        }
    }
}