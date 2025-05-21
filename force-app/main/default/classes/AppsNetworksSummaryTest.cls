@isTest
private class AppsNetworksSummaryTest {
	@isTest
	static void testAppsNetworksSummarySetAndGet() {
		AppsNetworksSummary summary = new AppsNetworksSummary();

		summary.totalSocialNetworks = 5;
		summary.totalSearchResults = 10;
		summary.totalSocialMediaPosts = 50;
		summary.followerToFollowingRatio = 1.75;
		summary.hasFacebook = true;
		summary.hasTwitter = false;
		summary.hasLinkedIn = true;
		summary.hasInstagram = false;
		summary.hasOLX = true;
		summary.hasMercadoLivre = false;

		System.assertEquals(5, summary.totalSocialNetworks);
		System.assertEquals(10, summary.totalSearchResults);
		System.assertEquals(50, summary.totalSocialMediaPosts);
		System.assertEquals(1.75, summary.followerToFollowingRatio);
		System.assertEquals(true, summary.hasFacebook);
		System.assertEquals(false, summary.hasTwitter);
		System.assertEquals(true, summary.hasLinkedIn);
		System.assertEquals(false, summary.hasInstagram);
		System.assertEquals(true, summary.hasOLX);
		System.assertEquals(false, summary.hasMercadoLivre);
	}
}