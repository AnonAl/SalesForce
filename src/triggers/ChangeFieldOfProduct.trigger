/**
 * Created by Alexander on 12.05.2021.
 */

trigger ChangeFieldOfProduct on Product2 (after update) {

    Product2Handler product2Handler = new Product2Handler();

    if (Trigger.isAfter) {
        if (Trigger.IsUpdate) {
            product2Handler.handler(Trigger.newMap, Trigger.oldMap);
        }
    }

}