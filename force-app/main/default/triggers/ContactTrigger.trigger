trigger ContactTrigger on Contact (before insert) {
	Map<String, String> roleToTypeMap = new Map<String, String>{
		'technical' 		=> 'Técnico',
		'emergency' 		=> 'Técnico',
		'billing' 			=> 'Financeiro',
		'invoice' 			=> 'Financeiro',
		'support' 			=> 'Suporte',
		'channel' 			=> 'Suporte',
		'contract' 			=> 'Notificação',
		'personal' 			=> 'Principal',
		'representative' 	=> 'Representante Legal',
		'refund' 			=> 'Reembolsos'
	};

	Set<Id> kycIds = new Set<Id>();
	Set<Id> kycXbIds = new Set<Id>();

	for (Contact c : Trigger.new) {
		if (c.AccountId == null) {
			if (c.Related_KYC__c != null) kycIds.add(c.Related_KYC__c);
			if (c.Related_KYC_XB__c != null) kycXbIds.add(c.Related_KYC_XB__c);
		}
	}

	Map<Id, KYC__c> kycMap = new Map<Id, KYC__c>(
		[SELECT Id, Client_Account__c FROM KYC__c WHERE Id IN :kycIds]
	);
	Map<Id, KYC_XB__c> kycXbMap = new Map<Id, KYC_XB__c>(
		[SELECT Id, Client_Account__c FROM KYC_XB__c WHERE Id IN :kycXbIds]
	);

	for (Contact c : Trigger.new) {
		if (c.AccountId == null) {
			if (c.Related_KYC__c != null && kycMap.containsKey(c.Related_KYC__c)) {
				c.AccountId = kycMap.get(c.Related_KYC__c).Client_Account__c;
			} else if (c.Related_KYC_XB__c != null && kycXbMap.containsKey(c.Related_KYC_XB__c)) {
				c.AccountId = kycXbMap.get(c.Related_KYC_XB__c).Client_Account__c;
			}
		}
        
	String role = c.KYC_Role__c;
	if (role != null) {
		role = role.toLowerCase();
			if (roleToTypeMap.containsKey(role)) {
				c.Type__c = roleToTypeMap.get(role);
			} else {
				c.Type__c = 'Other';
			}
		}
	}
}