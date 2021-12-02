@istest
public with sharing class VerifierUtilsTest {
	@IsTest
	public static void success() {
		test.setMock(HttpcalloutMock.class, new VerifierMockAPI());

		List<String> requestStrings = new List<String>{ 'Success', 'Fail' };
		List<VerifierResponse> responses = VerifierUtils.verifyQRCodes(requestStrings);
		System.assertEquals(2, responses.size());
		System.assertEquals(true, responses[0].verified);
		System.assertEquals(false, responses[1].verified);
	}
}