/**
 * @description       : 
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-25-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
**/
public with sharing class VerifierError {
    @AuraEnabled
    public String type;

    @AuraEnabled
    public String message;

    

    public VerifierError(String type, String message) {
        this.type = type;
        this.message = message;
       
    }
    public VerifierError() {}
}
