'use strict';
define(['widgets', 'brease'], function ({ brease }) {

    /**
    * @class widgets.MyWidgets.RefreshButton
    * A push button that reloads (refreshes) the current mappView page when clicked.
    * Inherits all appearance and behaviour from widgets.brease.Button.
    * @extends widgets.brease.Button
    *
    * @iatMeta studio:license
    * unlicensed
    * @iatMeta category:Category
    * Buttons
    * @iatMeta description:short
    * Button that reloads the current page
    * @iatMeta description:de
    * Schaltflaeche, die die aktuelle Seite neu laedt
    * @iatMeta description:en
    * Button that reloads (refreshes) the current page when clicked
    */

    const WidgetClass = brease.Button.extend(function RefreshButton() {
        brease.Button.apply(this, arguments);
    });

    let p = WidgetClass.prototype;

    p.init = function () {
        this.addInitialClass('classRefreshButton');
        brease.Button.prototype.init.apply(this, arguments);
    };

    /**
    * @method _onButtonClick
    * Called by widgets.brease.Button on a real (enabled, non-editMode) click.
    * brease.Button already guards against disabled state and editMode before
    * calling this hook, so it is safe to reload here unconditionally.
    */
    p._onButtonClick = function () {
        location.reload();
    };

    return WidgetClass;

});
