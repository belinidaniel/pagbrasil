@isTest
public class StringUtilTest {

	@isTest
	static void testRemoveAccents(){
		String noAccents = StringUtil.removeAccents('ÁÀÂÃÄÅáàâãäåÉÈÊËéèêëÍÌÎÏíìîïÓÒÔÕÖóòôõöÚÙÛÜúùûüÇçÑñ');
		System.assertEquals(noAccents, 'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuCcNn');
	}    

	@isTest
	static void testReplaceCaracteresSpecials_allAccentExamples() {
		String input = 'Áá Éé Íí Óó Úú Çç @#%!';
		String expected = 'Aa_Ee_Ii_Oo_Uu_Cc_____';

		String result = StringUtil.replaceCaracteresSpecials(input, '_');

		System.assertEquals(expected, result, 'Should normalize accented vowels and replace special characters with underscores');
    }
}