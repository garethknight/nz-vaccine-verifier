
/**
 * @description       : 
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-25-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
**/
public with sharing class VerifierDetails {
    @AuraEnabled
    public String value;

    @AuraEnabled
    public String msg;

    @AuraEnabled
    public String param;

    @AuraEnabled
    public String location;

    public VerifierDetails(String value, String msg, String param, String location) {
        this.value = value;
        this.msg = msg;
        this.param = param;
        this.location = location;
    }
    public VerifierDetails() {}
}