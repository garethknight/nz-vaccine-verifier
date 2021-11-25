/**
 * @description       : 
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-19-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
**/
public with sharing class VerifierMetadata {
    @AuraEnabled
    public Datetime notBefore;
    @AuraEnabled
    public Datetime expiry;
    @AuraEnabled
    public String issuer;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public String id;

    public VerifierMetadata(Datetime notBefore, Datetime expiry, String issuer, String type, String id) {
        this.notBefore = notBefore;
        this.expiry = expiry;
        this.issuer = issuer;
        this.type = type;
        this.id = id;
    }
    public VerifierMetadata() {}
}