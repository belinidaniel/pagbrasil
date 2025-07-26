import { LightningElement, api, track } from 'lwc';

export default class TaxesPriceFilter extends LightningElement {
    @api productOptions = [];
    @api businessModelOptions = [];
    @api integrationTypeOptions = [];
    @api taxRegionOptions = [];
    @api productClassOptions = [];
    @api typeOptions = [];
    @api statusTaxaOptions = [];
    @api processingTypeOptions = [];
    @api recordTypeNameOptions = [];
    @api productNameOptions = [];
    @api selectedProductId = '';
    @api isFlexible = false; // Indicates if the filter is for flexible taxes
    @track searchBranch = {
        isFlexible: false, // Assuming this is passed as a prop to determine if flexibility is enabled
        selectedBusinessModel: '',
        selectedIntegrationType: '',
        selectedTaxRegion: '',
        selectedProductClass: '',
        selectedType: '',
        selectedStatusTaxa: '',
        selectedProcessingType: '',
        selectedRecordTypeName: '',
        selectedProductName: '',
        selectedProductId: '',
    };

    handleSelectionChange(event) {
        const name = event.target.name;
        const selectedValues = event.detail.value || [];
        this.searchBranch[name] = selectedValues;
        this.handleSearch();
    }

    handleChange(event) {
        this.searchBranch[event.target.name] = event.target.value;
        this.handleSearch();
    }

    @api
    handleClear() {
        this.searchBranch = {
            isFlexible: false, // Assuming this is passed as a prop to determine if flexibility is enabled
            selectedBusinessModel: '',
            selectedIntegrationType: '',
            selectedTaxRegion: '',
            selectedProductClass: '',
            selectedType: '',
            selectedStatusTaxa: '',
            selectedProcessingType: '',
            selectedRecordTypeName: '',
            selectedProductName: '',
            selectedProductId: '',
        };
        // Limpar selects se necessário
        this.template.querySelectorAll('lightning-combobox').forEach(combo => {
            combo.value = '';
        });
        const selectedEvent = new CustomEvent('clear', {
            detail: { name: 'clear', value: true }
        });
        this.dispatchEvent(selectedEvent);
        this.handleSearch();
    }

    handleSearch() {
        this.searchBranch.isFlexible = this.isFlexible;
        const selectedEvent = new CustomEvent('taxesfilterchange', {
            detail: { name: 'taxesfilterchange', value: this.searchBranch }
        });
        this.dispatchEvent(selectedEvent);
    }

}
