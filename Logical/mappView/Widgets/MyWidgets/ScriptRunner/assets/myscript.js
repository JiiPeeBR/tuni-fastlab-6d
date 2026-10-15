// myscript.js
// Example script for the widgets.MyWidgets.ScriptRunner widget.
//
// Everything at the top level runs immediately when the file is loaded:
console.log('hello from the HMI');

// Optionally register a hook. ScriptRunner calls it once, right after this
// file has loaded, passing the ScriptRunner widget instance and the brease API.
// (The global name is configurable via the widget's "hookName" property and
// defaults to "onMyLibScript".)
window.onMyLibScript = function (widget, brease) {
    // timers, listeners, OPC-UA bindings, DOM tweaks, ...

    // A couple of things you can do with the two handles you are given:

    // 1) Log through the brease framework instead of the raw console.
    if (brease && brease.services && brease.services.logger) {
        // brease.services.logger.log(...);
    }

    // 2) Fire a widget event that a mapp View binding/action can react to.
    //    (ScriptRunner exposes ScriptLoaded / ScriptError / AllScriptsLoaded;
    //    here we just show that "widget" is the live widget instance.)
    console.log('onMyLibScript running for widget', widget.elem && widget.elem.id);

    // 3) Example: a periodic tick. Anything you start here keeps running for
    //    the lifetime of the page.
    var ticks = 0;
    var timer = setInterval(function () {
        ticks += 1;
        if (ticks >= 3) {
            clearInterval(timer);
            console.log('myscript.js: done ticking');
        }
    }, 1000);
};
