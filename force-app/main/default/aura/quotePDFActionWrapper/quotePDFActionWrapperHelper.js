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

                // checo  is sync
                if (!quote.IsSyncing) {
                    component.set("v.quoteValidationMessage", "Antes de gerar a proposta, sincronize a cotação.");
                    component.set("v.canGenerateProposal", false);
                    return;
                }

                // if(quote.Id === quote.Opportunity.SyncedQuoteId){

                //     // checo  is sync
                //     if (!quote.IsSyncing && 'SyncedQuoteId' in quote.Opportunity && quote.Opportunity.SyncedQuoteId === null) {
                //         component.set("v.quoteValidationMessage", "Antes de gerar a proposta, sincronize a cotação.");
                //         component.set("v.canGenerateProposal", false);
                //         return;
                //     }
                // }

                if(quote.Id != quote.Opportunity.SyncedQuoteId){

                    // checo  is sync
                     if (!quote.IsSyncing && 'SyncedQuoteId' in quote.Opportunity && 'SyncedQuote' in quote.Opportunity && quote.Opportunity.SyncedQuote.IsSyncing) {
                        component.set("v.quoteValidationMessage", "Oportunidade sincronizada com outra cotação.");
                        component.set("v.canGenerateProposal", false);
                        return;
                    }
                }
                
                // checo status
                if (!validStatuses.includes(quote.Status)) {
                    component.set("v.quoteValidationMessage", "Cotação com status igual a "+quote.Status+" não permite gerar proposta.");
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
                // Toast de sucesso
                $A.get("e.force:showToast").setParams({
                    title: "Sucesso",
                    message: "PDF salvo com sucesso!",
                    type: "success",
                    mode: "dismissible"
                }).fire();

                // Reaproveita o método de fechar o modal
                $A.get("e.force:closeQuickAction").fire();

            } else {
                // Toast de erro
                const errors = response.getError();
                const message = errors && errors[0] && errors[0].message ? errors[0].message : "Erro ao salvar PDF";
    
                $A.get("e.force:showToast").setParams({
                    title: "Erro",
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
    
                // Botão Salvar
                const saveBtn = document.createElement("button");
                saveBtn.className = "slds-button slds-button_brand";
                saveBtn.innerText = "Salvar";
                saveBtn.onclick = function () {
                    component.get("c.handleSave").run(); // invoca método Aura
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