/**
 * @description       : 
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-25-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
**/
public class VerifierUtils {

    @InvocableMethod(
        callout=true
        label = 'verifyQRCode'
        description = 'After scanning a NZ Covid Verification QR code, vaccination status & My Vaccine Pass detail is returned'
    )
    public static List<VerifierResponse> verifyQRCodes(List<String> encodedQRCodes) {
        List<VerifierResponse> vrs = new List<VerifierResponse>();
        for (String encodedQRCode : encodedQRCodes) {
            vrs.add(postVerificationRequest(encodedQRCode));
        }
        return vrs; 
    }

    private static VerifierResponse postVerificationRequest(String encodedQRCode) {

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Mattr');
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

        VerifierResponse vr = (VerifierResponse)JSON.deserialize(res.getBody(), VerifierResponse.class);
        system.debug('### vr = ' + vr);
        return vr;
    }
}