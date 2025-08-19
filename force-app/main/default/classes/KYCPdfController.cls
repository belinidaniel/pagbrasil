public with sharing class KYCPdfController {
    public KYC__c kyc { get; set; }
    public List<FileWrapper> files { get; set; }
    public List<Contact> relatedContacts { get; set; }
    public List<Contact> ownerContacts { get; set; }
    public List<Contact> representativeContacts { get; set; }
    public List<Contact> contractContacts { get; set; }
    public List<Contact> billingContacts { get; set; }
    public List<Contact> technicalContacts { get; set; }
    public List<Contact> supportContacts { get; set; }
    public List<Contact> channelContacts { get; set; }
    public List<Contact> refundContacts { get; set; }
    public Contact personalContact { get; set; }
	public List<FileWrapper> cpfFiles { get; set; }
	public List<FileWrapper> addressPartnersFiles { get; set; }
	public List<FileWrapper> cnpjFiles { get; set; }
	public List<FileWrapper> addressFiles { get; set; }
	public List<FileWrapper> secFiles { get; set; }
	public List<FileWrapper> conFiles { get; set; }
	public List<FileWrapper> repFiles { get; set; }
    public Boolean hasCpfFiles { get { return cpfFiles != null && !cpfFiles.isEmpty(); } }
	public Boolean hasAddressPartnersFiles { get { return addressPartnersFiles != null && !addressPartnersFiles.isEmpty(); } }
	public Boolean hasCnpjFiles { get { return cnpjFiles != null && !cnpjFiles.isEmpty(); } }
	public Boolean hasAddressFiles { get { return addressFiles != null && !addressFiles.isEmpty(); } }
	public Boolean hasSecFiles { get { return secFiles != null && !secFiles.isEmpty(); } }
	public Boolean hasConFiles { get { return conFiles != null && !conFiles.isEmpty(); } }
	public Boolean hasRepFiles { get { return repFiles != null && !repFiles.isEmpty(); } }

    public KYCPdfController() {
        Id recordId = ApexPages.currentPage().getParameters().get('id');

        if (recordId != null) {
            Schema.DescribeSObjectResult objDescribe = KYC__c.SObjectType.getDescribe();
            List<String> fieldNames = new List<String>(objDescribe.fields.getMap().keySet());
            String query = 'SELECT ' + String.join(fieldNames, ',') + ' FROM KYC__c WHERE Id = :recordId LIMIT 1';
            kyc = Database.query(query);
            
            Schema.DescribeSObjectResult contactDescribe = Contact.SObjectType.getDescribe();
	        List<String> contactFields = new List<String>(contactDescribe.fields.getMap().keySet());
                
			String wordQuery = 'personal';
			String personalQuery = 'SELECT ' 
                                        + String.join(contactFields, ',') 
                    					+ ' FROM Contact WHERE Related_KYC__c = :recordId AND KYC_Role__c = :wordQuery LIMIT 1';
			personalContact = Database.query(personalQuery);
			System.debug(personalContact);
                
			wordQuery = 'owner';
			String ownerQuery = 'SELECT ' 
                    				+ String.join(contactFields, ',') 
                    				+ ' FROM Contact WHERE Related_KYC__c = :recordId AND KYC_Role__c = :wordQuery'
                    				+ ' ORDER BY KYC_Role__c';
			ownerContacts = Database.query(ownerQuery);
                
			wordQuery = 'representative';
			String representativeQuery = 'SELECT ' 
                                            + String.join(contactFields, ',') 
                                            + ' FROM Contact WHERE Related_KYC__c = :recordId AND KYC_Role__c = :wordQuery'
                                            + ' ORDER BY KYC_Role__c';
			representativeContacts = Database.query(representativeQuery);

			wordQuery = 'contract';
			String contractQuery = 'SELECT ' 
                                        + String.join(contactFields, ',') 
                                        + ' FROM Contact WHERE Related_KYC__c = :recordId AND KYC_Role__c = :wordQuery'
                                        + ' ORDER BY KYC_Role__c';
			contractContacts = Database.query(contractQuery);

			wordQuery = 'billing';
			String billingQuery = 'SELECT ' 
                                        + String.join(contactFields, ',') 
                                        + ' FROM Contact WHERE Related_KYC__c = :recordId AND KYC_Role__c = :wordQuery'
                                        + ' ORDER BY KYC_Role__c';
			billingContacts = Database.query(billingQuery);

			wordQuery = 'technical';
			String technicalQuery = 'SELECT ' 
                                        + String.join(contactFields, ',') 
                                        + ' FROM Contact WHERE Related_KYC__c = :recordId AND KYC_Role__c = :wordQuery'
                                        + ' ORDER BY KYC_Role__c';
			technicalContacts = Database.query(technicalQuery);

			wordQuery = 'support';
			String supportQuery = 'SELECT ' 
                                        + String.join(contactFields, ',') 
                                        + ' FROM Contact WHERE Related_KYC__c = :recordId AND KYC_Role__c = :wordQuery'
                                        + ' ORDER BY KYC_Role__c';
			supportContacts = Database.query(supportQuery);

			wordQuery = 'channel';
			String channelQuery = 'SELECT ' 
                                        + String.join(contactFields, ',') 
                                        + ' FROM Contact WHERE Related_KYC__c = :recordId AND KYC_Role__c = :wordQuery'
                                        + ' ORDER BY KYC_Role__c';
			channelContacts = Database.query(channelQuery);

			wordQuery = 'refund';
			String refundQuery = 'SELECT ' 
                                        + String.join(contactFields, ',') 
                                        + ' FROM Contact WHERE Related_KYC__c = :recordId AND KYC_Role__c = :wordQuery'
                                        + ' ORDER BY KYC_Role__c';
			refundContacts = Database.query(refundQuery);

            files = new List<FileWrapper>();
    		cpfFiles = new List<FileWrapper>();
    		addressPartnersFiles = new List<FileWrapper>();
    		cnpjFiles = new List<FileWrapper>();
    		addressFiles = new List<FileWrapper>();
    		secFiles = new List<FileWrapper>();
    		conFiles = new List<FileWrapper>();
    		repFiles = new List<FileWrapper>();
 
            List<ContentDocumentLink> links = [
                SELECT ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :recordId
            ];

            if (!links.isEmpty()) {
                Set<Id> documentIds = new Set<Id>();
                for (ContentDocumentLink link : links) {
                    documentIds.add(link.ContentDocumentId);
                }

                List<ContentVersion> versions = [
                    SELECT Title, VersionDataUrl 
                    FROM ContentVersion 
                    WHERE ContentDocumentId IN :documentIds 
                    AND IsLatest = TRUE
                ];

		        for (ContentVersion version : versions) {
        		    FileWrapper file = new FileWrapper(version.Title, version.VersionDataUrl);
            		files.add(file);

        		    if (file.fileName.startsWith('cpf')) {
                		cpfFiles.add(file);
	            	} else if (file.fileName.startsWith('address_partners')) {
    	            	addressPartnersFiles.add(file);
        	    	} else if (file.fileName.startsWith('taxId')) {
            		    cnpjFiles.add(file);
        	    	} else if (file.fileName.startsWith('address') && !file.fileName.startsWith('address_partners')) {
    	            	addressFiles.add(file);
	            	} else if (file.fileName.startsWith('sec')) {
        		        secFiles.add(file);
		            } else if (file.fileName.startsWith('con')) {
        		        conFiles.add(file);
		            } else if (file.fileName.startsWith('rep')) {
                		repFiles.add(file);
        		    }
		        }
            }
        }
    }

    public class FileWrapper {
        public String fileName { get; set; }
        public String fileUrl { get; set; }

        public FileWrapper(String fileName, String fileUrl) {
            this.fileName = fileName;
            this.fileUrl = fileUrl;
        }
    }

	public static ContentVersion generateAndSavePdf(Id recordId) {
		PageReference pdfPage = Page.KYCPdfRenderPage;
		pdfPage.getParameters().put('id', recordId);

		Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContent();

		ContentVersion version = new ContentVersion();
		version.Title = 'KYC PDF - ' + recordId;
		version.PathOnClient = 'KYC_Document.pdf';
		version.VersionData = pdfBlob;
		version.IsMajorVersion = true;
		insert version;

		ContentDocumentLink link = new ContentDocumentLink();
		link.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id].ContentDocumentId;
		link.LinkedEntityId = recordId;
		link.ShareType = 'V';
		link.Visibility = 'AllUsers';
		insert link;

		return version;
	}

	public void generatePdf() {
		Id recordId = ApexPages.currentPage().getParameters().get('id');

		if (recordId != null) {
			generateAndSavePdf(recordId);
		}
	}
}