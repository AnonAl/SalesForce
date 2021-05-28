/**
 * Created by Alexander on 17.05.2021.
 */
@IsTest
public with sharing class Product2HandlerTest {

    private static Id oppId, productId;

    @TestSetup
    static void setup() {

        Id pricebook2 = Test.getStandardPricebookId();

        Product2 lProduct2s = new Product2(
                Name = 'Onnii ',
                Price__c = 1000,
                IsActive = true,
                ProductCode = '11232');
        insert lProduct2s;
        productId = lProduct2s.Id;

        Opportunity opportunity = new Opportunity(
                Name = 'Oppo',
                StageName = 'Closed Won',
                CloseDate = Date.today().addDays(4)
        );
        insert opportunity;
        oppId = opportunity.Id;

        PricebookEntry pricebookEntries = new PricebookEntry(
                Product2Id = lProduct2s.Id,
                Pricebook2Id = pricebook2,
                UnitPrice = 1000,
                IsActive = true
        );
        insert pricebookEntries;

        OpportunityLineItem opportunityLineItems = new OpportunityLineItem(
                OpportunityId = opportunity.Id,
                Product2Id = lProduct2s.Id,
                PricebookEntryId = pricebookEntries.Id,
                Quantity = 1,
                UnitPrice = 1000
        );
        insert opportunityLineItems;

        Task task = new Task(
                Subject = 'Old model deal!!!',
                Status = 'New',
                WhatId = opportunity.Id,
                Auto_created__c = true,
                ActivityDate__c = Date.today(),
                Priority = 'High'
        );

        lProduct2s.IsActive = false;
        update lProduct2s;

    }

    @IsTest
    static void test() {

        Product2 product2 = [
                SELECT Id, Name
                FROM Product2
                LIMIT 1
        ];

        OpportunityLineItem opportunityLineItems = [
                SELECT Name, Product2Id, OpportunityId
                FROM OpportunityLineItem
                WHERE Product2Id = :product2.Id
                LIMIT 1
        ];
        Opportunity opportunity = [
                SELECT Id, Name, StageName
                FROM Opportunity
                WHERE Id = :opportunityLineItems.OpportunityId
                LIMIT 1
        ];


        Task task = [
                SELECT WhatId, Priority
                FROM Task
                WHERE WhatId = :oppId
                LIMIT 1
        ];

        System.assertEquals(null, task);
        System.assertEquals(task.WhatId, oppId);

    }

}
