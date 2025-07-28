import { LightningElement, api, track } from 'lwc';
import getTaxesWithFlex from '@salesforce/apex/TaxesController.getTaxesWithFlex';
import updateTaxes from '@salesforce/apex/TaxesController.updateTaxes';

const COLUMNS = [
    { label: 'Business Model', fieldName: 'BusinessModel__c', editable: true },
    { label: 'Integration Type', fieldName: 'IntegrationType__c', editable: true },
    { label: 'Product', fieldName: 'Product__c', editable: false },
    { label: 'Unit Price', fieldName: 'UnitPrice__c', type: 'currency', editable: true },
    { label: 'Percent Value', fieldName: 'PercentValue__c', type: 'percent', editable: true },
    { label: 'Flex Head', fieldName: 'FlexHead__c', editable: true },
    { label: 'Flex Board', fieldName: 'FlexBoard__c', editable: true },
    { label: 'Is Percent', fieldName: 'IsPercent__c', type: 'boolean', editable: true },
    { label: 'Status', fieldName: 'StatusTaxa__c', editable: true },
    { label: 'Taxa Base Antecipação', fieldName: 'TaxaBaseAntecipacao__c', editable: true },
    { label: 'Processing Type', fieldName: 'ProcessingType__c', editable: true },
    { label: 'Record Type', fieldName: 'RecordTypeName__c', editable: true },
    { label: 'Faixa Inicial', fieldName: 'RangeFaixaInicial__c', editable: true },
    { label: 'Faixa Final', fieldName: 'RangeFaixaFinal__c', editable: true },
    { label: 'Flexibilization', fieldName: 'Flexibilization__c', type: 'boolean', editable: false },
    { label: 'Ticket Inicial', fieldName: 'TicketInicial__c', editable: true },
    { label: 'Installment Number', fieldName: 'InstallmentNumber__c', editable: true },
    { label: 'Antecipation Frequency', fieldName: 'AntecipationFrequency__c', editable: true },
    { label: 'Ticket Final', fieldName: 'TicketFinal__c', editable: true },
    { label: 'Receita Mensal Inicial', fieldName: 'ReceitaMensalInicial__c', editable: true },
    { label: 'Receita Mensal Final', fieldName: 'ReceitaMensalFinal__c', editable: true },
    { label: 'Is Active', fieldName: 'IsActive__c', type: 'boolean', editable: true },
    { label: 'Tax Region', fieldName: 'TaxRegion__c', editable: true },
    { label: 'Can Edit All Taxes', fieldName: 'Can_Edit_All_Taxes__c', type: 'boolean', editable: true },
    { label: 'Product Class', fieldName: 'ProductClass__c', editable: true },
    { label: 'Type', fieldName: 'Type__c', editable: true },
    { label: 'Gateway/Intermediation', fieldName: 'IsGatewayAndIntermediation__c', type: 'boolean', editable: true }
];

export default class TaxesTable extends LightningElement {
    @api productId;
    @track taxes = [];
    @track columns = COLUMNS;
    @track draftValues = [];
    @track isLoading = false;

    connectedCallback() {
        this.loadData();
    }

    @api
    refresh() {
        this.loadData();
    }

    loadData() {
        this.isLoading = true;
        getTaxesWithFlex({ productId: this.productId })
            .then(result => {
                this.taxes = result;
                this.isLoading = false;
            })
            .catch(() => { this.isLoading = false; });
    }

    handleSave(event) {
        this.isLoading = true;
        updateTaxes({ taxes: event.detail.draftValues })
            .then(() => {
                this.draftValues = [];
                this.loadData();
            })
            .catch(() => { this.isLoading = false; });
    }
}
