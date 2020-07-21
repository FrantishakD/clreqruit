@RestResource(urlMapping='/Lead/*')
global with sharing class LeadRestService {
    
    @HttpPost
    global static void upsertLeads(){
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        List<LeadWrapper> leadWrappers = (List<LeadWrapper>)JSON.deserialize(requestString,List<LeadWrapper>.class);
        
        List<ResultWrapper> results = new List<ResultWrapper>();
        List<Lead> leadsToUpsert = new List<Lead>();
        for(LeadWrapper lWrapper : leadWrappers){
            Lead newLead = lWrapper.getLead();
            if(String.isBlank(newLead.Source_Id__c) || String.isBlank(newLead.LastName) || String.isBlank(newLead.Phone)){
                results.add(new ResultWrapper(newLead));
            } else{
                leadsToUpsert.add(newLead);
            }
        }

        List<Database.UpsertResult> upsertResults = Database.upsert(leadsToUpsert, Lead.Fields.Source_Id__c, false);        
        for(Integer i = 0; i < upsertResults.size(); i++){
            results.add(new ResultWrapper(leadsToUpsert[i], upsertResults[i]));
        }

        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
        res.responseBody = Blob.valueOf(JSON.serialize(results));
        res.statusCode = 200;
    }

    public class LeadWrapper{
        String id {get;set;}
        Datetime createddate {get;set;}
        String firstname {get;set;}
        String lastname {get;set;}
        String phone {get;set;}
        AddressWrapper address {get;set;}

        public Lead getLead(){
            return new Lead(
                Source_Id__c = this.id, 
                Source_Created_Date__c = this.createddate,
                FirstName = this.firstname,
                LastName = this.lastname,
                Phone = this.phone,
                Street = this.address != null ? this.address.street : null,
                City = this.address != null ? this.address.city : null,
                PostalCode = this.address != null ? this.address.postalcode : null,
                Country = this.address != null ? this.address.country : null,
                Company = 'Not Specified'
            );
        }
    }

    public class AddressWrapper{
        String street {get;set;}
        String city {get;set;}
        String postalcode {get;set;}
        String country {get;set;}
    }

    public class ResultWrapper{
        public String id {get;set;}
        public Boolean success {get;set;}
        public String message {get;set;}

        public ResultWrapper(Lead failedLead){
            this.id = failedLead.Source_Id__c;
            this.success = false;
            this.message = 'Required field missing';
        }

        public ResultWrapper(Lead upsertedLead, Database.UpsertResult result){
            this.id = upsertedLead.Source_Id__c;
            this.success = result.isSuccess();
            if(this.success){
                this.message = result.isCreated() ? 'Created' : 'Updated';
            } else{
                this.message = result.getErrors()[0].getMessage();
            }
        }
    }
}