/**
 * Created by Alexander on 13.05.2021.
 */

public with sharing class Product2Handler {


    public void handler(Map<Id, Product2> newProducts, Map<Id, Product2> oldProducts) {

        List<Id> opporIds = new List<Id>();
        Set<Id> newProdIds = new Set<Id>();

        for (Id prodId : oldProducts.keySet()) {
            if (newProducts.get(prodId).IsActive != oldProducts.get(prodId).IsActive &&
                    !newProducts.get(prodId).IsActive) {
                newProdIds.add(prodId);
            }
        }

        List<OpportunityLineItem> opportunityProduct = [
                SELECT Id, Product2Id, OpportunityId
                FROM OpportunityLineItem
                WHERE Product2Id IN :newProdIds
        ];

        List <Opportunity> opportunities = [
                SELECT Id, Name, StageName, Account.Phone
                FROM Opportunity
                WHERE Id IN :getOppIdsFromOppLineItems(opportunityProduct)
        ];

        createTaskToOpportunity(opportunities);

    }
    public List<Id> getOppIdsFromOppLineItems(List<OpportunityLineItem> opportunityLineItems) {
        List<Id> opportunityIds = new List<Id>();
        for (OpportunityLineItem opportunityLineItem : opportunityLineItems) {
            opportunityIds.add(opportunityLineItem.OpportunityId);
        }
        return opportunityIds;
    }

    public void createTaskToOpportunity(List<Opportunity> opportunities) {

        List<Task> tasks = new List<Task>();
        Id RecordTypeID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Call').getRecordTypeId();

        for (Opportunity opportunity : opportunities) {
            tasks.add(new Task(RecordTypeId = RecordTypeID,
                    Subject = 'Old model deal!!!', Status = 'New', WhatId = opportunity.Id,
                    Auto_created__c = true, ActivityDate__c = Date.today(), Phone__c = opportunity.Account.Phone,
                    Priority = 'High'));
        }
        insert tasks;
    }

}
