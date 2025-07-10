import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import SETTLEMENT_1 from '@salesforce/schema/Opportunity.Settlement_Frequency_1__c';
import SETTLEMENT_2 from '@salesforce/schema/Opportunity.Settlement_Frequency_2__c';
import ANTECIPATION_1 from '@salesforce/schema/Opportunity.Antecipation_Frequency_1__c';
import ANTECIPATION_2 from '@salesforce/schema/Opportunity.Antecipation_Frequency_2__c';
import STAGE_NAME from '@salesforce/schema/Opportunity.StageName';
import ANSWERED from '@salesforce/schema/Opportunity.Answered_Confirmation_Form__c';
import ACCEPTPROPOSAL from '@salesforce/schema/Opportunity.Acceptable_Proposal__c';
import SYNCED_QUOTE_ID from '@salesforce/schema/Opportunity.SyncedQuoteId';
import RECORD_TYPE_ID from '@salesforce/schema/Opportunity.RecordTypeId';
import IS_OPPORTUNITY_VALID from '@salesforce/schema/Opportunity.Is_Opportunity_Valid__c';
import VISIBLE_SETTLEMENT from '@salesforce/schema/Opportunity.Visible_Settlement_Frequency__c';
import VISIBLE_ANTICIPATION from '@salesforce/schema/Opportunity.Visible_Anticipation_Frequency__c';

const FIELDS = [
    SETTLEMENT_1, SETTLEMENT_2, ANTECIPATION_1, ANTECIPATION_2, STAGE_NAME,
    ANSWERED, ACCEPTPROPOSAL, SYNCED_QUOTE_ID, RECORD_TYPE_ID, IS_OPPORTUNITY_VALID,
    VISIBLE_SETTLEMENT, VISIBLE_ANTICIPATION
];

export default class OpenFlowModal extends LightningElement {
    @api recordId;
    showModal = false;
    isLoading = false;
    recordTypeId;
    
    originalValues = {};
    selectedValues = {};

    @wire(getObjectInfo, { objectApiName: 'Opportunity' })
    objectInfo;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ data }) {
        if (data) {
            const stage = getFieldValue(data, STAGE_NAME);
            const responded = getFieldValue(data, ANSWERED);
            this.recordTypeId = getFieldValue(data, RECORD_TYPE_ID);
            this.isOpportunityValid = getFieldValue(data, IS_OPPORTUNITY_VALID);
            this.visibleSettlement = getFieldValue(data, VISIBLE_SETTLEMENT);
            this.visibleAnticipation = getFieldValue(data, VISIBLE_ANTICIPATION);

            if (stage === 'Contract' && !responded) {
                this.showModal = true;
                this.originalValues = {
                    s1: getFieldValue(data, SETTLEMENT_1),
                    s2: getFieldValue(data, SETTLEMENT_2),
                    a1: getFieldValue(data, ANTECIPATION_1),
                    a2: getFieldValue(data, ANTECIPATION_2)
                };
                this.selectedValues = { 
                    s1: getFieldValue(data, SETTLEMENT_1) || '',
                    s2: getFieldValue(data, SETTLEMENT_2) || '',
                    a1: getFieldValue(data, ANTECIPATION_1) || '',
                    a2: getFieldValue(data, ANTECIPATION_2) || ''
                };
            }
        }
    }

    get recordTypeApiName() {
        if (this.objectInfo.data && this.recordTypeId) {
            const rtInfo = this.objectInfo.data.recordTypeInfos[this.recordTypeId];
            return rtInfo ? rtInfo.name : '';
        }
        return '';
    }

    get settlementOptions() {
        const isNational = this.recordTypeApiName === 'National' || 
                          this.recordTypeApiName === 'NaTional' ||
                          this.recordTypeApiName.toLowerCase().includes('national');
        
        return isNational ? [
            { label: 'Daily', value: 'Daily' },
            { label: 'Weekly', value: 'Weekly' },
            { label: 'Bimonthly', value: 'Bimonthly' },
            { label: 'Monthly', value: 'Monthly' }
        ] : [
            { label: 'Weekly', value: 'Weekly' },
            { label: 'Bimonthly', value: 'Bimonthly' },
            { label: 'Monthly', value: 'Monthly' }
        ];
    }

    getAnticipationOptions(settlementValue) {
        const isNational = this.recordTypeApiName === 'National' || 
                          this.recordTypeApiName === 'NaTional' ||
                          this.recordTypeApiName.toLowerCase().includes('national');
        
        if (!isNational) {
            // Crossborder
            switch(settlementValue) {
                case 'Weekly': return ['Weekly', 'Bimonthly', 'Monthly'];
                case 'Bimonthly': return ['Bimonthly', 'Monthly'];
                case 'Monthly': return ['Monthly'];
                default: return [];
            }
        } else {
            // National
            switch(settlementValue) {
                case 'Daily': return ['Daily', 'Weekly', 'Bimonthly', 'Monthly', 'Fluxo Médio'];
                case 'Weekly': return ['Weekly', 'Bimonthly', 'Monthly', 'Fluxo Médio'];
                case 'Bimonthly': return ['Bimonthly', 'Monthly', 'Fluxo Médio'];
                case 'Monthly': return ['Monthly', 'Fluxo Médio'];
                default: return [];
            }
        }
    }

    get a1Options() {
        return this.getAnticipationOptions(this.selectedValues.s1)
            .map(option => ({ label: option, value: option }));
    }

    get a2Options() {
        return this.getAnticipationOptions(this.selectedValues.s2)
            .map(option => ({ label: option, value: option }));
    }

    get isS1Empty() {
        return !this.selectedValues.s1;
    }

    get isS2Empty() {
        return !this.selectedValues.s2;
    }

    handleChange(event) {
        const { name, value } = event.target;
        this.selectedValues = { ...this.selectedValues, [name]: value };

        if (name.startsWith('s')) {
            const anticipationField = name.replace('s', 'a');
            const allowedValues = this.getAnticipationOptions(value);
            
            this.selectedValues = { 
                ...this.selectedValues, 
                [anticipationField]: allowedValues.includes(this.selectedValues[anticipationField]) 
                    ? this.selectedValues[anticipationField] 
                    : '' 
            };
        }
    }

    validateFrequencies() {
        if (this.visibleSettlement) {
            if (!this.selectedValues.s1 || !this.selectedValues.s2) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Atenção',
                        message: 'Preencha ambos os campos de Settlement Frequency.',
                        variant: 'warning'
                    })
                );
                return false;
            }
        }
        if (this.visibleAnticipation) {
            if (!this.selectedValues.a1 || !this.selectedValues.a2) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Atenção',
                        message: 'Preencha ambos os campos de Anticipation Frequency.',
                        variant: 'warning'
                    })
                );
                return false;
            }
        }
        return true;
    }

    handleConfirm() {
        this.isLoading = true;

        if (!this.validateFrequencies()) {
            this.isLoading = false;
            return;
        }

        if (this.isOpportunityValid === false) {
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'This opportunity cannot be modified as it is not valid.',
                    variant: 'error'
                })
            );
            return;
        }

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
            fields.Acceptable_Proposal__c = false;
            fields.SyncedQuoteId = null;
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