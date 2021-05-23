/**
 * Created by Alexander on 25.05.2021.
 */
({

    getDubleCase: function (component) {
        var action = component.get("c.getDublicateCase");
        var recordId = component.get('v.recordId');
        action.setParams({recordId: recordId});
        action.setCallback(this, function (response) {
            var status = action.getState();
            if (status === "SUCCESS") {
                component.set("v.data", action.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    updateCase: function (component, event) {
        var duplicateCaseId = component.get('v.duplicateCaseId');
        var updateCs = component.get("c.updateCase");
        updateCs.setParams({"recordId": duplicateCaseId});
        updateCs.setCallback(this, function (response) {
            var status = response.getState();
            if (status === 'SUCCESS') {
            }
        });
        $A.enqueueAction(updateCs);
    },

    sendNotification: function (component, event) {
        var recordId = component.get('v.recordId');
        var sendNotify = component.get("c.notifyUser");
        sendNotify.setParams({"recordId": recordId});
        sendNotify.setCallback(this, function (response) {
            var status = response.getState();
            if (status === 'SUCCESS') {
                // $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(sendNotify);
    },

    mergeCase: function (component, event) {
        var recordId = component.get('v.recordId');
        var duplicateCaseId = component.get('v.duplicateCaseId');

        var mergeCase = component.get("c.mergeCases");
        mergeCase.setParams({"recordId": recordId, "duplicateCaseId": duplicateCaseId});
        mergeCase.setCallback(this, function (response) {
            var status = response.getState();
            if (status === 'SUCCESS') {

            }
        });
        $A.enqueueAction(mergeCase);
    }
})
