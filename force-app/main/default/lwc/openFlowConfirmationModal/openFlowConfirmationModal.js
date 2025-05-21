import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Opportunity.StageName',
    'Opportunity.Answered_Confirmation_Form__c'
];

export default class OpenFlowModal extends LightningElement {
    @api recordId;
    showModal = false;
    inputVariables = [];

    connectedCallback() {
        this.inputVariables = [{
            name: 'recordId',
            type: 'String',
            value: this.recordId
        }];
    }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ data }) {
        if (data) {
            const stage = data.fields.StageName.value;
            const responded = data.fields.Answered_Confirmation_Form__c.value;
            if (stage === 'Contract' && !responded) {
                this.showModal = true;
            }
        }
    }

    closeModal() {
        this.showModal = false;
    }

    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.showModal = false;
        }
    }
}