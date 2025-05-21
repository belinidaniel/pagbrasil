import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class RedirectToQuote extends NavigationMixin(LightningElement) {
    @api quoteId;

    connectedCallback() {
        if (this.quoteId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.quoteId,
                    objectApiName: 'Quote',
                    actionName: 'view'
                }
            });
        }
    }
}