@isTest
public with sharing class LeadRestServiceTest {
    
    @isTest
    static void upsertLeadsTest(){
        RestRequest request = new RestRequest();
        request.requestUri = System.URL.getOrgDomainUrl() +'/services/apexrest/Lead/';
        request.httpMethod = 'POST';
        String testRequest = '[' +
            '{' +
            '"id" : "123e4567-e89b-12d3-a456-426655440000", "createddate" : "2019-10-24T11:28:41.000-0700", "firstname" : "Arnold", "lastname" : "Shwarzenegger", "phone" : "12223334444", "address" : {' +
            '"street" : "Coulterville", "city" : "Los Angeles", "postalcode" : "​99501", "country" : "United States"' +
            '} }, {' +
            '"id" : "00112233-4455-6677-8899-aabbccddeeff", "createddate" : "2019-10-24T13:02:45.000-0700", "firstname" : "Brad", "lastname" : "Pitt", "phone" : null, "address" : {' + 
            '"street" : "Beverly Dr 238/1", "city" : "​Beverly Hills​", "postalcode" : "​90212​", "country" : "United States" } }' + 
        ']';
        request.requestBody = Blob.valueOf(testRequest);
        RestContext.request = request;

        LeadRestService.upsertLeads();
        RestResponse res = RestContext.response;
        String responseString = res.responseBody.toString();
        List<LeadRestService.ResultWrapper> leadWrappers = (List<LeadRestService.ResultWrapper>)JSON.deserialize(responseString,List<LeadRestService.ResultWrapper>.class);
        System.assertEquals(2, leadWrappers.size());
        
        LeadRestService.ResultWrapper successWrapper;
        LeadRestService.ResultWrapper errorWrapper;
        for(LeadRestService.ResultWrapper wrapper : leadWrappers){
            if(wrapper.success){
                successWrapper = wrapper;
            } else{
                errorWrapper = wrapper;
            }
        }
        System.assertEquals('123e4567-e89b-12d3-a456-426655440000', successWrapper.id);
        System.assertEquals('Created', successWrapper.message);
        System.assertEquals('00112233-4455-6677-8899-aabbccddeeff', errorWrapper.id);
        System.assertEquals('Required field missing', errorWrapper.message);
    }
}