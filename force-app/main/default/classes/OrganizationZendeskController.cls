/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-09
 * @last modified by  : Hersilio Belini de Oliveira
**/
public with sharing class OrganizationZendeskController {

    /**
    * @description search organization by filter
    * @author Hersilio Belini de Oliveira
    * @param filter String
    * @return void
    **/
    @AuraEnabled
    public static String searchOrganization(String filter) {
        try {
            return new ZendeskService().getOrganization(filter);
        } catch (Exception ex) {
            throw new AuraHandledException('erro ao consultar organização: ' + ex.getMessage());
        }
    }

    /**
    * @description create organization in zendesk
    * @author Hersilio Belini de Oliveira | 2025-01-07
    * @param idOpportunity
    * @param organizationId
    * @param domains
    * @param timeZone
    * @return OrganizationWrapper
    **/
    @AuraEnabled
    public static OrganizationWrapper createOrganization(String opportunityId, String organizationId, List<String> domains, String timeZone) {
        try {
            Opportunity opportunity = OpportunitySelector.getOpportunityById(opportunityId);
            Contact contact = ContactSelector.getContactPrincipalByAccountId(opportunity.AccountId);

            if(contact == null){
                throw new AuraHandledException('No main Contact found.');
            }

            OrganizationWrapper organization = new OrganizationWrapper(opportunity, contact, domains, timeZone);

            if(String.isNotBlank(organizationId)) {
                organization.organization.id = Long.valueOf(organizationId);
            }

            System.debug('organization: ' + JSON.serialize(organization));

            return new ZendeskService().createOrUpdateOrganization(organization);
        } catch (AuraHandledException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new AuraHandledException('Error: ' + ex.getMessage());
        }
    }
}