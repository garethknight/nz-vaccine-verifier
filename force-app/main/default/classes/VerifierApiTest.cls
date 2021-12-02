@istest
public with sharing class VerifierApiTest {
	@istest
	public static void testWithSuccessString() {
		test.setMock(HttpcalloutMock.class, new VerifierMockAPI());
		VerifierResponse resp = VerifierApi.postVerificationRequest('Success', 'application/json');
		System.assertEquals(true, resp.verified);
	}
	@istest
	public static void testWithFailString() {
		test.setMock(HttpcalloutMock.class, new VerifierMockAPI());
		VerifierResponse resp = VerifierApi.postVerificationRequest('Fail', 'application/json');
		System.assertEquals('code', resp.code);
	}
}