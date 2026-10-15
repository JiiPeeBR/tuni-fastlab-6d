interface widgets_MyWidgets_FileBrowser{
        
        /**
        * Downloads the currently selected file from the backend to the client device.
        */
        download(): void;

        /**
        * Reloads the list of the currently displayed backend folder.
        */
        refresh(): void;

        /**
        * Opens a file selection dialog and uploads the chosen file into thecurrently displayed backend folder.
        */
        upload(): void;

        /**
        * Sets focus on the widget element, if it can be focused and keyboardOperation=true
        */
        focus(): void;

        /**
        * Sets the state of property "enable"
        */
        setEnable(value: boolean): void;

        /**
        * Sets the maximum transfer size in bytes.
        */
        setMaxFileSize(maxFileSize: Integer): void;

        /**
        * Sets the label of the cancel button in the overwrite dialog.
        */
        setOverwriteCancelText(text: string): void;

        /**
        * Sets the label of the confirm (overwrite) button in the overwrite dialog.
        */
        setOverwriteConfirmText(text: string): void;

        /**
        * Sets the question shown in the overwrite confirmation dialog.
        */
        setOverwritePrompt(text: string): void;

        /**
        * Sets the backend directory to browse and refreshes the list.
        */
        setPath(path: string): void;

        /**
        * 
        */
        setStyle(value: StyleReference): void;

        /**
        * Sets the state of property "visible"
        */
        setVisible(value: boolean): void;

        /**
        * 
        */
        showTooltip(): void; 
        
        /**
        * Fired when element is clicked on.
        */
        click(handler: (e: { detail: { origin: string, horizontalPos: string, verticalPos: string } }) => void):void;

        /**
        * Fired when disabled element is clicked on.
        */
        disabledClick(handler: (e: { detail: { origin: string, hasPermission: boolean, horizontalPos: string, verticalPos: string } }) => void):void;

        /**
        * Fired when operability of the widget changes.
        */
        enableChanged(handler: (e: { detail: { value: boolean } }) => void):void;

        /**
        * Fired when a file was downloaded to the client device.
        */
        fileDownloaded(handler: (e: { detail: { filePath: string } }) => void):void;

        /**
        * Fired when a file was uploaded to the backend.
        */
        fileUploaded(handler: (e: { detail: { filePath: string } }) => void):void;

        /**
        * Fired when the widgets gets focus
        */
        focusIn(handler: () => void):void;

        /**
        * Fired when the widgets lost focus
        */
        focusOut(handler: () => void):void;

        /**
        * Fired when an error occurs during an operation.
        */
        onError(handler: (e: { detail: { response: number } }) => void):void;

        /**
        * Fired when the displayed backend folder changes.
        */
        pathChanged(handler: (e: { detail: { path: string } }) => void):void;

        /**
        * Fired when the selected item in the list changes.
        */
        selectionChanged(handler: (e: { detail: { fileName: string, filePath: string } }) => void):void;

        /**
        * Fired when the visibility of the widget changes.
        */
        visibleChanged(handler: (e: { detail: { value: boolean } }) => void):void;       
}
interface widgets_MyWidgets_FileBrowser_private extends widgets_MyWidgets_FileBrowser{
         
               
}