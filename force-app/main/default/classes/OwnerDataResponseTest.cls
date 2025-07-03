@isTest
public class OwnerDataResponseTest {
    @isTest
    static void testOwnerDataResponseStructure() {
        // Teste da classe ElectoralDonations
        OwnerDataResponse.ElectoralDonations donation = new OwnerDataResponse.ElectoralDonations();
        donation.DonationsCount = 2;
        donation.AmountDonated = 1500.50;
        System.assertEquals(2, donation.DonationsCount);
        System.assertEquals(1500.50, donation.AmountDonated);

        // Teste da classe PEPHistory
        OwnerDataResponse.PEPHistory pep = new OwnerDataResponse.PEPHistory();
        pep.Level = 'High';
        pep.JobTitle = 'Director';
        pep.Department = 'Finance';
        pep.Motive = 'Political';
        pep.Source = 'Gov';
        pep.TaxId = '12345678900';
        pep.StartDate = '2020-01-01';
        pep.EndDate = '2022-01-01';
        System.assertEquals('High', pep.Level);

        // Teste da classe SanctionDetails
        OwnerDataResponse.SanctionDetails sanctionDetails = new OwnerDataResponse.SanctionDetails();
        sanctionDetails.OriginalName = 'John Doe';
        sanctionDetails.SanctionName = 'J. Doe';
        sanctionDetails.BirthDate = '1980-01-01';
        sanctionDetails.StandardizedBirthDate = '1980-01-01';
        sanctionDetails.SourcePossibleDateOfBirthScore = '100';
        System.assertEquals('John Doe', sanctionDetails.OriginalName);

        // Teste da classe Sanction
        OwnerDataResponse.Sanction sanction = new OwnerDataResponse.Sanction();
        sanction.Source = 'UN';
        sanction.Type = 'Financial';
        sanction.StandardizedSanctionType = 'Standard';
        sanction.MatchRate = 90;
        sanction.NameUniquenessScore = 80;
        sanction.Details = sanctionDetails;
        sanction.NormalizedDetails = sanctionDetails;
        sanction.StartDate = '2021-01-01';
        sanction.EndDate = '2021-12-31';
        sanction.CreationDate = '2021-01-01';
        sanction.LastUpdateDate = '2022-01-01';
        sanction.IsCurrentlyPresentOnSource = true;
        sanction.WasRecentlyPresentOnSource = false;
        System.assertEquals('UN', sanction.Source);

        // Teste da classe OwnerKycDataDetails
        OwnerDataResponse.OwnerKycDataDetails ownerKyc = new OwnerDataResponse.OwnerKycDataDetails();
        ownerKyc.PEPHistory = new List<OwnerDataResponse.PEPHistory>{pep};
        ownerKyc.IsCurrentlyPEP = true;
        ownerKyc.SanctionsHistory = new List<OwnerDataResponse.Sanction>{sanction};
        ownerKyc.IsCurrentlySanctioned = true;
        ownerKyc.WasPreviouslySanctioned = false;
        ownerKyc.Last30DaysSanctions = 1;
        ownerKyc.Last90DaysSanctions = 2;
        ownerKyc.Last180DaysSanctions = 3;
        ownerKyc.Last365DaysSanctions = 4;
        ownerKyc.LastYearPEPOccurence = 1;
        ownerKyc.Last3YearsPEPOccurence = 2;
        ownerKyc.Last5YearsPEPOccurence = 3;
        ownerKyc.Last5PlusYearsPEPOccurence = 4;
        ownerKyc.FirstPEPOccurenceDate = '2020-01-01';
        ownerKyc.LastPEPOccurenceDate = '2022-01-01';
        ownerKyc.IsCurrentlyElectoralDonor = true;
        ownerKyc.IsHistoricalElectoralDonor = false;
        ownerKyc.TotalElectoralDonations = 2;
        ownerKyc.TotalElectoralDonationAmount = 1500.50;
        ownerKyc.ElectoralDonations = new Map<String, OwnerDataResponse.ElectoralDonations>{
            '2022' => donation
        };
        System.assert(ownerKyc.IsCurrentlyPEP);

        // Teste da classe OwnersKycData
        OwnerDataResponse.OwnersKycData ownersKyc = new OwnerDataResponse.OwnersKycData();
        ownersKyc.OwnersKycData = new Map<String, OwnerDataResponse.OwnerKycDataDetails>{
            '12345678900' => ownerKyc
        };
        ownersKyc.TotalCurrentlyPEP = 1;
        ownersKyc.TotalHistoricallyPEP = 2;
        ownersKyc.TotalCurrentlySanctioned = 1;
        ownersKyc.TotalHistoricallySanctioned = 2;
        ownersKyc.AverageSanctionsPerOwner = '1.5';
        ownersKyc.PEPPercentage = 50;
        ownersKyc.OwnerMaxSanctions = 3;
        ownersKyc.OwnerMinSanctions = 1;
        ownersKyc.Last30DaysSanctions = 1;
        ownersKyc.Last90DaysSanctions = 2;
        ownersKyc.Last180DaysSanctions = 3;
        ownersKyc.Last365DaysSanctions = 4;
        ownersKyc.LastYearPEPOccurence = 1;
        ownersKyc.Last3YearsPEPOccurence = 2;
        ownersKyc.Last5YearsPEPOccurence = 3;
        ownersKyc.Last5PlusYearsPEPOccurence = 4;
        ownersKyc.FirstPEPOccurenceDate = '2020-01-01';
        ownersKyc.LastPEPOccurenceDate = '2022-01-01';
        ownersKyc.FirstSanctionDate = '2021-01-01';
        ownersKyc.LastSanctionDate = '2021-12-31';
        ownersKyc.ActiveOwners = new List<String>{'12345678900'};
        ownersKyc.InactiveOwners = new List<String>{'09876543211'};
        System.assertEquals(1, ownersKyc.TotalCurrentlyPEP);

        // Teste da classe Result
        OwnerDataResponse.Result result = new OwnerDataResponse.Result();
        result.MatchKeys = 'TaxId';
        result.OwnersKycData = ownersKyc;
        System.assertEquals('TaxId', result.MatchKeys);

        // Teste da classe StatusItem
        OwnerDataResponse.StatusItem statusItem = new OwnerDataResponse.StatusItem();
        statusItem.Code = 200;
        statusItem.Message = 'OK';
        System.assertEquals(200, statusItem.Code);

        // Teste da classe Status
        OwnerDataResponse.Status status = new OwnerDataResponse.Status();
        status.owners_kyc = new List<OwnerDataResponse.StatusItem>{statusItem};
        System.assertEquals('OK', status.owners_kyc[0].Message);

        // Teste da classe RootResponse
        OwnerDataResponse.RootResponse root = new OwnerDataResponse.RootResponse();
        root.Result = new List<OwnerDataResponse.Result>{result};
        root.QueryId = 'Q123';
        root.ElapsedMilliseconds = 100;
        root.QueryDate = '2025-07-02';
        root.Status = status;
        root.Evidences = new Map<String, Object>{'key' => 'value'};
        System.assertEquals('Q123', root.QueryId);

        // Teste da classe OwnerSummary e construtor
        OwnerDataResponse.OwnerSummary summary = new OwnerDataResponse.OwnerSummary(
            '12345678900', true, true, false
        );
        System.assertEquals('12345678900', summary.TaxId);
        System.assertEquals(true, summary.IsCurrentlyElectoralDonor);
        System.assertEquals(true, summary.IsCurrentlyPEP);
        System.assertEquals(false, summary.IsCurrentlySanctioned);
    }
}