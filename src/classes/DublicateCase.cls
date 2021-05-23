/**
 * Created by Alexander on 21.05.2021.
 */

public with sharing class DublicateCase {

    @AuraEnabled
    public static List<Case> getDublicateCase(String recordId) {

        Case currentCase = [
                SELECT Id, Subject, Reason, SuppliedEmail
                FROM Case
                WHERE Id = :recordId
        ];


        List<Case> listCases = [
                SELECT CaseNumber,Origin,Subject,
                        SuppliedEmail, Reason, Status, Owner.Name, ParentId, OwnerId
                FROM Case
                WHERE Status != 'Closed'
                AND Subject = :currentCase.Subject
                AND SuppliedEmail = :currentCase.SuppliedEmail
                AND Reason = :currentCase.Reason
                AND Id != :recordId

        ];

        return listCases;
    }

    @AuraEnabled
    public static void updateCase(String recordId) {
        System.debug('asd');
        Case currentCase = [
                SELECT Id, Status
                FROM Case
                WHERE Id = :recordId
        ];
        currentCase.Status = 'Closed';
        update currentCase;
    }

    @AuraEnabled
    public static void notifyUser(String recordId) {

        Case currentCase = [
                SELECT Id, CaseNumber, Status, OwnerId, Owner.Name
                FROM Case
                WHERE Id = :recordId
        ];
        User userOfCase = [
                SELECT Id, Name
                FROM User
                WHERE Id = :currentCase.OwnerId
        ];
        Set<String> user = new Set<String>();
        user.add(userOfCase.Id);

        CustomNotificationType notificationType = [
                SELECT Id, DeveloperName
                FROM CustomNotificationType
                WHERE DeveloperName = 'Notify_the_employee_about_the_closure'
        ];

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Notify for user');
        notification.setBody('Attention: the ' + currentCase.CaseNumber + ' was closed as a duplicate.');
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(recordId);
        notification.send(user);

    }

    @AuraEnabled
    public static void mergeCases(String recordId, String duplicateCaseId) {

        Case currentCase = [
                SELECT Id, Description,Priority, Account.Name, Lead__r.Name,
                        Country__c,SuppliedEmail, ParentId
                FROM Case
                WHERE Id = :duplicateCaseId
        ];
        Case parentCase = [
                SELECT Id, Description,Priority, Account.Name, Lead__r.Name,
                        Country__c,SuppliedEmail, ParentId
                FROM Case
                WHERE Id = :recordId
        ];

        parentCase.Description = '----//----' + currentCase.Description;
        if ((parentCase.Priority == 'Low' && currentCase.Priority != 'Low') ||
                parentCase.Priority == 'Medium' && (currentCase.Priority != 'Low' || currentCase.Priority != 'Medium')) {
            parentCase.Priority = currentCase.Priority;
        }
        if ((currentCase.Lead__r != null || currentCase.Account != null) &&
                (parentCase.Lead__r == null || parentCase.Account == null)) {
            parentCase.Account = currentCase.Account;
            parentCase.Lead__r = currentCase.Lead__r;
        }

        if (parentCase.Country__c == '' && parentCase.SuppliedEmail == '') {
            parentCase.Country__c = currentCase.Country__c;
            parentCase.SuppliedEmail = currentCase.SuppliedEmail;
        }

        currentCase.ParentId = parentCase.Id;
        update currentCase;
        update parentCase;
    }

}

