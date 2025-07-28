import { LightningElement, track, api } from 'lwc';

export default class ButtonRadio extends LightningElement {
    @track isYesChecked = false;
    @track isNoChecked = false;
    @api title;
    @api name;

    get yesRadioId() {
        return `${this.name}_Yes`;
    }

    get noRadioId() {
        return `${this.name}_No`;
    }

    get radioName() {
        return this.name;
    }

    handleRadioChange(event) {
        const value = event.target.value;

        if (value === 'yes') {
            this.isYesChecked = true;
            this.isNoChecked = false;
            this.dispatchSelectionChangeEvent(true);
        } else if (value === 'no') {
            this.isYesChecked = false;
            this.isNoChecked = true;
            this.dispatchSelectionChangeEvent(false);
        }
    }

    dispatchSelectionChangeEvent(value) {
        const selectionChangeEvent = new CustomEvent('selectionchange', {
            detail: { value, name: this.name }
        });
        this.dispatchEvent(selectionChangeEvent);
    }

    @api
    resetValue() {
        this.isYesChecked = false;
        this.isNoChecked = false;
    }
}