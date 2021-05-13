/**
 * Created by Alexander on 06.05.2021.
 */

@IsTest
public with sharing class CloseOpportunityTest {

    @TestSetup
    static void setup() {

        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < 10; i++) {
            opportunities.add(new Opportunity(Name = 'test ' + i, CloseDate = Date.today().addDays(i), StageName = 'Qualification'));
        }
        insert opportunities;

    }
    @IsTest
    static void testBatch() {

        Test.startTest();
        CloseOpportunity closeOpportunity = new CloseOpportunity();
        Database.executeBatch(closeOpportunity);
        Test.stopTest();

        Opportunity opportunity = new Opportunity(CloseDate = Date.today(), StageName = 'Closed Lost');
        Opportunity opportunity1 = [
                SELECT CloseDate, StageName
                FROM Opportunity
                WHERE CloseDate = THIS_MONTH
                // AND StageName = 'Closed Lost'
                LIMIT 1
        ];

        System.assertEquals(opportunity.StageName, opportunity1.StageName);

    }

}
