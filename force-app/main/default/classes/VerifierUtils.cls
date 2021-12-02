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
            vrs.add(VerifierAPI.postVerificationRequest(encodedQRCode, 'application/json'));
        }
        return vrs; 
    }

    
}
