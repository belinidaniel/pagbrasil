({
    init : function (component) {

        if(component.get('v.exitFlow'))
            $A.get("e.force:closeQuickAction").fire();

        let flow = component.find("flowData");
        let inputVariables = [
            {
                    name: "recordId",
                    type: "String",
                    value: component.get('v.recordId')
            }
        ]

        flow.startFlow("RCC_Form",inputVariables);
    }
})