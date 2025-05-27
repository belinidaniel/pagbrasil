public with sharing class HomologationFormApprovalHandler {
    
    @AuraEnabled
    public static void sendApprovalHomologationForm(Id opportunityId) {

        System.debug('opportunityId: ' + opportunityId);

        Opportunity opp = [
            SELECT Id, Name
            FROM Opportunity
            WHERE Id = :opportunityId
        ];

        List<HomologationForm__c> forms = [
            SELECT Id, Name, Legal_Approval_Status__c
            FROM HomologationForm__c
            WHERE Opportunity__c = :opp.Id
        ];

        System.debug('forms: ' + forms);

        if (forms.isEmpty()) return;
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();

        String linhasTabela = '';
        for (HomologationForm__c form : forms) {
            String link = baseUrl + '/' + form.Id;
            form.Legal_Approval_Status__c = 'Approval Requested';
            linhasTabela += '<tr>' +
                            '<li><a href="' + link + '">' + form.Name + '</a></li>' +
                            '<td>' + (form.Legal_Approval_Status__c == 'Aprovado' ? 'Aprovado' : 'Pendente') + '</td>' +
                            '</tr>';
        }

        update forms;

        for (HomologationForm__c form : forms) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(form.Id);
            req.setSkipEntryCriteria(false);
            Approval.ProcessResult result = Approval.process(req);
            
            System.debug('Approval submitted for Form: ' + form.Name + ', result: ' + result.isSuccess());
        }

        String corpoEmail = '<html><body style="font-family: Arial, sans-serif; color: #333;">' +
            '<p>Olá,</p>' +
            '<p>Os <strong>formulários vinculados à oportunidade <span style="color:#2a7ae2;">"' + opp.Name + '"</span></strong> foram enviados para aprovação.</p>' +
            '<table cellpadding="8" cellspacing="0" border="0" style="border-collapse: collapse; width: 100%; background-color: #f9f9f9; margin-top: 16px;">' +
            '<thead><tr style="background-color: #eaeaea;">' +
            '<th align="left">Nome do Formulário</th><th align="left">Status</th>' +
            '</tr></thead><tbody>' + linhasTabela + '</tbody></table>' +
            '<p style="margin-top: 20px;">Favor revisar e aprovar diretamente no Salesforce.</p>' +
            '<p>Atenciosamente,<br>Sistema de Aprovação</p></body></html>';

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { 'gustavo.pias@srconsulting.io' });
        email.setSubject('Formulários enviados para aprovação - ' + opp.Name);
        email.setHtmlBody(corpoEmail);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

    }
}