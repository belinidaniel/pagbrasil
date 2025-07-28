import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updatePricebookEntries from '@salesforce/apex/ManageTaxesPricesController.updatePriceEntrys';

export default class PricesTable extends LightningElement {
    @api productId;
    @api columns = [];
    @api data;
    @api showResult = false;
    @api recordsTotal = '0/0';

    filteredData = [];
    prices = [];
    draftValues = [];
    isLoading = false;
    searchTerm = '';
    sortBy;
    sortDirection;
    disableCsv = true;
    disableSave = true;

    connectedCallback() {
        this.filteredData = this.data ? [...this.data] : [];
    }

    @api
    loadData() {
        // If parent reloads data, update filteredData as well
        this.filteredData = this.data ? [...this.data] : [];
        this.filterData();
    }

    handleSave(event) {
        this.isLoading = true;
        console.log('Saving draft values:', JSON.stringify(event.detail.draftValues));
        updatePricebookEntries({ taxes: event.detail.draftValues })
            .then(() => {
                this.draftValues = [];
                this.disableSave = true;
                // Notify parent to refresh from backend
                this.handleSearchEvent();
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Registros salvos com sucesso!',
                        variant: 'success'
                    })
                );
                this.isLoading = false;
            })
            .catch(() => {
                this.isLoading = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erro',
                        message: 'Erro ao salvar os registros.',
                        variant: 'error'
                    })
                );
            });
    }

    handleCellChange(event) {
        // Merge new draft values with existing ones
        const newDrafts = event.detail.draftValues;
        const draftMap = new Map();
        // Add existing drafts
        this.draftValues.forEach(draft => {
            draftMap.set(draft.Id, { ...draft });
        });
        // Merge or add new drafts
        newDrafts.forEach(draft => {
            draftMap.set(draft.Id, { ...draftMap.get(draft.Id), ...draft });
        });
        this.draftValues = Array.from(draftMap.values());
        this.disableSave = !this.draftValues || this.draftValues.length === 0;
    }

    handleSaveButton() {
        if (!this.disableSave) {
            const datatable = this.template.querySelector('lightning-datatable');
            if (datatable) {
                this.handleSave({ detail: { draftValues: this.draftValues } });
            }
        }
    }

    handleSearch(event) {
        this.searchTerm = event.target.value;
        this.filterData();
    }

    filterData() {
        if (!this.data) {
            this.filteredData = [];
            this.recordsTotal = '0/0';
            return;
        }
        const searchTermLower = this.searchTerm ? this.searchTerm.toLowerCase() : '';
        if (!searchTermLower) {
            this.filteredData = [...this.data];
            this.recordsTotal = `${this.filteredData.length}/${this.data.length}`;
            return;
        }
        this.filteredData = this.data.filter(item => {
            return Object.values(item).some(value => {
                if (typeof value === 'string') {
                    return value.toLowerCase().includes(searchTermLower);
                }
                return false;
            });
        });
        this.recordsTotal = `${this.filteredData.length}/${this.data.length}`;
    }

    handleClear() {
        this.searchTerm = '';
        this.draftValues = [];
        this.disableSave = true;
        this.filteredData = this.data ? [...this.data] : [];
        this.recordsTotal = this.data ? `${this.data.length}/${this.data.length}` : '0/0';
        // Notify parent to clear filters and filter component
        this.dispatchEvent(new CustomEvent('clear', { bubbles: true, composed: true }));
    }

    onHandleSort(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldName, direction) {
        let parseData = JSON.parse(JSON.stringify(this.filteredData));
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((a, b) => {
            let aValue = a[fieldName] === undefined || a[fieldName] === '' ? null : a[fieldName];
            let bValue = b[fieldName] === undefined || b[fieldName] === '' ? null : b[fieldName];
            if (aValue === null && bValue === null) return 0;
            if (aValue === null) return 1;
            if (bValue === null) return -1;
            return isReverse * ((aValue > bValue) - (bValue > aValue));
        });
        this.filteredData = parseData;
    }

    handleSearchEvent() {
        const selectedEvent = new CustomEvent('search', {
            detail: { value: true }
        });
        this.dispatchEvent(selectedEvent);
    }

    @api
    refreshTable(newData) {
        this.data = newData;
        this.filteredData = newData ? [...newData] : [];
        this.filterData();
    }
}
