@istest
public with sharing class VerifierUtilsFileTest {
	@istest
	public static void VerifierUtilsFileTest() {
		test.setMock(HttpcalloutMock.class, new VerifierMockAPI());

		Contentversion cv = new Contentversion(
			Title = 'ABC',
			PathOnClient = 'test.jpg',
			VersionData = EncodingUtil.base64Decode('Success')
		);
		insert cv;
		test.startTest();
		List<VerifierResponse> results = VerifierUtilsFile.verifyQRCodes(new List<Id>{ cv.id });
		test.stopTest();
		System.assertEquals(1, results.size());
		System.assertEquals(true, results[0].verified);
	}
}