/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2024-10-23
 * @last modified by  : Hersilio Belini de Oliveira
**/
public without sharing class LoggerBase {

    public static void log ( String message ) {
        System.debug( LoggingLevel.INFO, message );
    }

    public static void error ( String message ) {
        System.debug( LoggingLevel.ERROR, message );
    }

    public static void debug ( String message ) {
        System.debug( LoggingLevel.DEBUG, message );
    }

    public static void warn ( String message ) {
        System.debug( LoggingLevel.WARN, message );
    }
}