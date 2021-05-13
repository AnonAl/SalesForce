/**
 * Created by Alexander on 06.05.2021.
 */

public with sharing class ScheduleCloseOpportunity implements Schedulable {

    public void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new CloseOpportunity());

    }

}
