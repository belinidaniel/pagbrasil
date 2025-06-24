import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import generateAndSavePDF from '@salesforce/apex/ContractController.generateAndSavePDF';
import PagLogo from "@salesforce/resourceUrl/Logo2025";
import getKycIdByOpportunity from '@salesforce/apex/KYCService.getKycIdByOpportunity';
import attachContractToRecord from '@salesforce/apex/ContractController.attachContractToRecord';

const RECORD_TYPE_NAME_FIELD = 'Opportunity.RecordType.Name';
const QUARTER_MONTHS = ['01', '04', '07', '10'];

export default class GenerateContract extends LightningElement {
    @api recordId;
    @track isDropdownOpen = false;
    @track recordTypeName;
    @track kycId;
    month;
    contractYear;
    contractMonth;
    maintenanceYear;
    maintenanceMonth;
    link;
    showModal = false;
    vfUrl;
    selectedYear;
    yearOptions = [];
    PagLogoUrl = PagLogo;
    @track firstReviewYearOptions = [];

    /*@wire(getRecord, { 
        recordId: '$recordId', 
        fields: [RECORD_TYPE_NAME_FIELD] 
    })
    wiredRecord({ error, data }) {
        if (data) {
            this.recordTypeName = data.fields.RecordType.value.fields.Name.value;
        }
    }*/

    @wire(getRecord, { 
        recordId: '$recordId', 
        fields: [RECORD_TYPE_NAME_FIELD] 
    })
    async wiredRecord({ error, data }) {
        if (data) {
            this.recordTypeName = data.fields.RecordType.value.fields.Name.value;
            await this.fetchKycId();
        }
    }

    async fetchKycId() {
        if (!this.recordId || !this.recordTypeName) return;
        try {
            const result = await getKycIdByOpportunity({
                opportunityId: this.recordId,
                recordTypeName: this.recordTypeName === 'Cross-border' ? 'Crossborder' : this.recordTypeName
            });
            this.kycId = result;
        } catch (error) {
            this.kycId = null;
        }
    }

    get kycFormLinkValue() {
        const baseUrl = window.location.origin;
        if (this.recordTypeName === 'National') {
            return `${baseUrl}/apex/KYCPdfPage?id=${this.kycId}`;
        }
        if (this.recordTypeName === 'Crossborder') {
            return `${baseUrl}/apex/KYCPdfPage?id=${this.kycId}`;
        }
        return '';
    }

    get firstReviewOptions() {
        return [
            { label: 'January', value: '01' },
            { label: 'April', value: '04' },
            { label: 'July', value: '07' },
            { label: 'October', value: '10' }
        ];
    }

    calculateFirstReview() {
        if (!this.contractMonth || !this.contractYear) return;

        const startDate = new Date(this.contractYear, this.contractMonth - 1, 1);
        const minDate = new Date(startDate);
        minDate.setMonth(minDate.getMonth() + 3);
        
        const quarterMonths = QUARTER_MONTHS.map(m => parseInt(m));
        let reviewYear = minDate.getFullYear();
        let reviewMonth = quarterMonths.find(m => m >= minDate.getMonth() + 1);
        
        if (!reviewMonth) {
            reviewYear++;
            reviewMonth = 1;
        }

        this.month = reviewMonth.toString().padStart(2, '0');
        this.selectedYear = reviewYear.toString();
        this.updateYearOptions();
    }

    updateYearOptions() {
        if (!this.contractYear) return;
        const baseYear = parseInt(this.contractYear);
        this.firstReviewYearOptions = [
            { label: `${baseYear}`, value: `${baseYear}` },
            { label: `${baseYear + 1}`, value: `${baseYear + 1}` }
        ];
    }

    validateSelection() {
        if (!this.month || !this.selectedYear || !this.contractMonth || !this.contractYear) return;

        const start = new Date(this.contractYear, this.contractMonth - 1, 1);
        const selected = new Date(this.selectedYear, parseInt(this.month) - 1, 1);
        
        const monthDiff = (selected.getFullYear() - start.getFullYear()) * 12 + 
                         (selected.getMonth() - start.getMonth());
        
        if (monthDiff < 3) {
            this.calculateFirstReview();
            this.showNotification('Automatic adjustment', 
                `Minimum review requires 3 months. Date set to ${this.month}/${this.selectedYear}`, 
                'warning');
        }
    }

    connectedCallback() {
        this.generateYearOptions();
    }

    generateYearOptions() {
        const currentYear = new Date().getFullYear();
        this.yearOptions = [];

        for (let i = 0; i <= 1; i++) {
            this.yearOptions.push({
                label: `${currentYear + i}`,
                value: `${currentYear + i}`
            });
        }
    }

    get options() {
        return [
            { label: 'January', value: '01' },
            { label: 'February', value: '02' },
            { label: 'March', value: '03' },
            { label: 'April', value: '04' },
            { label: 'May', value: '05' },
            { label: 'June', value: '06' },
            { label: 'July', value: '07' },
            { label: 'August', value: '08' },
            { label: 'September', value: '09' },
            { label: 'October', value: '10' },
            { label: 'November', value: '11' },
            { label: 'December', value: '12' }
        ];
    }

    convertMonthToEnglish(monthInPortuguese) {
        const monthMap = {
            'January': 'January',
            'February': 'February',
            'March': 'March',
            'April': 'April',
            'May': 'May',
            'June': 'June',
            'July': 'July',
            'August': 'August',
            'September': 'September',
            'October': 'October',
            'November': 'November',
            'December': 'December'
        };
        return monthMap[monthInPortuguese] || monthInPortuguese;
    }

    handleChange(event) {
        this.month = event.detail.value;
    }

    async generate() {
        // const inputElement = this.template.querySelector('[data-id="kycLinkInput"]');
        // this.link = inputElement.value;

        console.log('month:', this.month);
        console.log('selectedYear:', this.selectedYear);
        console.log('link:', this.link);
        console.log('contractYear:', this.contractYear);
        console.log('contractMonth:', this.contractMonth);
        console.log('maintenanceMonth:', this.maintenanceMonth);
        console.log('maintenanceYear:', this.maintenanceYear);

        this.link = this.kycFormLinkValue;
        const selectedMonth = this.options.find(option => option.value === this.month);

        if (!this.month || !this.selectedYear || !this.contractYear
            || !this.contractMonth || !this.maintenanceMonth || !this.maintenanceYear) {
            this.showNotification('Error', 'Fill in all the fields to generate the contract', 'error');
            return;
        }

        let vfPageName = 'ContractNacionalPage';
        if (this.recordTypeName === 'Cross-border') {
            vfPageName = 'ContractCrossborderPage';
        }

        this.contractDate = `${this.contractYear}-${this.contractMonth}-01`;
        this.maintenanceDate = `${this.maintenanceYear}-${this.maintenanceMonth}-01`;
        let monthLabel = selectedMonth.label + ' de ' + this.selectedYear;

        if (this.recordTypeName === 'Cross-border') {
            const monthInEnglish = this.convertMonthToEnglish(selectedMonth.label);
            monthLabel = monthInEnglish + ' of ' + this.selectedYear;
        }

        const vfBaseURL = `/apex/${vfPageName}`;
        const queryParams = new URLSearchParams({
            id: this.recordId,
            month: monthLabel,
            contractDate: this.contractDate,
            link: this.link,
            maintenanceDate: this.maintenanceDate
        });

        this.vfUrl = `${vfBaseURL}?${queryParams.toString()}`;
        this.showModal = true;

        try {
            const contentDocumentId = await generateAndSavePDF({
                opportunityId: this.recordId,
                month: monthLabel,
                contractDate: this.contractDate,
                link: this.link,
                maintenanceDate: this.maintenanceDate
            });

            await updateRecord({
                fields: {
                    Id: this.recordId,
                    Contract_File_Id__c: contentDocumentId
                }
            });

            this.vfUrl = `${vfBaseURL}?${queryParams.toString()}`;
            this.showModal = true;

            this.showNotification('Success', 'PDF gerado e salvo!', 'success');
            
        } catch (error) {
            this.showNotification('Error', error.body?.message || error.message, 'error');
        }
    }

    closeModal() {
        this.showModal = false;
        location.reload();
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    handleChange(event) {
        this.month = event.detail.value;
        this.validateSelection();
    }

    handleContractMonth(event) {
        this.contractMonth = event.detail.value;
        this.calculateFirstReview();
    }

    handleContractYear(event) {
        this.contractYear = event.detail.value;
        this.updateYearOptions();
        this.calculateFirstReview();
    }

    handleMaintenanceDate(event) {
        this.maintenanceDate = event.target.value;
    }

    handleMaintenanceYear(event) {
        this.maintenanceYear = event.target.value;
    }

    handleMaintenanceMonth(event) {
        this.maintenanceMonth = event.target.value;
    }

    handleYearChange(event) {
        this.selectedYear = event.detail.value;
        this.validateSelection();
    }
}