@IsTest(SeeAllData = true)
public with sharing class LightningForgotPasswordControllerTest {

 /* Verifies that ForgotPasswordController handles invalid usernames appropriately */
 @IsTest
 static void testLightningForgotPasswordControllerInvalidUserName() {
  System.assertEquals(LightningForgotPasswordController.forgotPassword('fakeUser', 'http://a.com'), Label.Site.invalid_email);
  System.assertEquals(LightningForgotPasswordController.forgotPassword(null, 'http://a.com'), Label.Site.invalid_email);
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a', '/home/home.jsp'), Label.Site.invalid_email);
 }

 /* Verifies that null checkEmailRef url throws proper exception. */
 @IsTest
 static void testLightningForgotPasswordControllerWithNullCheckEmailRef() {
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a', null), 'Argument 1 cannot be null');
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a@salesforce.com', null), 'Argument 1 cannot be null');
 }

 /* Verifies that LightningForgotPasswordController object is instantiated correctly. */
 @IsTest
 static void LightningForgotPasswordControllerInstantiation() {
  LightningForgotPasswordController controller = new LightningForgotPasswordController();
  System.assertNotEquals(controller, null);
 }
    
    /* Verifica que setExperienceId retorna null quando null é passado */
    @IsTest
    static void testSetExperienceIdWithNull() {
        String result = LightningForgotPasswordController.setExperienceId(null);
        System.assertEquals(null, result, 'Deve retornar null quando ExperienceId é null');
    }
    
    /* Verifica que setExperienceId retorna mensagem de erro para ExperienceId inválido */
    @IsTest
    static void testSetExperienceIdWithInvalidId() {
        // Dependendo da implementação de Site.setExperienceId, pode lançar exceção para IDs inválidos
        // Simule um valor que cause erro, se aplicável
        String result = LightningForgotPasswordController.setExperienceId('invalid_id');
        // O resultado esperado depende da mensagem de erro lançada pela plataforma
        // Exemplo genérico:
        System.assert(result != null, 'Deve retornar mensagem de erro para ExperienceId inválido');
    }
}