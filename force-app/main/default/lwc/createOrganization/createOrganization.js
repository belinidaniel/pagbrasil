import { LightningElement, api, track, wire } from 'lwc';
import createOrganization from '@salesforce/apex/OrganizationZendeskController.createOrganization';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const FIELDS = [
    'Opportunity.Name',
    'Opportunity.Account.Name',
    'Opportunity.Account.VATCNPJ__c',
    'Opportunity.Account.Nome_Empresarial__c',
    'Opportunity.Country__c',
    'Opportunity.Product_Type__c',
    'Opportunity.ProductClass__c',
    'Opportunity.Moeda__c',
    'Opportunity.IntegrationType__c',
    'Opportunity.StageName',
    'Opportunity.Website__c',
    'Opportunity.TierCS__c',
    'Opportunity.Product_or_service_website_URL__c',
];

export default class CreateOrganization extends LightningElement {
    @api organizationId;
    @api opportunityId;

    @track timezone = ''; // Track selected timezone
    @track domainList = []; // Track the list of text inputs
    @track newDomain = ''; // Track the current input text
    @track isLoading = false;
    @track errorMessages = [];

    @wire(getRecord, { recordId: '$opportunityId', fields: FIELDS })
    opportunity;

    connectedCallback() {
        console.log('this.opportunityId: ', this.opportunityId);
        console.log('this.organizationId: ', this.organizationId);
    }


    handleTimezoneChange(event) {
        this.timezone = event.target.value;
    }

    handleDomainChange(event) {
        this.newDomain = event.target.value;
    }

    addDomainToList() {
        if (this.newDomain) {
            let elementExists = this.domainList.find(elem => elem == this.newDomain);
            if(elementExists && elementExists.length > 0){
                return;
            }

            let domain = this.newDomain.toLowerCase();

            this.domainList = [...this.domainList, domain];
            this.newDomain = '';
        } else {
            this.showErrorToast('Text input cannot be empty.');
        }
    }

    removeDomainFromList(event) {
        const index = event.target.dataset.index;
        console.log('index: ', index);
        this.domainList = this.domainList.filter(elem => elem != index);
    }

    validateInputs() {
        const isTimezoneValid = !!this.timezone;
        const isListValid = this.domainList.length > 0;

        if (!isTimezoneValid || !isListValid) {
            const message = !isTimezoneValid
                ? 'Timezone is required.'
                : 'The text list cannot be empty.';
            this.showErrorToast(message);
            return false;
        }
        return true;
    }

    showErrorToast(message) {
        const event = new ShowToastEvent({
            title: 'Validation Error',
            message,
            variant: 'error',
        });
        this.dispatchEvent(event);
    }

    @api
    handleSubmit() {
        if (this.validateInputs()) {
            this.organizationId = '24266831303709';

            let params = { opportunityId: this.opportunityId, organizationId: this.organizationId , domains: this.domainList, timeZone: this.timezone }

            console.log('saving:', JSON.stringify(params));

            this.isLoading = true;
            createOrganization(params)
            .then((result) => {
                console.log('result: ', JSON.stringify(result));

                if(result.organization && result.organization.id){
                    const selectedEvent = new CustomEvent("createdorganization", { detail:{ organizationId : result.organization.id } });
                    this.dispatchEvent(selectedEvent);
                }

                this.isLoading = false;
            }).catch((e) => {
                console.log('error: ', JSON.stringify(e));
                let message = e?.body?.message;

                if(message.indexOf('RecordInvalid') < 0){
                    const event = new ShowToastEvent({
                        title: 'Validation Error',
                        message: message,
                        variant: 'error',
                    });

                    this.dispatchEvent(event);
                } else {
                    this.errorMessages = this.formatErrorMessages(JSON.parse(message.replace('"{',"{").replace('}"',"}").replace('\"', '"')));
                }
                this.isLoading = false;
            });
        }
    }

    formatErrorMessages(response) {
        const messages = [];
        try {
            if (response.details) {
                for (const field in response.details) {
                    if (Array.isArray(response.details[field])) {
                        response.details[field].forEach(detail => {
                            messages.push(detail.description);
                        });
                    }
                }
            }
            return messages;
        } catch (e) {
            return messages
        }
    }

    get accountVatCnpj() {
        return this.opportunity?.data?.fields?.Account?.value?.fields?.VATCNPJ__c?.value;
    }

    get opportunityName() {
        return this.opportunity?.data?.fields?.Name?.value;
    }

    get accountName() {
        return this.opportunity?.data?.fields?.Account?.value?.fields?.Name?.value;
    }

    get accountCompanyName() {
        return this.opportunity?.data?.fields?.Account?.value?.fields?.Nome_Empresarial__c?.value;
    }

    get opportunityStage() {
        return this.opportunity?.data?.fields?.StageName?.value;
    }

    get opportunityCountry() {
        return this.opportunity?.data?.fields?.Country__c?.value;
    }

    get opportunityProductType() {
        return this.opportunity?.data?.fields?.Product_Type__c?.value;
    }

    get opportunityProductClass() {
        return this.opportunity?.data?.fields?.ProductClass__c?.value;
    }

    get opportunityWebSite() {
        return this.opportunity?.data?.fields?.Product_or_service_website_URL__c?.value;
    }

    get opportunityTier() {
        return this.opportunity?.data?.fields?.TierCS__c?.value;
    }

    get opportunityCurrency() {
        return this.opportunity?.data?.fields?.Moeda__c?.value;
    }

    get opportunityIntegrationType() {
        return this.opportunity?.data?.fields?.IntegrationType__c?.value;
    }
}