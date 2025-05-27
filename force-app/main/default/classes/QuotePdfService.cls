/**
 * @description       : 
 * @author            : aydhan.passos
 * @group             : 
 * @last modified on  : 05-16-2025
 * @last modified by  : eduardo.teixeira
**/
public with sharing class QuotePdfService {
    
    @AuraEnabled(cacheable=true)
    public static Quote getOpportunityType(Id quoteId) {
        List<Quote> quotes = [
            SELECT Id, Name, Status, OpportunityId, Opportunity.RecordType.DeveloperName,
            Opportunity.SyncedQuoteId, Opportunity.SyncedQuote.IsSyncing, IsSyncing
            FROM Quote
            WHERE Id = :quoteId
            LIMIT 1
        ];
        
        if (quotes.isEmpty()) {
            throw new AuraHandledException('Quote não encontrada com o ID informado.');
        }
    
        return quotes.get(0);
    }

    @AuraEnabled
    public static void savePdfVersion(Id quoteId) {

        // Determina qual VF usar dinamicamente
        Quote proposta = getOpportunityType(quoteId);

        // 2. Determina a página VF correta
        PageReference pdfPage;
        if (proposta.Opportunity.RecordType.DeveloperName == 'Crossborder') {
            pdfPage = Page.PropostaCross;
        } else {
            pdfPage = Page.PropostaNacional;
        }
        pdfPage.getParameters().put('id', quoteId);
        Blob pdfBlob = pdfPage.getContentAsPDF();

        // 3. Buscar a maior versão existente vinculada à Quote
        List<ContentDocumentLink> existingLinks = [
            SELECT ContentDocument.Title
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :quoteId ORDER BY SystemModstamp DESC LIMIT 1
        ];

        Integer latestVersion = 0;
        Integer nextVersion = 0;

        if (existingLinks.isEmpty()) {
            nextVersion = 1;
        } else {
            String title = existingLinks.get(0).ContentDocument.Title;
            if (title != null && title.contains('_V')) {
                try {
                    String versionStr = title.substringAfter('_V').replace('.pdf', '');
                    latestVersion = Integer.valueOf(versionStr);
                } catch (Exception e) {
                    // Ignorar arquivos com nome fora do padrão
                }
            }
            nextVersion = latestVersion + 1;
        }
       
        // 4. Monta nome do arquivo
        String baseName = proposta.Name != null ? proposta.Name : 'Quote';
        String fileName = 'proposta_' + baseName + '_V' + nextVersion ;

        // OBS: ContentVersion = moderno, QuoteDocument = legado, ambos criam o link automático(contentDocumentLink)

        // // 5. Cria ContentVersion com link automático à Quote
        // ContentVersion cv = new ContentVersion(
        //     Title = fileName,
        //     PathOnClient = fileName,
        //     VersionData = pdfBlob,
        //     FirstPublishLocationId = quoteId
        // );
        // insert cv;

        // 6. Cria QuoteDocument (legado, aparece na "Quote PDFs")
        QuoteDocument qd = new QuoteDocument();
        qd.QuoteId = quoteId;
        qd.Document = pdfBlob;
        insert qd;

        // Atualiza o campo Acceptable__c da respectiva Quote para true
        Quote quoteToUpdate = new Quote(Id = quoteId, Acceptable__c = true);
        update quoteToUpdate;

        // 7. Cria link do mesmo arquivo para a Opportunity
        if (proposta.OpportunityId != null) {
            List<ContentDocumentLink> cdLinks = [
                SELECT ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :quoteId 
                ORDER BY SystemModstamp DESC 
                LIMIT 1
            ];

            if (!cdLinks.isEmpty()) {
                ContentDocumentLink oppLink = new ContentDocumentLink(
                    ContentDocumentId = cdLinks[0].ContentDocumentId,
                    LinkedEntityId = proposta.OpportunityId,
                    ShareType = 'V',
                    Visibility = 'AllUsers'
                );
                insert oppLink;
            }
        }

        // 8. Atualiza estágio da oportunidade (código existente)
        if (proposta.OpportunityId != null) {
            Opportunity opp = new Opportunity(Id = proposta.Opportunity.Id, StageName = 'Negotiation');
            update opp;
        }
    }
}