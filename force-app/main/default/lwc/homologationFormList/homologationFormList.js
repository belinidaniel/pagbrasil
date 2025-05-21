import { LightningElement, api, wire, track } from 'lwc';
import getByOpportunityId from '@salesforce/apex/HomologationFormSelector.getByOpportunityId';

export default class HomologationFormList extends LightningElement {
    @api recordId;
    @track showCreateHomologationFormFlowModal = false;
    @track flowCreateHomologationFormInputVariables = [];
    @track showSendHomologationFormFlowModal = false;
    @track flowSendHomologationFormInputVariables = [];
    @track hasRecords = false;
    @track completed = false;

    @track forms;

    @wire(getByOpportunityId, { opportunityId: '$recordId' })
    wiredForms({ error, data }) {
        if (data) {
            this.forms = data;
            this.hasRecords = data && data.length > 0;
            this.completed = data.every(form => form.Completed__c === true);
        } else if (error) {
            console.error('Error loading forms:', error);
            this.hasRecords = false;
        }
    }

    handleEditForm(event) {
        event.preventDefault();
        const formUrl = event.currentTarget.dataset.url;
        
        this.flowCreateHomologationFormInputVariables = [
            { name: 'recordId', type: 'String', value: this.recordId },
            { name: 'URL', type: 'String', value: formUrl }
        ];
        this.showCreateHomologationFormFlowModal = true;
    }

    handleSendForms(event) {
        event.preventDefault();

        this.flowSendHomologationFormInputVariables = [
            { name: 'recordId', type: 'String', value: this.recordId }
        ];
        this.showSendHomologationFormFlowModal = true;
    }

    closeCreateHomologationFormFlowModal() {
        this.showCreateHomologationFormFlowModal = false;
    }

    handleCreateHomologationFormFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.closeCreateHomologationFormFlowModal();
        }
    }

    closeSendHomologationFormFlowModal() {
        this.showSendHomologationFormFlowModal = false;
    }

    handleSendHomologationFormFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.closeSendHomologationFormFlowModal();
        }
    }
}