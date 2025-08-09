@RestResource(urlMapping='/integration/file-xb/*')
global without sharing class FileXBService {
	@HttpGet
	global static String getFiles() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

		try {
			String requestURI = req.requestURI;
			String[] uriParts = requestURI.split('/');
			String kycUuid = uriParts[uriParts.size() - 1];

			KYC_XB__c kycRecord = [SELECT Id FROM KYC_XB__c WHERE Unique_Link__c = :kycUuid LIMIT 1];
			String kycId = String.valueOf(kycRecord.Id);
			System.debug(kycId);
			List<ContentDocumentLink> files = [
				SELECT 
					Id, 
					ContentDocumentId, 
					ContentDocument.Title, 
					ContentDocument.FileType, 
					ContentDocument.LatestPublishedVersion.CreatedDate, 
					ContentDocument.LatestPublishedVersion.PathOnClient,
					ContentDocument.LatestPublishedVersion.VersionData
				FROM 
					ContentDocumentLink 
				WHERE 
					LinkedEntityId = :kycId
			];

			List<FileDTO> dtoList = new List<FileDTO>();

			for(ContentDocumentLink cdl : files){
				dtoList.add(new FileDTO(cdl));
			}

			res.statusCode = 200;
			return JSON.serialize(dtoList);
			
		} catch (Exception e) {
			res.statusCode = 500;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'An unexpected error occurred: ' + e.getMessage() });
		}
	}
    
	@HttpDelete
	global static String deleteFile() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;

		try {
			String requestURI = req.requestURI;
			String[] uriParts = requestURI.split('/');
			String fileId = uriParts[uriParts.size() - 1];
			System.debug('file id: ' + fileId);
			ContentDocument docToDelete = [SELECT Id FROM ContentDocument WHERE Id = :fileId LIMIT 1];
            System.debug('doc to delete: ');
            System.debug(docToDelete);
			delete docToDelete;

			res.statusCode = 200;
			return JSON.serialize(new Map<String, Object>{
				'message' => 'File deleted successfully',
				'deletedDocumentId' => fileId
			});
		} catch (QueryException qe) {
			res.statusCode = 404;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'QueryException: ' + qe.getMessage() });
		} catch (Exception e) {
			res.statusCode = 500;
			return JSON.serialize(new Map<String, Object>{ 'error' => 'An unexpected error occurred: ' + e.getMessage() });
		}
	}

	public class FileDTO {
		public String id;
		public String documentId;
		public String title;
		public String fileType;
		public String createdDate;
		public String pathOnClient;

		public FileDTO(ContentDocumentLink cdl) {
			this.id = cdl.Id;
			this.documentId = cdl.ContentDocumentId;
			this.title = cdl.ContentDocument.Title;
			this.fileType = cdl.ContentDocument.FileType;
			this.createdDate = String.valueOf(cdl.ContentDocument.LatestPublishedVersion.CreatedDate);
			this.pathOnClient = cdl.ContentDocument.LatestPublishedVersion.PathOnClient;
		}
	}
}