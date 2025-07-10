@IsTest
public class IndicatorDataResponseTest {
    @IsTest
    static void testDeserializationFullCoverage() {
        String str = '{\"Result\":[{\"MatchKeys\":\"doc*************07}\",\"ActivityIndicators\":{\"EmployeesRange\":\"020 A 049\",\"IncomeRange\":\"ACIMA DE 2.5MM ATE 5MM\",\"HasActivity\":false,\"ActivityLevel\":\"0,24691358\",\"FirstLevelEconomicGroupAverageActivityLevel\":\"0,24691358\",\"FirstLevelEconomicGroupMaxActivityLevel\":\"0,24691358\",\"FirstLevelEconomicGroupMinActivityLevel\":\"0,24691358\",\"ShellCompanyLikelyhood\":\"0,25\",\"HasRecentAddress\":false,\"HasRecentPhone\":false,\"HasRecentEmail\":false,\"HasRecentPassages\":true,\"HasActiveDomain\":true,\"HasActiveSSL\":false,\"HasCorporateEmail\":true,\"NumberOfBranches\":0}}],\"QueryId\":\"106d9bec-ee8c-40c9-8b4a-99d039783456\",\"ElapsedMilliseconds\":88,\"QueryDate\":\"2024-09-10T15:10:40.7035132Z\",\"Status\":{\"activity_indicators\":[{\"Code\":0,\"Message\":\"OK\"}]},\"Evidences\":{}}';

        IndicatorDataResponse.RootResponse response = (IndicatorDataResponse.RootResponse)JSON.deserialize(str, IndicatorDataResponse.RootResponse.class);

        System.assertNotEquals(null, response);
        System.assertEquals('106d9bec-ee8c-40c9-8b4a-99d039783456', response.QueryId);
        System.assertEquals(88, response.ElapsedMilliseconds);
        System.assertEquals('2024-09-10T15:10:40.7035132Z', response.QueryDate);
        System.assertNotEquals(null, response.Evidences);

        System.assertEquals(1, response.Result.size());
        IndicatorDataResponse.Result firstResult = response.Result[0];
        System.assertEquals('doc*************07}', firstResult.MatchKeys);
        System.assertNotEquals(null, firstResult.ActivityIndicators);
        System.assertEquals('020 A 049', firstResult.ActivityIndicators.EmployeesRange);
        System.assertEquals('ACIMA DE 2.5MM ATE 5MM', firstResult.ActivityIndicators.IncomeRange);
        System.assertEquals(false, firstResult.ActivityIndicators.HasActivity);
        
        System.assertEquals('0,24691358', firstResult.ActivityIndicators.ActivityLevel);
        System.assertEquals('0,24691358', firstResult.ActivityIndicators.FirstLevelEconomicGroupAverageActivityLevel);
        System.assertEquals('0,24691358', firstResult.ActivityIndicators.FirstLevelEconomicGroupMaxActivityLevel);
        System.assertEquals('0,24691358', firstResult.ActivityIndicators.FirstLevelEconomicGroupMinActivityLevel);
        System.assertEquals(false, firstResult.ActivityIndicators.HasRecentAddress);
        System.assertEquals(false, firstResult.ActivityIndicators.HasRecentPhone);
        System.assertEquals(false, firstResult.ActivityIndicators.HasRecentEmail);
        
        System.assertEquals('0,25', firstResult.ActivityIndicators.ShellCompanyLikelyhood);
        System.assertEquals(true, firstResult.ActivityIndicators.HasRecentPassages);
        System.assertEquals(true, firstResult.ActivityIndicators.HasActiveDomain);
        System.assertEquals(false, firstResult.ActivityIndicators.HasActiveSSL);
        System.assertEquals(true, firstResult.ActivityIndicators.HasCorporateEmail);
        System.assertEquals(0, firstResult.ActivityIndicators.NumberOfBranches);

        System.assertNotEquals(null, response.Status);

        IndicatorDataResponse.IndicatorSummary summary = new IndicatorDataResponse.IndicatorSummary(
            '12345678901', true, false, true
        );
        System.assertEquals('12345678901', summary.TaxId);
        System.assertEquals(true, summary.IsCurrentlyElectoralDonor);
        System.assertEquals(false, summary.IsCurrentlyPEP);
        System.assertEquals(true, summary.IsCurrentlySanctioned);
    }
}