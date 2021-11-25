/**
 * @description       : 
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-23-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
**/
global class Mattr extends Auth.AuthProviderPluginClass {


    global String getCustomMetadataType() {
        return 'Mattr_Identity__mdt';
    }

    global PageReference initiate(Map<String, String> authProviderConfiguration, String stateToPropagate) {
        authUrl = authProviderConfiguration.get('Auth_URL__c');  
    }
}
