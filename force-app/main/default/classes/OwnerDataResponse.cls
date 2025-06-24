public class OwnerDataResponse {
	public class ElectoralDonations {
		public Integer DonationsCount;
		public Decimal AmountDonated;
	}

	public class PEPHistory {
		public String Level;
		public String JobTitle;
		public String Department;
		public String Motive;
		public String Source;
		public String TaxId;
		public String StartDate;
		public String EndDate;
	}

	public class SanctionDetails {
		public String OriginalName;
		public String SanctionName;
		public String BirthDate;
		public String StandardizedBirthDate;
		public String SourcePossibleDateOfBirthScore;
	}

	public class Sanction {
		public String Source;
		public String Type;
		public String StandardizedSanctionType;
		public Integer MatchRate;
		public Integer NameUniquenessScore;
		public SanctionDetails Details;  // Nested class
		public SanctionDetails NormalizedDetails;  // Nested class
		public String StartDate;
		public String EndDate;
		public String CreationDate;
		public String LastUpdateDate;
		public Boolean IsCurrentlyPresentOnSource;
		public Boolean WasRecentlyPresentOnSource;
	}

	public class OwnerKycDataDetails {
		public List<PEPHistory> PEPHistory;
		public Boolean IsCurrentlyPEP;
		public List<Sanction> SanctionsHistory;
		public Boolean IsCurrentlySanctioned;
		public Boolean WasPreviouslySanctioned;
		public Integer Last30DaysSanctions;
		public Integer Last90DaysSanctions;
		public Integer Last180DaysSanctions;
		public Integer Last365DaysSanctions;
		public Integer LastYearPEPOccurence;
		public Integer Last3YearsPEPOccurence;
		public Integer Last5YearsPEPOccurence;
		public Integer Last5PlusYearsPEPOccurence;
		public String FirstPEPOccurenceDate;
		public String LastPEPOccurenceDate;
		public Boolean IsCurrentlyElectoralDonor;
		public Boolean IsHistoricalElectoralDonor;
		public Integer TotalElectoralDonations;
		public Decimal TotalElectoralDonationAmount;
		public Map<String, ElectoralDonations> ElectoralDonations;
	}

	public class OwnersKycData {
		public Map<String, OwnerKycDataDetails> OwnersKycData;
		public Integer TotalCurrentlyPEP;
		public Integer TotalHistoricallyPEP;
		public Integer TotalCurrentlySanctioned;
		public Integer TotalHistoricallySanctioned;
		public String AverageSanctionsPerOwner;
		public Integer PEPPercentage;
		public Integer OwnerMaxSanctions;
		public Integer OwnerMinSanctions;
		public Integer Last30DaysSanctions;
		public Integer Last90DaysSanctions;
		public Integer Last180DaysSanctions;
		public Integer Last365DaysSanctions;
		public Integer LastYearPEPOccurence;
		public Integer Last3YearsPEPOccurence;
		public Integer Last5YearsPEPOccurence;
		public Integer Last5PlusYearsPEPOccurence;
		public String FirstPEPOccurenceDate;
		public String LastPEPOccurenceDate;
		public String FirstSanctionDate;
		public String LastSanctionDate;
		public List<String> ActiveOwners;
		public List<String> InactiveOwners;
	}

	public class Result {
		public String MatchKeys;
		public OwnersKycData OwnersKycData;
	}

	public class Status {
		public List<StatusItem> owners_kyc;
	}

	public class StatusItem {
		public Integer Code;
		public String Message;
	}

	public class RootResponse {
		public List<Result> Result;
		public String QueryId;
		public Integer ElapsedMilliseconds;
		public String QueryDate;
		public Status Status;
		public Map<String, Object> Evidences;
	}

	public class OwnerSummary {
		public String TaxId { get; set; }
		public Boolean IsCurrentlyElectoralDonor { get; set; }
		public Boolean IsCurrentlyPEP { get; set; }
		public Boolean IsCurrentlySanctioned { get; set; }
    
		public OwnerSummary(String taxId, Boolean isElectoralDonor, Boolean isPEP, Boolean isSanctioned) {
			this.TaxId = taxId;
			this.IsCurrentlyElectoralDonor = isElectoralDonor;
			this.IsCurrentlyPEP = isPEP;
			this.IsCurrentlySanctioned = isSanctioned;
		}
	}
}