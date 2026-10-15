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
        decorators: { LanguageDependency },
        services: { logger, language }
    } = brease;

    /**
     * @class widgets.MyWidgets.FileBrowser
     * #Description
     * A file browser widget that lists the files and folders located on the
     * backend (PLC) via widgets.brease.FileManager and provides buttons to
     * download a selected file to the client device and to upload a file from
     * the client device to the current backend folder.
     *
     * @extends brease.core.BaseWidget
     * @requires widgets.brease.FileManager
     *
     * @iatMeta studio:license
     * unlicensed
     * @iatMeta category:Category
     * Media
     * @iatMeta description:short
     * File browser with download/upload
     * @iatMeta description:de
     * Dateibrowser mit Download- und Upload-Funktion
     * @iatMeta description:en
     * Lists backend files and allows download/upload of files
     */

    /**
     * @cfg {String} path=''
     * @iatStudioExposed
     * @bindable
     * @iatCategory Data
     * Initial backend directory that is listed. An empty string lists the root
     * of the mapp File component configured on the target.
     */

    /**
     * @cfg {Integer} maxFileSize=10000000
     * @iatStudioExposed
     * @bindable
     * @iatCategory Data
     * Maximum size (in bytes) of a file that can be transferred to/from the backend.
     */

    /**
     * @cfg {Boolean} showSize=true
     * @iatStudioExposed
     * @iatCategory Appearance
     * Show the file size column in the list.
     */

    /**
     * @cfg {Boolean} showDate=true
     * @iatStudioExposed
     * @iatCategory Appearance
     * Show the modification date column in the list.
     */

    /**
     * @cfg {Boolean} allowFolderNavigation=true
     * @iatStudioExposed
     * @iatCategory Behavior
     * Allow navigating into folders (double click) and back up via the ".." entry.
     */

    /**
     * @cfg {Boolean} confirmOverwrite=true
     * @iatStudioExposed
     * @iatCategory Behavior
     * If true, uploading a file whose name already exists in the current backend
     * folder shows a confirmation dialog before overwriting. If false, the file
     * is overwritten silently.
     */

    /**
     * @cfg {String} overwritePrompt='A file with this name already exists. Overwrite it?'
     * @localizable
     * @iatStudioExposed
     * @iatCategory Behavior
     * Question shown in the overwrite confirmation dialog. Accepts either static
     * text typed in the editor or a text system item (text key); a text key is
     * re-resolved automatically when the HMI language changes.
     */

    /**
     * @cfg {String} overwriteConfirmText='Overwrite'
     * @localizable
     * @iatStudioExposed
     * @iatCategory Behavior
     * Label of the confirm (overwrite) button in the overwrite dialog. Accepts
     * static text or a text system item.
     */

    /**
     * @cfg {String} overwriteCancelText='Cancel'
     * @localizable
     * @iatStudioExposed
     * @iatCategory Behavior
     * Label of the cancel button in the overwrite dialog. Accepts static text or
     * a text system item.
     */

    /**
     * @cfg {Integer} fontSize=12
     * @iatStudioExposed
     * @iatCategory Appearance
     * Font size (in pixels) of the file list and toolbar. Increase it to make the
     * list items easier to read on large or touch screens.
     */

    /**
     * @cfg {Integer} rowHeight=0
     * @iatStudioExposed
     * @iatCategory Appearance
     * Minimum height (in pixels) of a file list row. 0 keeps the automatic height
     * derived from the font size; a larger value gives bigger touch targets.
     */

    /**
     * @cfg {Integer} dialogFontSize=16
     * @iatStudioExposed
     * @iatCategory Appearance
     * Font size (in pixels) of the overwrite confirmation dialog. The dialog is
     * shown centered on the whole screen, so this is independent of the widget size.
     */

    /**
     * @cfg {Integer} dialogWidth=320
     * @iatStudioExposed
     * @iatCategory Appearance
     * Width (in pixels) of the overwrite confirmation dialog box (capped at 90% of
     * the screen width).
     */

    /**
     * @cfg {Boolean} imagePreview=true
     * @iatStudioExposed
     * @iatCategory Behavior
     * If true, double clicking an image file (jpg, jpeg, png, gif, bmp, webp)
     * opens a full screen preview. If a file with the same name but a ".svg"
     * extension exists in the same folder, its content is drawn as an overlay on
     * top of the image (aligned to the image pixel coordinates).
     */

    // Local constants and limits (mirrors the limits enforced by the backend)
    const _minFileSize = 1000;
    const _maxFileSize = 10000000;
    const keyStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';

    // Widget error numbers
    const err_unknown = 10200;
    const err_file_size = 10201;
    const err_no_selection = 10202;

    // Not a real backend error: the FileManager returns this code when a still
    // pending request (e.g. a browse that the file backend has not answered yet)
    // is superseded by a newer one for the same widget. It is safe to ignore.
    const err_request_superseded = -120202020;

    var defaultSettings = {
            path: '',
            maxFileSize: 10000000,
            showSize: true,
            showDate: true,
            allowFolderNavigation: true,
            confirmOverwrite: true,
            overwritePrompt: 'A file with this name already exists. Overwrite it?',
            overwriteConfirmText: 'Overwrite',
            overwriteCancelText: 'Cancel',
            fontSize: 12,
            rowHeight: 0,
            dialogFontSize: 16,
            dialogWidth: 320,
            imagePreview: true
        },

        WidgetClass = BaseWidget.extend(function FileBrowser() {
            BaseWidget.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {
        if (this.settings.omitClass !== true) {
            this.addInitialClass('MyWidgetsFileBrowser');
        }

        this.settings.showSize = Types.parseValue(this.settings.showSize, 'Boolean', { default: true });
        this.settings.showDate = Types.parseValue(this.settings.showDate, 'Boolean', { default: true });
        this.settings.allowFolderNavigation = Types.parseValue(this.settings.allowFolderNavigation, 'Boolean', { default: true });
        this.settings.confirmOverwrite = Types.parseValue(this.settings.confirmOverwrite, 'Boolean', { default: true });
        this.settings.imagePreview = Types.parseValue(this.settings.imagePreview, 'Boolean', { default: true });

        this.settings.fontSize = _toInt(this.settings.fontSize, 12);
        this.settings.rowHeight = _toInt(this.settings.rowHeight, 0);
        this.settings.dialogFontSize = _toInt(this.settings.dialogFontSize, 16);
        this.settings.dialogWidth = _toInt(this.settings.dialogWidth, 320);

        if (this.settings.maxFileSize < _minFileSize) {
            this.settings.maxFileSize = _minFileSize;
        } else if (this.settings.maxFileSize > _maxFileSize) {
            this.settings.maxFileSize = _maxFileSize;
        }

        // Resolve the localizable dialog texts. Each may hold a text key (system
        // text item) which is stored so it can be re-resolved on language change.
        this._locKeys = {};
        this._resolveLocalizable('overwritePrompt');
        this._resolveLocalizable('overwriteConfirmText');
        this._resolveLocalizable('overwriteCancelText');

        // The path that is currently displayed.
        this.currentPath = this.settings.path || '';
        // The item currently selected in the list: { name, path, type }.
        this.selected = null;
        // Names of the files (not folders) in the currently displayed folder,
        // used to detect a name collision before an upload overwrites a file.
        this.currentFileNames = [];

        _buildDom(this);

        if (!config.editMode) {
            // Hidden anchor used to trigger the client side download.
            this.a = document.createElement('a');
            this.a.style.display = 'none';
            document.body.appendChild(this.a);

            // Hidden file input used to pick a file for upload.
            this.form = document.createElement('input');
            this.form.setAttribute('type', 'file');
            this.form.style.display = 'none';
            this.form.addEventListener('change', this._bind('_upload'));
            document.body.appendChild(this.form);

            if (!config.preLoadingState) {
                this.fileManager = widgets.brease.FileManager.createWidget(this.elem.id);
                this._browse(this.currentPath);
            }
        } else {
            // In the editor there is no backend: show representative sample rows
            // so the list styling (fontSize, rowHeight, columns) can be judged,
            // and show the overwrite dialog as an inline preview (see _buildDom).
            this._renderList(_sampleTelegram());
        }

        BaseWidget.prototype.init.call(this);
    };

    p.wake = function () {
        BaseWidget.prototype.wake.apply(this, arguments);
        if (!config.editMode) {
            // Re-establish the communication to the FileManager after the widget
            // has been restored from the cache.
            this.fileManager = widgets.brease.FileManager.createWidget(this.elem.id);
            this._browse(this.currentPath);
        }
    };

    // ----------------------------------------------------------------- Public API

    /**
     * @method Refresh
     * @iatStudioExposed
     * Reloads the list of the currently displayed backend folder.
     */
    p.Refresh = function Refresh() {
        this._browse(this.currentPath);
    };

    /**
     * @method Download
     * @iatStudioExposed
     * Downloads the currently selected file from the backend to the client device.
     */
    p.Download = function Download() {
        if (this.selected === null || this.selected.type === 'FOLDER') {
            this._errorHandling(err_no_selection);
            return;
        }
        this._openFile(this.selected.path, 'LOCK', 'BINARY', this.settings.maxFileSize, 0);
    };

    /**
     * @method Upload
     * @iatStudioExposed
     * Opens a file selection dialog and uploads the chosen file into the
     * currently displayed backend folder.
     */
    p.Upload = function Upload() {
        if (this.form) {
            this.form.click();
        }
    };

    /**
     * @method setPath
     * @iatStudioExposed
     * Sets the backend directory to browse and refreshes the list.
     * @param {String} path
     */
    p.setPath = function setPath(path) {
        this.settings.path = (typeof path === 'string') ? path : '';
        this.currentPath = this.settings.path;
        this.selected = null;
        if (config.editMode) {
            // Update the path label / sample list in the editor preview.
            this._rerender();
        } else {
            this._browse(this.currentPath);
        }
        this._dispatchPathChanged();
    };

    /**
     * @method getPath
     * Returns the backend directory that is currently displayed.
     * @return {String}
     */
    p.getPath = function getPath() {
        return this.currentPath;
    };

    /**
     * @method setMaxFileSize
     * @iatStudioExposed
     * Sets the maximum transfer size in bytes.
     * @param {Integer} maxFileSize
     */
    p.setMaxFileSize = function setMaxFileSize(maxFileSize) {
        var value = parseInt(maxFileSize, 10);
        if (!isNaN(value) && value >= _minFileSize && value <= _maxFileSize) {
            this.settings.maxFileSize = value;
        } else {
            this._errorHandling(err_file_size);
        }
    };

    /**
     * @method getMaxFileSize
     * Returns the maximum transfer size in bytes.
     * @return {Integer}
     */
    p.getMaxFileSize = function getMaxFileSize() {
        return this.settings.maxFileSize;
    };

    /**
     * @method setOverwritePrompt
     * @iatStudioExposed
     * Sets the question shown in the overwrite confirmation dialog.
     * @param {String} text
     * @paramMeta text:localizable=true
     */
    p.setOverwritePrompt = function setOverwritePrompt(text) {
        this._setLocalizable('overwritePrompt', text);
    };

    /**
     * @method getOverwritePrompt
     * @return {String}
     */
    p.getOverwritePrompt = function getOverwritePrompt() {
        return this.settings.overwritePrompt;
    };

    /**
     * @method setOverwriteConfirmText
     * @iatStudioExposed
     * Sets the label of the confirm (overwrite) button in the overwrite dialog.
     * @param {String} text
     * @paramMeta text:localizable=true
     */
    p.setOverwriteConfirmText = function setOverwriteConfirmText(text) {
        this._setLocalizable('overwriteConfirmText', text);
    };

    /**
     * @method getOverwriteConfirmText
     * @return {String}
     */
    p.getOverwriteConfirmText = function getOverwriteConfirmText() {
        return this.settings.overwriteConfirmText;
    };

    /**
     * @method setOverwriteCancelText
     * @iatStudioExposed
     * Sets the label of the cancel button in the overwrite dialog.
     * @param {String} text
     * @paramMeta text:localizable=true
     */
    p.setOverwriteCancelText = function setOverwriteCancelText(text) {
        this._setLocalizable('overwriteCancelText', text);
    };

    /**
     * @method getOverwriteCancelText
     * @return {String}
     */
    p.getOverwriteCancelText = function getOverwriteCancelText() {
        return this.settings.overwriteCancelText;
    };

    // ----------------------------------------------- Appearance setters/getters
    // The Automation Studio editor calls set<Property> whenever a value changes,
    // so updating the DOM here keeps the editor preview in sync live. This mirrors
    // the pattern used by widgets.brease.FileExplorer (e.g. setImageBin).

    /**
     * @method setFontSize
     * Sets the state of property "fontSize".
     * @param {Integer} value
     */
    p.setFontSize = function setFontSize(value) {
        this.settings.fontSize = _toInt(value, 12);
        this.elem.style.fontSize = (this.settings.fontSize > 0) ? this.settings.fontSize + 'px' : '';
    };
    /**
     * @method getFontSize
     * @return {Integer}
     */
    p.getFontSize = function getFontSize() {
        return this.settings.fontSize;
    };

    /**
     * @method setRowHeight
     * Sets the state of property "rowHeight".
     * @param {Integer} value
     */
    p.setRowHeight = function setRowHeight(value) {
        this.settings.rowHeight = _toInt(value, 0);
        this._rerender();
    };
    /**
     * @method getRowHeight
     * @return {Integer}
     */
    p.getRowHeight = function getRowHeight() {
        return this.settings.rowHeight;
    };

    /**
     * @method setDialogFontSize
     * Sets the state of property "dialogFontSize".
     * @param {Integer} value
     */
    p.setDialogFontSize = function setDialogFontSize(value) {
        this.settings.dialogFontSize = _toInt(value, 16);
        if (this.modal) {
            this.modal.style.fontSize = (this.settings.dialogFontSize > 0) ? this.settings.dialogFontSize + 'px' : '';
        }
    };
    /**
     * @method getDialogFontSize
     * @return {Integer}
     */
    p.getDialogFontSize = function getDialogFontSize() {
        return this.settings.dialogFontSize;
    };

    /**
     * @method setDialogWidth
     * Sets the state of property "dialogWidth".
     * @param {Integer} value
     */
    p.setDialogWidth = function setDialogWidth(value) {
        this.settings.dialogWidth = _toInt(value, 320);
        if (this.modalBox) {
            this.modalBox.style.width = (this.settings.dialogWidth > 0) ? this.settings.dialogWidth + 'px' : '';
        }
    };
    /**
     * @method getDialogWidth
     * @return {Integer}
     */
    p.getDialogWidth = function getDialogWidth() {
        return this.settings.dialogWidth;
    };

    /**
     * @method setConfirmOverwrite
     * Sets the state of property "confirmOverwrite".
     * @param {Boolean} value
     */
    p.setConfirmOverwrite = function setConfirmOverwrite(value) {
        this.settings.confirmOverwrite = Types.parseValue(value, 'Boolean', { default: true });
        // In the editor, reflect whether a dialog would be shown at all.
        if (config.editMode && this.modal) {
            this.modal.style.display = this.settings.confirmOverwrite ? 'flex' : 'none';
        }
    };
    /**
     * @method getConfirmOverwrite
     * @return {Boolean}
     */
    p.getConfirmOverwrite = function getConfirmOverwrite() {
        return this.settings.confirmOverwrite;
    };

    /**
     * @method setShowSize
     * Sets the state of property "showSize".
     * @param {Boolean} value
     */
    p.setShowSize = function setShowSize(value) {
        this.settings.showSize = Types.parseValue(value, 'Boolean', { default: true });
        this._rerender();
    };
    /**
     * @method getShowSize
     * @return {Boolean}
     */
    p.getShowSize = function getShowSize() {
        return this.settings.showSize;
    };

    /**
     * @method setShowDate
     * Sets the state of property "showDate".
     * @param {Boolean} value
     */
    p.setShowDate = function setShowDate(value) {
        this.settings.showDate = Types.parseValue(value, 'Boolean', { default: true });
        this._rerender();
    };
    /**
     * @method getShowDate
     * @return {Boolean}
     */
    p.getShowDate = function getShowDate() {
        return this.settings.showDate;
    };

    /**
     * @method setAllowFolderNavigation
     * Sets the state of property "allowFolderNavigation".
     * @param {Boolean} value
     */
    p.setAllowFolderNavigation = function setAllowFolderNavigation(value) {
        this.settings.allowFolderNavigation = Types.parseValue(value, 'Boolean', { default: true });
        this._rerender();
    };
    /**
     * @method getAllowFolderNavigation
     * @return {Boolean}
     */
    p.getAllowFolderNavigation = function getAllowFolderNavigation() {
        return this.settings.allowFolderNavigation;
    };

    // Re-renders the list: sample rows in the editor, the current folder at runtime.
    p._rerender = function _rerender() {
        if (config.editMode) {
            this._renderList(_sampleTelegram());
        } else if (this.fileManager) {
            this._browse(this.currentPath);
        }
    };

    /**
     * @method langChangeHandler
     * Called by the LanguageDependency decorator when the HMI language changes.
     * Re-resolves any dialog text that was set from a text key and refreshes the
     * dialog DOM.
     */
    p.langChangeHandler = function langChangeHandler(e) {
        var widget = this;
        var changed = false;
        ['overwritePrompt', 'overwriteConfirmText', 'overwriteCancelText'].forEach(function (name) {
            var key = widget._locKeys ? widget._locKeys[name] : null;
            if (key && (e === undefined || e.detail === undefined || e.detail.textkey === undefined || e.detail.textkey === key)) {
                widget.settings[name] = language.getText(key);
                changed = true;
            }
        });
        if (changed) {
            widget._refreshModalTexts();
        }
    };

    // Resolves a localizable setting on init: if it holds a text key it is stored
    // and the current translation is applied; otherwise it is kept as literal text.
    p._resolveLocalizable = function _resolveLocalizable(name) {
        var value = this.settings[name];
        if (typeof value === 'string' && language.isKey(value)) {
            var key = language.parseKey(value);
            this._locKeys[name] = key;
            this.settings[name] = language.getText(key);
            this.setLangDependency(true);
        } else {
            this._locKeys[name] = null;
        }
    };

    // Applies a new value to a localizable setting (text key or literal) and
    // refreshes the dialog DOM.
    p._setLocalizable = function _setLocalizable(name, text) {
        if (typeof text !== 'string') { return; }
        if (language.isKey(text)) {
            var key = language.parseKey(text);
            this._locKeys[name] = key;
            this.settings[name] = language.getText(key);
            this.setLangDependency(true);
        } else {
            this._locKeys[name] = null;
            this.settings[name] = text;
        }
        this._refreshModalTexts();
    };

    // Pushes the current dialog texts into the modal DOM.
    p._refreshModalTexts = function _refreshModalTexts() {
        if (this.modalMsg) { this.modalMsg.textContent = this.settings.overwritePrompt; }
        if (this.modalConfirm) { this.modalConfirm.textContent = this.settings.overwriteConfirmText; }
        if (this.modalCancel) { this.modalCancel.textContent = this.settings.overwriteCancelText; }
    };

    // Returns true if a file with the given name exists in the current folder.
    p._fileExists = function _fileExists(name) {
        return Array.isArray(this.currentFileNames) && this.currentFileNames.indexOf(name) !== -1;
    };

    // Shows the overwrite confirmation dialog. onConfirm is called if the user
    // confirms; nothing happens on cancel.
    p._confirmOverwrite = function _confirmOverwrite(fileName, onConfirm) {
        var widget = this;
        if (!this.modal) { onConfirm(); return; }

        this._refreshModalTexts();
        this.modalFile.textContent = fileName;
        this.modal.style.display = 'flex';

        function cleanup() {
            widget.modal.style.display = 'none';
            widget.modalConfirm.removeEventListener('click', onOk);
            widget.modalCancel.removeEventListener('click', onCancel);
        }
        function onOk() { cleanup(); onConfirm(); }
        function onCancel() { cleanup(); }

        this.modalConfirm.addEventListener('click', onOk);
        this.modalCancel.addEventListener('click', onCancel);
    };

    // ------------------------------------------------------------- Backend access

    p._browse = function _browse(path) {
        if (config.editMode || config.preLoadingState || !this.fileManager) { return; }
        var widget = this;

        widget.fileManager.browse(widget.elem.id, path || '', 'FILES|FOLDERS').then(function (telegram) {
            widget.currentPath = path || '';
            widget._renderList(telegram);
        }).catch(function (telegram) {
            widget._handleTelegramError(telegram);
        });
    };

    p._openFile = function _openFile(path, flags, encoding, maxFileSize, offset) {
        if (config.editMode || config.preLoadingState || !this.fileManager) { return; }
        var widget = this;

        if (maxFileSize <= _minFileSize || maxFileSize > _maxFileSize) {
            widget._errorHandling(err_file_size);
            return;
        }

        return widget.fileManager.load(widget.elem.id, path, flags, encoding, maxFileSize, offset).then(function (fileData) {
            if (fileData.length <= widget.settings.maxFileSize) {
                var data = atob(fileData);
                var decode = _decodeBase64(data);
                var blob = new Blob([decode], { type: 'octet/stream' });
                var objectURL = window.URL.createObjectURL(blob);

                widget.a.href = objectURL;
                widget.a.download = _fileName(path);
                widget.a.click();
                window.URL.revokeObjectURL(objectURL);

                /**
                 * @event FileDownloaded
                 * Fired when a file was downloaded to the client device.
                 * @param {String} filePath Path of the file on the backend.
                 * @iatStudioExposed
                 */
                var ev = widget.createEvent('FileDownloaded', { filePath: path });
                if (ev !== undefined) {
                    ev.dispatch();
                }
            } else {
                widget._errorHandling(err_file_size);
            }
        }).catch(function (telegram) {
            widget._handleTelegramError(telegram);
        });
    };

    p._upload = function _upload(event) {
        var widget = this;

        var file = event.target.files[0];
        widget.form.value = null;

        // Ignore a cancelled file dialog.
        if (file === undefined) { return; }

        if (file.size >= widget.settings.maxFileSize) {
            widget._errorHandling(err_file_size);
            return;
        }

        var reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = function (readerEvent) {
            var content = readerEvent.target.result;
            var match = content.match(/data:[^;]+;base64,(.*)/);
            if (match === null) {
                widget._errorHandling(err_unknown);
                return;
            }
            var base64 = match[1];
            var path = _joinPath(widget.currentPath, file.name);

            if (widget.settings.confirmOverwrite && widget._fileExists(file.name)) {
                widget._confirmOverwrite(file.name, function () {
                    widget._saveFile(path, 'OVERWRITE', 'BINARY', base64);
                });
            } else {
                widget._saveFile(path, 'OVERWRITE', 'BINARY', base64);
            }
        };
    };

    p._saveFile = function _saveFile(path, flags, encoding, data) {
        if (config.editMode || config.preLoadingState || !this.fileManager) { return; }
        var widget = this;

        widget.fileManager.save(widget.elem.id, path, flags, encoding, data).then(function () {
            /**
             * @event FileUploaded
             * Fired when a file was uploaded to the backend.
             * @param {String} filePath Path of the file that has been saved.
             * @iatStudioExposed
             */
            var ev = widget.createEvent('FileUploaded', { filePath: path });
            if (ev !== undefined) {
                ev.dispatch();
            }
            // Refresh so the new file appears in the list.
            widget._browse(widget.currentPath);
        }).catch(function (telegram) {
            widget._handleTelegramError(telegram);
        });
    };

    // --------------------------------------------------------------- Image preview

    // Loads an image file (and, if present, a same-named .svg overlay) and shows
    // them in a full screen preview. The two files are loaded sequentially because
    // the FileManager only tracks one pending Load per widget.
    p._previewImage = function _previewImage(item) {
        if (config.editMode || config.preLoadingState || !this.fileManager) { return; }
        var widget = this;
        var name = item.name;
        var mime = _mimeType(name);
        var baseNoExt = name.replace(/\.[^.]+$/, '');
        var svgName = _findSibling(widget.currentFileNames, baseNoExt, 'svg');
        var svgPath = svgName ? _joinPath(widget.currentPath, svgName) : null;

        widget.fileManager.load(widget.elem.id, item.path, 'LOCK', 'BINARY', widget.settings.maxFileSize, 0).then(function (imgData) {
            var url = window.URL.createObjectURL(new Blob([_fileDataToBytes(imgData)], { type: mime }));

            if (!svgPath) {
                widget._showImagePreview(url, '', name);
                return;
            }

            widget.fileManager.load(widget.elem.id, svgPath, 'LOCK', 'BINARY', widget.settings.maxFileSize, 0).then(function (svgData) {
                var overlay = '';
                try {
                    overlay = _extractSvgInner(new TextDecoder().decode(_fileDataToBytes(svgData)));
                } catch (e) {
                    overlay = '';
                }
                widget._showImagePreview(url, overlay, name);
            }).catch(function () {
                // Show the image without an overlay if the svg cannot be loaded.
                widget._showImagePreview(url, '', name);
            });
        }).catch(function (telegram) {
            widget._handleTelegramError(telegram);
        });
    };

    // Measures the image, then renders the preview (see _renderImagePreview).
    p._showImagePreview = function _showImagePreview(url, overlayInner, title) {
        var widget = this;
        var probe = new Image();
        probe.onload = function () {
            widget._renderImagePreview(url, overlayInner, title, probe.naturalWidth, probe.naturalHeight);
        };
        probe.onerror = function () {
            widget._renderImagePreview(url, overlayInner, title, 0, 0);
        };
        probe.src = url;
    };

    p._renderImagePreview = function _renderImagePreview(url, overlayInner, title, imgWidth, imgHeight) {
        var widget = this;
        this._closeImagePreview();

        var overlay = document.createElement('div');
        overlay.className = 'MyWidgetsFileBrowserImagePreview';

        var box = document.createElement('div');
        box.className = 'fb-imgpreview-box';

        var header = document.createElement('div');
        header.className = 'fb-imgpreview-header';

        var titleEl = document.createElement('span');
        titleEl.className = 'fb-imgpreview-title';
        titleEl.textContent = title || '';

        var closeBtn = _createButton('fb-imgpreview-close', '×');

        header.appendChild(titleEl);
        header.appendChild(closeBtn);

        // The image scales responsively; the svg overlay is stretched over its box
        // with a viewBox equal to the image pixel size, so overlay coordinates
        // (e.g. cx="971.1") line up with the picture at any display scale.
        var stage = document.createElement('div');
        stage.className = 'fb-imgpreview-stage';

        var img = document.createElement('img');
        img.className = 'fb-imgpreview-img';
        img.src = url;
        stage.appendChild(img);

        if (overlayInner && imgWidth > 0 && imgHeight > 0) {
            var wrap = document.createElement('div');
            wrap.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" class="fb-imgpreview-overlay" ' +
                'viewBox="0 0 ' + imgWidth + ' ' + imgHeight + '" preserveAspectRatio="none">' +
                overlayInner + '</svg>';
            if (wrap.firstChild) {
                stage.appendChild(wrap.firstChild);
            }
        }

        box.appendChild(header);
        box.appendChild(stage);
        overlay.appendChild(box);
        document.body.appendChild(overlay);

        widget.imagePreviewEl = overlay;
        widget.imagePreviewUrl = url;

        var close = function () { widget._closeImagePreview(); };
        closeBtn.addEventListener('click', close);
        overlay.addEventListener('click', function (e) {
            // Close when the dimmed backdrop (not the box) is clicked.
            if (e.target === overlay) { close(); }
        });
    };

    p._closeImagePreview = function _closeImagePreview() {
        if (this.imagePreviewEl && this.imagePreviewEl.parentNode) {
            this.imagePreviewEl.parentNode.removeChild(this.imagePreviewEl);
        }
        this.imagePreviewEl = null;
        if (this.imagePreviewUrl) {
            window.URL.revokeObjectURL(this.imagePreviewUrl);
            this.imagePreviewUrl = null;
        }
    };

    // ------------------------------------------------------------------- Rendering

    p._renderList = function _renderList(telegram) {
        var widget = this;
        var list = widget.list;
        list.innerHTML = '';
        widget.currentFileNames = [];

        if (widget.pathLabel) {
            widget.pathLabel.textContent = widget.currentPath || '/';
        }

        // Parent folder navigation entry.
        if (widget.settings.allowFolderNavigation && widget.currentPath) {
            list.appendChild(_createRow(widget, {
                name: '..',
                path: _parentPath(widget.currentPath),
                type: 'FOLDER',
                size: '',
                date: ''
            }, true));
        }

        if (Array.isArray(telegram)) {
            telegram.forEach(function (entry) {
                var type = (entry.Type === 'FILE') ? 'FILE' : 'FOLDER';
                var item = {
                    name: _baseName(entry.Path, type),
                    path: entry.Path,
                    type: type,
                    size: (type === 'FILE') ? _formatSize(entry.Size) : '',
                    date: _formatDate(entry.Date)
                };
                if (type === 'FILE') {
                    widget.currentFileNames.push(item.name);
                }
                list.appendChild(_createRow(widget, item, false));
            });
        }

        widget.selected = null;
    };

    p._selectItem = function _selectItem(item, rowEl) {
        var widget = this;
        var previous = widget.list.querySelector('.fb-item.selected');
        if (previous) { previous.classList.remove('selected'); }
        rowEl.classList.add('selected');

        widget.selected = item;

        /**
         * @event SelectionChanged
         * Fired when the selected item in the list changes.
         * @param {String} fileName Name of the selected item.
         * @param {String} filePath Backend path of the selected item.
         * @iatStudioExposed
         */
        var ev = widget.createEvent('SelectionChanged', { fileName: item.name, filePath: item.path });
        if (ev !== undefined) {
            ev.dispatch();
        }
    };

    p._openFolder = function _openFolder(item) {
        if (!this.settings.allowFolderNavigation || item.type !== 'FOLDER') { return; }
        this.currentPath = item.path;
        this.selected = null;
        this._browse(this.currentPath);
        this._dispatchPathChanged();
    };

    p._dispatchPathChanged = function _dispatchPathChanged() {
        /**
         * @event PathChanged
         * Fired when the displayed backend folder changes.
         * @param {String} path New backend path.
         * @iatStudioExposed
         */
        var ev = this.createEvent('PathChanged', { path: this.currentPath });
        if (ev !== undefined) {
            ev.dispatch();
        }
    };

    // ------------------------------------------------------------- Error handling

    p._handleTelegramError = function _handleTelegramError(telegram) {
        if (telegram === undefined || telegram.error === undefined || telegram.error.code === undefined) {
            this._errorHandling(err_unknown);
        } else if (telegram.error.code === err_request_superseded) {
            // A newer request replaced this one - benign, do not surface it.
            return;
        } else {
            this._errorHandling(telegram.error.code);
        }
    };

    p._errorHandling = function _errorHandling(code) {
        var widget = this;

        /**
         * @event OnError
         * Fired when an error occurs during an operation.
         * @param {Number} response Error number transmitted by the mapp component or the widget.
         * @iatStudioExposed
         */
        var ev = widget.createEvent('OnError', { response: code });
        if (ev !== undefined) {
            ev.dispatch();
        }

        if (!config.editMode && logger !== undefined) {
            var m = 'Error ' + code + ' in FileBrowser on page ' + widget.settings.parentContentId + ' at widget ' + widget.elem.id;
            logger.log(Enum.EventLoggerId.CLIENT_SCRIPT_FAIL, Enum.EventLoggerCustomer.BUR, Enum.EventLoggerVerboseLevel.OFF, Enum.EventLoggerSeverity.ERROR, [], m);
        }
    };

    // ------------------------------------------------------------------- Lifecycle

    p.dispose = function () {
        if (this.a && this.a.parentNode) {
            this.a.parentNode.removeChild(this.a);
        }
        if (this.form) {
            this.form.removeEventListener('change', this._getBound('_upload'));
            if (this.form.parentNode) {
                this.form.parentNode.removeChild(this.form);
            }
        }
        // The dialog and image preview live on <body>, so remove them explicitly.
        if (this.modal && this.modal.parentNode) {
            this.modal.parentNode.removeChild(this.modal);
        }
        this._closeImagePreview();
        if (this.fileManager) {
            this.fileManager.removePromises(this.elem.id);
        }
        // Stop listening for language changes.
        if (typeof this.setLangDependency === 'function') {
            this.setLangDependency(false);
        }
        BaseWidget.prototype.dispose.apply(this, arguments);
    };

    // ------------------------------------------------------------- Private helpers

    function _buildDom(widget) {
        var root = widget.elem;

        var toolbar = document.createElement('div');
        toolbar.className = 'fb-toolbar';

        widget.btnRefresh = _createButton('fb-btn fb-refresh', 'Refresh');
        widget.btnUpload = _createButton('fb-btn fb-upload', 'Upload');
        widget.btnDownload = _createButton('fb-btn fb-download', 'Download');

        toolbar.appendChild(widget.btnRefresh);
        toolbar.appendChild(widget.btnUpload);
        toolbar.appendChild(widget.btnDownload);

        widget.pathLabel = document.createElement('span');
        widget.pathLabel.className = 'fb-path';
        widget.pathLabel.textContent = widget.currentPath || '/';
        toolbar.appendChild(widget.pathLabel);

        widget.list = document.createElement('ul');
        widget.list.className = 'fb-list';

        root.appendChild(toolbar);
        root.appendChild(widget.list);

        // Configurable font size for the whole widget (list + toolbar).
        if (widget.settings.fontSize > 0) {
            root.style.fontSize = widget.settings.fontSize + 'px';
        }

        // Overwrite confirmation dialog. At runtime it is appended to <body> and
        // positioned fixed so it is centered on the whole screen and never
        // clipped by the (possibly small) widget bounds. In the editor it is
        // instead shown inline inside the widget as an always-visible preview.
        var modal = document.createElement('div');
        modal.className = 'MyWidgetsFileBrowserModal' + (config.editMode ? ' MyWidgetsFileBrowserModal--preview' : '');
        if (widget.settings.dialogFontSize > 0) {
            modal.style.fontSize = widget.settings.dialogFontSize + 'px';
        }

        var box = document.createElement('div');
        box.className = 'fb-modal-box';
        if (widget.settings.dialogWidth > 0) {
            box.style.width = widget.settings.dialogWidth + 'px';
        }
        widget.modalBox = box;

        widget.modalMsg = document.createElement('div');
        widget.modalMsg.className = 'fb-modal-msg';

        widget.modalFile = document.createElement('div');
        widget.modalFile.className = 'fb-modal-file';

        var actions = document.createElement('div');
        actions.className = 'fb-modal-actions';

        widget.modalCancel = _createButton('fb-modal-btn fb-modal-cancel', '');
        widget.modalConfirm = _createButton('fb-modal-btn fb-modal-confirm', '');

        actions.appendChild(widget.modalCancel);
        actions.appendChild(widget.modalConfirm);
        box.appendChild(widget.modalMsg);
        box.appendChild(widget.modalFile);
        box.appendChild(actions);
        modal.appendChild(box);
        widget.modal = modal;

        if (config.editMode) {
            // Inline preview: contained in the widget, always visible.
            root.style.position = 'relative';
            widget.modalFile.textContent = 'Example.file';
            modal.style.display = 'flex';
            root.appendChild(modal);
        } else {
            modal.style.display = 'none';
            document.body.appendChild(modal);
        }

        widget._refreshModalTexts();

        if (!config.editMode) {
            widget.btnRefresh.addEventListener('click', widget._bind('Refresh'));
            widget.btnUpload.addEventListener('click', widget._bind('Upload'));
            widget.btnDownload.addEventListener('click', widget._bind('Download'));
        }
    }

    function _createButton(className, text) {
        var btn = document.createElement('button');
        btn.className = className;
        btn.type = 'button';
        btn.textContent = text;
        return btn;
    }

    // Parses a value to an integer, returning fallback when it is not a number.
    function _toInt(value, fallback) {
        var n = parseInt(value, 10);
        return isNaN(n) ? fallback : n;
    }

    // True if the file name has a raster image extension.
    function _isImage(name) {
        return /\.(jpe?g|png|gif|bmp|webp)$/i.test(name || '');
    }

    // MIME type for an image file name (defaults to jpeg).
    function _mimeType(name) {
        var ext = ((name || '').split('.').pop() || '').toLowerCase();
        switch (ext) {
            case 'png': return 'image/png';
            case 'gif': return 'image/gif';
            case 'bmp': return 'image/bmp';
            case 'webp': return 'image/webp';
            default: return 'image/jpeg';
        }
    }

    // Finds a sibling file "<baseNoExt>.<ext>" (case-insensitive) in a name list,
    // returning its actual (original-case) name or null.
    function _findSibling(names, baseNoExt, ext) {
        if (!Array.isArray(names)) { return null; }
        var target = (baseNoExt + '.' + ext).toLowerCase();
        for (var i = 0; i < names.length; i += 1) {
            if ((names[i] || '').toLowerCase() === target) { return names[i]; }
        }
        return null;
    }

    // Returns the drawable content of an svg overlay file: strips an XML/doctype
    // prologue and, if the content is a full <svg> document, returns its inner
    // markup; a bare fragment (e.g. "<circle .../>") is returned unchanged.
    function _extractSvgInner(text) {
        if (typeof text !== 'string') { return ''; }
        var t = text.replace(/<\?xml[\s\S]*?\?>/i, '').replace(/<!DOCTYPE[\s\S]*?>/i, '');
        var m = t.match(/<svg[\s\S]*?>([\s\S]*)<\/svg\s*>/i);
        return (m ? m[1] : t).trim();
    }

    // Converts the base64 string returned by FileManager.load into raw bytes,
    // using the same two-step decoding as _openFile (which is known to be correct
    // because the download it drives produces valid files).
    function _fileDataToBytes(fileData) {
        return _decodeBase64(atob(fileData));
    }

    // Representative folder/file rows shown in the editor so the list styling can
    // be judged without a backend connection.
    function _sampleTelegram() {
        var now = new Date().toISOString();
        return [
            { Path: 'Recipes/', Type: 'DIRECTORY', Size: 0, Date: now },
            { Path: 'Backups/', Type: 'DIRECTORY', Size: 0, Date: now },
            { Path: 'Report.csv', Type: 'FILE', Size: 10240, Date: now },
            { Path: 'Config.xml', Type: 'FILE', Size: 1536, Date: now },
            { Path: 'Image01.png', Type: 'FILE', Size: 204800, Date: now }
        ];
    }

    function _createRow(widget, item, isParent) {
        var li = document.createElement('li');
        li.className = 'fb-item ' + (item.type === 'FOLDER' ? 'fb-folder' : 'fb-file');
        li.setAttribute('data-path', item.path);
        li.setAttribute('data-type', item.type);
        if (widget.settings.rowHeight > 0) {
            li.style.minHeight = widget.settings.rowHeight + 'px';
        }

        var icon = document.createElement('span');
        icon.className = 'fb-icon';
        icon.textContent = (item.type === 'FOLDER') ? '📁' : '📄';
        li.appendChild(icon);

        var name = document.createElement('span');
        name.className = 'fb-name';
        name.textContent = item.name;
        li.appendChild(name);

        if (widget.settings.showSize) {
            var size = document.createElement('span');
            size.className = 'fb-size';
            size.textContent = item.size;
            li.appendChild(size);
        }

        if (widget.settings.showDate) {
            var date = document.createElement('span');
            date.className = 'fb-date';
            date.textContent = item.date;
            li.appendChild(date);
        }

        if (!config.editMode) {
            li.addEventListener('click', function () {
                if (isParent) {
                    widget._openFolder(item);
                } else {
                    widget._selectItem(item, li);
                }
            });
            if (item.type === 'FOLDER') {
                li.addEventListener('dblclick', function () {
                    widget._openFolder(item);
                });
            } else if (widget.settings.imagePreview && !isParent && _isImage(item.name)) {
                li.addEventListener('dblclick', function () {
                    widget._previewImage(item);
                });
            }
        }

        return li;
    }

    // Returns the file/folder name from a full backend path.
    function _baseName(path, type) {
        if (typeof path !== 'string') { return ''; }
        var parts = path.split('/');
        if (type === 'FILE') {
            return parts[parts.length - 1];
        }
        // Folder paths usually end with a trailing slash.
        return parts[parts.length - 1] || parts[parts.length - 2] || path;
    }

    // Returns just the file name (used for the client side download name).
    function _fileName(path) {
        if (typeof path !== 'string') { return 'download'; }
        var s = path.replace(/\\/g, '/');
        return s.substring(s.lastIndexOf('/') + 1) || 'download';
    }

    // Computes the parent folder path of a folder path.
    function _parentPath(path) {
        if (!path) { return ''; }
        var s = path.replace(/\/+$/, '');
        var idx = s.lastIndexOf('/');
        return (idx <= 0) ? '' : s.substring(0, idx + 1);
    }

    // Joins a folder path and a file name into a full backend path.
    function _joinPath(dir, name) {
        if (!dir) { return name; }
        return (dir.charAt(dir.length - 1) === '/') ? dir + name : dir + '/' + name;
    }

    function _formatSize(size) {
        if (size === undefined || size === null || size === '') { return ''; }
        var bytes = (typeof size === 'number') ? size : parseInt(size, 10);
        if (isNaN(bytes)) { return String(size); }
        if (bytes < 1024) { return bytes + ' B'; }
        if (bytes < 1024 * 1024) { return (bytes / 1024).toFixed(1) + ' KB'; }
        return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
    }

    function _formatDate(date) {
        if (!date) { return ''; }
        var d = new Date(date);
        if (isNaN(d.getTime())) { return String(date); }
        return d.toLocaleString();
    }

    // Decodes a binary base64 string into a byte array.
    function _decodeBase64(input) {
        var output = new Uint8Array(input.length);
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;
        var n = 0;

        input = input.replace(/[^A-Za-z0-9+/=]/g, '');

        while (i < input.length) {
            enc1 = keyStr.indexOf(input.charAt(i++));
            enc2 = keyStr.indexOf(input.charAt(i++));
            enc3 = keyStr.indexOf(input.charAt(i++));
            enc4 = keyStr.indexOf(input.charAt(i++));

            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;

            output[n++] = chr1;
            if (enc3 !== 64) { output[n++] = chr2; }
            if (enc4 !== 64) { output[n++] = chr3; }
        }

        return output.subarray(0, n);
    }

    return LanguageDependency.decorate(WidgetClass, false);
});
