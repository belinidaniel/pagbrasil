public class KYCXBPdfController {
    public KYC_XB__c kycXB { get; set; }
    public List<FileWrapper> files { get; set; }
    
    public List<Contact> relatedContacts { get; set; }
    public List<Contact> ownerContacts { get; set; }
    public List<Contact> representativeContacts { get; set; }
    public List<Contact> contractContacts { get; set; }
    public List<Contact> invoiceContacts { get; set; }
    public List<Contact> technicalContacts { get; set; }
    public List<Contact> emergencyContacts { get; set; }
    public List<Contact> channelContacts { get; set; }
    public List<Contact> refundContacts { get; set; }
    public List<Contact> politicalContacts { get; set; }
    public List<Contact> supportContacts { get; set; }
    public Contact personalContact { get; set; }
    
    public List<FileWrapper> cpfFiles { get; set; }
    public List<FileWrapper> addressPartnersFiles { get; set; }
    public List<FileWrapper> cnpjFiles { get; set; }
    public List<FileWrapper> addressFiles { get; set; }
    public List<FileWrapper> secFiles { get; set; }
    public List<FileWrapper> conFiles { get; set; }
    public List<FileWrapper> repFiles { get; set; }
    public List<FileWrapper> bankFiles { get; set; }
    
    public Boolean hasCpfFiles { get { return !cpfFiles.isEmpty(); } }
    public Boolean hasAddressPartnersFiles { get { return !addressPartnersFiles.isEmpty(); } }
    public Boolean hasCnpjFiles { get { return !cnpjFiles.isEmpty(); } }
    public Boolean hasAddressFiles { get { return !addressFiles.isEmpty(); } }
    public Boolean hasSecFiles { get { return !secFiles.isEmpty(); } }
    public Boolean hasConFiles { get { return !conFiles.isEmpty(); } }
    public Boolean hasRepFiles { get { return !repFiles.isEmpty(); } }
    public Boolean hasBankFiles { get { return !bankFiles.isEmpty(); } }
    
    
    public class ShareholderWrapper {
        public Integer index { get; set; }
        public Contact contact { get; set; }
        
        public ShareholderWrapper(Integer index, Contact contact) {
            this.index = index;
            this.contact = contact;
        }
    }
    
    public class RepresentativeWrapper {
        public Integer index { get; set; }
        public Contact contact { get; set; }
        
        public RepresentativeWrapper(Integer index, Contact contact) {
            this.index = index;
            this.contact = contact;
        }
    }
    
    public List<RepresentativeWrapper> wrappedRepresentatives { get; set; }
    public Map<Integer, Map<Integer, List<FileWrapper>>> repFileMapByIndexAndType { get; set; }
    public List<ShareholderWrapper> wrappedShareholders { get; set; }
    public Map<Integer, Map<Integer, List<FileWrapper>>> shFileMapByIndexAndType { get; set; }
    
    public KYCXBPdfController() {
        Id recordId = ApexPages.currentPage().getParameters().get('id');
        
        if (recordId != null) {
            Schema.DescribeSObjectResult objDescribe = KYC_XB__c.SObjectType.getDescribe();
            List<String> fieldNames = new List<String>(objDescribe.fields.getMap().keySet());
            String query = 'SELECT ' + String.join(fieldNames, ',') + ' FROM KYC_XB__c WHERE Id = :recordId LIMIT 1';
            kycXB = Database.query(query);
            
            Schema.DescribeSObjectResult contactDescribe = Contact.SObjectType.getDescribe();
            List<String> contactFields = new List<String>(contactDescribe.fields.getMap().keySet());
            
            personalContact = queryContact(recordId, 'personal', contactFields);
            ownerContacts = queryContacts(recordId, 'owner', contactFields);
            representativeContacts = queryContacts(recordId, 'representative', contactFields);
            contractContacts = queryContacts(recordId, 'contract', contactFields);
            invoiceContacts = queryContacts(recordId, 'invoice', contactFields);
            technicalContacts = queryContacts(recordId, 'technical', contactFields);
            emergencyContacts = queryContacts(recordId, 'emergency', contactFields);
            channelContacts = queryContacts(recordId, 'channel', contactFields);
            refundContacts = queryContacts(recordId, 'refund', contactFields);
            politicalContacts = queryContacts(recordId, 'political', contactFields);
            supportContacts = queryContacts(recordId, 'support', contactFields);
            
            files = new List<FileWrapper>();
            cpfFiles = new List<FileWrapper>();
            addressPartnersFiles = new List<FileWrapper>();
            cnpjFiles = new List<FileWrapper>();
            addressFiles = new List<FileWrapper>();
            secFiles = new List<FileWrapper>();
            conFiles = new List<FileWrapper>();
            repFiles = new List<FileWrapper>();
            bankFiles = new List<FileWrapper>();
            
            wrappedShareholders = new List<ShareholderWrapper>();
            Integer shIndex = 0;
            for (Contact c : ownerContacts) {
                wrappedShareholders.add(new ShareholderWrapper(shIndex, c));
                shIndex++;
            }
            
            shFileMapByIndexAndType = new Map<Integer, Map<Integer, List<FileWrapper>>>();
            wrappedRepresentatives = new List<RepresentativeWrapper>();
            repFileMapByIndexAndType = new Map<Integer, Map<Integer, List<FileWrapper>>>();
            
            Integer i = 0;
            for (Contact c : representativeContacts) {
                wrappedRepresentatives.add(new RepresentativeWrapper(i, c));
                i++;
            }
            
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
                    
                    if (file.fileName.startsWith('file_shareholder')) {
                        cpfFiles.add(file);
                        
                        List<String> parts = file.fileName.split('_');
                        if (parts.size() >= 4) {
                            Integer shFileIndex = Integer.valueOf(parts[2]);
                            Integer docType = Integer.valueOf(parts[3]);
                            
                            if (!shFileMapByIndexAndType.containsKey(shFileIndex)) {
                                shFileMapByIndexAndType.put(shFileIndex, new Map<Integer, List<FileWrapper>>());
                            }
                            if (!shFileMapByIndexAndType.get(shFileIndex).containsKey(docType)) {
                                shFileMapByIndexAndType.get(shFileIndex).put(docType, new List<FileWrapper>());
                            }
                            
                            List<FileWrapper> existingFiles = shFileMapByIndexAndType.get(shFileIndex).get(docType);
                            Boolean isDuplicate = false;
                            for (FileWrapper f : existingFiles) {
                                if (f.fileName == file.fileName) {
                                    isDuplicate = true;
                                    break;
                                }
                            }
                            if (!isDuplicate) {
                                existingFiles.add(file);
                            }
                        }
                        
                    } else if (file.fileName.startsWith('address_partners')) {
                        addressPartnersFiles.add(file);
                        
                    } else if (file.fileName.startsWith('companyInformationCertificateIncorporation')) {
                        cnpjFiles.add(file);
                        
                    } else if (file.fileName.startsWith('companyInformationProofAddress')) {
                        addressFiles.add(file);
                        
                    } else if (file.fileName.startsWith('sec')) {
                        secFiles.add(file);
                        
                    } else if (file.fileName.startsWith('con')) {
                        conFiles.add(file);
                        
                    } else if (file.fileName.startsWith('file_representative')) {
                        repFiles.add(file);
                        
                        List<String> parts = file.fileName.split('_');
                        if (parts.size() >= 4) {
                            Integer repIndex = Integer.valueOf(parts[2]);
                            Integer docType = Integer.valueOf(parts[3]);
                            
                            if (!repFileMapByIndexAndType.containsKey(repIndex)) {
                                repFileMapByIndexAndType.put(repIndex, new Map<Integer, List<FileWrapper>>());
                            }
                            if (!repFileMapByIndexAndType.get(repIndex).containsKey(docType)) {
                                repFileMapByIndexAndType.get(repIndex).put(docType, new List<FileWrapper>());
                            }
                            
                            repFileMapByIndexAndType.get(repIndex).get(docType).add(file);
                        }
                        
                    } else if (file.fileName.startsWith('bank')) {
                        bankFiles.add(file);
                    }
                }
            }
        }
    }
    
    private Contact queryContact(Id kycId, String role, List<String> fields) {
        String query = 'SELECT ' + String.join(fields, ',') +
            ' FROM Contact WHERE Related_KYC_XB__c = :kycId AND KYC_Role__c = :role LIMIT 1';
        return Database.query(query);
    }
    
    private List<Contact> queryContacts(Id kycId, String role, List<String> fields) {
        String query = 'SELECT ' + String.join(fields, ',') +
            ' FROM Contact WHERE Related_KYC_XB__c = :kycId AND KYC_Role__c = :role ORDER BY KYC_Role__c';
        return Database.query(query);
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
        PageReference pdfPage = Page.KYCXBPdfRenderPage;
        pdfPage.getParameters().put('id', recordId);
        
        Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContent();
        
        ContentVersion version = new ContentVersion();
        version.Title = 'KYC XB PDF - ' + recordId;
        version.PathOnClient = 'KYCXB_Document.pdf';
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