import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateApprovalStatus from '@salesforce/apex/ApprovalKYCHandler.updateApprovalStatus';

export default class KYCApproval extends LightningElement {
  @api recordId;

  @api async invoke() {
    await updateApprovalStatus({ recordId: this.recordId })
      .then(rccStatus => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Success',
            message: rccStatus === 'Approval Requested' ? 'Forms submitted for legal approval.' : 'Waiting for RCC to send to legal approval.',
            variant: 'success'
          })
        );

        this.sleep(2000);
      }).catch(error => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Error updating KYC Approval status',
            message: error.body.message,
            variant: 'error'
          })
        );

      this.dispatchEvent(new CustomEvent('close'));
    });
  }

  sleep(ms) {
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    return new Promise((resolve) => setTimeout(resolve, ms));
}
}