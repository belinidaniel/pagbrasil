// Script to test the sendIntegration method in CreateTicketMethod
// Run this in Salesforce Developer Console -> Debug -> Open Execute Anonymous Window

// Replace these values with actual data from your org
Id opportunityId = '006XXXXXXXXXXXXXXX'; // Replace with actual Opportunity ID
String organizationId = 'your_organization_id'; // Replace with actual Organization ID
String priority = 'High'; // Options: High, Medium, Low
Date accountCreationDate = Date.today().addDays(-30); // Example: 30 days ago

// Create the FlowInputs object
CreateTicketMethod.FlowInputs input = new CreateTicketMethod.FlowInputs();
input.idOpportunity = opportunityId;
input.organizationId = organizationId;
input.priority = priority;
input.dataCreateAccount = accountCreationDate;

// Set the boolean flags for ticket checks
input.pagShieldActivationCheck = true;
input.paymentMethodsInFooter = true;
input.logoInsertionInBoleto = false;
input.reclameAqui = true;
input.pods = true;
input.visualIdentityManualRequest = false;
input.welcomeEmailAndTrainingLinks = true;
input.triggerIndication = 'Manual Test';

try {
    System.debug('Starting sendIntegration test...');
    System.debug('Opportunity ID: ' + opportunityId);
    System.debug('Organization ID: ' + organizationId);
    System.debug('Priority: ' + priority);
    
    // Call the sendIntegration method
    CreateTicketMethod.sendIntegration(input);
    
    System.debug('sendIntegration completed successfully!');
    
} catch (Exception e) {
    System.debug('Error occurred: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
