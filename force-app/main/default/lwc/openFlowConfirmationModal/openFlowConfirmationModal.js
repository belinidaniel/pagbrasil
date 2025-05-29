import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import SETTLEMENT_1 from '@salesforce/schema/Opportunity.Settlement_Frequency_1__c';
import SETTLEMENT_2 from '@salesforce/schema/Opportunity.Settlement_Frequency_2__c';
import ANTECIPATION_1 from '@salesforce/schema/Opportunity.Antecipation_Frequency_1__c';
import ANTECIPATION_2 from '@salesforce/schema/Opportunity.Antecipation_Frequency_2__c';
import STAGE_NAME from '@salesforce/schema/Opportunity.StageName';
import ANSWERED from '@salesforce/schema/Opportunity.Answered_Confirmation_Form__c';
import ACCEPTPROPOSAL from '@salesforce/schema/Opportunity.Acceptable_Proposal__c';
import SYNCED_QUOTE_ID from '@salesforce/schema/Opportunity.SyncedQuoteId';

const FIELDS = [SETTLEMENT_1, SETTLEMENT_2, ANTECIPATION_1, ANTECIPATION_2, STAGE_NAME, ANSWERED, ACCEPTPROPOSAL, SYNCED_QUOTE_ID];

export default class OpenFlowModal extends LightningElement {
    @api recordId;
    showModal = false;
    isLoading = false;

    originalValues = {};
    selectedValues = {};

    frequencyOptions = [
        { label: 'Weekly', value: 'Weekly' },
        { label: 'Bimonthly', value: 'Bimonthly' },
        { label: 'Monthly', value: 'Monthly' }
    ];

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ data }) {
        if (data) {
            const stage = getFieldValue(data, STAGE_NAME);
            const responded = getFieldValue(data, ANSWERED);

            if (stage === 'Contract' && !responded) {
                this.showModal = true;
                this.originalValues = {
                    s1: getFieldValue(data, SETTLEMENT_1),
                    s2: getFieldValue(data, SETTLEMENT_2),
                    a1: getFieldValue(data, ANTECIPATION_1),
                    a2: getFieldValue(data, ANTECIPATION_2)
                };
                this.selectedValues = { ...this.originalValues };
            }
        }
    }

    handleChange(event) {
        const { name, value } = event.target;
        this.selectedValues[name] = value;
    }

    handleConfirm() {
        this.isLoading = true;

        const hasChange = Object.keys(this.selectedValues).some(
            key => this.selectedValues[key] !== this.originalValues[key]
        );

        const fields = {
            Id: this.recordId,
            Settlement_Frequency_1__c: this.selectedValues.s1,
            Settlement_Frequency_2__c: this.selectedValues.s2,
            Antecipation_Frequency_1__c: this.selectedValues.a1,
            Antecipation_Frequency_2__c: this.selectedValues.a2
        };

        if (hasChange) {
            fields.StageName = 'Negotiation';
            fields.Acceptable_Proposal__c = false; // Assuming this field is set to true when moving to Negotiation
            fields.SyncedQuoteId = null; // Remove sync quote when returning to Negotiation
        } else {
            fields.Answered_Confirmation_Form__c = true;
        }

        updateRecord({ fields })
            .then(() => {
                this.isLoading = false;
                this.showModal = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: hasChange ? 'Stage moved to Negotiation' : 'Confirmation saved',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.isLoading = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    closeModal() {
        this.showModal = false;
    }
}