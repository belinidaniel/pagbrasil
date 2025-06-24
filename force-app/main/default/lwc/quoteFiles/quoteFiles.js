import { LightningElement, api, wire } from 'lwc';
import getSyncedQuoteFiles from '@salesforce/apex/QuoteFilesController.getSyncedQuoteFiles';

export default class QuoteFiles extends LightningElement {
    @api recordId;
    latestFile;

    @wire(getSyncedQuoteFiles, { opportunityId: '$recordId' })
    wiredFiles({ data, error }) {
        if (data && data.length > 0) {
            this.latestFile = {
                title: data[0].ContentDocument.Title,
                extension: data[0].ContentDocument.FileExtension,
                url: `/lightning/r/Quote/${data[0].LinkedEntityId}/related/QuoteDocuments/view`,
                size: this.formatFileSize(data[0].ContentDocument.ContentSize)
            };
        } else {
            this.latestFile = null;
        }
    }

    formatFileSize(bytes) {
        if (bytes >= 1048576) return `${(bytes / 1048576).toFixed(2)} MB`;
        return `${(bytes / 1024).toFixed(2)} KB`;
    }
}