/**
 * @description       : 
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-19-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
**/
public with sharing class VerifierPayload {
    @AuraEnabled
    public String givenName;
    @AuraEnabled
    public String familyName;
    @AuraEnabled
    public String dob;

    public VerifierPayload(String givenName, String familyName, String dob) {
        this.givenName = givenName;
        this.familyName = familyName;
        this.dob = dob;
    }
    public VerifierPayload() {}
}