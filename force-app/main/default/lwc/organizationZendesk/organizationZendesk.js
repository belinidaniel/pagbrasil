import { LightningElement, track, api } from 'lwc';
import {
    FlowAttributeChangeEvent,
    FlowNavigationNextEvent,
} from 'lightning/flowSupport';

export default class OrganizationZendesk extends LightningElement {
    @api organizationId;
    @api opportunityId;
    @api availableActions = [];

    @track showCreateOrg = false;

    callAction(actionName){
        if (this.availableActions.find((action) => action === actionName)) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }

    handleSelectedOrganization(event){
        this.organizationId = event.detail.organizationId;
    }

    handleCreatedOrganization(event){
        this.organizationId = event.detail.organizationId;
        this.callAction('NEXT');
    }

    handleSelect(event){
        this.callAction('NEXT');
    }

    handleCreate(event){
        this.organizationId = null;
        this.showCreateOrg = true;
    }

    handleCancel() {
        const closeFlowEvent = new CustomEvent('closeflow');
        this.dispatchEvent(closeFlowEvent);
    }

    handleCancelCreate(event){
        this.organizationId = null;
        this.showCreateOrg = false;
    }

    handleSave(event){
        this.template.querySelector("c-create-organization").handleSubmit();
    }

    get hasrganization(){
        return this.organizationId != null;
    }
}