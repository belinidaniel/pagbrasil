import { LightningElement, track } from 'lwc';
import getBusinessModels from '@salesforce/apex/ManageTaxesPricesController.getBusinessModels';
import getIntegrationTypes from '@salesforce/apex/ManageTaxesPricesController.getIntegrationTypes';
import getTaxRegions from '@salesforce/apex/ManageTaxesPricesController.getTaxRegions';
import getProductClasses from '@salesforce/apex/ManageTaxesPricesController.getProductClasses';
import getTypes from '@salesforce/apex/ManageTaxesPricesController.getTypes';
import getStatusTaxas from '@salesforce/apex/ManageTaxesPricesController.getStatusTaxas';
import getProcessingTypes from '@salesforce/apex/ManageTaxesPricesController.getProcessingTypes';
import getRecordTypeNames from '@salesforce/apex/ManageTaxesPricesController.getRecordTypeNames';
import getProductNames from '@salesforce/apex/ManageTaxesPricesController.getProductNames';
import getProductOptions from '@salesforce/apex/ManageTaxesPricesController.getProductOptions';
import filterTaxesOrPrices from '@salesforce/apex/ManageTaxesPricesController.filterTaxesOrPrices';
const LOCAL_STORAGE_WIDTH = 'userColumnSettings';


const COLUMNSWITHFLEXIBILITY = [
    { label : 'Business Model1', fieldName: 'BusinessModel__c', editable: false, initialWidth : 300},
    { label: 'Name', fieldName: 'NameUrl', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }, editable: false },
    { label: 'CurrencyIsoCode', fieldName: 'CurrencyIsoCode', editable: false, initialWidth : 100},
    { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', editable: true, initialWidth : 150},
    { label: 'Is Active', fieldName: 'IsActive', type: 'boolean', editable: true, initialWidth : 150},
    { label: 'Product Code', fieldName: 'ProductCode', editable: false, initialWidth : 150},
    { label: 'Is Percent', fieldName: 'IsPercent__c', type: 'boolean', editable: true, initialWidth : 150},
    { label: 'Order', fieldName: 'Order__c', editable: true, initialWidth : 150}
];

const COLUMNSWITHOUTFLEXIBILITY = [
    { label : 'Business Model', fieldName: 'Pricebook2Name', editable: false, initialWidth : 300},
    { label: 'Name', fieldName: 'NameUrl', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }, editable: false },
    { label: 'Is Percent', fieldName: 'IsPercent__c', type: 'boolean', editable: true, initialWidth: 150 },
    { label: 'CurrencyIsoCode', fieldName: 'CurrencyIsoCode', editable: false, initialWidth : 150 },
    { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', editable: true, initialWidth: 150 },
    { label: 'Percent Value', fieldName: 'PercentValue__c', type: 'number', editable: true, initialWidth: 150 },
    { label: 'Order', fieldName: 'Order__c', editable: true, initialWidth: 100 },
    { label: 'Active', fieldName: 'IsActive', type: 'boolean', editable: true, initialWidth: 150 }
];
export default class LwcTaxesPrice extends LightningElement {
    @track businessModelOptions = [];
    @track integrationTypeOptions = [];
    @track taxRegionOptions = [];
    @track productClassOptions = [];
    @track typeOptions = [];
    @track statusTaxaOptions = [];
    @track processingTypeOptions = [];
    @track recordTypeNameOptions = [];
    @track productNameOptions = [];
    @track productOptions = [];
    @track isLoading = false;
    @track prices = [];

    @track columnsWithoutFlexibility = COLUMNSWITHOUTFLEXIBILITY;
    @track columnsWithFlexibility = COLUMNSWITHFLEXIBILITY;

    @track displayedData = [];
    @track recordsTotal = '0/0';
    @track searchTerm = '';
    @track showResult = false;
    @track selectedProductId = '';

    async connectedCallback() {
        await this.loadBusinessModels();
        await this.loadIntegrationTypes();
        await this.loadTaxRegions();
        await this.loadProductClasses();
        await this.loadTypes();
        await this.loadStatusTaxas();
        await this.loadProcessingTypes();
        await this.loadRecordTypeNames();
        await this.loadProductNames();
        await this.loadProductOptions();
    }

    async loadBusinessModels() {
        this.businessModelOptions = (await getBusinessModels()).map(v => ({ label: v, value: v }));
    }
    async loadIntegrationTypes() {
        this.integrationTypeOptions = (await getIntegrationTypes()).map(v => ({ label: v, value: v }));
    }
    async loadTaxRegions() {
        this.taxRegionOptions = (await getTaxRegions()).map(v => ({ label: v, value: v }));
    }
    async loadProductClasses() {
        this.productClassOptions = (await getProductClasses()).map(v => ({ label: v, value: v }));
    }
    async loadTypes() {
        this.typeOptions = (await getTypes()).map(v => ({ label: v, value: v }));
    }
    async loadStatusTaxas() {
        this.statusTaxaOptions = (await getStatusTaxas()).map(v => ({ label: v, value: v }));
    }
    async loadProcessingTypes() {
        this.processingTypeOptions = (await getProcessingTypes()).map(v => ({ label: v, value: v }));
    }
    async loadRecordTypeNames() {
        this.recordTypeNameOptions = (await getRecordTypeNames()).map(v => ({ label: v, value: v }));
    }
    async loadProductNames() {
        this.productNameOptions = (await getProductNames()).map(v => ({ label: v, value: v }));
    }
    async loadProductOptions() {
        this.productOptions = await getProductOptions();
    }

    handleSearchTerms(event) {
        const filter = event.detail.value;
        this.searchTerm = filter;
        // Optionally clear table if filter is empty
        if (!filter || Object.keys(filter).length === 0) {
            this.displayedData = [];
            this.recordsTotal = '0/0';
            this.showResult = false;
        }
    }


    async handleSearchButton() {
        this.isLoading = true;
        try {
            const filterJson = JSON.stringify(this.searchTerm);
            const resultJson = await filterTaxesOrPrices({ filterJson , isFlex: this.searchTerm?.isFlexible == null ? false : this.searchTerm?.isFlexible });
            let data = JSON.parse(resultJson);
            data = data.map(row => {
                if (row.Pricebook2 && row.Pricebook2.Name) {
                    row.Pricebook2Name = row.Pricebook2.Name;
                }
                if (this.searchTerm?.isFlexible) {
                    row.NameUrl = `/lightning/r/Taxes__c/${row.Id}/view`;
                } else {
                    row.NameUrl = `/lightning/r/PricebookEntry/${row.Id}/view`;
                }
                return row;
            });
            this.displayedData = data;
            this.recordsTotal = `${this.displayedData.length}/${this.displayedData.length}`;
            this.showResult = true;
            // Notify child table to refresh
            this.template.querySelectorAll('c-prices-table').forEach(table => {
                if (table.refreshTable) table.refreshTable(data);
            });
        } catch (e) {
            this.displayedData = [];
            this.showResult = false;
            this.recordsTotal = '0/0';
        }
        this.isLoading = false;
    }

    handleClear(event) {
        this.selectedProductId = '';
        this.displayedData = [];
        this.showResult = false;
        this.recordsTotal = '0/0';
        // Clear child tables
        this.template.querySelectorAll('c-prices-table').forEach(table => {
            if (table.refreshTable) table.refreshTable([]);
        });
        // Clear filter component
        const filterComps = this.template.querySelectorAll('c-taxes-price-filter');
        filterComps.forEach(filter => {
            if (filter.handleClear) filter.handleClear();
        });
    }
}