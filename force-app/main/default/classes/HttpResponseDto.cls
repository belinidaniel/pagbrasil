/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2024-12-12
 * @last modified by  : Hersilio Belini de Oliveira
**/

public class HttpResponseDto {

	public HttpResponseDto(){}

	public HttpResponseDto(HttpResponse response){
		this.body = response.getBody();
		this.status = response.getStatus();
		this.code = response.getStatusCode();
	}

	public string body{
		get;set;
	}

	public string status {
		get;set;
	}

	public integer code {
		get;set;
	}
}