import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import generateAndSavePDF from '@salesforce/apex/ContractController.generateAndSavePDF';
import PagLogo from "@salesforce/resourceUrl/Logo2025";

const RECORD_TYPE_NAME_FIELD = 'Opportunity.RecordType.Name';

export default class GenerateContract extends LightningElement {
    @api recordId;
    @track isDropdownOpen = false;
    @track recordTypeName;
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

    @wire(getRecord, { recordId: '$recordId', fields: [RECORD_TYPE_NAME_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            this.recordTypeName = data.fields.RecordType.value.fields.Name.value;
        }
    }

    connectedCallback() {
        this.generateYearOptions();
    }

    generateYearOptions() {
        const currentYear = new Date().getFullYear();
        this.yearOptions = [];

        for (let i = -1; i <= 1; i++) {
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
        const inputElement = this.template.querySelector('[data-id="kycLinkInput"]');
        this.link = inputElement.value;
        const selectedMonth = this.options.find(option => option.value === this.month);

        if (!this.month || !this.selectedYear || !this.link || !this.contractYear
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
            await generateAndSavePDF({
                opportunityId: this.recordId,
                month: monthLabel,
                contractDate: this.contractDate,
                link: this.link,
                maintenanceDate: this.maintenanceDate
            });

            this.showNotification('Success', 'PDF generated and saved successfully!', 'success');
        } catch (error) {
            this.showNotification('Error', error.body.message, 'error');
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
    }

    handleContractYear(event) {
        this.contractYear = event.target.value;
    }

    handleContractMonth(event) {
        this.contractMonth = event.target.value;
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
    }
}