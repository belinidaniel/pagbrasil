({
    doInit : function(component, event, helper) {

        component.set("v.isLoading", true);

        helper.loadVFUrl(component);

        // Simula tempo de carregamento (3 a 4 segundos)
        window.setTimeout($A.getCallback(function() {            
            // helper.injectSaveButtonInOverrideFooter(component);
            component.set("v.isLoading", false);
             
        }), 5500); // ou 4000 para 4s

        window.setTimeout(() => {
            const backdrop = document.querySelector('.slds-backdrop.slds-backdrop_open');
            if (backdrop) {
                backdrop.style.display = 'none';
            }
        }, 10); 
    },

    handleSave : function(component, event, helper) {
        component.set("v.isLoading", true); // Show spinner
        helper.savePDF(component);
    },

    closeModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    handleSendEmail : function(component, event, helper) {
        helper.sendPDFByEmail(component);
    }

});