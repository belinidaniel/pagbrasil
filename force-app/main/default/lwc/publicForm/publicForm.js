import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getOpportunityDetails from '@salesforce/apex/PublicFormController.getOpportunityDetails';
import saveFormData from '@salesforce/apex/PublicFormController.saveFormData';
import criarContato from '@salesforce/apex/PublicFormController.criarContato';
import companyLogo from '@salesforce/resourceUrl/Logo2';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadImage from '@salesforce/apex/PublicFormController.uploadImage';
import getHomologationForm from '@salesforce/apex/PublicFormController.getHomologationForm';


export default class PublicForm extends LightningElement {
    @track opportunity;
    @track accountId = '';
    @track isLoading = false;
    @track showTextInputs = false;
    @track showEvidencePODInput = false;
    @track showErrorDelivery = false;
    @track showErrorTaxe = false;
    @track IntegrationJSorAPI = false;
    @track IntegrationShopifyOrPBCheckout = false;
    @track PhysicalProductType = false;
    @track industryDropshipping = false;
    @track SolucaoPagBrasil = false;
    @track showJurosMensal = false;
    @track tenhoInteresseDesconto = true; 
    @track haveGateway = false;
    @track haveCielo = false;
    @track haveERede = false;
    @track haveReclameAqui = false;
    @track haveStone = false;
    @track errorMessage = '';
    @track selectedYesNo = '';
    @track Login = '';
    @track Senha = '';
    @track textInputTerminalID = '';
    @track textInputRegKey = '';
    @track selectedCheckboxesCompany = [];
    @track linkOrImageCompany = '';
    @track selectedCheckboxesContact = [];
    @track linkOrImageContact = '';
    @track checkboxResponseTime = false;
    @track linkOrImageResponseTime = '';
    @track checkboxPricingFormat = false;
    @track linkOrImagePricingFormat = '';
    @track linkOrImageInfoVerification = '';
    @track linkOrImageReclameAqui = '';
    @track selectedCheckboxesDeliveryTime = [];
    @track selectedCheckboxesCustoms = [];
    @track CheckboxCEPVerification = false;
    @track CheckboxInfosVerification = false;
    @track checkboxPagBrasilSolution = false;
    @track selectedPodOption = [];
    @track selectedParcelas = '';
    @track selectedrepasseJuros = '';
    @track podManagerEmails = '';
    @track checkboxSemInteresseDesconto;
    @track contactCount = 0;
    @track contacts = [];
    @track evidencePOD = '';
    @track linkMap = {};
    @track contactFields = {
        FirstName: '',
        LastName: '',
        Email: '',
        idioma: '',
        nivelAcesso: '',
    };
    @track jurosMensal = '';
    @track descontoShopify= '';
    @track boletoFlash= '';
    @track pagBrasilPix= '';
    @track descontoPBCheckout= '';
    @track checkboxCielo = false;
    @track merchantId= '';
    @track merchantKey= '';
    @track checkboxERede = false;
    @track PV= '';
    @track token= '';
    @track checkboxStone = false;
    @track MIDMerchantId= ''; 
    @track soliciteiReclameAqui= false;
    @track fileMap= {};
    @track fieldLabels = {};
    @track textContent = {};
    @track isCrossborder = false;
    
    file;
    fileName;
    logoUrl = companyLogo;

    @wire(CurrentPageReference)
    pageRef;



    
    ParcelasOptions = [
        { label: '2', value: '2' },
        { label: '3', value: '3' },
        { label: '4', value: '4' },
        { label: '5', value: '5' },
        { label: '6', value: '6' },
        { label: '7', value: '7' },
        { label: '8', value: '8' },
        { label: '9', value: '9' },
        { label: '10', value: '10' },
        { label: '11', value: '11' },
        { label: '12', value: '12' }
    ];

    optionsConfig = {
        yesNoOptions: {
            National: [
                { label: 'Sim', value: 'true' },
                { label: 'Não', value: 'false' }
            ],
            Crossborder: [
                { label: 'Yes', value: 'true' },
                { label: 'No', value: 'false' }
            ]
        },
        interesseOptions: {
            National: [
                { label: 'Sim, tenho interesse', value: 'false' },
                { label: 'Não, não tenho interesse', value: 'true' }
            ],
            Crossborder: [
                { label: 'Yes, interested', value: 'false' },
                { label: 'No, not interested', value: 'true' }
            ]
        },
        
        repasseJurosOptions: {
            National: [
                { label: 'Automático', value: 'Automático' },
                { label: 'Manual', value: 'Manual' }
            ],
            Crossborder: [
                { label: 'Automatic', value: 'Automático' },
                { label: 'Manual', value: 'Manual' }
            ]
        },
        checkboxOptionsCompany: {
            National: [
                { label: 'Rodapé do site', value: 'Rodapé do site' },
                { label: 'Página “sobre nós” ou similar', value: 'Página sobre nós ou similar' }
            ],
            Crossborder: [
                { label: 'Website footer', value: 'Rodapé do site' },
                { label: '“About us” page or similar', value: 'Página sobre nós ou similar' }
            ]
        },
        checkboxOptionsContact: {
            National: [
                { label: 'Formulário de contato e/ou endereço de e-mail.', value: 'Formulário de contato e/ou endereço de e-mail' },
                { label: 'Número de telefone brasileiro para contato.', value: 'Número de telefone brasileiro para contato' }
            ],
            Crossborder: [
                { label: 'Contact form and/or email address.', value: 'Formulário de contato e/ou endereço de e-mail' },
                { label: 'Brazilian contact phone number.', value: 'Número de telefone brasileiro para contato' }            
            ]
        },
        podOptions: {
            National: [
                { label: 'Ainda não fiz envios para o Brasil', value: 'Ainda não fiz envios para o Brasil' },
                { label: 'Já faço envios para o Brasil', value: 'Já faço envios para o Brasil' }
            ],
            Crossborder: [
                { label: 'I have not shipped to Brazil yet.', value: 'Ainda não fiz envios para o Brasil' },
                { label: 'I already ship to Brazil.', value: 'Já faço envios para o Brasil' }            
            ]
        },
        checkboxOptionsDeliveryTime: {
            National: [
                { label: 'O prazo de entrega é calculado na página de checkout antes de concluir o pagamento.', value: 'O prazo de entrega é calculado na página de checkout antes de concluir o pagamento' },
                { label: 'O tempo médio de entrega é mostrado na página Termos e Condições, Política de Entrega ou FAQ.', value: 'O tempo médio de entrega é mostrado na página Termos e Condições, Política de Entrega ou FAQ' },
                { label: 'O prazo de entrega é informado no e-mail de confirmação do pedido.', value: 'O prazo de entrega é informado no e-mail de confirmação do pedido' }        
            ],
            Crossborder: [
                { label: 'The delivery time is calculated on the checkout page before completing the payment.', value: 'O prazo de entrega é calculado na página de checkout antes de concluir o pagamento' },
                { label: 'The average delivery time is shown on the Terms and Conditions, Delivery Policy, or FAQ page.', value: 'O tempo médio de entrega é mostrado na página Termos e Condições, Política de Entrega ou FAQ' },
                { label: 'The delivery time is informed in the order confirmation email.', value: 'O prazo de entrega é informado no e-mail de confirmação do pedido' }            
            ]
        },
        checkboxOptionsCustoms: {
            National: [
                { label: 'O aviso de que impostos podem ser cobrados está na página de checkout antes de finalizar o pagamento.', value: 'O aviso de que impostos podem ser cobrados está na página de checkout antes de finalizar o pagamento'},
                { label: 'O aviso de que impostos podem ser cobrados está na página Termos e Condições, Política de Entrega ou FAQ. ', value: 'O aviso de que impostos podem ser cobrados está na página Termos e Condições, Política de Entrega ou FAQ'},
                { label: 'O aviso de que impostos podem ser cobrados está no e-mail de confirmação do pedido. ', value: 'O aviso de que impostos podem ser cobrados está no e-mail de confirmação do pedido'}
            ],
            Crossborder: [
                { label: 'The notice that taxes may apply is on the checkout page before completing the payment.', value: 'O aviso de que impostos podem ser cobrados está na página de checkout antes de finalizar o pagamento' },
                { label: 'The notice that taxes may apply is on the Terms and Conditions, Delivery Policy, or FAQ page.', value: 'O aviso de que impostos podem ser cobrados está na página Termos e Condições, Política de Entrega ou FAQ' },
                { label: 'The notice that taxes may apply is in the order confirmation email.', value: 'O aviso de que impostos podem ser cobrados está no e-mail de confirmação do pedido' }            
            ]
        },
        nivelAcessoOptions: {
            National: [
                { label: 'Administrador Completo', value: 'Usuário Completo' },
                { label: 'Restrito', value: 'Usuário Restrito' },
                { label: 'Somente Visualização', value: 'Usuário Visualização' }
            ],
            Crossborder: [
                { label: 'Full Admin', value: 'Usuário Completo' },
                { label: 'Restricted Access', value: 'Usuário Restrito' },
                { label: 'View Only', value: 'Usuário Visualização' }
            ]
        },
        idiomaOptions: {
            National: [
                { label: 'Português', value: 'Português' },
                { label: 'Inglês', value: 'Inglês' }
            ],
            Crossborder: [
                { label: 'Portuguese', value: 'Português' },
                { label: 'English', value: 'Inglês' }
            ]
        },
      
    };
     
    fieldLabelConfig = {
        Password__c: {
            National: 'Insira a senha',
            Crossborder: 'Enter Password'
        },
        Login__c: {
            National: 'Insira o Login',
            Crossborder: 'Enter Login'
        },
        CompanyDetails__c: {
            National: 'Detalhes da empresa: informe os dados da sua empresa (razão social, CNPJ e endereço com cidade e país) em um dos seguintes locais:',
            Crossborder: 'Company details: enter your company details (corporate name, Tax ID and address with city and country) in one of the following locations:'
        },
        EvidenceCompanyDetails__c: {
            National: 'Evidências da Empresa',
            Crossborder: 'Company Evidence'
        },
        ContactInformation__c: {
            National: 'Informações de contato: certifique-se de que sua página de contato inclua ao menos uma das seguintes opções:',
            Crossborder: 'Contact information: Make sure your contact page includes at least one of the following:'
        },
        EvidenceContactInformation__c: {
            National: 'Evidências de Contato',
            Crossborder: 'Contact evidence'
        },
        RequirementResponseTime__c: {
            National: 'Exigência Cumprida',
            Crossborder: 'Requirement Fulfilled'
        },
        EvidenceResponseTime__c: {
            National: 'Evidências de Tempo de Resposta',
            Crossborder: 'Response Time Evidence'
        },
        EvidencePriceFormat__c: {
            National: 'Evidências do Formato de Preços',
            Crossborder: 'Evidence of the Pricing Format'
        },
        DeliveryTime__c: {
            National: 'Prazo de entrega: informe claramente o prazo médio de entrega (porta-a-porta). A informação deve estar em pelo menos duas das opções abaixo:',
            Crossborder: 'Delivery time: clearly inform the average delivery time (door-to-door). This information must be provided in at least two of the following options: '
        },
        EvidenceDeliveryTime__c: {
            National: 'Evidências do Prazo de Entrega',
            Crossborder: 'Evidence of Delivery Time'
        },
        ShippingProofPod__c: {
            National: 'Comprovante de envio (POD): assim que o produto for enviado, você precisará enviar ao cliente final um e-mail de confirmação incluindo o número de rastreamento: ',
            Crossborder: 'Proof of Delivery (POD): once the product is shipped you will need to send the end customer a confirmation email including the tracking number: '
        },
        EvidenceShippingProofPod__c: {
            National: 'Evidências de Comprovante de Envio',
            Crossborder: 'Evidence of Proof of Shipping'
        },
        EmailsPodManager__c: {
            National: 'E-mail(s) Gerente de POD:  ',
            Crossborder: 'POD Manager Email(s):  '
        },
        CustomsFee__c: {
            National: 'A informação deve estar em pelo menos duas das opções abaixo:',
            Crossborder: 'The information must be in at least two of the options below:'
        },
        EvidenceCustomsFee__c: {
            National: 'Evidências da Taxa Alfandegária',
            Crossborder: 'Customs Duty Evidence'
        },
        EvidenceZipCodeValidator__c: {
            National: 'Evidências',
            Crossborder: 'Evidences'
        },
        PagBrasilSolutionForTransferringFee__c: {
            National: 'Ativar a solução da PagBrasil para transferir a taxa de antecipação para o cliente final:',
            Crossborder: 'Activate the PagBrasil solution to transfer the advance fee to the end customer:'
        },
        MinimumInstallmentsForInterest__c: {
            National: 'Quantidade mínima de parcelas para acrescentar os juros ao valor: ',
            Crossborder: 'Minimum number of installments to add interest to the amount: '
        },
        InterestRepassMethodToCustomer__c: {
            National: 'Selecione',
            Crossborder: 'Select'
        },
        MonthlyInterestOnCustomerInstallments__c: {
            National: 'Juros mensal de Parcelamento ao Cliente final: ',
            Crossborder: 'Monthly installment interest for the end customer: '
        },
        NotInterestedInOfferingDiscount__c: {
            National: 'Tem interesse em oferecer desconto por método de pagamento?',
            Crossborder: 'Are you interested in offering a discount by payment method?'
        },
        ShopifyDiscount__c: {
            National: 'Desconto Shopify: ',
            Crossborder: 'Shopify Discount: '
        },
        FlashBoleto__c: {
            National: 'Boleto Flash®: ',
            Crossborder: 'Flash® Ticket: '
        },
        PbCheckoutDiscount__c: {
            National: 'Desconto PB Checkout: ',
            Crossborder: 'PB Checkout Discount: '
        },
        AlreadyRequestedReclameAqui__c: {
            National: 'Já tenho uma conta ou já solicitei a criação de uma conta:',
            Crossborder: 'I already have an account or have already requested to create an account:'
        },
        nameField: {
            National: 'Nome',
            Crossborder: 'Name'
        },
        lastNameField: {
            National: 'Sobrenome',
            Crossborder: 'Last Name'
        },
        languageField: {
            National: 'Idioma',
            Crossborder: 'Language'
        },
        accessLevelField: {
            National: 'Nível de Acesso',
            Crossborder: 'Access Level'
        },
        SalesProcess__c: {
            Crossborder: 'Please describe your sales process here, including how the end customer completes the payment'
        },
        ReimbursementPolicy__c: {
            Crossborder: 'Please describe here the reimbursement policies, including details on the process, such as eligibility criteria, required steps, and expected timelines. '
        }
    };

    translations = {
        National: {
            firstTopic: '⮟ Informações da Loja',
            secondTopic: '⮟ Informações de Entrega',
            thirdTopic: '⮟ Validadores e Recursos',
            fourthTopic: '⮟ Gateway',
            fiveTopic: '⮟ Reclame Aqui',
            sixTopic: '⮟ Usuários',
            oppName: 'Oportunidade:',
            oppValue: 'Valor:',
            oppCloseDate: 'Data de Fechamento:',
            responseTimeTitle: 'Tempo de resposta: ',
            responseTimeText: 'informações sobre prazos para e-mails e horários de atendimento para suporte telefônico.',
            priceFormatTitle: 'Formato dos preços: ',
            priceFormatText: 'todos os preços devem estar em reais com o formato R$ XX,XX(com vírgula como separador, por exemplo R$ 29,90 ou R$ 1.400,00).',
            errorMsgTwoOptions: 'Selecione pelo menos duas opções.',
            contactPod: 'Contato POD',
            customsFeeTitle: 'Taxa alfandegária: ',
            customsFeeFirstText: 'para produtos importados, informar claramente se os impostos são pré-pagos ou não. Se você opera com produtos físicos, adicione o seguinte texto em português sobre impostos de importação: ',
            customsFeeSecondText: '“Os envios para o Brasil poderão estar sujeitos à taxação alfandegária. A cobrança será de responsabilidade do comprador”. ',
            addressValidatorTitle: 'Verificação de endereço e validador de CEP: ',
            addressValidatorText: 'Garanta que os campos de endereço no seu checkout sejam obrigatórios e que uma ferramenta de validação de CEP esteja ativa.',
            fieldsAndValidatorTitle: 'Campos e validadores de e-mail, telefone celular¹ e CPF: ',
            fieldsAndValidatorText: 'Recomendamos que os campos de endereço de e-mail, celular, CPF/CNPJ² sejam obrigatórios e que você use uma ferramenta de validação.',
            configTaxTitle: 'Configuração de repasse de taxa de antecipação de cartão de crédito: ',
            configTaxText: 'A PagBrasil oferece a opção de repasse automático da taxa de antecipação ao cliente. Você poderá configurar o número máximo de parcelas disponíveis para seu cliente final no checkout, o valor mínimo por parcela, a quantidade mínima de parcelas para acrescentar taxa ao valor e a taxa a ser acrescentada³. ',
            finalClientTitle: 'Como serão repassados os juros ao cliente final?',
            automaticTitle: 'Automático: ',
            automaticText: 'Juros de antecipação repassados integralmente',
            manualTitle: 'Manual: ',
            manualText: 'Juros de parcelamento ao cliente final definidos',
            paymentMethodTitle: 'Desconto por método de pagamento: ',
            paymentMethodText: 'A PagBrasil oferece uma ferramenta que permite conceder desconto por método de pagamento ao cliente final. Se você estiver interessado em oferecer desconto por método de pagamento, preencha o percentual abaixo. ',
            reclameAquiText: 'O “Reclame Aqui” é uma plataforma onde brasileiros discutem e dão opiniões sobre negócios de todos os tipos, incluindo e-commerce. É nela que boa parte dos clientes irá buscar referências sobre a sua empresa, com a intenção de entender se é confiável e segura. Portanto, é muito importante que você tenha registro no “Reclame Aqui” e acompanhe cada comentário adicionado.  Além disso, é fundamental que você responda a todas as avaliações, pois uma má reputação nesta plataforma pode trazer um grande impacto negativo para o seu negócio. ',
            registerText: 'Para realizar o seu cadastro no site Reclame Aqui, ',
            openLinkText: 'abra este link!',
            defineUsersText: 'Defina os Usuários que poderão acessar o Dashboard da PagBrasil conforme as restrições de acesso abaixo definidas:',
            completeUserText: 'Usuário Completo',
            restrictUserText: 'Usuário Restrito',
            visualizationUserText: 'Usuário Visualização',
            consultOrderText: 'Consultar Pedidos',
            refundText: 'Realizar Reembolsos',
            viewReportText: 'Visualizar relatórios de Conciliação',
            accessTabText: 'Acessar a aba ',
            resourceText: 'Recursos',
            configTabText: 'Alterar Configurações globais na aba ',
            accText: 'Conta',
            createUserText: 'Criar Usuário',
            placeholderText: 'Insira aqui links',
            imagesText: 'Clique aqui para enviar imagens',
            passwordText: 'Existe uma senha para acessar o checkout?',
            selectText: 'Selecione',
            sendLabel: 'Enviar',
        },
        Crossborder: {
            firstTopic: '⮟ Store Information',
            secondTopic: '⮟ Delivery Information',
            thirdTopic: '⮟ Validators and Resources',
            fourthTopic: '⮟ Tell us more about your sales process',
            fiveTopic: '⮟ Reclame Aqui',
            sixTopic: '⮟ Users',
            oppName: 'Opportunity:',
            oppValue: 'Value:',
            oppCloseDate: 'Close Date:',
            responseTimeTitle: 'Response Time: ',
            responseTimeText: 'Information about email response times and business hours for phone support.',
            priceFormatTitle: 'Price Format: ',
            priceFormatText: 'All prices must be in Brazilian real (BRL) using the format R$ XX,XX (with a comma as the separator, e.g., R$ 29,90 or R$ 1.400,00).',
            errorMsgTwoOptions: 'Select at least two options.',
            contactPOD: 'POD Contact',
            customsFeeTitle: 'Customs duties: ',
            customsFeeFirstText: 'clearly specify whether taxes are pre-paid or not. If you operate with physical goods, please include the following text in Portuguese regarding import taxes and custom duties:',
            customsFeeSecondText: '“Os envios para o Brasil poderão estar sujeitos à taxação alfandegária. A cobrança será de responsabilidade do comprador”.',
            addressValidatorTitle: 'Address check & ZIP code validation: ',
            addressValidatorText: 'Ensure that the address fields in your checkout process are mandatory, and that a ZIP code validation tool is enabled.',
            fieldsAndValidatorTitle: 'Email address, mobile number1, and CPF (tax ID) fields and validators: ',
            fieldsAndValidatorText: 'We recommend that the email, phone number, and CPF/CNPJ fields be requires, and that a validation tool be implemented to verify the information.',
            configTaxTitle: 'Credit Card Anticipation Fee Configuration: ',
            configTaxText: 'PagBrasil offers the option to automatically transfer the anticipation fee to the end customer. You can configure the following parameter at checkout: (i.) the maximum number of installments available to your end customer, (ii.) the minimum amount per installment, (iii.) the minimum number of installments required to apply a fee, and (iv.) the fee to be added to the amount.',
            finalClientTitle: 'How will the interest be passed to the final customer?',
            automaticTitle: 'Automatic: ',
            automaticText: 'Advance interest fully passed on',
            manualTitle: 'Manual: ',
            manualText: 'Installment interest defined for the final customer',
            paymentMethodTitle: 'Discount by Payment Method: ',
            paymentMethodText: 'PagBrasil offers a tool that enables you to provide discounts to the end customer based on the payment method. If you wish to offer payment method discounts, please specify the percentage below.',
            reclameAquiText: '“Reclame Aqui” is a platform that allows Brazilian users to post complaints about products and services offered by various companies, as well as share opinions and experiences related to businesses, including e-commerce. It functions similarly to Trustpilot, helping customers assess the trustworthiness and reliability of a company. You must register your business on “Reclame Aqui” and actively monitor all comments received. It is essential to check the platform daily and respond to all reviews. A negative reputation on Reclame Aqui can significantly affect your business.',
            registerText: 'To register on the Reclame Aqui website, ',
            openLinkText: 'open this link!',
            defineUsersText: 'Define the Users who will have access to the PagBrasil Dashboard according to the access restrictions defined below:',
            completeUserText: 'Complete User',
            restrictUserText: 'Restricted User',
            visualizationUserText: 'View-Only User',
            consultOrderText: 'Consult Orders',
            refundText: 'Process Refunds',
            viewReportText: 'View Reconciliation Reports',
            accessTabText: 'Access the tab ',
            resourceText: 'Resources',
            configTabText: 'Change Global Settings in the tab ',
            accText: 'Account',
            createUserText: 'Create User',
            placeholderText: 'Insert links here',
            imagesText: 'Click here to insert images',
            passwordText: 'Is there a password to access the checkout?',
            selectText: 'Select',
            sendLabel: 'Send',
            describeSalesText: 'Describe the sales process in detail (from the first contact until the product or service is delivered or made available): ',
            exampleText: 'Ex: End customer access website, selects a product, and completes the payment.',
            storeReceiveText: 'The store receives the order and sends a confirmation email to the end customer. ',
            storePrepareText: 'The store prepares and ships the product. ',
            storeNotifyText: 'The store notifies the end customer via email once the product has been shipped. ',
            reimbursementPolicyTitle: 'Reimbursement policy:',
            reimbursementPolicyText: ' Describe your company´s policy regarding refunds when the end customer requests a reimbursement. ',
        }        
    };




    connectedCallback() {
        this._getOpportunityIdFromPageReference();
    }

    _getOpportunityIdFromPageReference() {
        if (this.pageRef?.state?.opportunityId) {
            const opportunityId = this.pageRef.state.opportunityId;
            this._fetchOpportunityDetails(opportunityId);
        } else {
            this.errorMessage = 'O ID da Oportunidade não foi encontrado na URL.';
        }
    }

    _fetchOpportunityDetails(opportunityId) {
        getOpportunityDetails({ opportunityId })
            .then((result) => {
                this.opportunity = result;
                this.accountId = this.opportunity?.AccountId;

                

                const businessModel = this.opportunity?.BusinessModel__c;
                const valueBusinessModel = ['Gateway'];

                const recordTypeName = this.opportunity.RecordType.DeveloperName;

                this.isCrossborder = recordTypeName === 'Crossborder';
                this._updateFieldLabels(recordTypeName);
                this._updateOptions(recordTypeName);
                this.textContent = this.translations[recordTypeName];

                this.haveGateway = valueBusinessModel.includes(businessModel);

                const integrationValue = this.opportunity?.IntegrationType__c;
                const valuesJSorAPI = ['JS', 'API','Salesforce'];
                const valuesShopifyOrPBCheckout = ['PB Checkout','Shopify','Salesforce'];

                this.IntegrationJSorAPI = valuesJSorAPI.includes(integrationValue);
                this.IntegrationShopifyOrPBCheckout = valuesShopifyOrPBCheckout.includes(integrationValue);
                
                if (this.opportunity?.Product_Type__c === "Physical" ){
                    this.PhysicalProductType = true;
                }
                if (this.opportunity?.Segmento__c === "Dropshipping") {
                    this.industryDropshipping = true;
                }

            return getHomologationForm({ opportunityId });
            })
            .then((form) => {
                if (form) {
                    this.homologationFormId = form.Id;
                    console.log('📌 HomologationForm__c encontrado:', this.homologationFormId);
                } else {
                    console.warn('⚠️ Nenhum HomologationForm__c encontrado.');
                }
            })
            .catch((error) => {
                this.errorMessage = `Erro ao buscar os detalhes da oportunidade: ${error.body.message}`;
                this.IntegrationJSorAPI = false;
                this.IntegrationShopifyOrPBCheckout = false;
            });
    }
    _updateFieldLabels(recordTypeName) {
        Object.keys(this.fieldLabelConfig).forEach((field) => {
            this.fieldLabels[field] =
                this.fieldLabelConfig[field][recordTypeName] || 'Texto Padrão';
        });
    }

    _updateOptions(recordTypeName) {
        Object.keys(this.optionsConfig).forEach((optionKey) => {
            const config = this.optionsConfig[optionKey];
            this[optionKey] = config[recordTypeName] || config.default;
        });
    }

    handleYesNoChange(event) {
        this.selectedYesNo = event.detail.value;
        this.showTextInputs = this.selectedYesNo === 'true';
    }

    handleStoneChange(event) {
        this.checkboxStone = event.detail.value;
        if (this.checkboxStone === 'true') {
            this.haveStone = true;
            this.handleInputChange(event);
        } else {
            this.handleInputChange(event);
            this.haveStone = false;
        }
    }
    handleCieloChange(event) {
        this.checkboxCielo = event.detail.value;
        if (this.checkboxCielo === 'true') {
            this.haveSCielo = true;
            this.handleInputChange(event);
        } else {
            this.handleInputChange(event);
            this.haveSCielo = false;
        }
    }
    handleERedeChange(event) {
        this.checkboxERede = event.detail.value;
        if (this.checkboxERede === 'true') {
            this.haveERede = true;
            this.handleInputChange(event);
        } else {
            this.handleInputChange(event);
            this.haveERede = false;
        }
    }
    
    handleSolucaoPagBrasil(event) {
        this.checkboxPagBrasilSolution = event.detail.value;
        if (this.checkboxPagBrasilSolution === 'true') {
            this.SolucaoPagBrasil = true;
            this.handleInputChange(event);
        } else {
            this.handleInputChange(event);
            this.SolucaoPagBrasil = false;
        }
    }

    handleInteresseDescontoChange(event) {
        this.checkboxSemInteresseDesconto = event.detail.value;
        if (this.checkboxSemInteresseDesconto === 'false') {
            this.tenhoInteresseDesconto = true;
            this.handleInputChange(event);
        } else {
            this.handleInputChange(event);
            this.tenhoInteresseDesconto = false;
        }
    }

    handleEnviosPODChange(event) {
        this.handleCheckboxChange(event);
        this.selectedPodOption = event.detail.value;
        if(this.selectedPodOption === 'Já faço envios para o Brasil'){
            this.showEvidencePODInput = true;
        } else {
            this.showEvidencePODInput = false;
        }
    }

    handleContactCountChange(event) {
        this.contactCount = parseInt(event.target.value, 10);
        this.generateContactFields();
    }

    handleOptionsFeesChange(event) {
        this.selectedrepasseJuros = event.detail.value;

        if(this.selectedrepasseJuros === 'Manual'){
            this.handleCheckboxChange(event);
            this.showJurosMensal = true;
        } else {
            this.showJurosMensal = false;
            this.handleCheckboxChange(event);

        }
    }

    handleOptionsDeliveryChange(event) {
        this.selectedCheckboxesDeliveryTime = event.detail.value;
        
        if (this.selectedCheckboxesDeliveryTime.length < 2) {
            this.showErrorDelivery = true;
        } else {
            this.handleCheckboxChange(event);
            this.showErrorDelivery = false;
        }

    }

    handleOptionsTaxes(event) {
        this.selectedCheckboxesCustoms = event.detail.value;
        
        if (this.selectedCheckboxesCustoms.length < 2) {
            this.showErrorTaxe = true;
        } else {
            this.handleCheckboxChange(event);
            this.showErrorTaxe = false;
        }
    }

    handleInputChange(event) {
        const field = event.target.name; 
        const value = event.detail ? event.detail.value : event.target.value;

        this[field] = value === 'true' ? true : value === 'false' ? false : value;
        console.log(this[field]);
    }
    handleInputContactChange(event) {
        const fieldName = event.target.dataset.id;
        this.contactFields[fieldName] = event.target.value;
    }


    handleCreateContact() {
        const contactData = {
            ...this.contactFields,
            AccountId: this.accountId,
            
        };

        criarContato({ contactData })
            .then(() => {
                this.showToast('Sucesso', 'Contato criado com sucesso!', 'success');
                this.clearContactFields();
            })
            .catch((error) => {
                this.showToast('Erro', error.body.message, 'error');
            });
    }
    
    handleCheckboxChange(event) {
        const field = event.target.name; 
        this[field] = event.detail.value;

        console.log(this[field]);
    }

    

    handleUniqueCheckboxChange(event) {
        const field = event.target.name; 
        this[field] = event.target.checked;
    }


    handleLinkChange(event) {
        const field = event.target.dataset.field;
        const linkValue = event.target.value;
    
        if (!this.linkMap) {
            this.linkMap = {}; 
        }
    
        this.linkMap[field] = linkValue;
    
        console.log('linkMap atualizado:', JSON.stringify(this.linkMap));
    }

    handleFileChange(event) {
        const field = event.target.dataset.field;
        if (!field) {
            console.error('Campo não definido no handleFileChange.');
            this.showToast('Erro', 'Campo não definido. Verifique o input.', 'error');
            return;
        }

        const file = event.target.files[0];
        if (file && file.size < 5 * 1024 * 1024 && file.type.startsWith('image/')) {
            this.readFileAsBase64(file).then((base64Data) => {
                uploadImage({ base64Image: base64Data.split(',')[1], fileName: file.name, recordId: this.homologationFormId })
                    .then((publicUrl) => {
                        this.fileMap[field] = publicUrl; 
                        this.showToast('Sucesso', 'Imagem enviada com sucesso!', 'success');
                    })
                    .catch((error) => {
                        this.showToast('Erro', 'Erro ao fazer upload da imagem', 'error');
                    });
            });
        } else {
            this.showToast('Erro', 'Arquivo inválido. Apenas imagens menores que 5MB são permitidas.', 'error');
        }
    }


    handleSuccess(event) {
        const contactId = event.detail.id;
        this.showToast('Sucesso', `Contato criado com sucesso!`, 'success');
    }

    handleError(event) {
        const errorMessage = event.detail.message;
        this.showToast('Erro', `Erro ao criar o contato: ${errorMessage}`, 'error');
    }
    

    handleSubmit() {
        this.isLoading = true;
        const formData = this.collectFormData();
        saveFormData({ formDataJson: JSON.stringify(formData) })
            .then(() => {
                this.showToast('Sucesso', 'Dados salvos com sucesso!', 'success');
                this.isLoading = false;
            })
            .catch((error) => {
                this.showToast('Erro', `Erro ao salvar: ${error.body.message}`, 'error');
                this.isLoading = false;

            });
    }

    readFileAsBase64(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result);
            reader.onerror = (error) => reject(error);
            reader.readAsDataURL(file);
        });
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(toastEvent);
    }

    clearContactFields() {
        this.contactFields = {
            FirstName: '',
            LastName: '',
            nivelAcesso: '',
            idioma: '',
        };
    }




    collectFormData() {
        const formData = {};

        this.template.querySelectorAll('lightning-input, lightning-combobox, lightning-checkbox-group').forEach((input) => {
            const field = input.name || input.dataset.field;
    
            if (input.type === 'checkbox-group') {
                formData[field] = Array.isArray(input.value) ? input.value.join(',') : input.value;
            } else if (input.type === 'checkbox') {
                formData[field] = input.checked ? 'true' : 'false';
            } else {
                formData[field] = input.value;
            }
        });


        formData.Account__c = this.accountId ? this.accountId : '';
        formData.Opportunity__c = this.opportunity && this.opportunity.Id ? this.opportunity.Id : '';

        console.log('fileMap:', this.fileMap);
        console.log('linkMap:', this.linkMap);

        formData.linkMap = this.linkMap || {};
        formData.fileMap = this.fileMap || {};
    
        console.log('FormData:', JSON.stringify(formData));

        return formData;
    }

    get cardTitle() {
        if (this.opportunity) {
            const recordTypeName = this.opportunity?.RecordType?.DeveloperName;
    
            if (recordTypeName === 'Crossborder') {
                return `Homologation Form for: ${this.opportunity.Name}`;
            } else {
                return `Formulário de Homologação de: ${this.opportunity.Name}`;
            }
        }
    
        return 'Formulário de Homologação';
    }    

}