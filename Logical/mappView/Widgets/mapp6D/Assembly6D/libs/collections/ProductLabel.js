'use strict';
define(['brease'], function ({ datatype: { StructuredProperty: SuperClass }}) {

    /**
    * @class widgets.mapp6D.Assembly6D.ProductLabel
    * Defines appearance of a shuttle with a given product label
    * @extends brease.datatype.StructuredProperty
    * @embeddedClass
    * @virtualNote
    */

    /**
    * @cfg {Color} color='#FFFFFF'
    * @iatStudioExposed
    * @iatCategory Appearance 
    * Color of the product label
    */

    /**
    * @cfg {ImagePath} image=''
    * @iatStudioExposed
    * @iatCategory Appearance 
    * Image of the product label
    */

    const defaultSettings = {
        color: '#FFFFFF',
        image: ''
    };

    let ProductLabel = SuperClass.extend(function (id, options, widgetId, propName) {
        SuperClass.call(this, id, options, widgetId, propName);
    }, defaultSettings);

    let p = ProductLabel.prototype;

    p.dispose = function () {
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    
    p.setColor = function (color) {
        this.settings.color = color;
    };

    p.getColor = function () {
        return this.settings.color;
    };

    p.setImage = function (image) {
        this.settings.image = image;
    };

    p.getImage = function () {
        return this.settings.image;
    };

    return ProductLabel;
});