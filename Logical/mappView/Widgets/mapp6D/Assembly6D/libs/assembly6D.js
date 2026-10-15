'use strict';
define([
    'widgets/mapp6D/common/mapp6DWidgetCore/libs/amd/assembly6D',
], function (Assembly6DBundle) {

    var DependenciesClass = function () {
    };

    // static members

    DependenciesClass.dataAccessFactory = function (opcUaNodeBindingEventManager, mpLink, namespace) {
        return new Assembly6DBundle['DataAccessFactoryOpcUa'](opcUaNodeBindingEventManager, mpLink, namespace);
    };
    
    DependenciesClass.componentFactoryOptions = function () {
        return new Assembly6DBundle['ComponentFactoryOptions']();
    };
    
    DependenciesClass.componentFactory = function (dataAccessFactory, options) {
        return new Assembly6DBundle['ComponentFactory'](dataAccessFactory, options);
    };
    
    DependenciesClass.configParser = function (componentFactory, svg) {
        return new Assembly6DBundle['ConfigParser'](componentFactory, svg);
    };

    DependenciesClass.assemblyBuilder = function (configParser, componentFactory, dataAccessFactory, domElement) {
        return new Assembly6DBundle['AssemblyBuilder'](configParser, componentFactory, dataAccessFactory, domElement);
    };

    DependenciesClass.eventOnClickHandler = function (element, mpLink) {
        return new Assembly6DBundle['EventOnClickHandler'](element, mpLink);
    };

    DependenciesClass.SingleSystemAreaDisplayModeEnum = function () {
        return Assembly6DBundle['SingleSystemAreaDisplayModeEnum'];
    }

    return DependenciesClass;
});
