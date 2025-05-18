/**
 * @description       : 
 * @author            : aydhan.passos
 * @group             : 
 * @last modified on  : 04-10-2025
 * @last modified by  : aydhan.passos
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
        String fileName = baseName + '_V' + nextVersion ;

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
        // qd.Name = fileName;
        List<QuoteDocument> oldDocs = [SELECT Id From QuoteDocument WHERE QuoteId = :quoteID];
        if(!oldDocs.isEmpty()){
          delete oldDocs;
        }
        insert qd;

        // 7. Atualiza estágio da oportunidade, se necessário
        if (proposta.OpportunityId != null) {
            Opportunity opp = new Opportunity(Id = proposta.Opportunity.Id, StageName = 'Negotiation');
            update opp;
        }
    }
}