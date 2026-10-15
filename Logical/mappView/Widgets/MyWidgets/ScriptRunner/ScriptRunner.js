'use strict';
define([
    'widgets',
    'brease'
], function (
    widgets,
    brease
) {
    var {
        core: { BaseWidget, Types },
        config,
        enum: { Enum },
        services: { logger }
    } = brease;

    /**
     * @class widgets.MyWidgets.ScriptRunner
     * #Description
     * An invisible widget that loads and executes one or more user supplied
     * JavaScript files at runtime. Place it on a page, list the script files in
     * the {@link #cfg-scripts scripts} property (separated by commas) and they
     * are fetched and run in order when the page is shown.
     *
     * Each loaded file runs immediately in the global scope, so plain top level
     * statements execute right away:
     *
     *     // myscript.js
     *     console.log('hello from the HMI');
     *     window.onMyLibScript = function (widget, brease) {
     *         // timers, listeners, OPC-UA bindings, DOM tweaks, ...
     *     };
     *
     * In addition, a file may register a callback on the global object under the
     * name configured in {@link #cfg-hookName hookName} (default
     * `onMyLibScript`). After the file has loaded, ScriptRunner invokes that
     * callback with two arguments: the ScriptRunner `widget` instance and the
     * `brease` API object. This gives the user code a handle to create events,
     * read/write the DOM and use the brease framework. The hook is cleared
     * before each file is loaded, so every file gets its own invocation.
     *
     * The widget itself renders nothing at runtime; in the Automation Studio
     * editor it shows a small badge so it can be selected and positioned.
     *
     * @extends brease.core.BaseWidget
     *
     * @iatMeta studio:license
     * unlicensed
     * @iatMeta category:Category
     * System
     * @iatMeta description:short
     * Runs user supplied script files
     * @iatMeta description:de
     * Fuehrt benutzerdefinierte Skriptdateien aus
     * @iatMeta description:en
     * Invisible widget that loads and executes user supplied JavaScript files
     */

    /**
     * @cfg {String} scripts=''
     * @iatStudioExposed
     * @bindable
     * @iatCategory Data
     * Comma separated list of JavaScript files to load and execute, e.g.
     * `media/myscript.js, media/other.js`. Paths are resolved by the browser
     * relative to the current page. Whitespace around each entry is ignored and
     * empty entries are skipped.
     */

    /**
     * @cfg {String} hookName='onMyLibScript'
     * @iatStudioExposed
     * @iatCategory Behavior
     * Name of the global (window) function that a loaded script may define. After
     * each file has loaded, this function - if present - is called with
     * `(widget, brease)`.
     */

    /**
     * @cfg {Boolean} autoRun=true
     * @iatStudioExposed
     * @iatCategory Behavior
     * If true, the configured scripts are loaded automatically when the widget
     * is initialized. If false, nothing happens until the Run() action is
     * triggered.
     */

    // Widget error numbers
    const err_load = 10300;
    const err_run = 10301;

    var defaultSettings = {
            scripts: '',
            hookName: 'onMyLibScript',
            autoRun: true
        },

        WidgetClass = BaseWidget.extend(function ScriptRunner() {
            BaseWidget.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {
        if (this.settings.omitClass !== true) {
            this.addInitialClass('MyWidgetsScriptRunner');
        }

        this.settings.autoRun = Types.parseValue(this.settings.autoRun, 'Boolean', { default: true });
        if (typeof this.settings.hookName !== 'string' || this.settings.hookName === '') {
            this.settings.hookName = 'onMyLibScript';
        }

        // <script> elements appended by this widget, so they can be removed on dispose.
        this._scriptElems = [];
        // Guards against running the scripts more than once (init + wake).
        this._hasRun = false;

        if (config.editMode) {
            _buildEditorPlaceholder(this);
        } else if (!config.preLoadingState && this.settings.autoRun) {
            this.Run();
        }

        BaseWidget.prototype.init.call(this);
    };

    p.wake = function () {
        BaseWidget.prototype.wake.apply(this, arguments);
        // The widget was restored from the cache. Run the scripts now if they
        // could not run during init (e.g. the page was pre-loaded in background).
        if (!config.editMode && !this._hasRun && this.settings.autoRun) {
            this.Run();
        }
    };

    // ----------------------------------------------------------------- Public API

    /**
     * @method Run
     * @iatStudioExposed
     * Loads and executes the configured scripts, in order. Can be triggered
     * repeatedly; each call re-loads the files.
     */
    p.Run = function Run() {
        if (config.editMode) { return; }
        var widget = this;
        this._hasRun = true;

        var files = _parseList(this.settings.scripts);

        // Load the files sequentially so their execution order is deterministic.
        var chain = Promise.resolve();
        files.forEach(function (file) {
            chain = chain.then(function () {
                return widget._runOne(file);
            });
        });

        chain.then(function () {
            /**
             * @event AllScriptsLoaded
             * Fired once, after every configured script has finished loading
             * (whether it succeeded or errored).
             * @param {Number} count Number of script files that were processed.
             * @iatStudioExposed
             */
            var ev = widget.createEvent('AllScriptsLoaded', { count: files.length });
            if (ev !== undefined) {
                ev.dispatch();
            }
        });
    };

    /**
     * @method setScripts
     * @iatStudioExposed
     * Sets the comma separated list of scripts. If autoRun is enabled the new
     * list is executed immediately.
     * @param {String} scripts
     */
    p.setScripts = function setScripts(scripts) {
        this.settings.scripts = (typeof scripts === 'string') ? scripts : '';
        if (!config.editMode && this.settings.autoRun) {
            this.Run();
        }
    };

    /**
     * @method getScripts
     * Returns the currently configured comma separated list of scripts.
     * @return {String}
     */
    p.getScripts = function getScripts() {
        return this.settings.scripts;
    };

    // ------------------------------------------------------------- Script loading

    p._runOne = function _runOne(file) {
        var widget = this;
        var hook = widget.settings.hookName;

        return new Promise(function (resolve) {
            // Clear any hook a previous file may have registered, so we only
            // invoke the callback that *this* file defines.
            try {
                delete window[hook];
            } catch (e) {
                window[hook] = undefined;
            }

            var script = document.createElement('script');
            script.type = 'text/javascript';
            // async=false keeps the execution order of dynamically inserted scripts.
            script.async = false;
            script.setAttribute('data-scriptrunner', widget.elem.id);
            script.src = file;

            script.onload = function () {
                widget._invokeHook(file, hook);

                /**
                 * @event ScriptLoaded
                 * Fired after a single script file has loaded and its hook (if
                 * any) has been invoked.
                 * @param {String} script Path of the script that was loaded.
                 * @iatStudioExposed
                 */
                var ev = widget.createEvent('ScriptLoaded', { script: file });
                if (ev !== undefined) {
                    ev.dispatch();
                }
                resolve();
            };

            script.onerror = function () {
                widget._dispatchError(file, 'Failed to load script', err_load);
                resolve();
            };

            (document.head || document.body).appendChild(script);
            widget._scriptElems.push(script);
        });
    };

    p._invokeHook = function _invokeHook(file, hook) {
        var widget = this;
        var fn = window[hook];
        if (typeof fn !== 'function') { return; }

        try {
            fn(widget, brease);
        } catch (e) {
            widget._dispatchError(file, (e && e.message) ? e.message : String(e), err_run);
        }
    };

    // ------------------------------------------------------------- Error handling

    p._dispatchError = function _dispatchError(file, message, code) {
        var widget = this;

        /**
         * @event ScriptError
         * Fired when a script cannot be loaded or its hook throws.
         * @param {String} script Path of the offending script.
         * @param {String} message Error description.
         * @iatStudioExposed
         */
        var ev = widget.createEvent('ScriptError', { script: file, message: message });
        if (ev !== undefined) {
            ev.dispatch();
        }

        if (!config.editMode && logger !== undefined) {
            var m = 'Error ' + code + ' in ScriptRunner (' + file + '): ' + message +
                ' on page ' + widget.settings.parentContentId + ' at widget ' + widget.elem.id;
            logger.log(Enum.EventLoggerId.CLIENT_SCRIPT_FAIL, Enum.EventLoggerCustomer.BUR, Enum.EventLoggerVerboseLevel.OFF, Enum.EventLoggerSeverity.ERROR, [], m);
        }
    };

    // ------------------------------------------------------------------- Lifecycle

    p.dispose = function () {
        // Remove the script elements we appended to the document.
        if (this._scriptElems) {
            this._scriptElems.forEach(function (script) {
                if (script && script.parentNode) {
                    script.parentNode.removeChild(script);
                }
            });
            this._scriptElems = [];
        }
        BaseWidget.prototype.dispose.apply(this, arguments);
    };

    // ------------------------------------------------------------- Private helpers

    // Splits the comma separated list into trimmed, non-empty file paths.
    function _parseList(value) {
        if (typeof value !== 'string' || value === '') { return []; }
        return value.split(',').map(function (s) {
            return s.trim();
        }).filter(function (s) {
            return s.length > 0;
        });
    }

    // Builds the placeholder badge shown in the Automation Studio editor only.
    function _buildEditorPlaceholder(widget) {
        var badge = document.createElement('div');
        badge.className = 'sr-badge';

        var icon = document.createElement('span');
        icon.className = 'sr-icon';
        icon.textContent = '⚙'; // gear
        badge.appendChild(icon);

        var label = document.createElement('span');
        label.className = 'sr-label';
        label.textContent = 'ScriptRunner';
        badge.appendChild(label);

        widget.elem.appendChild(badge);
    }

    return WidgetClass;
});
