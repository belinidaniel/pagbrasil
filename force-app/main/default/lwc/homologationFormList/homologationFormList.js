import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getByOpportunityId from '@salesforce/apex/HomologationFormSelector.getByOpportunityId';

export default class HomologationFormList extends LightningElement {
    @api recordId;
    @track showSendHomologationFormFlowModal = false;
    @track flowSendHomologationFormInputVariables = [];
    @track hasRecords = false;
    @track completed = false;

    @wire(getByOpportunityId, { opportunityId: '$recordId' })
    wiredForms({ error, data }) {
        if (data) {
            this.forms = data;
            this.hasRecords = data && data.length > 0;
            this.completed = data.every(form => !form.Required_Fields__c);
        } else if (error) {
            console.error('Error loading forms:', error);
            this.hasRecords = false;
        }
    }


    handleSendForms(event) {
        event.preventDefault();

        this.flowSendHomologationFormInputVariables = [
            { name: 'recordId', type: 'String', value: this.recordId }
        ];
        this.showSendHomologationFormFlowModal = true;
    }
    
    closeSendHomologationFormFlowModal() {
        this.showSendHomologationFormFlowModal = false;
    }

    handleSendHomologationFormFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.closeSendHomologationFormFlowModal();
            this.showToast('Sucess', 'Email sent successfully!', 'success');
        }

        if (event.detail.status === 'ERROR') {
            this.closeSendHomologationFormFlowModal();
            this.showToast('Error', 'An error occurred while sending the email', 'error');
        }
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(toastEvent);
    }
}