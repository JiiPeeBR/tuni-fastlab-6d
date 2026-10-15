# widgets.MyWidgets.ScriptRunner

An **invisible** mapp View widget that loads and executes one or more user
supplied JavaScript files at runtime. Drop it on any page, list the files in the
`scripts` property (comma separated) and they are fetched and run in order when
the page is shown.

It renders nothing on the running HMI. In the Automation Studio editor it shows
a small dashed badge (⚙ ScriptRunner) so you can select and position it.

## How a script is executed

Each entry in `scripts` is loaded as a normal `<script src="…">` element that is
appended to the document, so **top level statements run immediately**:

```js
// myscript.js
console.log('hello from the HMI');
window.onMyLibScript = function (widget, brease) {
    // timers, listeners, OPC-UA bindings, DOM tweaks, ...
};
```

In addition, a file may register a callback on the global object under the name
configured in `hookName` (default **`onMyLibScript`**). After the file has
loaded, ScriptRunner invokes that callback with two arguments:

| Argument | What it is |
|---|---|
| `widget` | The ScriptRunner widget instance (`widget.elem`, `widget.createEvent(...)`, …). |
| `brease` | The brease framework API object. |

The hook is **cleared before each file is loaded**, so every file in the list
gets its own invocation even if they all use the same hook name.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `scripts` | String | `''` | Comma separated list of JS files to load, e.g. `assets/myscript.js, assets/other.js`. Whitespace is trimmed, empty entries skipped. |
| `hookName` | String | `onMyLibScript` | Global function a loaded file may define; called with `(widget, brease)` after the file loads. |
| `autoRun` | Boolean | `true` | Load the scripts automatically on init. If `false`, nothing happens until the `Run()` action fires. |

Plus the inherited `enable`, `visible`, `style`, `tabIndex`, `tooltip`,
`permissionOperate` / `permissionView`.

## Methods (event/action bindable)

- `Run()` – (re)load and execute the configured scripts.
- `SetScripts(scripts)` – replace the list; runs immediately when `autoRun` is on.

plus the inherited `SetEnable`, `SetVisible`, `SetStyle`, `Focus`, `ShowTooltip`.

## Events (event/action bindable)

- `ScriptLoaded {script}` – one file finished loading and its hook ran.
- `ScriptError {script, message}` – a file failed to load or its hook threw.
- `AllScriptsLoaded {count}` – every configured file has been processed.

plus the inherited `EnableChanged`, `VisibleChanged`, `FocusIn`, `FocusOut`.

## Where to put the script files

Paths in `scripts` are resolved by the browser **relative to the current HMI
page** (i.e. relative to the `BRVisu` web root). Add your `.js` files to the
mapp View project so they are deployed under `BRVisu`, then reference them with
their relative path, for example:

```
scripts = assets/myscript.js
```

For a quick test without adding your own files, the bundled example can be
referenced directly:

```
scripts = widgets/MyWidgets/ScriptRunner/assets/myscript.js
```

Open the browser dev console and you will see `hello from the HMI` followed by
the `onMyLibScript` output.

> **Note:** ScriptRunner executes arbitrary JavaScript in the HMI client. Only
> reference files you trust and control, exactly as you would when adding a
> `<script>` to the page yourself.

## Files

Hand-authored source: `ScriptRunner.js`, `ScriptRunner.html`,
`css/ScriptRunner.scss`, `meta/ScriptRunner.widget`, `meta/ScriptRunner.style`,
`assets/myscript.js`.

The remaining files (`meta/ScriptRunner.json`, `.d.ts`, `.xsd`,
`_EventsActions.xsd`, `_Styles.xsd`, `_base.scss`, `_default.scss`, the
`.sass.css` files and `designer/ClassInfo.js`) are the artifacts the Automation
Studio widget toolchain regenerates from the source on build. They are provided
so the widget is complete, but AS will overwrite them if you change the
`.widget` / `.scss`.

The widget is registered in the library catalogs one level up
(`../WidgetLibrary.mapping`, `../WidgetLibrary.xmlschemaset`,
`../WidgetEventsActions.xmlschemaset`, `../WidgetStyles.xmlschemaset`) and in the
custom widget bundle `../cwidgets.js`.
