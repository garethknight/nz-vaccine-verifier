/**
 * @description       : 
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-25-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
**/
public class VerifierUtils {

    //@future(callout=true)
    @InvocableMethod(
        callout=true
        label = 'verifyQRCode'
        description = 'After scanning a NZ Covid Verification QR code, then vaccination status is returned'
    )
    public static List<VerifierResponse> verifyQRCodes(List<String> encodedQRCodes) {
        List<VerifierResponse> vrs = new List<VerifierResponse>();
        for (String encodedQRCode : encodedQRCodes) {
            vrs.add(postVerificationRequest(encodedQRCode));
        }
        return vrs; 
    }


    private static VerifierResponse postVerificationRequest(String encodedQRCode) {

        /*Mattr_Identity__mdt mattrId = Mattr_Identity__mdt.getInstance('Mattr');

        Http authH = new Http();
        HttpRequest authReq = createAuthRequest(mattrId);
        HttpResponse authRes = new HttpResponse();

        try {
            authRes = authH.send(authReq);            
        } catch (Exception ex) {
            system.debug('### Ex = ' + ex);
            system.debug('### Body = ' + ex.getMessage());
        }
        

        AuthResponse ar = (AuthResponse)JSON.deserialize(authRes.getBody(), AuthResponse.class);
        system.debug('### ar = ' + ar);
        */

        //String mattrEndpoint = ''; //TODO Custom Setting to store individual endpoint
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //req.setEndpoint('https://' + mattrId.Tenant_Subdomain__c + '.' + mattrId.Audience__c + mattrId.Verify_URL_Suffix__c);
        req.setEndpoint('callout:Mattr');
        //req.setHeader('Authorization', 'Bearer ' + ar.access_token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');

        req.setBody('{"payload": "' + encodedQRCode + '"}');

        system.debug('### req = ' + req);
        system.debug('### req.body = ' + req.getBody());


        HttpResponse res = new HttpResponse();

        try {
            res = h.send(req);
            system.debug('### res = ' + res);
        } catch (Exception e) {
            system.debug('### Exception = ' + e.getMessage());
        }
        system.debug('### res.getBopdy = ' + res.getBody());
        //return res;

        VerifierResponse vr = (VerifierResponse)JSON.deserialize(res.getBody(), VerifierResponse.class);
        /*Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        VerifierResponse vr = new VerifierResponse();
        vr.verified = (Boolean)resMap.get('verified');
        vr.payload = new VerifierResponse.payload();
        Map<String, Object> resPayload = resMap.get('payload');
        vr.payload.givenName = resPayload.get('givenName');*/
        system.debug('### vr = ' + vr);
        return vr;
    }

    //@future(callout=true)
 /*   private static HttpRequest createAuthRequest(Mattr_Identity__mdt mattrId) {
        
        //Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(mattrId.Auth_URL__c);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        
        bodyData bd = new bodyData(mattrId.Client_Id__c, mattrId.Client_Secret__c, 'https://' + mattrId.Audience__c, mattrId.Grant_Type__c);
        
        req.setBody(JSON.serialize(bd));
        system.debug('### body = ' + req.getBody());
        
        return req;
        //HttpResponse res = new HttpResponse();

        //res = h.send(req);
        //system.debug('### res = ' + res);
        //system.debug('### res. getError = ' + res.getBody());

        
    }*/
/*
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

    private class AuthResponse {
        public String access_token;
        public Integer expires_in;
        public String token_type;
    }*/
}