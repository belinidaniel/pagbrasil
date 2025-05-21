public class IndicatorDataResponse {
	public class RootResponse {
		public List<Result> Result { get; set; }
		public String QueryId;
		public Integer ElapsedMilliseconds;
		public String QueryDate;
		public Status Status;
		public Map<String, Object> Evidences;
	}

	public class Result {
		public String MatchKeys;
		public ActivityIndicators ActivityIndicators { get; set; }
	}

	public class ActivityIndicators {
		public String EmployeesRange { get; set; }
		public String IncomeRange { get; set; }
		public Boolean HasActivity { get; set; }
		public String ActivityLevel { get; set; }
		public String FirstLevelEconomicGroupAverageActivityLevel { get; set; }
		public String FirstLevelEconomicGroupMaxActivityLevel { get; set; }
		public String FirstLevelEconomicGroupMinActivityLevel { get; set; }
		public String ShellCompanyLikelyhood { get; set; }
		public Boolean HasRecentAddress { get; set; }
		public Boolean HasRecentPhone { get; set; }
		public Boolean HasRecentEmail { get; set; }
		public Boolean HasRecentPassages { get; set; }
		public Boolean HasActiveDomain { get; set; }
		public Boolean HasActiveSSL { get; set; }
		public Boolean HasCorporateEmail { get; set; }
		public Integer NumberOfBranches { get; set; }
	}

	public class Status {
		public List<StatusItem> owners_kyc;
	}

	public class StatusItem {
		public Integer Code;
		public String Message;
	}

	public class IndicatorSummary {
		public String TaxId { get; set; }
		public Boolean IsCurrentlyElectoralDonor { get; set; }
		public Boolean IsCurrentlyPEP { get; set; }
		public Boolean IsCurrentlySanctioned { get; set; }
		
		public IndicatorSummary(String taxId, Boolean isElectoralDonor, Boolean isPEP, Boolean isSanctioned) {
			this.TaxId = taxId;
			this.IsCurrentlyElectoralDonor = isElectoralDonor;
			this.IsCurrentlyPEP = isPEP;
			this.IsCurrentlySanctioned = isSanctioned;
		}
	}
}