/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 05-27-2025
 * @last modified by  : Daniel Belini
**/
public class OrganizationWrapper {

    private List<ZendeskValue__c> zendeskValues {
        get {
            if(zendeskValues == null){
                zendeskValues = [SELECT Name, ZendeskValue__c, ObjectName__c, FieldApiName__c, SalesforceValue__c FROM ZendeskValue__c];
            }

            return zendeskValues;
        }

        set;
    }

    @AuraEnabled public Organization organization;

    public OrganizationWrapper() {
        organization = new Organization();
    }

    public OrganizationWrapper(Opportunity opp, Contact contact, List<String> domains, String timezone){
        organization = new Organization();
        organization.name = opp.Account.Name;
        organization.organization_fields = new OrganizationFields();
        organization.organization_fields.comany_name = opp.Account.Nome_Empresarial__c;
        organization.organization_fields.integration_type = opp.IntegrationType__c;
        organization.organization_fields.website = opp.Product_or_service_website_URL__c;
        organization.organization_fields.client_status_comment = opp.StageName;
        organization.organization_fields.product_description = opp.ProductClass__c;
        organization.organization_fields.remittance_currency = opp.Moeda__c;
        organization.organization_fields.end_user_support = contact.Email;
        organization.organization_fields.vat_cnpj = opp.Account.VATCNPJ__c;
        organization.organization_fields.business_size = getZendeskValue('Opportunity', 'TierCS', opp.TierCS__c);
        organization.organization_fields.country = getZendeskValue('Opportunity', 'Country', opp.Country__c);
        organization.organization_fields.contacts_timezone = timezone;
        organization.domain_names = domains;
    }

    public class Organization {
        @AuraEnabled public Long id;
        @AuraEnabled public String name;
        @AuraEnabled public List<String> domain_names;
        @AuraEnabled public OrganizationFields organization_fields;
    }

    public class OrganizationFields {
        @AuraEnabled public String business_size;
        @AuraEnabled public String client_status_comment;
        @AuraEnabled public String comany_name;
        @AuraEnabled public String contacts_timezone;
        @AuraEnabled public String country;
        @AuraEnabled public String end_user_support;
        @AuraEnabled public String integration_type;
        @AuraEnabled public Boolean local_entity;
        @AuraEnabled public String product_description;
        @AuraEnabled public String remittance_currency;
        @AuraEnabled public String website;
        @AuraEnabled public String vat_cnpj;
    }

    // Static method to parse JSON into the wrapper class
    public static OrganizationWrapper fromJSON(String jsonString) {
        return (OrganizationWrapper) JSON.deserialize(jsonString, OrganizationWrapper.class);
    }

    // Static method to serialize the wrapper class into JSON
    public static String toJSON(OrganizationWrapper wrapper) {
        return JSON.serialize(wrapper);
    }

    private String getZendeskValue(String objectName, String fieldName, String value){
        for(ZendeskValue__c zendeskValue : this.zendeskValues){
            if(zendeskValue.ObjectName__c == objectName && zendeskValue.FieldApiName__c == fieldName && zendeskValue.SalesforceValue__c == value){
                return zendeskValue.ZendeskValue__c;
            }
        }

        return '';
    }
}