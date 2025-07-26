import { LightningElement, api, track } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import selectize from '@salesforce/resourceUrl/selectize';
import selectizecss from '@salesforce/resourceUrl/selectizecss';
import jquery from '@salesforce/resourceUrl/jquery';

export default class MultiPicklist extends LightningElement {
    @track _options; // Internal tracking for options
    @api placeholder = '';
    @api title = '';
    @api name;
    @track selectedValues = [];
    selectizeInstance;
    _resourcesLoaded = false;

    // Setter for options to detect changes
    @api
    set options(value) {
        this._options = value || [];
        if (this.selectizeInstance) {
            this.updateSelectizeOptions();
        }
    }
    get options() {
        return this._options;
    }

    // Setter for value to update selected values dynamically
    @api
    set value(newValue) {
        this.selectedValues = newValue || [];
        if (this.selectizeInstance) {
            this.updateSelectizeValues();
        }
    }
    get value() {
        return this.selectedValues;
    }

    @api
    clearSelection() {
        if (this.selectizeInstance) {
            this.selectizeInstance.clear(); // Clears only the selected values
        }
        this.selectedValues = []; // Reset the internal selected values state
    }


    renderedCallback() {
        if (!this.selectizeInstance && !this._resourcesLoaded) {
            this._resourcesLoaded = true;
            this.loadScriptsWithRetry(3); // Retry loading scripts up to 3 times
        }
    }

    loadScriptsWithRetry(retryCount) {
        loadScript(this, jquery)
            .then(() => loadScript(this, selectize))
            .then(() => loadStyle(this, selectizecss))
            .then(() => this.initializeSelectize())
            .catch(error => {
                if (retryCount > 0) {
                    setTimeout(() => this.loadScriptsWithRetry(retryCount - 1), 500); // Retry after 500ms.
                } else {
                }
            });
    }

    initializeSelectize() {
        const selectElement = this.template.querySelector('select');
        if (!selectElement) {
            return;
        }

        let options;
        try {
            // Ensure `_options` is converted to plain objects
            const rawOptions = Array.isArray(this._options) ? this._options : JSON.parse(this._options || '[]');
            options = rawOptions.map(option => ({ ...option })); // Convert to plain objects
        } catch (error) {
            options = []; // Default to an empty array on error
        }

        try {
            // Destroy any existing Selectize instance to avoid reinitialization issues
            if ($(selectElement)[0]?.selectize) {
                $(selectElement)[0].selectize.destroy();
            }

            // Initialize Selectize
            this.selectizeInstance = $(selectElement).selectize({
                options: options,
                valueField: 'value',
                labelField: 'label',
                searchField: 'label',
                create: false,
                onChange: this.handleSelectionChange.bind(this),
            })[0].selectize;

            // Update the selected values in the dropdown
            this.updateSelectizeValues();
        } catch (error) {
        }
    }

    updateSelectizeOptions() {
        const newOptions = (this._options || []).map(option => ({ ...option })); // Ensure plain objects
        if (this.selectizeInstance) {
            try {
                this.selectizeInstance.clearOptions(); // Clear existing options
                this.selectizeInstance.addOption(newOptions); // Add new options
                this.selectizeInstance.refreshOptions(false); // Refresh without closing the dropdown

                // Update selected values if they exist
                if (this.selectedValues.length > 0) {
                    this.selectizeInstance.setValue(this.selectedValues);
                }
            } catch (error) {
            }
        }
    }

    updateSelectizeValues() {
        if (this.selectizeInstance && this.selectedValues) {
            try {
                this.selectizeInstance.clear();
                this.selectizeInstance.setValue(this.selectedValues);
            } catch (error) {
            }
        }
    }

    handleSelectionChange(value) {
        this.selectedValues = value || [];
        const selectedEvent = new CustomEvent('selectionchange', {
            detail: { value: this.selectedValues, name: this.name }
        });
        this.dispatchEvent(selectedEvent);
    }

    disconnectedCallback() {
        if (this.selectizeInstance) {
            this.selectizeInstance.destroy();
        }
    }
}