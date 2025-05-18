public class WebhookDTO{
	public String type;
	public Resource resource;
	public String method;
	public String status;
	public String id;
	public String to;
	public class Resource {
		public Integer total;
		public String itemType;
		public Items[] items;
	}
	public class Items {
		public String id;
		public String direction;
		public String type;
		public Content content;
		public String content_x;
		public Datetime date_x;
		public String status;
		public Metadata metadata;
	}
	public class Content {
		public String scope;
		public String text;
		public String team;
		public String agentIdentity;
		public String customerIdentity;
		public String CampaignId;
		public Options[] options;
		public Metadata metadata;
	}
	class Options {
		public String text;
		public String type;
		public String value;
	}
	public class Metadata {
		public String messageEmitter;
		public String tunnelOriginator;
	}
	public static WebhookDTO parse(String json){
		if(json.indexOf('"content": "') > -1) json = json.replaceAll('"content": "', '"content_x": "');
		if(json.indexOf('"#messageEmitter": "') > -1) json = json.replaceAll('"#messageEmitter": "', '"messageEmitter": "');
		return (WebhookDTO) System.JSON.deserialize(json, WebhookDTO.class);
	}
}