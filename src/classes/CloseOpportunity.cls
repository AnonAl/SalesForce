/**
 * Created by Alexander on 06.05.2021.
 */

public with sharing class CloseOpportunity implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        return Database.getQueryLocator([
                SELECT Id, Name, OwnerId, CloseDate
                FROM Opportunity
                WHERE IsClosed = false AND CloseDate = THIS_MONTH AND (StageName NOT IN ('Closed Won', 'Closed Lost'))
        ]);
    }
    public void execute(Database.BatchableContext bc, List<Opportunity> records) {

        List<Opportunity> opportunities = new List<Opportunity>();

        for (Opportunity opportunity : records) {
            opportunity.StageName = 'Closed Lost';
            opportunities.add(opportunity);
        }
        // System.debug(opportunities);
        update opportunities;

    }
    public void finish(Database.BatchableContext bc) {

    }


}
