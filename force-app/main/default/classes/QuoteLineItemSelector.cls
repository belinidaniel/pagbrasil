/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-09
 * @last modified by  : Hersilio Belini de Oliveira
**/
public with sharing class QuoteLineItemSelector {

    /**
    * @description
    * @author Hersilio Belini de Oliveira | 2025-01-09
    * @param quoteId
    * @return List<QuoteLineItem>
    **/
    public static List<QuoteLineItem> getQuoteLineItemByQuoteId(Id quoteId){
        return [
            SELECT
                Id,
                Product2.Name,
                Order__c,
                ProductFamily__c,
                TotalPrice,
                IsMain__c,
                InitialMonthlyRevenue__c,
                FinalMonthlyRevenue__c
            FROM QuoteLineItem Where QuoteId =: quoteId
           ORDER BY Order__c
        ];
    }
}