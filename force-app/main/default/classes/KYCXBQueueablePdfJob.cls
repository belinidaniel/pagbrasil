public class KYCXBQueueablePdfJob implements Queueable, Database.AllowsCallouts {
	private Id recordId;

	public KYCXBQueueablePdfJob(Id recordId) {
		this.recordId = recordId;
	}

	public void execute(QueueableContext context) {
		KYCXBPdfController.generateAndSavePdf(recordId);
	}
}