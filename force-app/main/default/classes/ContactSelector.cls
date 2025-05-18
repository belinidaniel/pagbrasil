/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-13
 * @last modified by  : Hersilio Belini de Oliveira
**/
public with sharing class ContactSelector {

    /**
    * @description get contact
    * @author Hersilio Belini de Oliveira | 2025-01-07
    * @param idAccount
    * @return Contact
    **/
    public static Contact getContactPrincipalByAccountId(Id idAccount) {
        List<Contact> contacts = [
            SELECT
                Id,
                Name,
                Email,
                Phone
            FROM Contact
            WHERE AccountId = :idAccount AND Type__c INCLUDES ('Principal')
            ORDER BY CreatedDate
        ];

        if(contacts.isEmpty()) {
            return null;
        }

        return contacts[0];
    }

    /**
    * @description get contact
    * @author Hersilio Belini de Oliveira | 2025-01-07
    * @param idAccount
    * @return Contact
    **/
    public static List<Contact> getContactsByAccountId(Id idAccount) {
        return [
            SELECT
                Id,
                Name,
                Email,
                Phone,
                Type__c
            FROM Contact
            WHERE AccountId = :idAccount
        ];
    }
}