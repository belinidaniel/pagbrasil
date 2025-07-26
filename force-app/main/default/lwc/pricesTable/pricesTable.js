import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

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

    handleSave(event) {
        this.isLoading = true;
        updatePricebookEntries({ taxes: event.detail.draftValues })
            .then(() => {
                this.draftValues = [];
                this.disableSave = true;
                this.loadData();
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Registros salvos com sucesso!',
                        variant: 'success'
                    })
                );
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
        this.draftValues = event.detail.draftValues;
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

    handleTaxesFilterChange(event) {
        this.searchTerm = event.target.value;
        this.columns = this.searchTerm.isFlexible ? this.columnsWithFlexibility : this.columnsWithoutFlexibility;
        this.filterData();
    }

    filterData() {
        if (!this.data) {
            this.filteredData = [];
            return;
        }
        const searchTermLower = this.searchTerm.toLowerCase();
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
        console.log('Clear search term' , JSON.stringify(this.data));
        this.searchTerm = '';
        this.filterData();
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
}
