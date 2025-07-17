import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import SETTLEMENT_1 from '@salesforce/schema/Opportunity.Settlement_Frequency_1__c';
import SETTLEMENT_2 from '@salesforce/schema/Opportunity.Settlement_Frequency_2__c';
import ANTECIPATION_1 from '@salesforce/schema/Opportunity.Antecipation_Frequency_1__c';
import ANTECIPATION_2 from '@salesforce/schema/Opportunity.Antecipation_Frequency_2__c';
import OTHER_SETTLEMENT_1 from '@salesforce/schema/Opportunity.Other_Payments_Settlement_Frequency_1__c';
import OTHER_SETTLEMENT_2 from '@salesforce/schema/Opportunity.Other_Payments_Settlement_Frequency_2__c';
import VISIBLE_OTHERS_SETTLEMENT from '@salesforce/schema/Opportunity.Visible_Others_Settlement_Frequency__c';
import STAGE_NAME from '@salesforce/schema/Opportunity.StageName';
import ANSWERED from '@salesforce/schema/Opportunity.Answered_Confirmation_Form__c';
import ACCEPTPROPOSAL from '@salesforce/schema/Opportunity.Acceptable_Proposal__c';
import SYNCED_QUOTE_ID from '@salesforce/schema/Opportunity.SyncedQuoteId';
import RECORD_TYPE_ID from '@salesforce/schema/Opportunity.RecordTypeId';
import IS_OPPORTUNITY_VALID from '@salesforce/schema/Opportunity.Is_Opportunity_Valid__c';
import VISIBLE_SETTLEMENT from '@salesforce/schema/Opportunity.Visible_Settlement_Frequency__c';
// REMOVIDO import VISIBLE_ANTICIPATION

import SELECTED_CREDIT_FREQ from '@salesforce/schema/Opportunity.Selected_Credit_Frequency__c';
import SELECTED_OTHERS_FREQ from '@salesforce/schema/Opportunity.Selected_Others_Frequency__c';

const FIELDS = [
    SETTLEMENT_1, SETTLEMENT_2, ANTECIPATION_1, ANTECIPATION_2,
    OTHER_SETTLEMENT_1, OTHER_SETTLEMENT_2, VISIBLE_OTHERS_SETTLEMENT,
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
    confirmStep = 'edit'; // valores possíveis: 'edit', 'chooseFrequencies'

    // Opções de seleção de dupla
    selectedCreditFrequency = '1';
    selectedOthersFrequency = '1';

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
            this.visibleOthersSettlement = getFieldValue(data, VISIBLE_OTHERS_SETTLEMENT);

            if (stage === 'Contract' && !responded) {
                this.showModal = true;
                this.confirmStep = 'edit';
                this.originalValues = {
                    s1: getFieldValue(data, SETTLEMENT_1),
                    s2: getFieldValue(data, SETTLEMENT_2),
                    a1: getFieldValue(data, ANTECIPATION_1),
                    a2: getFieldValue(data, ANTECIPATION_2),
                    osf1: getFieldValue(data, OTHER_SETTLEMENT_1),
                    osf2: getFieldValue(data, OTHER_SETTLEMENT_2)
                };
                this.selectedValues = {
                    s1: getFieldValue(data, SETTLEMENT_1) || '',
                    s2: getFieldValue(data, SETTLEMENT_2) || '',
                    a1: getFieldValue(data, ANTECIPATION_1) || '',
                    a2: getFieldValue(data, ANTECIPATION_2) || '',
                    osf1: getFieldValue(data, OTHER_SETTLEMENT_1) || '',
                    osf2: getFieldValue(data, OTHER_SETTLEMENT_2) || ''
                };
                this.selectedCreditFrequency = '1';
                this.selectedOthersFrequency = '1';
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
        const isNational = this.recordTypeApiName.toLowerCase().includes('national');
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
                case 'Weekly': return ['Weekly', 'Bimonthly', 'Monthly'];
                case 'Bimonthly': return ['Bimonthly', 'Monthly'];
                case 'Monthly': return ['Monthly'];
                default: return [];
            }
        } else {
            switch (settlementValue) {
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
        // Não valida mais antecipation isoladamente!
        if (this.visibleOthersSettlement) {
            if (!this.selectedValues.osf1 || !this.selectedValues.osf2) {
                this.showToast('Atenção', 'Preencha ambos os campos de Other Payments Settlement Frequency.', 'warning');
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
            this.showToast('Error', 'This opportunity cannot be modified as it is not valid.', 'error');
            return;
        }

        const hasChange = Object.keys(this.selectedValues).some(
            key => this.selectedValues[key] !== this.originalValues[key]
        );

        if (!hasChange && (this.visibleSettlement || this.visibleOthersSettlement) && this.confirmStep === 'edit') {
            // Mostra os interruptores para selecionar a dupla
            this.confirmStep = 'chooseFrequencies';
            this.isLoading = false;
            return;
        }

        // Monta campos
        const fields = {
            Id: this.recordId,
            Settlement_Frequency_1__c: this.selectedValues.s1,
            Settlement_Frequency_2__c: this.selectedValues.s2,
            Antecipation_Frequency_1__c: this.selectedValues.a1,
            Antecipation_Frequency_2__c: this.selectedValues.a2,
            Other_Payments_Settlement_Frequency_1__c: this.selectedValues.osf1,
            Other_Payments_Settlement_Frequency_2__c: this.selectedValues.osf2
        };

        // Seta picklists se for o caso (quando está na tela de seleção de dupla)
        if (!hasChange && this.confirmStep === 'chooseFrequencies') {
            if (this.visibleSettlement) {
                fields.Selected_Credit_Frequency__c = this.selectedCreditFrequency;
            }
            if (this.visibleOthersSettlement) {
                fields.Selected_Others_Frequency__c = this.selectedOthersFrequency;
            }
            fields.Answered_Confirmation_Form__c = true;
        }

        if (hasChange) {
            fields.StageName = 'Negotiation';
            fields.Acceptable_Proposal__c = false;
            fields.SyncedQuoteId = null;
        }

        updateRecord({ fields })
            .then(() => {
                this.isLoading = false;
                this.showModal = false;
                this.confirmStep = 'edit';
                this.showToast(
                    'Success',
                    hasChange
                        ? 'Stage moved to Negotiation'
                        : 'Confirmation saved',
                    'success'
                );
            })
            .catch(error => {
                this.isLoading = false;
                this.showToast(
                    'Error',
                    error.body && error.body.message ? error.body.message : 'Erro ao salvar',
                    'error'
                );
            });
    }

    // Exibe as seções dos interruptores conforme o estado
    get showCreditFrequencySwitch() {
        return this.visibleSettlement && this.confirmStep === 'chooseFrequencies';
    }
    get showOthersFrequencySwitch() {
        return this.visibleOthersSettlement && this.confirmStep === 'chooseFrequencies';
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
        this.confirmStep = 'edit';
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