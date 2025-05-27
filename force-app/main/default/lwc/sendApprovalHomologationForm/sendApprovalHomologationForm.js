import { LightningElement, api } from 'lwc';
import sendApproval from '@salesforce/apex/HomologationFormApprovalHandler.sendApprovalHomologationForm';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class SendApprovalHomologationForm extends LightningElement {

    @api recordId;

    @api invoke() {
        console.log('Record ID:', this.recordId);
        sendApproval({ opportunityId: this.recordId })
        .then(() => {
            this.showToast('Success', 'Forms submitted for approval and email sent.', 'success');
        })
        .catch(error => {
            console.error(error);
            this.showToast('Error', 'An error occurred while processing the approval.', 'error');
        })
        .finally(() => {
            this.dispatchEvent(new CustomEvent('close'));
        });
    }

    sleep(ms) {
        return new Promise((resolve) => setTimeout(resolve, ms));
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant })
        );
    }
}