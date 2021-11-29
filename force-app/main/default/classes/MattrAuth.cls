/**
 * @description       : Custom Auth Provider for the Mattr NZ My Covid Pass verification
 *                    : Implements the Client Credentials flow which is intended for server-to-server integrations 
 *                    :
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-29-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
 * 
**/
global class MattrAuth extends Auth.AuthProviderPluginClass {

    private static final String RESOURCE_CALLBACK = '/services/authcallback/';
    private static final String ENCODING_XML = 'application/x-www-form-urlencoded;charset=UTF-8';
    private static final String ENCODING_JSON = 'application/json';
    private static final String DUMMY_CODE = '111';
    private static final String MATTR_METADATA_TYPE = 'Mattr_Identity__mdt';
    private static final String DEFAULT_TOKEN_TYPE = 'Bearer';
    
    /*
        Field names for Custom Metadata fields to support custom auth provider
    */
    private static final String FIELD_AUDIENCE = 'Audience__c';
    private static final String FIELD_AUTH_URL = 'Auth_URL__c';
    private static final String FIELD_CALLBACK_URL_OVERRIDE = 'Callback_URL_Override__c';
    private static final String FIELD_CLIENT_ID = 'Client_Id__c';
    private static final String FIELD_CLIENT_SECRET = 'Client_Secret__c';
    private static final String FIELD_GRANT_TYPE = 'Grant_Type__c';
    private static final String FIELD_TENANT_SUBDOMAIN = 'Tenant_Subdomain__c';
    private static final String FIELD_VERIFY_URL_SUFFIX = 'Verify_URL_Suffix__c';
    private static final String FIELD_AUTH_PROVIDER_NAME = 'Auth_Provider_Name__c';  //In the config needs to be the same as the label

    // Ensure the name of your custom metadata type matches below
    public String getCustomMetadataType() {
        return MATTR_METADATA_TYPE;
    }

    /*
        Contructor for debugging purposes to understand when instantiated
    */
    public MattrAuth() {
        super();
        system.debug('### Constructor called:');
    }

    /*
        Initiate callback.  Required method for Auth Provider.  No End User authorization is required for this flow so it goes straight to the token request
        The interface needs the Callback URL to be defined.
    */
    global PageReference initiate(Map<String, String> authProviderConfiguration, String stateToPropagate) {
        system.debug('### Initiate');


        final PageReference pageRef = new PageReference(getCallbackUrl(authProviderConfiguration));
        pageRef.getParameters().put('state', stateToPropagate);
        pageRef.getParameters().put('code', DUMMY_CODE); // This is required, however is never used hence the dummy value
        System.debug('### ' + pageRef.getUrl());
        return pageRef;
    }

    /**
      This method composes the callback URL automatically UNLESS it has been overridden through Configuration.
      Normally one should not override the callback URL, but it's there in case the generated URL doesn't work.
    **/
    private String getCallbackUrl(Map<string,string> authProviderConfiguration) {
        // https://{salesforce-hostname}/services/authcallback/{urlsuffix}
        final String overrideUrl = authProviderConfiguration.get(FIELD_CALLBACK_URL_OVERRIDE);
        final String generatedUrl = URL.getSalesforceBaseUrl().toExternalForm() + RESOURCE_CALLBACK + authProviderConfiguration.get(FIELD_AUTH_PROVIDER_NAME);

        return String.isEmpty(overrideUrl) ? generatedUrl : overrideUrl;
    }

    /*
        Handle callback (from initial loop back "code" step in the flow).
        In the Client Credentials flow, this method retrieves the access token directly.
        Required by parent class.
        Error handling here is a bit painful as the UI never displays the exception or error message 
        supplied here.  The exception is thrown for Logging/Debugging purposes only. 
    */
    public Auth.AuthProviderTokenResponse handleCallback(Map<String, String> authProviderConfiguration, Auth.AuthProviderCallbackState state ) {
        System.debug('### handleCallback');
        final AuthResponse authToken = retrieveToken(authProviderConfiguration);

        if (authToken.statusCode != 200) {
            throw new AuthException(authToken.errorMessage);
        }

        return new Auth.AuthProviderTokenResponse(authProviderConfiguration.get(FIELD_AUTH_PROVIDER_NAME), 
                                                    authtoken.access_token,
                                                    authProviderConfiguration.get(FIELD_CLIENT_SECRET),
                                                    state.queryParameters.get('state')
                                                );
    } 
    
    /**
        Refresh is required by the parent class and it's used if the original Access Token has expired.
        In the Client Credentials flow, there is no Refresh token, so its implementation is exactly the
        same as the Initiate() step.
    **/
    public override Auth.OAuthRefreshResult refresh(Map<String,String> authProviderConfiguration, String refreshToken) {
        System.debug('### refresh');
        final AuthResponse response = retrieveToken(authProviderConfiguration);
        return new Auth.OAuthRefreshResult(response.access_token, response.token_type);
    }

    /**
       Private method that gets the Auth Token using the Client Credentials Flow.
    **/
    private AuthResponse retrieveToken(Map<String,String> authProviderConfiguration) {
         
        System.debug('### retrieveToken');

        HttpRequest authReq = new HttpRequest();
        authReq.setEndpoint(authProviderConfiguration.get(FIELD_AUTH_URL));
        authReq.setHeader('Content-Type', 'application/json');
        authReq.setMethod('POST');
        
        bodyData bd = new bodyData( authProviderConfiguration.get(FIELD_CLIENT_ID), 
                                    authProviderConfiguration.get(FIELD_CLIENT_SECRET), 
                                    'https://' + authProviderConfiguration.get(FIELD_AUDIENCE), 
                                    authProviderConfiguration.get(FIELD_GRANT_TYPE)
                                );
        
        authReq.setBody(JSON.serialize(bd));
        system.debug('### body = ' + authReq.getBody());

        HttpResponse authRes = new HttpResponse();

        try {
            authRes = new Http().send(authReq);   
            AuthResponse authToken = deserializeToken(authRes.getBody());
            authToken.token_type = (authToken.token_type == null) ? DEFAULT_TOKEN_TYPE : authToken.token_type;
            authToken.statusCode = authRes.getStatusCode();
            return authToken;
        } catch (Exception ex) {
            system.debug('### Ex = ' + ex);
            system.debug('### Body = ' + ex.getMessage());

            AuthResponse errorToken = new AuthResponse();
            errorToken.errorMessage = ex.getMessage();
            return errorToken;
        }
    }

    /**
        getUserInfo is required by the Parent class, but not fully supported by this provider.
        Effectively the Client Credentials flow is only useful for Server-to-Server API integrations
        and cannot be used for other contexts such as a Registration Handler for Communities.
     **/
    public Auth.UserData getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response) {
        System.debug('### getUserInfo-was-called');
        final AuthResponse authToken = retrieveToken(authProviderConfiguration);

        final Auth.UserData userData = new Auth.UserData(
              generateRandomString(20) // identifier
            , null // firstName
            , null // lastName
            , null // fullName
            , generateRandomString(10) + '@example.com' // email
            , null // link
            , generateRandomString(10) + '@example.com' // userName
            , null  //locale
            , authProviderConfiguration.get(FIELD_AUTH_PROVIDER_NAME) //provider
            , null // siteLoginUrl
            , new Map<String,String>());


        return userData;
    }

    //deserialize response and return token
    @testVisible
    private AuthResponse deserializeToken(String responseBody) {
        
        System.debug('### Auth Response:' +responseBody);
        
        // Use wrapper class to parse response
        AuthResponse parsedResponse = (AuthResponse)JSON.deserialize(responseBody, AuthResponse.class);
        return parsedResponse;
    }

    private class AuthResponse {
        public String access_token;
        public Integer expires_in;
        public String token_type;
        public Integer statusCode;
        public String errorMessage;
    }

    private class BodyData {
        public String client_id;
        public String client_secret;
        public String audience;
        public String grant_type;
    
        public BodyData(String client_id, String client_secret, String audience, String grant_type) {
            this.client_id = client_id;
            this.client_secret = client_secret;
            this.audience = audience;
            this.grant_type = grant_type;
        }
    }

    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz1234567890';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

    /**
        Custom exception type so we can wrap and rethrow
    **/
    private class AuthException extends Exception {

    }

}