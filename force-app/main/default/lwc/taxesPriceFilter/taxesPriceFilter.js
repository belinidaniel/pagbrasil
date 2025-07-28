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
        selectedBusinessModel: [],
        selectedIntegrationType: [],
        selectedTaxRegion: [],
        selectedProductClass: [],
        selectedType: [],
        selectedStatusTaxa: [],
        selectedProcessingType: [],
        selectedRecordTypeName: [],
        selectedProductName: [],
        selectedProductId: [],
        isPercent: false, // Assuming this is a boolean for percent filter
        isActive: true // Assuming this is a boolean for active filter
    };

    handleSelectionChange(event) {
        const name = event.target.name;
        const selectedValues = event.detail.value || [];
        this.searchBranch[name] = selectedValues;
        this.handleSearch();
    }

    handleSelectionChangeBoolean(event) {
        const name = event.target.name;
        const selectedValues = event.detail.value || false;
        this.searchBranch[name] = selectedValues;
        console.log(`Boolean filter changed: ${name} = ${selectedValues}`);
        this.handleSearch();
    }


    handleChange(event) {
        this.searchBranch[event.target.name] = event.target.value;
        this.handleSearch();
    }

    @api
    handleClear() {
        this.searchBranch = {
            isFlexible: this.isFlexible, // Always set isFlexible correctly
            selectedBusinessModel: [],
            selectedIntegrationType: [],
            selectedTaxRegion: [],
            selectedProductClass: [],
            selectedType: [],
            selectedStatusTaxa: [],
            selectedProcessingType: [],
            selectedRecordTypeName: [],
            selectedProductName: [],
            selectedProductId: [],
            isPercent: false, // Assuming this is a boolean for percent filter
            isActive: true // Assuming this is a boolean for active filter
        };
        // Limpar selects se necessário
        this.template.querySelectorAll('lightning-combobox').forEach(combo => {
            combo.value = '';
        });
        // Dispatch filter change with cleared filters
        this.handleSearch();
    }

    handleSearch() {
        this.searchBranch.isFlexible = this.isFlexible;
        const selectedEvent = new CustomEvent('taxesfilterchange', {
            detail: { name: 'taxesfilterchange', value: { ...this.searchBranch } }
        });
        this.dispatchEvent(selectedEvent);
    }

}
