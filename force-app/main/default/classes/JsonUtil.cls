/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2025-01-09
 * @last modified by  : Hersilio Belini de Oliveira
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   2021-06-29   Hersilio Belini de Oliveira   Initial Version
 **/
public without sharing class JsonUtil {

    /**
     * @description
     * @author Hersilio Belini de Oliveira | 2021-06-29
     * @param jsonValue para buscar o nó
     * @param nodeToSearch nó do json que quer obter o valor. exemplo data.param1
     * @return valor do nó no formato json
     **/
    public static String getNode(String jsonValue, String nodeToSearch) {
        List<String> nodes = new List<String>();

        if (nodeToSearch.indexOf('.') > -1) {
            nodes = nodeToSearch.split('\\.');
        } else {
            nodes.add(nodeToSearch);
        }

        Map<String, Object> cObjMap;

        for (String node : nodes) {
            try {
                cObjMap = (Map<String, Object>) JSON.deserializeUntyped(
                    jsonValue
                );
                
            } catch (Exception ex) {
                System.debug('error: ' + ex); // node não é um json
            }

            jsonValue = JSON.serialize(cObjMap.get(node));
        }

        return jsonValue.replace('"', '');
    }
}