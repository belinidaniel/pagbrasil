public class DeletePricebookEntry {

    public void deleteEntries() {
        // Define o ID do usuário criador dos registros
        Id userId = '005VA000005FWL1YAO';

        // Query para buscar os PricebookEntry com base no criador do registro
        List<PricebookEntry> pricebookEntriesToDelete = [SELECT Id FROM PricebookEntry WHERE CreatedById = :userId];

        // Verifica se há registros a serem deletados
        if (!pricebookEntriesToDelete.isEmpty()) {
            // Deleta os registros encontrados
            delete pricebookEntriesToDelete;
        }
    }
}