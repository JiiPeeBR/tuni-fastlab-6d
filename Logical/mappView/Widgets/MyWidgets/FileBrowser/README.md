# widgets.MyWidgets.FileBrowser

A mapp View widget that lists the files/folders on the backend (PLC) and lets the
operator **download** a selected file to the client device or **upload** a file
from the client device into the currently displayed backend folder.

It talks to the backend through the singleton `widgets.brease.FileManager`
(requires the **MpFile** and **MpServer** libraries on the target), the same
component used by `widgets.brease.FileExplorer`.

## UI

```
┌───────────────────────────────────────────────┐
│ [Refresh] [Upload] [Download]      /current/path│  ← toolbar
├───────────────────────────────────────────────┤
│ 📁 ..                                          │
│ 📁 Recipe                                       │  ← scrollable list
│ 📄 Logger.csv               10.0 KB  2024-… │
│ 📄 Config.xml                1.2 KB  2024-… │
└───────────────────────────────────────────────┘
```

- **Single click** selects a row (fires `SelectionChanged`).
- **Double click** on a folder (or the `..` entry) navigates into it when
  `allowFolderNavigation` is `true` (fires `PathChanged`).
- **Double click** on an image file (jpg/jpeg/png/gif/bmp/webp) opens a full
  screen **image preview** when `imagePreview` is `true`. If a same-named `.svg`
  file exists in the same folder, its content is drawn as an **overlay** on top of
  the image, aligned to the image's pixel coordinates (see below).
- **Download** transfers the selected file to the client (fires `FileDownloaded`).
- **Upload** opens the browser file dialog and stores the chosen file into the
  current folder (fires `FileUploaded`), then refreshes the list. If a file of
  the same name already exists in the current folder and `confirmOverwrite` is
  `true`, an in-widget confirmation dialog is shown first; the file is only
  overwritten if the user confirms.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `path` | String | `''` | Initial backend directory. `''` = root of the configured MpFile component. |
| `maxFileSize` | Integer | `10000000` | Max transfer size in bytes (1 000 – 10 000 000). |
| `showSize` | Boolean | `true` | Show the size column. |
| `showDate` | Boolean | `true` | Show the modification-date column. |
| `allowFolderNavigation` | Boolean | `true` | Enable folder navigation. |
| `confirmOverwrite` | Boolean | `true` | Ask before overwriting an existing file on upload. `false` = overwrite silently. |
| `overwritePrompt` | String *(localizable)* | `A file with this name already exists. Overwrite it?` | Question shown in the overwrite dialog. Accepts static text or a **text system item** (text key) that follows the HMI language. |
| `overwriteConfirmText` | String *(localizable)* | `Overwrite` | Confirm-button label in the overwrite dialog. |
| `overwriteCancelText` | String *(localizable)* | `Cancel` | Cancel-button label in the overwrite dialog. |
| `fontSize` | Integer (px) | `12` | Font size of the file list and toolbar. Increase for readability on large/touch screens. |
| `rowHeight` | Integer (px) | `0` | Minimum height of a list row. `0` = automatic; larger = bigger touch targets. |
| `dialogFontSize` | Integer (px) | `16` | Font size of the overwrite dialog (scales the whole dialog). |
| `dialogWidth` | Integer (px) | `320` | Width of the overwrite dialog box (capped at 90% of screen width). |
| `imagePreview` | Boolean | `true` | Double-clicking an image file opens a full-screen preview with the same-named `.svg` overlaid on top. |

The overwrite dialog is rendered **centered on the whole screen** (not inside the
widget), so it stays readable and operable even when the widget itself is small.

### Image preview with SVG overlay

Double-clicking an image opens a centered full-screen preview. If a sibling
`<name>.svg` exists, its markup is overlaid on the picture:

- The base image is shown responsively, and an `<svg>` with
  `viewBox="0 0 <naturalWidth> <naturalHeight>"` is stretched over it
  (`preserveAspectRatio="none"`). Overlay coordinates are therefore interpreted in
  the **image's pixel space**, so an element such as
  `<circle cx="971.1" cy="412.7" r="60" .../>` lands on the right spot at any
  display scale.
- The `.svg` file may be a **full `<svg>…</svg>` document** (its inner markup is
  used) or a **bare fragment** of one or more elements (used as-is). An
  XML/DOCTYPE prologue is stripped.

Click the backdrop or the ✕ button to close. Set `imagePreview=false` to disable.

### Editor preview

In the Automation Studio editor the widget shows a **live preview** so the sizing
and text properties can be configured without a running backend:
- the list is filled with **sample folders and files** (so `fontSize`, `rowHeight`,
  `showSize`, `showDate` can be judged), and
- the **overwrite dialog is shown inline** (using `overwritePrompt`,
  `overwriteConfirmText`, `overwriteCancelText`, `dialogFontSize`, `dialogWidth`).

The preview is purely visual (it does not capture clicks, so the widget stays
selectable). At runtime the list shows real backend content and the dialog only
appears on an actual overwrite.

> The three `overwrite*` texts are **localizable**: in the editor you can type a
> static string or reference a text system item. When bound to a text key, the
> dialog text updates automatically on language change.

## Methods (event/action bindable)

`Download()`, `Upload()`, `Refresh()`, `setPath(path)`, `setMaxFileSize(bytes)`,
`setOverwritePrompt(text)`, `setOverwriteConfirmText(text)`,
`setOverwriteCancelText(text)` (all three accept a static string or a text key)
plus the inherited `SetEnable`, `SetVisible`, `SetStyle`, `Focus`, `ShowTooltip`.

## Events (event/action bindable)

`SelectionChanged {fileName, filePath}`, `FileDownloaded {filePath}`,
`FileUploaded {filePath}`, `PathChanged {path}`, `OnError {response}`
plus the inherited `EnableChanged`, `VisibleChanged`, `FocusIn`, `FocusOut`.

## FileManager backend calls used

- `browse(elemId, path, 'FILES|FOLDERS')` → resolves an array of
  `{ Path, Type: 'FILE'|'FOLDER', Size, Date, Locked, ReadOnly }` entries.
- `load(elemId, path, 'LOCK', 'BINARY', maxSize, 0)` → resolves base64 file data
  (decoded to a Blob and pushed to the client via a hidden `<a download>`).
- `save(elemId, path, 'OVERWRITE', 'BINARY', base64)` → stores an uploaded file.

## Files

Hand-authored source: `FileBrowser.js`, `FileBrowser.html`,
`css/FileBrowser.scss`, `meta/FileBrowser.widget`, `meta/FileBrowser.style`.

The remaining files (`meta/FileBrowser.json`, `.d.ts`, `.xsd`,
`_EventsActions.xsd`, `_Styles.xsd`, `_base.scss`, `_default.scss`, the
`.sass.css` files and `designer/ClassInfo.js`) are the artifacts that the
Automation Studio widget toolchain regenerates from the source on build. They
are provided here so the widget is complete, but AS will overwrite them if you
change the `.widget`/`.scss`.

The widget is registered in the library catalogs one level up
(`../WidgetLibrary.mapping`, `../WidgetLibrary.xmlschemaset`,
`../WidgetEventsActions.xmlschemaset`, `../WidgetStyles.xmlschemaset`).
