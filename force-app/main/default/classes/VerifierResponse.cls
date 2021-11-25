/**
 * @description       : 
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-25-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
**/
public with sharing class VerifierResponse {
    @InvocableVariable
    public Boolean verified = false;

    @InvocableVariable
    public VerifierPayload payload;

    @InvocableVariable
    public VerifierMetadata metadata;

    @InvocableVariable
    public Integer errorStatusCode;

    @InvocableVariable
    public String code;
    
    @InvocableVariable
    public String message;

    @InvocableVariable
    public List<VerifierError> details;

    public VerifierResponse(Boolean verified, VerifierPayload payload, VerifierMetadata metadata) {
        this.verified = verified;
        this.payload = payload;
        this.metadata = metadata;
    }

    public VerifierResponse(String code, String message, List<VerifierError> details) {
        this.code = code;
        this.message = message;
        this.details = details;
    }
}