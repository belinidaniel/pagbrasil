/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 07-08-2025
 * @last modified by  : Daniel Belini
**/
public with sharing class ZendeskService {

    private static final String ENDPOINT_BASE = 'callout:Zendesk/api/v2/';

    /**
    * @description create ticket
    * @author Hersilio Belini de Oliveira | 2024-12-26
    * @return String
    **/
    public String createTicket(ZendeskTicketWrapper ticket){
        try {
            String url = ENDPOINT_BASE + 'tickets.json';

            String body = JSON.serialize(ticket).replace('publicComment', 'public');
            System.Debug('Request url:       ------------ ' + url);
            System.Debug('Request body:       ------------ ' + body);
            HttpResponseDto response = HttpRequestUtil.sendRequest(url, MehtodRequestEnum.POST, body, null);
            System.Debug(response);
            if(response.code == 201){
                return JsonUtil.getNode(response.body, 'ticket.id');
            }

            throw new AuraHandledException('Error creating ticket: ' + String.valueOf(response.code) + ' - ' + response.body);

        } catch (Exception ex) {
            System.debug('Error creating ticket: ' + ex.getMessage() + ' - ' + ex.getStackTraceString());
            throw new AuraHandledException('Error creating ticket: ' + ex.getMessage() + ' - ' + ex.getStackTraceString());
        }
    }

    /**
    * @description create attach in zendesk
    * @author Hersilio Belini de Oliveira | 2025-01-02
    * @param file
    * @param fileName
    * @param fileType
    * @return String
    **/
    public String createAttach(Blob file, String fileName, String fileType){

        try {
            String url = ENDPOINT_BASE + 'uploads.json?filename=' + fileName;

            HttpResponseDto response = HttpRequestUtil.sendFileRequest(url, file, fileType);

            if(response.code == 201){
                return JsonUtil.getNode(response.body, 'upload.token');
            }

            throw new AuraHandledException('Error creating attach: ' + String.valueOf(response.code) + ' - ' + response.body);

        } catch (Exception ex) {
            System.debug('Error creating attach: ' + ex.getMessage() + ' - ' + ex.getStackTraceString());
            throw new AuraHandledException('Error creating attach: ' + ex.getMessage() + ' - ' + ex.getStackTraceString());
        }
    }

    /**
    * @description search organization by filter
    * @author Hersilio Belini de Oliveira
    * @param filter String
    * @return void
    **/
    public String getOrganization(String filter) {
        String url = ENDPOINT_BASE + 'organizations/autocomplete.json?name=' + EncodingUtil.urlEncode(filter, 'UTF-8');

        String response = HttpRequestUtil.sendRequest(url, MehtodRequestEnum.GET);

        return response;
    }

    /**
    * @description create or update organization in zendesk
    * @author Hersilio Belini de Oliveira | 2024-12-31
    * @param body
    * @return String
    **/
    public OrganizationWrapper createOrUpdateOrganization(OrganizationWrapper orgWrapper){
        String url = ENDPOINT_BASE + 'organizations/create_or_update.json';

        HttpResponseDto response = HttpRequestUtil.sendRequest(url, MehtodRequestEnum.POST, orgWrapper, null);

        System.debug('response.body: ' + response.body);
        System.debug('response.code: ' + response.code);

        if(response.code == 200 || response.code == 201){
            return OrganizationWrapper.fromJSON(response.body);
        }

        throw new AuraHandledException(response.body);
    }
}