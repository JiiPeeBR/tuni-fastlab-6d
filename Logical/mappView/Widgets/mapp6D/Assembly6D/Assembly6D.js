'use strict';
define([
    'brease',
    'widgets/mapp6D/Assembly6D/libs/assembly6D',
    'widgets/mapp6D/Assembly6D/libs/trafficManager',
    'widgets/mapp6D/Assembly6D/libs/FileLoader',
    'widgets/mapp6D/Assembly6D/libs/collections/ProductLabel',
    'widgets/mapp6D/common/libs/mapp6DShared',
    'widgets/mapp6D/OpcUaNodeBindingEventManager/OpcUaNodeBindingEventManager',
    'widgets/mapp6D/OpcUaNodeBindingEventManager/libs/Constants',
], function ({
    config,
    core: { BaseWidget },
    controller: { widgetRegistry }
}, Assembly6DDependencies, TrafficManagerDependencies, FileLoader, ProductLabel, mapp6DSharedDependencies, OpcUaNodeBindingEventManager, OpcUaConstants) {

    /**
    * @class widgets.mapp6D.Assembly6D
    * #Description
    * Assembly that represents the layout with the segments and shuttles
    * of an ACOPOS6D.
    * @extends brease.core.BaseWidget
    *
    * @iatMeta category:Category
    * Assembly
    * @iatMeta description:de
    * Widget für ein mapp6D Assembly
    * @iatMeta description:en
    * Widget for a mapp6D assembly
    */
       
    /**
    * @cfg {MpComIdentReference} mpLink={}
    * @iatStudioExposed
    * @iatCategory Data
    * @subtype Assembly6D
    * Link to the Assembly6D
    */

    /**
    * @cfg {MpComIdentReference} mpLinkTrafficManager={}
    * @iatStudioExposed
    * @iatCategory Data
    * @subtype TrafficManager
    * Link to the TrafficManager
    */

    /**
    * @cfg {Boolean} showAdditionalShuttleInfo=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the additional information of the shuttles should be displayed
    */

    /**
    * @cfg {Boolean} showStateShuttleInfo=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the state information of the shuttles should be displayed
    */

    /**
    * @cfg {Boolean} showXAxisShuttleInfo=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the x axis information of the shuttles should be displayed
    */

    /**
    * @cfg {Boolean} showYAxisShuttleInfo=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the y axis information of the shuttles should be displayed
    */

    /**
    * @cfg {Boolean} showZAxisShuttleInfo=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the z axis information of the shuttles should be displayed
    */

    /**
    * @cfg {Boolean} showRxAxisShuttleInfo=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the Rx axis information of the shuttles should be displayed
    */

    /**
    * @cfg {Boolean} showRyAxisShuttleInfo=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the Ry axis information of the shuttles should be displayed
    */

    /**
    * @cfg {Boolean} showRzAxisShuttleInfo=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the Rz axis information of the shuttles should be displayed
    */

    /**
    * @cfg {Boolean} showTrafficManager=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the traffic manager should be displayed
    */

    /**
    * @cfg {Boolean} showAdditionalTrafficManagerInfo=false
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the additional information of the traffic manager should be displayed
    */

    /**
    * @cfg {Boolean} showCoordinateSystem=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the coordinate system should be displayed
    */

    /**
    * @cfg {Boolean} showZones=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the zones should be displayed
    */

    /**
    * @cfg {Boolean} showPowerSectors=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the power sectors should be displayed
    */

    /**
    * @cfg {Boolean} showStereotypes=true
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * Specifies whether the stereotypes should be displayed
    */

    /**
    * @cfg {widgets.mapp6D.Assembly6D.ProductLabel} productLabel={}
    * @iatStudioExposed
    * @iatCategory Collections
    * Specifies the shuttle appearance based on its product label
    * @iatMeta StructuredProperty:true
    * @iatMeta minSize:0
    * @iatMeta maxSize:500
    */

    var defaultSettings = {
            mpLink: {},
            mpLinkTrafficManager: {},
            productLabel: {},
            showAdditionalShuttleInfo: true,
            showStateShuttleInfo: true,
            showXAxisShuttleInfo: true,
            showYAxisShuttleInfo: true,
            showZAxisShuttleInfo: true,
            showRxAxisShuttleInfo: true,
            showRyAxisShuttleInfo: true,
            showRzAxisShuttleInfo: true,
            showTrafficManager: true,
            showAdditionalTrafficManagerInfo: false,
            showCoordinateSystem: true,
            showZones: true,
            showPowerSectors: true,
            showStereotypes: true
        },
    
        WidgetClass = BaseWidget.extend(function Assembly6D() {
            BaseWidget.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    const FILE_DEVICE_NAME = '6DData';
    
    p.init = function () {

        if (this.settings.omitClass !== true) {
            this.addInitialClass('mapp6DAssembly6D');
        }

        this.fileLoader = new FileLoader(this, this.getSvgFileName(this.getMpLink()), FILE_DEVICE_NAME);
        if (typeof this.settings.mpLinkTrafficManager === 'string') {
            this.fileLoaderTrafficManager = new FileLoader(this, this.getSvgFileName(this.getMpLinkTrafficManager()), FILE_DEVICE_NAME);
        } else {
            this.fileLoaderTrafficManager = null;
        }
        this._assembly6DDataAccessFactory = null;
        this._assembly = null;
        this._trafficManagerDataAccessFactory = null;
        this._trafficManager = null;
        this._trafficManagerComponentFactory = null;
        this._initContent = false;
        this._widgetBuilder = null;

        if (config.editMode) {
            _addPlaceholderImage(this);
        } else if (!config.preLoadingState && this._assembly === null) {
            this._loadSvg();
        }
        
        BaseWidget.prototype.init.call(this);
    };

    p.dispose = function () {
        if (this._assembly6DDataAccessFactory !== null) {
            this._assembly6DDataAccessFactory.getDataAccessContainer().removeSubscriptions();
            this._assembly6DDataAccessFactory = null;
        }

        if (this._trafficManagerDataAccessFactory !== null) {
            this._trafficManagerDataAccessFactory.getDataAccessContainer().removeSubscriptions();
            this._trafficManagerDataAccessFactory = null;
        }

        if (this._assembly !== null) {
            this._assembly.dispose();
            this._assembly = null;
        }

        if (this._trafficManager !== null) {
            this._trafficManager.dispose();
            this._trafficManager = null;
        }
        
        this._trafficManagerComponentFactory = null;
        this._widgetBuilder = null;
        
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    p.onBeforeSuspend = function () {
        if (this._assembly6DDataAccessFactory !== null) {
            this._assembly6DDataAccessFactory.getDataAccessContainer().removeSubscriptions();
        }
        BaseWidget.prototype.onBeforeSuspend.apply(this, arguments);
    };

    p.wake = function () {
        if (this.internalData.preLoaded && this._assembly === null && !this._initContent) {
            this._loadSvg();
        } else if (this._assembly6DDataAccessFactory !== null) {
            this._assembly6DDataAccessFactory.getDataAccessContainer().addSubscriptions();
        }
        BaseWidget.prototype.wake.apply(this, arguments);
    };
    
    /**
    * @method setMpLink
    * @param {MpComIdentReference} mpLink
    * Sets the name of the MpLink.
    */
    p.setMpLink = function (mpLink) {
        this.settings.mpLink = mpLink;
    };

    /**
    * @method getMpLink
    * @return {MpComIdentReference}
    * Gets the name of the MpLink.
    */
    p.getMpLink = function () {
        return this.settings.mpLink.replace(/^mapp6D::/, '');
    };

    /**
    * @method setMpLinkTrafficManager
    * @param {MpComIdentReference} mpLinkTrafficManager
    * Sets the name of the MpLink.
    */
    p.setMpLinkTrafficManager = function (mpLink) {
        this.settings.mpLinkTrafficManager = mpLink;
    };

    /**
    * @method getMpLinkTrafficManager
    * @return {MpComIdentReference}
    * Gets the name of the MpLink for a TrafficManager.
    */
    p.getMpLinkTrafficManager = function () {
        return this.settings.mpLinkTrafficManager.replace(/^mapp6D::/, '');
    };

    /**
    * @method setShowAdditionalShuttleInfo
    * @iatStudioExposed
    * @param {Boolean} showAdditionalShuttleInfo
    * Sets the flag to show the additional shuttle information.
    */
    p.setShowAdditionalShuttleInfo = function (showAdditionalShuttleInfo) {
        this.settings.showAdditionalShuttleInfo = showAdditionalShuttleInfo;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.shuttle.showAdditionalInformation = showAdditionalShuttleInfo;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.shuttles.forEach(function (shuttle) {
                shuttle.svg.applyOptions(options.shuttle);
            });
        }
    };

    /**
    * @method getShowAdditionalShuttleInfo
    * @return {Boolean}
    * Gets the flag to show the additional shuttle information.
    */
    p.getShowAdditionalShuttleInfo = function () {
        return this.settings.showAdditionalShuttleInfo;
    };

    /**
    * @method setShowStateShuttleInfo
    * @iatStudioExposed
    * @param {Boolean} showStateShuttleInfo
    * Sets the flag to show the additional shuttle information for the state.
    */
    p.setShowStateShuttleInfo = function (showStateShuttleInfo) {
        this.settings.showStateShuttleInfo = showStateShuttleInfo;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.shuttle.showState = showStateShuttleInfo;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.shuttles.forEach(function (shuttle) {
                shuttle.svg.applyOptions(options.shuttle);
            });
        }
    };

    /**
    * @method getShowStateShuttleInfo
    * @return {Boolean}
    * Gets the flag to show the additional shuttle information for the state.
    */
    p.getShowStateShuttleInfo = function () {
        return this.settings.showStateShuttleInfo;
    };

    /**
    * @method setShowXAxisShuttleInfo
    * @iatStudioExposed
    * @param {Boolean} showXAxisShuttleInfo
    * Sets the flag to show the additional shuttle information for the x axis.
    */
    p.setShowXAxisShuttleInfo = function (showXAxisShuttleInfo) {
        this.settings.showXAxisShuttleInfo = showXAxisShuttleInfo;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.shuttle.showPosition.x = showXAxisShuttleInfo;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.shuttles.forEach(function (shuttle) {
                shuttle.svg.applyOptions(options.shuttle);
            });
        }
    };

    /**
    * @method getShowXAxisShuttleInfo
    * @return {Boolean}
    * Gets the flag to show the additional shuttle information for the x axis.
    */
    p.getShowXAxisShuttleInfo = function () {
        return this.settings.showXAxisShuttleInfo;
    };

    /**
    * @method setShowYAxisShuttleInfo
    * @iatStudioExposed
    * @param {Boolean} showYAxisShuttleInfo
    * Sets the flag to show the additional shuttle information for the x axis.
    */
    p.setShowYAxisShuttleInfo = function (showYAxisShuttleInfo) {
        this.settings.showYAxisShuttleInfo = showYAxisShuttleInfo;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.shuttle.showPosition.y = showYAxisShuttleInfo;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.shuttles.forEach(function (shuttle) {
                shuttle.svg.applyOptions(options.shuttle);
            });
        }
    };

    /**
    * @method getShowYAxisShuttleInfo
    * @return {Boolean}
    * Gets the flag to show the additional shuttle information for the x axis.
    */
    p.getShowYAxisShuttleInfo = function () {
        return this.settings.showYAxisShuttleInfo;
    };

    /**
    * @method setShowZAxisShuttleInfo
    * @iatStudioExposed
    * @param {Boolean} showZAxisShuttleInfo
    * Sets the flag to show the additional shuttle information for the x axis.
    */
    p.setShowZAxisShuttleInfo = function (showZAxisShuttleInfo) {
        this.settings.showZAxisShuttleInfo = showZAxisShuttleInfo;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.shuttle.showPosition.z = showZAxisShuttleInfo;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.shuttles.forEach(function (shuttle) {
                shuttle.svg.applyOptions(options.shuttle);
            });
        }
    };

    /**
    * @method getShowZAxisShuttleInfo
    * @return {Boolean}
    * Gets the flag to show the additional shuttle information for the x axis.
    */
    p.getShowZAxisShuttleInfo = function () {
        return this.settings.showZAxisShuttleInfo;
    };

    /**
    * @method setShowRxAxisShuttleInfo
    * @iatStudioExposed
    * @param {Boolean} showRxAxisShuttleInfo
    * Sets the flag to show the additional shuttle information for the x axis.
    */
    p.setShowRxAxisShuttleInfo = function (showRxAxisShuttleInfo) {
        this.settings.showRxAxisShuttleInfo = showRxAxisShuttleInfo;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.shuttle.showPosition.rX = showRxAxisShuttleInfo;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.shuttles.forEach(function (shuttle) {
                shuttle.svg.applyOptions(options.shuttle);
            });
        }
    };

    /**
    * @method getShowRxAxisShuttleInfo
    * @return {Boolean}
    * Gets the flag to show the additional shuttle information for the x axis.
    */
    p.getShowRxAxisShuttleInfo = function () {
        return this.settings.showRxAxisShuttleInfo;
    };

    /**
    * @method setShowRyAxisShuttleInfo
    * @iatStudioExposed
    * @param {Boolean} showRyAxisShuttleInfo
    * Sets the flag to show the additional shuttle information for the x axis.
    */
    p.setShowRyAxisShuttleInfo = function (showRyAxisShuttleInfo) {
        this.settings.showRyAxisShuttleInfo = showRyAxisShuttleInfo;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.shuttle.showPosition.rY = showRyAxisShuttleInfo;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.shuttles.forEach(function (shuttle) {
                shuttle.svg.applyOptions(options.shuttle);
            });
        }
    };

    /**
    * @method getShowRyAxisShuttleInfo
    * @return {Boolean}
    * Gets the flag to show the additional shuttle information for the x axis.
    */
    p.getShowRyAxisShuttleInfo = function () {
        return this.settings.showRyAxisShuttleInfo;
    };

    /**
    * @method setShowRzAxisShuttleInfo
    * @iatStudioExposed
    * @param {Boolean} showRzAxisShuttleInfo
    * Sets the flag to show the additional shuttle information for the x axis.
    */
    p.setShowRzAxisShuttleInfo = function (showRzAxisShuttleInfo) {
        this.settings.showRzAxisShuttleInfo = showRzAxisShuttleInfo;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.shuttle.showPosition.rZ = showRzAxisShuttleInfo;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.shuttles.forEach(function (shuttle) {
                shuttle.svg.applyOptions(options.shuttle);
            });
        }
    };

    /**
    * @method getShowRzAxisShuttleInfo
    * @return {Boolean}
    * Gets the flag to show the additional shuttle information for the x axis.
    */
    p.getShowRzAxisShuttleInfo = function () {
        return this.settings.showRzAxisShuttleInfo;
    };

    /**
    * @method setShowTrafficManager
    * @iatStudioExposed
    * @param {Boolean} showTrafficManager
    * Sets the flag to show the traffic manager.
    */
    p.setShowTrafficManager = function (showTrafficManager) {
        this.settings.showTrafficManager = showTrafficManager;
        if (this._trafficManagerComponentFactory && this._trafficManager) {
            this._trafficManagerComponentFactory.options.trafficManager.show = showTrafficManager;
            this._trafficManager.svg.applyOptions(this._trafficManagerComponentFactory.options.trafficManager);
        }
    };

    /**
    * @method getShowTrafficManager
    * @return {Boolean}
    * Gets the flag to show the traffic manager.
    */
    p.getShowTrafficManager = function () {
        return this.settings.showTrafficManager;
    };

    /**
    * @method setShowAdditionalTrafficManagerInfo
    * @iatStudioExposed
    * @param {Boolean} showAdditionalTrafficManagerInfo
    * Sets the flag to show the additional traffic manager information.
    */
    p.setShowAdditionalTrafficManagerInfo = function (showAdditionalTrafficManagerInfo) {
        this.settings.showAdditionalTrafficManagerInfo = showAdditionalTrafficManagerInfo;
        if (this._trafficManagerComponentFactory && this._trafficManager) {
            this._trafficManagerComponentFactory.options.trafficManager.showAdditionalInformation = showAdditionalTrafficManagerInfo;
            this._trafficManager.svg.applyOptions(this._trafficManagerComponentFactory.options.trafficManager);
        }
    };

    /**
    * @method getShowAdditionalTrafficManagerInfo
    * @return {Boolean}
    * Gets the flag to show the additional traffic manager information.
    */
    p.getShowAdditionalTrafficManagerInfo = function () {
        return this.settings.showAdditionalTrafficManagerInfo;
    };

    /**
    * @method setShowCoordinateSystem
    * @iatStudioExposed
    * @param {Boolean} showCoordinateSystem
    * Sets the flag to show the coordinate system.
    */
    p.setShowCoordinateSystem = function (showCoordinateSystem) {
        this.settings.showCoordinateSystem = showCoordinateSystem;
        if (this._widgetBuilder && this._widgetBuilder.coordinateSystem) {
            this._widgetBuilder.options.coordinateSystem.show = showCoordinateSystem;
            this._widgetBuilder.coordinateSystem.applyOptions(this._widgetBuilder.options.coordinateSystem);
        }
    };

    /**
    * @method getShowCoordinateSystem
    * @return {Boolean}
    * Gets the flag to show the coordinate system.
    */
    p.getShowCoordinateSystem = function () {
        return this.settings.showCoordinateSystem;
    };

    /**
    * @method setShowZones
    * @iatStudioExposed
    * @param {Boolean} showZones
    * Sets the flag to show the zones.
    */
    p.setShowZones = function (showZones) {
        this.settings.showZones = showZones;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.zone.show = showZones;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.zones.forEach(function (zone) {
                zone.svg.applyOptions(options.zone);
            });
        }
    };

    /**
    * @method getShowZones
    * @return {Boolean}
    * Gets the flag to show the zones.
    */
    p.getShowZones = function () {
        return this.settings.showZones;
    };

    /**
    * @method setShowPowerSectors
    * @iatStudioExposed
    * @param {Boolean} showPowerSectors
    * Sets the flag to show the power sectors.
    */
    p.setShowPowerSectors = function (showPowerSectors) {
        this.settings.showPowerSectors = showPowerSectors;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.powerSector.show = showPowerSectors;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.powerSectors.forEach(function (powerSector) {
                powerSector.svg.applyOptions(options.powerSector);
            });
        }
    };

    /**
    * @method getShowPowerSectors
    * @return {Boolean}
    * Gets the flag to show the power sectors.
    */
    p.getShowPowerSectors = function () {
        return this.settings.showPowerSectors;
    };

    /**
    * @method setShowStereotypes
    * @iatStudioExposed
    * @param {Boolean} showStereotypes
    * Sets the flag to show the stereotypes.
    */
    p.setShowStereotypes = function (showStereotypes) {
        this.settings.showStereotypes = showStereotypes;
        if (this._widgetBuilder && this._widgetBuilder.assemblyBuilder && this._assembly) {
            this._widgetBuilder.assemblyBuilder.componentFactory.options.shuttle.stereotype.show = showStereotypes;
            var options = this._widgetBuilder.assemblyBuilder.componentFactory.options;
            this._assembly.shuttles.forEach(function (shuttle) {
                shuttle.svg.applyOptions(options.shuttle);
            });
        }
    };

    /**
    * @method getShowStereotypes
    * @return {Boolean}
    * Gets the flag to show the stereotypes.
    */
    p.getShowStereotypes = function () {
        return this.settings.showStereotypes;
    };

    /**
    * @method getFileName
    * @return {String}
    * Gets the file name that belongs to the MpLink.
    */
    p.getSvgFileName = function (fileName) {
        return fileName + '.svg';
    };

    p._loadSvg = function () {
        this._initContent = true;
        var self = this;
        var deferred = $.Deferred();
        var deferredAssembly6D, deferredTrafficManager;
        var trafficManagerSvg = null;

        deferredAssembly6D = this.fileLoader.getConfiguration().then(function (svgContent) {
            self._insertScaledSvg(svgContent);
        });

        if (this.fileLoaderTrafficManager) {
            deferredTrafficManager = this.fileLoaderTrafficManager.getConfiguration().then(function (svgContent) {
                const svgContainer = document.createElement('div');
                svgContainer.innerHTML = svgContent;
                trafficManagerSvg = svgContainer.querySelector('svg') || undefined;
            });
        }
        
        $.when(deferredAssembly6D, deferredTrafficManager).then(function () {
            var softwareComponentsNs = 'NS6';
            let OpcUaNodeBindingEventManagerClass = widgetRegistry.get('widgets.mapp6D.OpcUaNodeBindingEventManager');
            const opcUaNodeBindingEventManager = OpcUaNodeBindingEventManagerClass.createWidget(self.elem.id);
            opcUaNodeBindingEventManager.getNamespaceIdx(OpcUaConstants.SOFTWARE_COMPONENTS_URI).then(function (namespaceIdx) {
                softwareComponentsNs = 'NS' + namespaceIdx;
            }).then(function () {
                self._assembly6DDataAccessFactory = Assembly6DDependencies.dataAccessFactory(opcUaNodeBindingEventManager, self.getMpLink(), softwareComponentsNs);
                const assemblyComponentFactoryOptions = Assembly6DDependencies.componentFactoryOptions();
                assemblyComponentFactoryOptions.shuttle.showAdditionalInformation = self.getShowAdditionalShuttleInfo();
                assemblyComponentFactoryOptions.shuttle.stereotype.show = self.getShowStereotypes();
                assemblyComponentFactoryOptions.shuttle.showState = self.getShowStateShuttleInfo();
                assemblyComponentFactoryOptions.shuttle.showPosition.x = self.getShowXAxisShuttleInfo();
                assemblyComponentFactoryOptions.shuttle.showPosition.y = self.getShowYAxisShuttleInfo();
                assemblyComponentFactoryOptions.shuttle.showPosition.z = self.getShowZAxisShuttleInfo();
                assemblyComponentFactoryOptions.shuttle.showPosition.rX = self.getShowRxAxisShuttleInfo();
                assemblyComponentFactoryOptions.shuttle.showPosition.rY = self.getShowRyAxisShuttleInfo();
                assemblyComponentFactoryOptions.shuttle.showPosition.rZ = self.getShowRzAxisShuttleInfo();
                assemblyComponentFactoryOptions.zone.show = self.getShowZones();
                assemblyComponentFactoryOptions.powerSector.show = self.getShowPowerSectors();
                const assembly6DComponentFactory = Assembly6DDependencies.componentFactory(self._assembly6DDataAccessFactory, assemblyComponentFactoryOptions);
                const assembly6DConfigParser = Assembly6DDependencies.configParser(assembly6DComponentFactory, self._svg);
                const assemblyBuilder = Assembly6DDependencies.assemblyBuilder(assembly6DConfigParser, assembly6DComponentFactory, self._assembly6DDataAccessFactory, self._svg);
                const onClickHandler = Assembly6DDependencies.eventOnClickHandler(self.elem, self.getMpLink());
                assemblyBuilder.useOnClickHandler(onClickHandler).addZones().addPowerSectors();
                assemblyBuilder.onConfigChange(function (component) {
                    if (self._assembly !== null) {
                        self._assembly.dispose();
                    }
                    self._assembly = component;
                });
                assemblyBuilder.onShuttleCreated((shuttle)=>{
                    shuttle.dataAccess.onProductLabelChange((productLabel)=>{
                        const [image, color] = self._getProductLabelConfig(productLabel);
                        shuttle.svg.options.customImageHref = image;
                        shuttle.svg.applyOptions(shuttle.svg.options);
                        shuttle.svg.fillColor = color;
                    });
                });
            self._widgetBuilder = mapp6DSharedDependencies.widgetBuilder(assemblyBuilder);
            self._widgetBuilder.options.coordinateSystem.show = self.getShowCoordinateSystem();

            if (trafficManagerSvg) {
                self._trafficManagerDataAccessFactory = TrafficManagerDependencies.dataAccessFactory(opcUaNodeBindingEventManager, self.getMpLinkTrafficManager(), softwareComponentsNs);
                const trafficManagerComponentFactoryOptions = TrafficManagerDependencies.componentFactoryOptions();
                trafficManagerComponentFactoryOptions.trafficManager.show = self.getShowTrafficManager();
                trafficManagerComponentFactoryOptions.trafficManager.showAdditionalInformation = self.getShowAdditionalTrafficManagerInfo();
                self._trafficManagerComponentFactory = TrafficManagerDependencies.componentFactory(trafficManagerComponentFactoryOptions);
                const trafficManagerConfigParser = TrafficManagerDependencies.configParser(self._trafficManagerComponentFactory, trafficManagerSvg);
                const trafficManagerBuilder = TrafficManagerDependencies.trafficManagerBuilder(trafficManagerConfigParser, self._trafficManagerDataAccessFactory, self._svg);
                trafficManagerBuilder.onConfigChange(function (component) {
                    if (self._trafficManager !== null) {
                        self._trafficManager.dispose();
                    }
                    self._trafficManager = component;
                });
                self._widgetBuilder.useTrafficManagerBuilder(trafficManagerBuilder);
            }

                if (self.getShowCoordinateSystem()) {
                    self._widgetBuilder.addCoordinateSystem();
                }

                self._widgetBuilder.build();
                self._initContent = false;
                self._assembly = assemblyBuilder.getComponent();
                self._trafficManager = self._widgetBuilder.trafficManagerBuilder ? self._widgetBuilder.trafficManagerBuilder.getComponent() : null;

                deferred.resolve();
            })
        });
        return deferred;
    };

    p._insertScaledSvg = function (svgContent) {
        this._svg = mapp6DSharedDependencies.svgUtils().insertSvgIntoDom(
            this.elem,
            svgContent);
        mapp6DSharedDependencies.svgUtils().limitSvgDimension(
            this._svg,
            this.settings.width,
            this.settings.height);
    };

    function _addPlaceholderImage(widget) {
        widget.el.css({
            'background-image': 'url("widgets/mapp6D/Assembly6D/assets/Assembly6DPlaceholder.svg")',
            'background-repeat': 'no-repeat',
            'background-position': 'center center'
        });
    };

    p._getProductLabelConfig = function(label) {
        let id = this.elem.id+'_productLabel_'+label;
        let productLabel = this.settings.productLabel[id];
        if (productLabel == undefined) {
            return ['', ''];
        }
        const image = productLabel.image || '';
        const color = productLabel.color || 'rgba(255, 255, 255, 1)';
        return [ image, color ];
    };
    
    /**
    * @method setProductLabel
    * Set property value of single ProductLabel. Method needed for binding of properties of the structured property.
    * @param {String} path
    * @param {String} attribute
    * @param {Object} value
    */
    p.setProductLabel = function (path, attribute, value) {
        if (this.ProductLabel[path]) {
            this.ProductLabel[path][Utils.setter(attribute)](value);
        }
    };

    /**
    * @method getProductLabel
    * Get property value of single ProductLabel
    */
    p.getProductLabel = function (path, attribute) {
        if (this.ProductLabel[path]) {
            return this.ProductLabel[path][Utils.getter(attribute)]();
        } else {
            return null;
        }
    };

    /**
    * @method addProductLabel
    * Add a new ProductLabel
    */
    p.addProductLabel = function (id, options) {
        if (!this.settings.ProductLabel[id]) {
            this.settings.ProductLabel[id] = options;
        }
        this.ProductLabel[id] = new ProductLabel(id, options, this.elem.id, 'ProductLabel');
    };

    /**
    * @method deleteProductLabel
    * Delete a ProductLabel
    */
    p.deleteProductLabel = function (id) {
        this.ProductLabel[id].dispose();
        delete this.ProductLabel[id];
        delete this.settings.ProductLabel[id];
    };

    p.renameProductLabel = function (id, newId) {
        this._renameStructProp('ProductLabel', id, newId);
    };

    p._renameStructProp = function (prop, id, newId) {
        this[prop][id].setId(newId);
        this[prop][newId] = this[prop][id];
        delete this[prop][id];
        this.settings[prop][newId] = this.settings[prop][id];
        delete this.settings[prop][id];
    };

    p.orderProductLabel = function (ids) {
    };

    return WidgetClass;
});
