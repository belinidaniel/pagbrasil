import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const OPPORTUNITY_FIELDS = [
    'Opportunity.AccountId'
];

const ACCOUNT_FIELDS = [
    'Account.Type',
    'Account.Billing_Country__c'
];

export default class OpenBillingCountryModal extends LightningElement {
    @api recordId;
    showModal = false;
    inputVariables = [];
    accountId;

    constructor() {
        super();
        // Log constructor
        // eslint-disable-next-line no-console
        console.log('[OpenBillingCountryModal] constructor');
    }

    @wire(getRecord, { recordId: '$recordId', fields: OPPORTUNITY_FIELDS })
    wiredOpportunity({ data, error }) {
        // eslint-disable-next-line no-console
        console.log('[OpenBillingCountryModal] wiredOpportunity', { data, error });
        if (data) {
            this.accountId = data.fields.AccountId.value;
            // eslint-disable-next-line no-console
            console.log('[OpenBillingCountryModal] accountId set:', this.accountId);
        }
        if (error) {
            // eslint-disable-next-line no-console
            console.error('[OpenBillingCountryModal] wiredOpportunity error:', error);
        }
    }

    @wire(getRecord, { recordId: '$accountId', fields: ACCOUNT_FIELDS })
    wiredAccount({ data, error }) {
        // eslint-disable-next-line no-console
        console.log('[OpenBillingCountryModal] wiredAccount', { data, error });
        if (data) {
            const type = data.fields.Type.value;
            const billingCountry = data.fields.Billing_Country__c.value;
            // eslint-disable-next-line no-console
            console.log('[OpenBillingCountryModal] Account Type:', type, 'Billing Country:', billingCountry);
            if (type === 'Cross Border (XB)' && (billingCountry === 'Brazil' || billingCountry === null)) {
                this.showModal = true;
                // eslint-disable-next-line no-console
                console.log('[OpenBillingCountryModal] showModal set to true');
            }
        }
        if (error) {
            // eslint-disable-next-line no-console
            console.error('[OpenBillingCountryModal] wiredAccount error:', error);
        }
    }

    connectedCallback() {
        // eslint-disable-next-line no-console
        console.log('[OpenBillingCountryModal] connectedCallback');
        this.inputVariables = [{
            name: 'recordId',
            type: 'String',
            value: this.recordId
        }];
        // eslint-disable-next-line no-console
        console.log('[OpenBillingCountryModal] inputVariables:', this.inputVariables);
    }

    closeModal() {
        // eslint-disable-next-line no-console
        console.log('[OpenBillingCountryModal] closeModal');
        this.showModal = false;
    }

    handleStatusChange(event) {
        // eslint-disable-next-line no-console
        console.log('[OpenBillingCountryModal] handleStatusChange', event.detail);
        if (event.detail.status === 'FINISHED') {
            this.showModal = false;
            // eslint-disable-next-line no-console
            console.log('[OpenBillingCountryModal] showModal set to false after FINISHED');
        }
    }
}