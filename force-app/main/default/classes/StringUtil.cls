/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-22
 * @last modified by  : Hersilio Belini de Oliveira
**/
public with sharing class StringUtil {
    public static String removeAccents(String input) {
        if (String.isBlank(input)) {
            return input;
        }

        // Mapeia os caracteres acentuados e suas versões sem acento
        Map<String, String> accentMap = new Map<String, String>{
            'Á' => 'A', 'À' => 'A', 'Â' => 'A', 'Ã' => 'A', 'Ä' => 'A', 'Å' => 'A',
            'á' => 'a', 'à' => 'a', 'â' => 'a', 'ã' => 'a', 'ä' => 'a', 'å' => 'a',
            'É' => 'E', 'È' => 'E', 'Ê' => 'E', 'Ë' => 'E',
            'é' => 'e', 'è' => 'e', 'ê' => 'e', 'ë' => 'e',
            'Í' => 'I', 'Ì' => 'I', 'Î' => 'I', 'Ï' => 'I',
            'í' => 'i', 'ì' => 'i', 'î' => 'i', 'ï' => 'i',
            'Ó' => 'O', 'Ò' => 'O', 'Ô' => 'O', 'Õ' => 'O', 'Ö' => 'O',
            'ó' => 'o', 'ò' => 'o', 'ô' => 'o', 'õ' => 'o', 'ö' => 'o',
            'Ú' => 'U', 'Ù' => 'U', 'Û' => 'U', 'Ü' => 'U',
            'ú' => 'u', 'ù' => 'u', 'û' => 'u', 'ü' => 'u',
            'Ç' => 'C', 'ç' => 'c',
            'Ñ' => 'N', 'ñ' => 'n'
        };

        // Converte o input substituindo os caracteres
        String result = input;
        for (String accentedChar : accentMap.keySet()) {
            result = result.replaceAll(accentedChar, accentMap.get(accentedChar));
        }

        return result;
    }

    /**
    * @description replace Caracteres Speciais
    * @author Hersilio Belini de Oliveira | 2025-01-22
    * @param input
    * @param replaceInput
    * @return String
    **/
    public static String replaceCaracteresSpecials(String input, String replaceInput){
        if (String.isBlank(input)) {
            return '';
        }

        // Substituir caracteres com acento e 'ç' pelos equivalentes sem acento
        input = removeAccents(input);
        input = input.replace(' ', replaceInput);

        // Remover caracteres especiais, deixando apenas letras, números, espaços e '_'
        input = input.replaceAll('[^a-zA-Z0-9_ ]', replaceInput);

        return input;
    }
}