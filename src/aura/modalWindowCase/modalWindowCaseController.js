/**
 * Created by Alexander on 26.05.2021.
 */
({

    submitDetails: function (component, event, helper) {
        var valCheck = component.find('check').get('v.value');
        //console.log(valCheck);
        var compEvent = component.getEvent("modalHandler");
        compEvent.setParams({"sendNotification": valCheck});
        compEvent.setParams({"closeMdl": false});
        compEvent.setParams({"submit": true});
        compEvent.fire();

    },

    onCloseModal: function (component, event, helper) {
        var compEvent = component.getEvent("modalHandler");
        compEvent.setParams({"closeMdl": false});
        compEvent.setParams({"submit": false});
        compEvent.fire();
    }

})
