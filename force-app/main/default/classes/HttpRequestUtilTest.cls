@isTest
public class HttpRequestUtilTest {

    @isTest
    static void testSendRequestWithBodyRequest() {
        String testUrl = 'https://example.com/api';

        Map<String, Object> bodyRequest = new Map<String, Object>{
            'key1' => 'value1',
            'key2' => 'value2'
        };

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"status":"success"}');
        mockResponse.setStatusCode(200);

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        String responseBody = HttpRequestUtil.sendRequest(testUrl, MehtodRequestEnum.POST, bodyRequest);
        System.assertEquals('{"status":"success"}', responseBody);
    }

    @isTest
    static void testHttpRequestUtilConstructor() {
        String testUrl = 'https://example.com/api';

        Map<String, Object> bodyRequest = new Map<String, Object>{
            'key1' => 'value1',
            'key2' => 'value2'
        };

        Map<String, String> headers = new Map<String, String>{
            'Authorization' => 'Bearer dummy-token',
            'Custom-Header' => 'CustomValue'
        };

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"status":"success"}');
        mockResponse.setStatusCode(200);

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        HttpRequestUtil httpRequestUtil = new HttpRequestUtil(testUrl, 'POST', bodyRequest, headers);
        System.assertNotEquals(null, httpRequestUtil.httpResponseDto);
        System.assertEquals('{"status":"success"}', httpRequestUtil.httpResponseDto.body);
    }

    @isTest
    static void testRedirectHandling() {
        String testUrl = 'https://example.com/api';

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"status":"redirect"}');
        mockResponse.setStatusCode(301);
        mockResponse.setHeader('Location', 'https://example.com/new-location');

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        try {
            Blob testBlob = Blob.valueOf('Sample file content');
            HttpRequestUtil.sendFileRequest(testUrl, testBlob, 'txt');
            System.assert(false, 'Deveria ter lançado uma exceção.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Endpoint moved to: https://example.com/new-location', e.getMessage());
        }
    }

    @isTest
    static void testSendRequestWithHeaders() {
        String testUrl = 'https://example.com/api';

        Map<String, String> headers = new Map<String, String>{
            'Authorization' => 'Bearer dummy-token',
            'Custom-Header' => 'CustomValue'
        };

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"status":"success"}');
        mockResponse.setStatusCode(200);

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        String responseBody = HttpRequestUtil.sendRequest(testUrl, MehtodRequestEnum.GET, headers);
        System.assertEquals('{"status":"success"}', responseBody);
    }

    @isTest
    static void testSendRequestWithoutHeaders() {
        String testUrl = 'https://example.com/api';

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"status":"success"}');
        mockResponse.setStatusCode(200);

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        String responseBody = HttpRequestUtil.sendRequest(testUrl, MehtodRequestEnum.GET);
        System.assertEquals('{"status":"success"}', responseBody);
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse mockResponse;

        public MockHttpResponseGenerator(HttpResponse response) {
            this.mockResponse = response;
        }

        public HTTPResponse respond(HTTPRequest req) {
            return mockResponse;
        }
    }
}