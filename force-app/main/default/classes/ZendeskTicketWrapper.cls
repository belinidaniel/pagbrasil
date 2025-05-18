/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-02-28
 * @last modified by  : Hersilio Belini de Oliveira
**/
public class ZendeskTicketWrapper {

    private static final String GROUP_ID = ZendeskConfig__c.getInstance().GroupId__c;
    private static final String AUTHOR_ID = ZendeskConfig__c.getInstance().AuthorId__c;

    public Ticket ticket { get; set; }

    public ZendeskTicketWrapper(Opportunity opp, List<String> uploads, TicketCheck tickectCheck, String organizationId) {
        this.ticket = new ticket();

        Contact contact = ContactSelector.getContactPrincipalByAccountId(opp.AccountId);

        if(String.isBlank(organizationId)){
            throw new AuraHandledException('Required Organization Id not found');
        }

        this.ticket.subject = getSubject(opp);
        this.ticket.organization_id = Decimal.valueOf(organizationId);
        this.ticket.priority = opp.Priority__c == 'P0' ? 'high' : opp.Priority__c == 'P1' ? 'normal' : 'low';
        this.ticket.group_id = GROUP_ID;
        this.ticket.comment.uploads = uploads;
        this.ticket.comment.body = getDescription(opp, tickectCheck, contact);
        this.ticket.comment.author_id = AUTHOR_ID;
        this.ticket.comment.publicComment = false;

        // if(contact != null){
        //     this.ticket.requester.name = contact.Name;
        //     this.ticket.requester.email = contact.Email;
        // }
    }

    private String getSubject(Opportunity opp) {
        return 'Solicitaçãode Go-Live - ' + opp.Priority__c;
    }

    private String getDescription(Opportunity opp, TicketCheck check, Contact contact) {
        String subject = 'Prezados, \n\n';
        subject += 'Solicito autorização para Go-live da conta, conforme arquivos que se encontram na pasta do cliente: ' + opp.Account.Name + '.\n\n';
        subject += '- A conta é no modelo ' + getFomatedBusinessModel(opp.BusinessModel__c) + '\n';
        subject += '- Prioridade: ' + opp.Priority__c + (opp.Priority__c == 'P2' && opp.DateAccountCreation__c != null ? ' / Data de criação da conta: ' + getFormatedDate(opp.DateAccountCreation__c) : '') + '\n\n';

        subject += 'Pontos pendentes Customer Service:\n';
        subject += '- Conferência ativação do PagShield: ' + (check.pagShieldActivationCheck ? 'SIM' : 'NÃO') + ' \n';
        subject += '- Formas de pagamento no rodapé: ' + (check.paymentMethodsInFooter ? 'SIM' : 'NÃO') + ' \n';
        subject += '- Inserção de logotipo no Boleto: ' + (check.logoInsertionInBoleto ? 'SIM' : 'NÃO') + ' \n';
        subject += '- Solicitação de manual de Identidade Visual em PDF com os vetores ou logo da marca em PDF, TIFF ou SVG: ' + (check.visualIdentityManualRequest ? 'SIM' : 'NÃO') + ' \n';
        subject += '- Reclame Aqui: ' + (check.reclameAqui ? 'SIM' : 'NÃO') + ' \n\n';

        subject += 'Pontos pendentes Customer Success: \n';
        subject += '- Envio do e-mail de boas-vindas + link dos treinamentos: ' + (check.welcomeEmailAndTrainingLinks ? 'SIM / ' + check.triggerIndication : 'NÃO') + ' \n\n';

        subject += 'Informações Adicionais:\n';
        subject += contact != null ? '- Nome de contato para Customer Success: ' + contact.Name + '\n\n' : '';
        subject += contact != null ? '- E-mail de contato para Customer Success: ' + contact.Email + '\n\n' : '';
        subject += '- POD\'s: ' + (check.pods ? 'SIM / Plugins: ' + opp.IntegrationType__c : 'NÃO');
        return subject;
    }

    public class Ticket {
        public Ticket(){
            this.comment = new Comment();
            // this.requester = new Requester();
        }

        public String subject;
        public String group_id;
        public String priority;
        public Comment comment;
        public Decimal organization_id;
        // public Requester requester;
    }

    public class Comment {
        public String body;
        public String author_id;
        public List<String> uploads;
        public Boolean publicComment;
    }

    // public class Requester {
    //     public String name;
    //     public String email;
    // }

    public class TicketCheck {
        public Boolean pagShieldActivationCheck;
        public Boolean paymentMethodsInFooter;
        public Boolean logoInsertionInBoleto;
        public Boolean reclameAqui;
        public Boolean pods;
        public Boolean visualIdentityManualRequest;
        public Boolean welcomeEmailAndTrainingLinks;
        public String triggerIndication;
    }

    private String getFormatedDate(Date dateInput){
        if(dateInput == null){
            return '';
        }

        String day = String.valueOf(dateInput.day());

        String month = String.valueOf(dateInput.month());

        return (day.length() == 1 ? '0':'' ) + day + '/' +
                (month.length() == 1 ? '0':'' ) + month + '/' +
                String.valueOf(dateInput.year());
    }

    private String getFomatedBusinessModel(String businessModel){
        return businessModel.replace(';', ' e ')
            .replace('Intermediation', '"Intermediação"')
            .replace('Gateway', '"Gateway"');
    }
}