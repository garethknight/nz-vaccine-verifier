public with sharing class VerifierAPI {
	public static VerifierResponse postVerificationRequest(String payload, string contentType) {
		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:Mattr');
		req.setHeader('Content-Type', contentType);
		req.setMethod('POST');
		req.setBody('{"payload": "' + payload + '"}');

		system.debug('VerifierAPI: postVerificationRequest: req: ' + req);

		return sendRequest(req);
	}

	public static VerifierResponse postVerificationRequest(blob payload, string contentType) {
		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:Mattr');
		req.setHeader('Content-Type', contentType);
		req.setMethod('POST');
		req.setBodyasBlob(payload);

		system.debug('VerifierAPI: postVerificationRequest: req: ' + req);

		return sendRequest(req);
	}

	private static VerifierResponse sendRequest(HttpRequest req) {
		Http h = new Http();
		HttpResponse res = new HttpResponse();

		try {
			res = h.send(req);
			system.debug('VerifierAPI: sendRequest: res = ' + res);
		} catch (Exception e) {
			system.debug('VerifierAPI: sendRequest: Exception = ' + e.getMessage());
		}
		system.debug('VerifierAPI: sendRequest: res.getBody = ' + res.getBody());
		switch on res.getStatusCode() {
			when 200 {
				return (VerifierResponse) JSON.deserialize(res.getBody(), VerifierResponse.class);
			}
			when else {
				system.debug('VerifierAPI: sendRequest: status was ' + res.getStatusCode() + ', res: ' + res);
				try {
					return (VerifierResponse) JSON.deserialize(res.getBody(), VerifierResponse.class);
				} catch (Exception e) {
					system.debug('VerifierAPI: sendRequest: couldn\'t parse response, faking it');
					return new verifierResponse(false, null, null);
				}
			}
		}
	}
}
