import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCompanyReportDataset from '@salesforce/apex/BigBoostService.getCompanyReportDataset'; 
import FISCAL_REGISTRATION from '@salesforce/schema/KYC__c.Fiscal_Registration__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateBigBoost extends LightningElement {
	@api recordId
	fiscalRegistration;
	isLoading = false;
	datasets = ['basic_data', 'registration_data', 'kyc', 'owners_kyc', 'media_profile_and_exposure', 'phones_extended', 'emails_extended', 'addresses_extended', 'apps_networks_and_platforms', 'domains', 'processes', 'activity_indicators', 'relationships'];

	@wire(getRecord, { recordId: '$recordId', fields: [FISCAL_REGISTRATION] })
	wiredRecord({ error, data }) {
		if (data) {
			this.fiscalRegistration = data.fields.Fiscal_Registration__c.value;
		} else if (error) {
			console.error('Error fetching KYC record: ', error);
		}
	}

	async handleClick() {
		if (!this.fiscalRegistration) {
			this.showToast('Error', 'Fiscal Registration is missing!', 'error');
			return;
		}

		this.isLoading = true;
		const cnpj = this.removeSymbols(this.fiscalRegistration);

		const promises = this.datasets.map(dataset => getCompanyReportDataset({ dataset, cnpj, kycId: this.recordId }));
		Promise.allSettled(promises)
			.then((results) => {
				const successes = results.filter(response => response.status === 'fulfilled').map(response => response.value);
				const failures = results.filter(response => response.status === 'rejected').map(response => response.reason);
				if (failures.length > 0) {
					this.showToast('Error', `Some requests failed: ${failures.join('', '')}`, 'error');
				} else {
					this.showToast('Success', 'All requests were successful!', 'success');
				}
			})
			.catch(error => {
				console.error('Unexpected Error: ', error);
				this.showToast('Error', 'An Unexpected error occurred.', 'error');
			})
			.finally(() => {
				this.isLoading = false;
			});
	}

	removeSymbols(str) {
		if (!str) {
			return '';
		}
		return str.replace(/\D/g, '');
	}

	showToast(title, message, variant) {
		const event = new ShowToastEvent({
			title,
			message,
			variant
		});
		this.dispatchEvent(event);
	}
}