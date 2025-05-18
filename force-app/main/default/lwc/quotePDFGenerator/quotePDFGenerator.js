import { LightningElement, api } from 'lwc';
import savePdfVersion from '@salesforce/apex/QuotePdfService.savePdfVersion';
import getOpportunityType from '@salesforce/apex/QuotePdfService.getOpportunityType';
import LightningModal from 'lightning/modal';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class QuotePDFGenerator extends LightningModal {

    @api recordId;
    vfUrl;

    async connectedCallback() {
        console.log('RECEIVED recordId from Aura:', this.recordId);
        try {
            const type = await getOpportunityType({ quoteId: this.recordId });
            // const type = getOpportunityType({ quoteId: this.recordId });

            const vfPageName = type.Opportunity.RecordType.DeveloperName  === 'Crossborder' ? 'PropostaCross' : 'PropostaNacional';

            this.vfUrl = `/apex/${vfPageName}?id=${this.recordId}`;
        } catch (error) {
            console.error('Erro ao determinar tipo da opp:', error);
        }
    }

    async handleSave() {
        try {
            await savePdfVersion({ quoteId: this.recordId });
            alert('PDF salvo com sucesso!');
        } catch (error) {
            console.error(error);
            alert('Erro ao salvar PDF');
        }
    }

    close() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}