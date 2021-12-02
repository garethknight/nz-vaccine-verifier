public with sharing class VerifierMockAPI implements HttpCalloutMock {
	public HttpResponse respond(HttpRequest request) {
		HttpResponse resp = new HttpResponse();
		string contenttype = request.getHeader('Content-Type');
		System.debug('VerifierMockAPI: content type: ' + contenttype);
		string bodystring;
		switch on contentType {
			when 'application/json' {
				bodystring = request.getBody();
			}
			when else {
				bodystring = EncodingUtil.base64Encode(request.getBodyAsBlob());
			}
		}
		//payload string
		System.debug('VerifierMockAPI: bodystring: ' + bodystring);
		if (bodystring.contains('Success')) {
			resp.setStatusCode(200);
			VerifierPayload payload = new VerifierPayload('mike', 'cleaver', '10/12/1987');
			VerifierMetadata metadata = new VerifierMetadata(
				Datetime.now(),
				Datetime.now().adddays(1),
				'issuer',
				'type',
				'id'
			);
			VerifierResponse vresp = new VerifierResponse(true, payload, metadata);
			resp.setBody(JSON.serialize(vresp));
		} else {
			resp.setStatusCode(400);

			List<VerifierDetails> details = new List<VerifierDetails>{
				new VerifierDetails('value', 'msg', 'param', 'location')
			};

			VerifierResponse vresp = new VerifierResponse('code', 'message', details);
			resp.setBody(JSON.serialize(vresp));
		}

		return resp;
	}
}