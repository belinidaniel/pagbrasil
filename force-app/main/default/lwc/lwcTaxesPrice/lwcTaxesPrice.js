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
import getPricebookEntries from '@salesforce/apex/ManageTaxesPricesController.getPricebookEntries';
import updatePricebookEntries from '@salesforce/apex/ManageTaxesPricesController.updateTaxes';
import updatePriceEntrys from '@salesforce/apex/ManageTaxesPricesController.updatePriceEntrys';
import filterTaxesOrPrices from '@salesforce/apex/ManageTaxesPricesController.filterTaxesOrPrices';

const COLUMNSWITHFLEXIBILITY = [
    { label: 'Name', fieldName: 'Name', editable: false },
    { label: 'CurrencyIsoCode', fieldName: 'CurrencyIsoCode', editable: false },
    { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', editable: true },
    { label: 'Is Active', fieldName: 'IsActive', type: 'boolean', editable: true },
    { label: 'Product Code', fieldName: 'ProductCode', editable: false },
    { label: 'Is Percent', fieldName: 'IsPercent__c', type: 'boolean', editable: true },
    { label: 'CurrencyIsoCode__c', fieldName: 'CurrencyIsoCode__c', editable: true },
    { label: 'Order', fieldName: 'Order__c', editable: true },
    { label: 'Optional', fieldName: 'Optional__c', type: 'boolean', editable: true }
];

const COLUMNSWITHOUTFLEXIBILITY = [
    { label: 'Name', fieldName: 'Name', editable: false },
    { label: 'CurrencyIsoCode', fieldName: 'CurrencyIsoCode', editable: false },
    { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', editable: true },
    { label: 'Is Active', fieldName: 'IsActive', type: 'boolean', editable: true },
    { label: 'Product Code', fieldName: 'ProductCode', editable: false },
    { label: 'Is Percent', fieldName: 'IsPercent__c', type: 'boolean', editable: true },
    { label: 'CurrencyIsoCode__c', fieldName: 'CurrencyIsoCode__c', editable: true },
    { label: 'Order', fieldName: 'Order__c', editable: true },
    { label: 'Optional', fieldName: 'Optional__c', type: 'boolean', editable: true }
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
    }


    async handleSearchButton() {
        this.isLoading = true;
        try {
            const filterJson = JSON.stringify(this.searchTerm);
            console.log('Search initiated with filter:', filterJson);
            const resultJson = await filterTaxesOrPrices({ filterJson , isFlex: this.searchTerm?.isFlexible == null ? false : this.searchTerm?.isFlexible });
            this.displayedData = JSON.parse(resultJson);
            this.recordsTotal = `${this.displayedData.length}/${this.displayedData.length}`;
            this.showResult = true;
        } catch (e) {
            this.displayedData = [];
            this.showResult = false;
            this.recordsTotal = '0/0';
        }
        this.isLoading = false;
    }

    handleClear() {
        this.selectedProductId = '';
        this.displayedData = [];
        this.showResult = false;
        this.recordsTotal = '0/0';
    }
}