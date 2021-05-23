/**
 * Created by Alexander on 25.05.2021.
 */
({
    init: function (cmp, event, helper) {
        var action = [{
            label: 'Merge', name: 'merge'
        }];
        cmp.set('v.columns', [
            {label: 'Case Number', fieldName: 'CaseNumber', type: 'number'},
            {label: 'Case Origin', fieldName: 'Origin', type: 'text'},
            {label: 'SuppliedEmail', fieldName: 'SuppliedEmail', type: 'email'},
            {label: 'Status', fieldName: 'Status', type: 'text'},
            {label: 'Reason', fieldName: 'Reason', type: 'text'},
            {label: 'Subject', fieldName: 'Subject', type: 'text'},
            {label: 'Owner', fieldName: 'OwnerId', type: 'text'},
            {
                label: 'Action', type: 'action', typeAttributes:
                    {
                        rowActions: action
                    }
            }
        ]);
        helper.getDubleCase(cmp);
    },

    handleRowAction: function (component, event, helper) {

        var action = event.getParam('action');
        if (action.name !== 'merge') return;

        var row = event.getParam('row');
        component.set('v.duplicateCaseId', row.Id);

        var duplicateCase = component.get('v.duplicateCaseId');

        debugger;
        if (!!row.ParentId &&
            (row.Status === 'In progress' || row.Status === 'On hold') &&
            row.OwnerId !== '03g') {

            component.set('v.isShowModal', true);
        }

        if (duplicateCase.Status === 'New') {
            helper.mergeCase(component);
            helper.sendNotification(component);
            helper.updateCase(component);
        }
    },


    handleModalEvent: function (component, event, helper) {
        debugger;
        var close = event.getParam("closeMdl");
        var isSubmit = event.getParam("submit");
        var isSendNotification = event.getParam("sendNotification");
        component.set("v.isShowModal", close);

        if (!isSubmit) return;

        helper.mergeCase(component);
        helper.updateCase(component);

        if (isSendNotification) {
            helper.sendNotification(component);
        }
    }
})
