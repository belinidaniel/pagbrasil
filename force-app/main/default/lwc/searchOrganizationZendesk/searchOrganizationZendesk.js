// searchOrganizationZendesk.js
import { LightningElement, track, api } from 'lwc';
import searchOrganization from '@salesforce/apex/OrganizationZendeskController.searchOrganization';

export default class SearchOrganizationZendesk extends LightningElement {
    @track searchKey = '';
    @track organizations = [];
    @track error;
    @track selectedOrganization;
    @track isLoading = false;

    searchOrganizations() {
        this.isLoading = true;
        searchOrganization({ filter: this.searchKey })
            .then((result) => {
                this.organizations = JSON.parse(result)?.organizations?.slice(0, 10);

                if (this.organizations.length) {
                    this.template.querySelector('.slds-combobox.slds-dropdown-trigger.slds-dropdown-trigger_click')?.classList.add('slds-is-open');
                    this.template.querySelector('.slds-combobox.slds-dropdown-trigger.slds-dropdown-trigger_click')?.focus();
                }

                this.error = undefined;

                this.isLoading = false;
            })
            .catch((error) => {
                this.error = error;
                this.organizations = [];
                this.isLoading = false;
            });
    }

    handleInputChange(event) {
        this.searchKey = event.target.value;

        if (this.searchKey.length > 2) {
            this.searchOrganizations();
        } else {
            this.selectedOrganization = null;
            this.organizationChanged(null);
        }
    }

    handleOnBlur(event) {
        setTimeout(() => {
            if (!this.selectedOrganizationId) {
                this.template.querySelector('.slds-combobox.slds-dropdown-trigger.slds-dropdown-trigger_click')?.classList.remove('slds-is-open');
            }
        }, 300);
    }

    handleOptionClick(event) {
        this.selectedOrganization = this.organizations.find(org => org.id === parseInt(event.currentTarget?.dataset?.value));
        console.log('selectedOrganization: ', JSON.stringify(this.selectedOrganization));
        this.template.querySelector('.slds-combobox.slds-dropdown-trigger.slds-dropdown-trigger_click')?.classList.remove('slds-is-open');

        this.organizationChanged(this.selectedOrganization?.id);
    }

    organizationChanged(organizationId){
        const selectedEvent = new CustomEvent("selectedorganization", { detail:{ organizationId : organizationId } });
        this.dispatchEvent(selectedEvent);
    }

    get selectedOrganizationId(){
        return this.selectedOrganization?.id;
    }

    get selectedOrganizationName(){
        return this.selectedOrganization?.name;
    }

    get hasSelectedOrganization(){
        return this.selectedOrganization != null;
    }
}