public class TestDataFactory {

    public static Lead createAndInsertLeadNB() {
        Lead leadNB = new Lead(
            LastName = 'Apex NB Test',
            Company = 'company nb',
            Phone = '123456789',
            MobilePhone = '234567890',
            Email = 'apexnbtest@srconsulting.io',
            LeadSource = 'Outras publicidades',
            Status = 'Pre prospection',
            RecordTypeId = getLeadRecordTypeIdByName('National'),
            AtendimentoWhatsApp__c = 'Não',
            DataAgendamento__c = Date.newInstance(2025, 8, 22),
            LinkedInContato__c = 'linkedin.com/in/apexnbtest',
            LinkedIn__c = 'companylkd',
            Mensagem__c = 'msg',
            NotaReclameAqui__c = 5,
            Receita_Mensal__c = 'Até R$50k',
            Segmento__c = 'Acessórios',
            SeguidoresInstagram__c = 1001,
            TeseProspeccao__c = 'thesis',
            Descricao_Empresa__c = 'detailed description',
            Product_or_service_website_URL__c = 'apexnbteste.com.br',
            Ag_ncia__c = 'agency nb',
            Operacao__c = 'Inbound',
            Data_de_indicacao__c = Date.newInstance(2025, 8, 22),
            cf_email_indicador__c = 'apexnbtest@srconsulting.io',
            previs_fat_rs__c = 100,
            PSP__c = 'psp',
            Pais__c = 'Brazil',
            Boleto_Share__c = 1,
            Cartao_Credito_Mensal__c = 1,
            PixMensal__c = 1,
            Lead_Area__c = 'Diretoria',
            AverageSalesTicket__c = 100,
            Business_Model_Type__c = 'B2B',
            CNPJ__c = '72784626000147',
            Cartao_Debito_Mensal__c = 1,
            City__c = 'Congonhas',
            Desired_Business_Model__c = 'Intermediation',
            Product_Type__c = 'Physical',
            Recurring_Payments__c = 'Sim',
            State__c = 'SP',
            TPV_Potencial__c = 100,
            Use_Apple_Pay__c = true,
            Use_Google_Pay__c = true,
            Use_One_Click_Pix__c = true,
            Use_Pagshield_Premium__c = false,
            Use_Pagshield_Premium_on_Demand__c = false,
            Use_Pagshield__c = false,
            Use_Pagstream__c = true,
            Use_Payout__c = true,
            Contact_City__c = 'contactcity',
            Integration_Type__c = 'JS',
            Payment_Methods__c = 'Pix',
            Product_Category__c = '5122'
        );
        insert leadNB;
        return leadNB;
    }

    public static Lead createAndInsertLeadXB() {
        Lead leadXB = new Lead(
            LastName = 'Apex XB Test',
            Company = 'company xb',
            Phone = '234567890',
            MobilePhone = '098765432',
            Email = 'apexxbtest@srconsulting.io',
            LeadSource = 'Social | LinkedIn',
            Status = 'Pre prospection',
            RecordTypeId = getLeadRecordTypeIdByName('Cross-border'),
            AtendimentoWhatsApp__c = 'Não',
            DataAgendamento__c = Date.newInstance(2025, 8, 22),
            LinkedInContato__c = 'linkedin.com/in/apexnbtest',
            LinkedIn__c = 'companylkdxb',
            Mensagem__c = 'msg xb',
            NotaReclameAqui__c = 4,
            Receita_Mensal__c = 'Acima de R$1M',
            Segmento__c = 'Cosméticos',
            SeguidoresInstagram__c = 1000001,
            TeseProspeccao__c = 'thesis xb',
            Descricao_Empresa__c = 'detailed xb description',
            Product_or_service_website_URL__c = 'apexxbteste.com.br',
            Ag_ncia__c = 'agency xb',
            Operacao__c = 'Outbound',
            Data_de_indicacao__c = Date.newInstance(2025, 8, 22),
            cf_email_indicador__c = 'apexxbtest@srconsulting.io',
            previs_fat_rs__c = 200,
            PSP__c = 'psp',
            Pais__c = 'United States of America',
            Boleto_Share__c = 2,
            Cartao_Credito_Mensal__c = 2,
            PixMensal__c = 2,
            Lead_Area__c = 'Comercial',
            AverageSalesTicket__c = 200,
            Business_Model_Type__c = 'B2B2C',
            City__c = 'New York',
            Desired_Business_Model__c = 'Intermediation',
            Product_Type__c = 'Digital',
            Recurring_Payments__c = 'Não',
            State__c = 'New York',
            TPV_Potencial__c = 200,
            Use_Apple_Pay__c = false,
            Use_Google_Pay__c = false,
            Use_One_Click_Pix__c = false,
            Use_Pagshield_Premium__c = false,
            Use_Pagshield_Premium_on_Demand__c = false,
            Use_Pagshield__c = false,
            Use_Pagstream__c = false,
            Use_Payout__c = false,
            VAT__c = '793198392345673',
            Integration_Type__c = 'Vtex',
            Payment_Methods__c = 'Cartão de Crédito',
            Product_Category__c = '5122'
        );
        insert leadXB;
        return leadXB;
    }

    public static Id getLeadRecordTypeIdByName(String recordTypeName) {
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Lead.getRecordTypeInfosByName();

        if (recordTypeMap.containsKey(recordTypeName)) {
            return recordTypeMap.get(recordTypeName).getRecordTypeId();
        } else {
            throw new RecordTypeNotFoundException('RecordType "' + recordTypeName + '" não encontrado para Lead.');
        }
    }

    public class RecordTypeNotFoundException extends Exception {}
}