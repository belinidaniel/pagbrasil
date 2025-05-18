/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-02-28
 * @last modified by  : Hersilio Belini de Oliveira
**/
public with sharing class RccService {

    @invocableMethod
    public static List<FlowOutput> getResult(List<FlowInput> rccData){
        FlowInput input = rccData[0];
        Integer score = 0;

        List<Settings_RCC__mdt> rccQuestions = !Test.isRunningTest() ? [SELECT Id, DeveloperName, Calcula_Risco__c, Pergunta__c FROM Settings_RCC__mdt] : new List<Settings_RCC__mdt>{ new Settings_RCC__mdt(Calcula_Risco__c = true, Pergunta__c = 'Question') };

        List<String> questions = input.questionsAndResponse;

        for(String question : questions){
            if(question == '-')
                continue;

            for(Settings_RCC__mdt rccQuestion : rccQuestions){
                if(rccQuestion.Pergunta__c == question.split('|')[0]){
                    if(rccQuestion.Calcula_Risco__c){
                        String response = question.split('|')[1];
                        score += response == 'Sim' ? input.segmentRisk : response == 'Em Partes' ? input.segmentRisk * 2 : input.segmentRisk * 5;
                    }

                    break;
                }
            }
        }

        return new List<FlowOutput>{new FlowOutput(score)};
    }

    public class FlowInput {
        @InvocableVariable(required=true)
        public List<String> questionsAndResponse;

        @InvocableVariable(required=true)
        public String responseOne;

        @InvocableVariable(required=true)
        public String responseTwo;

        @InvocableVariable(required=true)
        public String responseThree;

        @InvocableVariable(required=true)
        public Opportunity opp;

        @InvocableVariable(required=true)
        public Integer segmentRisk;
    }

    public class FlowOutput {
        @InvocableVariable(required=true)
        public Integer score;

        public FlowOutput(Integer score){
            this.score = score;
        }
    }
}