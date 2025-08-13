import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import shouldShowModal from '@salesforce/apex/OpportunityUtils.shouldShowModal';

import SETTLEMENT_1 from '@salesforce/schema/Opportunity.Settlement_Frequency_1__c';
import SETTLEMENT_2 from '@salesforce/schema/Opportunity.Settlement_Frequency_2__c';
import ANTECIPATION_1 from '@salesforce/schema/Opportunity.Antecipation_Frequency_1__c';
import ANTECIPATION_2 from '@salesforce/schema/Opportunity.Antecipation_Frequency_2__c';
import OTHER_SETTLEMENT_1 from '@salesforce/schema/Opportunity.Other_Payments_Settlement_Frequency_1__c';
import VISIBLE_OTHERS_SETTLEMENT from '@salesforce/schema/Opportunity.Visible_Others_Settlement_Frequency__c';
import STAGE_NAME from '@salesforce/schema/Opportunity.StageName';
import ANSWERED from '@salesforce/schema/Opportunity.Answered_Confirmation_Form__c';
import ACCEPTPROPOSAL from '@salesforce/schema/Opportunity.Acceptable_Proposal__c';
import SYNCED_QUOTE_ID from '@salesforce/schema/Opportunity.SyncedQuoteId';
import RECORD_TYPE_ID from '@salesforce/schema/Opportunity.RecordTypeId';
import IS_OPPORTUNITY_VALID from '@salesforce/schema/Opportunity.Is_Opportunity_Valid__c';
import VISIBLE_SETTLEMENT from '@salesforce/schema/Opportunity.Visible_Settlement_Frequency__c';

const FIELDS = [
    SETTLEMENT_1, SETTLEMENT_2, ANTECIPATION_1, ANTECIPATION_2,
    OTHER_SETTLEMENT_1, VISIBLE_OTHERS_SETTLEMENT,
    STAGE_NAME, ANSWERED, ACCEPTPROPOSAL, SYNCED_QUOTE_ID, RECORD_TYPE_ID,
    IS_OPPORTUNITY_VALID, VISIBLE_SETTLEMENT
];

export default class OpenFlowModal extends LightningElement {
    @api recordId;
    showModal = false;
    isLoading = false;
    recordTypeId;
    visibleSettlement = false;
    visibleOthersSettlement = false;
    isOpportunityValid;
    originalValues = {};
    selectedValues = {};
    confirmStep = 'chooseFrequencies';

    selectedCreditFrequency = '1';
    selectedOthersFrequency = '1';

    @wire(getObjectInfo, { objectApiName: 'Opportunity' })
    objectInfo;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ data }) {
        if (data) {
            this.recordTypeId = getFieldValue(data, RECORD_TYPE_ID);
            this.isOpportunityValid = getFieldValue(data, IS_OPPORTUNITY_VALID);
            this.visibleSettlement = getFieldValue(data, VISIBLE_SETTLEMENT);
            this.visibleOthersSettlement = getFieldValue(data, VISIBLE_OTHERS_SETTLEMENT);

            // Chama Apex para validar regra completa
            shouldShowModal({ opportunityId: this.recordId })
                .then(canShow => {
                    if (canShow) {
                        this.showModal = true;
                        this.confirmStep = 'chooseFrequencies';
                        this.originalValues = {
                            s1: getFieldValue(data, SETTLEMENT_1),
                            s2: getFieldValue(data, SETTLEMENT_2),
                            a1: getFieldValue(data, ANTECIPATION_1),
                            a2: getFieldValue(data, ANTECIPATION_2),
                            osf1: getFieldValue(data, OTHER_SETTLEMENT_1)
                        };
                        this.selectedValues = {
                            s1: getFieldValue(data, SETTLEMENT_1) || '',
                            s2: getFieldValue(data, SETTLEMENT_2) || '',
                            a1: getFieldValue(data, ANTECIPATION_1) || '',
                            a2: getFieldValue(data, ANTECIPATION_2) || '',
                            osf1: getFieldValue(data, OTHER_SETTLEMENT_1) || ''
                        };
                        this.selectedCreditFrequency = '1';
                        this.selectedOthersFrequency = '1';
                    }
                })
                .catch(error => {
                    console.error('Erro ao verificar modal:', error);
                });
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
        const isNational = this.recordTypeApiName.toLowerCase().includes('national');
        return isNational ? [
            { label: 'Daily', value: 'Daily' },
            { label: 'Weekly', value: 'Weekly' },
            { label: 'Biweekly', value: 'Biweekly' },
            { label: 'Monthly', value: 'Monthly' }
        ] : [
            { label: 'Weekly', value: 'Weekly' },
            { label: 'Biweekly', value: 'Biweekly' },
            { label: 'Monthly', value: 'Monthly' }
        ];
    }

    get otherSettlementOptions() {
        return [
            { label: 'Daily', value: 'Daily' },
            { label: 'Weekly', value: 'Weekly' },
            { label: 'Biweekly', value: 'Biweekly' },
            { label: 'Monthly', value: 'Monthly' }
        ];
    }

    getAnticipationOptions(settlementValue) {
        const isNational = this.recordTypeApiName.toLowerCase().includes('national');
        if (!isNational) {
            switch (settlementValue) {
                case 'Weekly': return ['Weekly', 'Biweekly', 'Monthly'];
                case 'Biweekly': return ['Biweekly', 'Monthly'];
                case 'Monthly': return ['Monthly'];
                default: return [];
            }
        } else {
            switch (settlementValue) {
                case 'Daily': return ['Daily', 'Weekly', 'Biweekly', 'Monthly', 'Fluxo Médio'];
                case 'Weekly': return ['Weekly', 'Biweekly', 'Monthly', 'Fluxo Médio'];
                case 'Biweekly': return ['Biweekly', 'Monthly', 'Fluxo Médio'];
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
        if (name === 's1' || name === 's2') {
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
                this.showToast('Atenção', 'Preencha ambos os campos de Settlement Frequency.', 'warning');
                return false;
            }
        }
        if (this.visibleOthersSettlement) {
            if (!this.selectedValues.osf1) {
                this.showToast('Atenção', 'Preencha ambos os campos de Other Payments Settlement Frequency.', 'warning');
                return false;
            }
        }
        return true;
    }

    async handleConfirm() {
        this.isLoading = true;
        if (this.confirmStep === 'edit') {
            if (!this.validateFrequencies()) {
                this.isLoading = false;
                return;
            }
            const hasChange = Object.keys(this.selectedValues)
                .some(k => this.selectedValues[k] !== this.originalValues[k]);
            const fields = {
                Id: this.recordId,
                Settlement_Frequency_1__c: this.selectedValues.s1,
                Settlement_Frequency_2__c: this.selectedValues.s2,
                Antecipation_Frequency_1__c: this.selectedValues.a1,
                Antecipation_Frequency_2__c: this.selectedValues.a2,
                Other_Payments_Settlement_Frequency_1__c: this.selectedValues.osf1
            };

            if (hasChange) {
                fields.StageName = 'Negotiation';
                fields.Acceptable_Proposal__c = false;
                fields.SyncedQuoteId = null;
            }

            try {
                await updateRecord({ fields });
                this.isLoading = false;
                this.confirmStep = 'chooseFrequencies';
                this.showToast('Success', hasChange ? 'Stage moved to Negotiation' : 'Values updated', 'success');
            } catch (error) {
                this.isLoading = false;
                this.showToast('Error', error.body && error.body.message ? error.body.message : 'Erro ao salvar', 'error');
            }
            return;
        }

        if (this.confirmStep === 'chooseFrequencies') {
            const fields = { Id: this.recordId };
            if (this.visibleSettlement) {
                fields.Selected_Credit_Frequency__c = this.selectedCreditFrequency;
            }
            if (this.visibleOthersSettlement) {
                fields.Selected_Others_Frequency__c = this.selectedOthersFrequency;
            }
            fields.Answered_Confirmation_Form__c = true;

            try {
                await updateRecord({ fields });
                this.isLoading = false;
                this.showModal = false;
                this.showToast('Success', 'Confirmation saved', 'success');
            } catch (error) {
                this.isLoading = false;
                this.showToast('Error', error.body && error.body.message ? error.body.message : 'Erro ao salvar', 'error');
            }
            return;
        }
    }

    handleChangeValues() {
        this.confirmStep = 'edit';
    }

    get showCreditFrequencySwitch() {
        return this.visibleSettlement && this.confirmStep === 'chooseFrequencies';
    }
    get showOthersFrequencySwitch() {
        return this.visibleOthersSettlement && this.confirmStep === 'chooseFrequencies';
    }
    get showEditSection() {
        return this.confirmStep === 'edit';
    }

    get creditOptions() {
        return [
            { label: 'First', value: '1' },
            { label: 'Second', value: '2' }
        ];
    }
    get othersOptions() {
        return [
            { label: 'First', value: '1' },
            { label: 'Second', value: '2' }
        ];
    }

    handleCreditFrequencyChange(event) {
        this.selectedCreditFrequency = event.detail.value;
    }
    handleOthersFrequencyChange(event) {
        this.selectedOthersFrequency = event.detail.value;
    }

    closeModal() {
        this.showModal = false;
        this.confirmStep = 'chooseFrequencies';
    }

    get showChangeValuesButton() {
        return this.confirmStep === 'chooseFrequencies';
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}