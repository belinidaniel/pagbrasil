public class InsertBigBoostJob implements Queueable {
	private Id kycId;
	private String cnpj;
	private String dataset;
	private String result;

	public InsertBigBoostJob(Id kycId, String cnpj, String dataset, String result) {
		this.kycId = kycId;
		this.cnpj = cnpj;
		this.dataset = dataset;
		this.result = result;
	}

	public void execute(QueueableContext context) {
		try {
			Big_Boost__c bigBoost = new Big_Boost__c(
				KYC__c = kycId,
				CNPJ__c = cnpj,
				Dataset__c = dataset,
				Result__c = result
			);
			insert bigBoost;
		} catch (DmlException e) {
			System.debug('DML Exception: ' + e.getMessage());
		}
	}
}