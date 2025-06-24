({
    loadVFUrl : function(component) {
        const action = component.get("c.getOpportunityType");
        action.setParams({ quoteId: component.get("v.recordId") });

        action.setCallback(this, function(response) {
            
            if (response.getState() === "SUCCESS") {
                const quote = response.getReturnValue();

                console.log("quote", quote);

                const validStatuses = [
                    'Draft',
                    'Rascunho',
                    'Aprovada',
                    'Approved'
                ];

                // check is sync
                if (!quote.IsSyncing) {
                    component.set("v.quoteValidationMessage", "Please sync the quote before generating the proposal.");
                    component.set("v.canGenerateProposal", false);
                    return;
                }

                // if(quote.Id === quote.Opportunity.SyncedQuoteId){

                //     // check is sync
                //     if (!quote.IsSyncing && 'SyncedQuoteId' in quote.Opportunity && quote.Opportunity.SyncedQuoteId === null) {
                //         component.set("v.quoteValidationMessage", "Please sync the quote before generating the proposal.");
                //         component.set("v.canGenerateProposal", false);
                //         return;
                //     }
                // }

                if(quote.Id != quote.Opportunity.SyncedQuoteId){
                    // check is sync
                    if (!quote.IsSyncing && 'SyncedQuoteId' in quote.Opportunity && 'SyncedQuote' in quote.Opportunity && quote.Opportunity.SyncedQuote.IsSyncing) {
                        component.set("v.quoteValidationMessage", "Opportunity is synced with another quote.");
                        component.set("v.canGenerateProposal", false);
                        return;
                    }
                }
                
                // check status
                if (!validStatuses.includes(quote.Status)) {
                    component.set("v.quoteValidationMessage", "Quote with status '" + quote.Status + "' does not allow proposal generation.");
                    component.set("v.canGenerateProposal", false);
                    return;
                }

                component.set("v.canGenerateProposal", true);
                
                const vfPage = quote.Opportunity.RecordType.DeveloperName === 'Crossborder'
                    ? 'PropostaCross'
                    : 'PropostaNacional';
                const vfUrl = '/apex/' + vfPage + '?id=' + component.get("v.recordId");
                component.set("v.vfUrl", vfUrl);

                // Set quote status for button visibility
                component.set("v.quoteStatus", quote.Status);

            } else {
                console.error("Erro ao buscar tipo de opp:", response.getError());
            }
        });

        $A.enqueueAction(action);
        
    },

    savePDF : function(component) {
        component.set("v.isLoading", true); // Inicia spinner

        const action = component.get("c.savePdfVersion");
        action.setParams({ quoteId: component.get("v.recordId") });
    
        action.setCallback(this, function(response) {
            component.set("v.isLoading", false); // Finaliza spinner
            const state = response.getState();
            if (state === "SUCCESS") {
                // Success toast
                $A.get("e.force:showToast").setParams({
                    title: "Success",
                    message: "PDF saved successfully!",
                    type: "success",
                    mode: "dismissible"
                }).fire();

                // Fecha o modal
                $A.get("e.force:closeQuickAction").fire();

                // Força refresh da página para atualizar a lista de arquivos
                $A.get('e.force:refreshView').fire();

            } else {
                // Error toast
                const errors = response.getError();
                const message = errors && errors[0] && errors[0].message ? errors[0].message : "Error saving PDF";
                $A.get("e.force:showToast").setParams({
                    title: "Error",
                    message: message,
                    type: "error",
                    mode: "sticky"
                }).fire();
            }
        });
    
        $A.enqueueAction(action);
    }, 

    sendPDFByEmail : function(component) {
        component.set("v.isLoading", true); // Start spinner
        const action = component.get("c.sendToEmail");
        action.setParams({ quoteId: component.get("v.recordId") });
        action.setCallback(this, function(response) {
            component.set("v.isLoading", false); // Stop spinner
            const state = response.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:showToast").setParams({
                    title: "Success",
                    message: "PDF sent to quote owner successfully!",
                    type: "success",
                    mode: "dismissible"
                }).fire();
                $A.get("e.force:closeQuickAction").fire();
            } else {
                const errors = response.getError();
                const message = errors && errors[0] && errors[0].message ? errors[0].message : "Error sending PDF by email";
                $A.get("e.force:showToast").setParams({
                    title: "Error",
                    message: message,
                    type: "error",
                    mode: "sticky"
                }).fire();
            }
        });
        $A.enqueueAction(action);
    },

    injectSaveButtonInOverrideFooter : function(component) {
        const tryInject = () => {
            const footer = document.querySelector('.slds-modal__footer');
            if (footer && footer.children.length < 2) {
                // Botão Cancelar
                // const cancelBtn = document.createElement("button");
                // cancelBtn.className = "slds-button slds-button_neutral slds-m-right_small";
                // cancelBtn.innerText = "Cancelar";
                // cancelBtn.onclick = function () {
                //     $A.get("e.force:closeQuickAction").fire();
                // };
    
                // Save button
                const saveBtn = document.createElement("button");
                saveBtn.className = "slds-button slds-button_brand";
                saveBtn.innerText = "Save";
                saveBtn.onclick = function () {
                    component.get("c.handleSave").run(); // invoke Aura method
                };
    
                footer.innerHTML = ''; // limpa se necessário
                // footer.appendChild(cancelBtn);
                footer.appendChild(saveBtn);
            } else {
                // Retry loop
                setTimeout(tryInject, 150);
            }
        };
    
        tryInject();
    }
    
})