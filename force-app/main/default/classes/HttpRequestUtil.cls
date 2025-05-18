/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-07
 * @last modified by  : Hersilio Belini de Oliveira
**/

public without sharing class HttpRequestUtil {
    public HttpResponseDto httpResponseDto { get; set; }

    public HttpRequestUtil(String url, string methodName, Object bodyRequest, map<string, string> headers) {
        methodName = methodName.toUpperCase();

        MehtodRequestEnum methodMatch;
        for (MehtodRequestEnum methodEnumName : MehtodRequestEnum.values()) {
            if (methodEnumName.name() == methodName) {
                methodMatch = methodEnumName;
                break;
            }
        }

        httpResponseDto = sendRequest(url, methodMatch, bodyRequest, headers);
    }

    public static String sendRequest(String url, MehtodRequestEnum method, map<string, string> header) {
        HttpResponseDto response = sendRequest(url, method, '', header);

        return response.body;
    }

    public static String sendRequest(String url, MehtodRequestEnum method) {
        HttpResponseDto response = sendRequest(url, method, '', null);

        return response.body;
    }

    public static String sendRequest(String url, MehtodRequestEnum method, Object bodyRequest) {
        HttpResponseDto response = sendRequest(url, method, bodyRequest, null);

        return response.body;
    }

    public static HttpResponseDto sendRequest(String url, MehtodRequestEnum method, Object bodyRequest, map<string, string> headers) {
        String body;

        if (MehtodRequestEnum.POST.equals(method) && bodyRequest != null) {
            body = JSON.serialize(bodyRequest);
        }

        return sendRequest(url, method, body, headers);
    }

    public static HttpResponseDto sendRequest(String url, MehtodRequestEnum method, String body, map<string, string> headers) {
        HttpRequest req = new HttpRequest();

        req.setTimeout(120000);

        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint(url);
        req.setMethod(String.valueOf(method));
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', '*/*');

        if (headers != null) {
            for (String key : headers.keySet()) {
                req.setHeader(key, headers.get(key));
            }
        }

        if (!String.isBlank(body)) {
            req.setBody(body);
        }

        req.setCompressed(false);

        System.debug('body: ' + req.getBody());
        System.debug('url: ' + req.getEndpoint());

        String response;
        res = http.send(req);
        response = res.getBody();
        System.debug('response: ' + response);

        return new HttpResponseDto(res);
    }

    public static HttpResponseDto sendFileRequest(String url, Blob file, String fileType) {
        HttpRequest req = new HttpRequest();

        req.setTimeout(120000);

        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/' + fileType);
        req.setHeader('Accept', '*/*');
        req.setTimeout(120000);
        req.setBodyAsBlob(file);

        String response;
        res = http.send(req);
        response = res.getBody();

        if (res.getStatusCode() == 301 || res.getStatusCode() == 302) {
            System.debug('response: ' + response);
            throw new IllegalArgumentException('Endpoint moved to: ' + res.getHeader('Location'));
        }

        return new HttpResponseDto(res);
    }
}