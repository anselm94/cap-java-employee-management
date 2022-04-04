sap.ui.define(["sap/fe/core/AppComponent"], AppComponent => AppComponent.extend("profile.Component", {
    metadata:{ manifest:'json' },
    init: function() {
        var oHashChanger = sap.ushell.Container.getService("ShellNavigation").hashChanger;
        oHashChanger.replaceHash('Employee(ID=236a30f4-0504-49fc-92db-c1719ce05bc4,IsActiveEntity=true)'); 
        AppComponent.prototype.init.apply(this, arguments);                     
    }
}))
