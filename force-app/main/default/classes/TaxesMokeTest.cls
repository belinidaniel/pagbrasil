/**
 * @description       : 
 * @author            : Daniel Belini
 * @group             : 
 * @last modified on  : 08-08-2025
 * @last modified by  : Daniel Belini
**/
@istest
public with sharing class TaxesMokeTest {
    @isTest static void testCreateAllPricebooksProductsEntries() {
        // Pricebooks
        // Garante o ID do Pricebook padrão em ambiente de teste
        Id standardPbId = Test.getStandardPricebookId();

        // Cria os Pricebooks customizados
        List<Pricebook2> pricebooks = new List<Pricebook2>{
            new Pricebook2(Name = 'Preços - Intermediação', IsActive = true, BusinessModel__c = 'Intermediation'),
            new Pricebook2(Name = 'Preços - Gateway', IsActive = true, BusinessModel__c = 'Gateway'),
            new Pricebook2(Name = 'Preços - Intermediação + Gateway', IsActive = true, BusinessModel__c = 'Intermediation;Gateway'),
            new Pricebook2(Name = 'Preços - Intermediação Cross', IsActive = true, IsCrossBoard__c = true, BusinessModel__c = 'Intermediation')
        };
        insert pricebooks;

        // Products
        List<Product2> products = new List<Product2>{
            new Product2(Name = 'Taxas de processamento', ProductCode = 'TAXA_PROCESSAMENTO', IsActive = true, Family = 'TaxasProcessamento'),
            new Product2(Name = 'Taxa da Solução PagBrasil', ProductCode = 'TAXA_PAGBRASIL', IsActive = true, Family = 'TaxasSolucaoPagBrasil', Flexibility__c = true),
            new Product2(Name = 'Taxa adicional de parcelamento: 2 a 6 parcelas', ProductCode = 'TAXA_PARC_2A6', IsActive = true, Family = 'TaxasProcessamento'),
            new Product2(Name = 'Taxa adicional de parcelamento: 7 a 12 parcelas', ProductCode = 'TAXA_PARC_7A12', IsActive = true, Family = 'TaxasProcessamento'),
            new Product2(Name = 'Taxa de Processamento Gateway', ProductCode = 'TAXA_PROCESS_GATEWAY', IsActive = true, Family = 'TaxasProcessamento', Flexibility__c = true),
            new Product2(Name = 'Taxa adicional de tokenização', ProductCode = 'TAXA_TOKENIZACAO', IsActive = true, Family = 'TaxasProcessamento'),
            new Product2(Name = 'Taxa base de antecipação', ProductCode = 'TAXA_ANTECIPACAO', IsActive = true, Family = 'TaxaAntecipacaoCredito', Flexibility__c = true),
            new Product2(Name = 'Taxa de Instalação', ProductCode = 'TAXA_INSTALACAO', IsActive = true, Family = 'CustosOperacionais', Flexibility__c = true),
            new Product2(Name = 'Taxa Mínima de Manutenção', ProductCode = 'TAXA_MIN_MANUTENCAO', IsActive = true, Family = 'CustosOperacionais', Flexibility__c = true),
            new Product2(Name = 'Taxa de Integração Cartão de Crédito', ProductCode = 'TAXA_INT_CARTAO', IsActive = true, Family = 'CustosOperacionais'),
            new Product2(Name = 'Taxa de Encerramento da Conta do Estabelecimento', ProductCode = 'TAXA_ENCERRAMENTO', IsActive = true, Family = 'CustosOperacionais', Flexibility__c = true),
            new Product2(Name = 'Valor Mínimo para Repasse', ProductCode = 'VALOR_MIN_REPASSE', IsActive = true, Family = 'TermosRepasse'),
            new Product2(Name = 'Taxa de Transferência', ProductCode = 'TAXA_TRANSFERENCIA', IsActive = true, Family = 'TermosRepasse'),
            new Product2(Name = 'Reserva Giratória', ProductCode = 'RESERVA_GIRATORIA', IsActive = true, Family = 'ReservaGiratoria', Flexibility__c = true),
            new Product2(Name = 'Taxa de Reembolso via adquirinte ou PIX', ProductCode = 'TAXA_REEMBOLSO_PIX', IsActive = true, Family = 'CustoDevolucaoEstorno'),
            new Product2(Name = 'Taxa Reembolso via transferência bancária', ProductCode = 'TAXA_REEMBOLSO_TRANSF', IsActive = true, Family = 'CustoDevolucaoEstorno'),
            new Product2(Name = 'Taxa de Chargeback', ProductCode = 'TAXA_CHARGEBACK', IsActive = true, Family = 'CustoDevolucaoEstorno'),
            new Product2(Name = 'Taxa adicional de excesso de Chargebacks para transação com Cartão', ProductCode = 'TAXA_EXCESSO_CHARGEBACK', IsActive = true, Family = 'CustoDevolucaoEstorno'),
            new Product2(Name = 'Pacote 500 SMS', ProductCode = 'PACOTE_500_SMS', IsActive = true, Family = 'ServicosOpcionais'),
            new Product2(Name = 'Pacote 1000 SMS', ProductCode = 'PACOTE_1000_SMS', IsActive = true, Family = 'ServicosOpcionais'),
            new Product2(Name = 'Pacote 10000 SMS', ProductCode = 'PACOTE_10000_SMS', IsActive = true, Family = 'ServicosOpcionais'),
            new Product2(Name = 'Pacote 1000 e-mails', ProductCode = 'PACOTE_1000_EMAILS', IsActive = true, Family = 'ServicosOpcionais'),
            new Product2(Name = 'Pacote 10000 e-mails', ProductCode = 'PACOTE_10000_EMAILS', IsActive = true, Family = 'ServicosOpcionais'),
            new Product2(Name = 'Pacote 100000 e-mails', ProductCode = 'PACOTE_100000_EMAILS', IsActive = true, Family = 'ServicosOpcionais'),
            new Product2(Name = 'Solução de carteira digital', ProductCode = 'SOLUCAO_CARTEIRA_DIGITAL', IsActive = true, Family = 'ServicosOpcionais', Flexibility__c = true),
            new Product2(Name = 'Custo Pagshield por transação', ProductCode = 'CUSTO_PAGSHIELD', IsActive = true, Family = 'PagShield'),
            new Product2(Name = 'Taxa fixa PagShield Premium', ProductCode = 'TAXA_FIX_PAGSHIELD', IsActive = true, Family = 'PagShield', Flexibility__c = true),
            new Product2(Name = 'Taxa variável PagShield Premium', ProductCode = 'TAXA_VAR_PAGSHIELD', IsActive = true, Family = 'PagShield', Flexibility__c = true),
            new Product2(Name = 'Taxa PagStream', ProductCode = 'TAXA_PAGSTREAM', IsActive = true, Family = 'PagStream', Flexibility__c = true),
            new Product2(Name = 'Taxa mínima de manutenção do PagStream', ProductCode = 'TAXA_MIN_PAGSTREAM', IsActive = true, Family = 'PagStream'),
            new Product2(Name = 'Taxa de transferência para fornecedores', ProductCode = 'TAXA_TRANSFER_FORNEC', IsActive = true, Family = 'Payout', Flexibility__c = true),
            new Product2(Name = 'Taxa de Serviço de Payout', ProductCode = 'TAXA_PAYOUT', IsActive = true, Family = 'Payout', Flexibility__c = true)
        };
        insert products;

        // Reconsulta os produtos criados no teste para garantir que os IDs estejam corretos
        Set<String> testProductCodes = new Set<String>();
        for (Product2 p : products) {
            if (p.ProductCode != null) testProductCodes.add(p.ProductCode);
        }
        List<Product2> insertedProducts = [SELECT Id, Name, ProductCode FROM Product2 WHERE IsActive = true AND ProductCode IN :testProductCodes];

        // PricebookEntry padrão para cada produto
        List<PricebookEntry> standardEntries = new List<PricebookEntry>();
        for (Product2 prod : insertedProducts) {
            standardEntries.add(new PricebookEntry(Pricebook2Id = standardPbId, Product2Id = prod.Id, UnitPrice = 1, IsActive = true, UseStandardPrice = false));
        }
        insert standardEntries;

        // PricebookEntries customizados
        List<PricebookEntry> entries = new List<PricebookEntry>();
        for (Pricebook2 pb : pricebooks) {
            for (Product2 prod : insertedProducts) {
                entries.add(new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 1, IsActive = true, UseStandardPrice = false));
            }
        }
        insert entries;
    }
}