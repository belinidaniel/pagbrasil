@isTest
public class HttpResponseDtoTest {

    @isTest
    static void testHttpResponseDtoConstructorWithHttpResponse() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody('{"status":"success"}');
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200);

        HttpResponseDto responseDto = new HttpResponseDto(mockResponse);

        System.assertEquals('{"status":"success"}', responseDto.body);
        System.assertEquals('OK', responseDto.status);
        System.assertEquals(200, responseDto.code);
    }

    @isTest
    static void testHttpResponseDtoConstructorEmpty() {
        HttpResponseDto responseDto = new HttpResponseDto();

        System.assertEquals(null, responseDto.body);
        System.assertEquals(null, responseDto.status);
        System.assertEquals(null, responseDto.code);
    }
}