public class KYCQueueablePdfJob implements Queueable, Database.AllowsCallouts {
	private Id recordId;

	public KYCQueueablePdfJob(Id recordId) {
		this.recordId = recordId;
	}

	public void execute(QueueableContext context) {
		KYCPdfController.generateAndSavePdf(recordId);
	}
}