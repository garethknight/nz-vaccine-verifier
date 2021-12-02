/**
 * @description       : 
 * @author            : Gareth Knight - gknight@salesforce.com
 * @group             : 
 * @last modified on  : 11-25-2021
 * @last modified by  : Gareth Knight - gknight@salesforce.com
**/
public class VerifierUtilsFile{

    @InvocableMethod(
        callout=true
        label = 'verifyQRCode'
        description = 'After scanning a NZ Covid Verification QR code, vaccination status & My Vaccine Pass detail is returned'
    )
    public static List<VerifierResponse> verifyQRCodes(List<String> ContentIds) {
        List<VerifierResponse> vrs = new List<VerifierResponse>();
        for (String ContentId : ContentIds) {
          
            
                ContentVersion cv = [select versiondata, FileExtension from contentversion where id = :ContentId][0];
                blob body = cv.versiondata ;
                
                if(cv.FileExtension=='png'){
                    vrs.add(verifierapi.postVerificationRequest(body, 'image/png')); 
                }
                else if(cv.FileExtension=='pdf'){
                    vrs.add(verifierapi.postVerificationRequest(body, 'application/pdf')); 
                }
                else if(cv.FileExtension=='jpg'){
                    vrs.add(verifierapi.postVerificationRequest(body, 'image/jpg')); 
                }
                else if(cv.FileExtension=='jpeg'){
                    vrs.add(verifierapi.postVerificationRequest(body, 'image/jpg'));
                    
                }
                else{return null;}
                }
        
        return vrs; 
    }

}