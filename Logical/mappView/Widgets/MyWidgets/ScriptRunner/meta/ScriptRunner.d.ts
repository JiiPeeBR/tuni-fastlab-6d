interface widgets_MyWidgets_ScriptRunner{
        
        /**
        * Loads and executes the configured scripts, in order. Can be triggeredrepeatedly; each call re-loads the files.
        */
        run(): void;

        /**
        * Sets focus on the widget element, if it can be focused and keyboardOperation=true
        */
        focus(): void;

        /**
        * Sets the state of property "enable"
        */
        setEnable(value: boolean): void;

        /**
        * Sets the comma separated list of scripts. If autoRun is enabled the newlist is executed immediately.
        */
        setScripts(scripts: string): void;

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
        * Fired once, after every configured script has finished loading(whether it succeeded or errored).
        */
        allScriptsLoaded(handler: (e: { detail: { count: number } }) => void):void;

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
        * Fired when the widgets gets focus
        */
        focusIn(handler: () => void):void;

        /**
        * Fired when the widgets lost focus
        */
        focusOut(handler: () => void):void;

        /**
        * Fired when a script cannot be loaded or its hook throws.
        */
        scriptError(handler: (e: { detail: { script: string, message: string } }) => void):void;

        /**
        * Fired after a single script file has loaded and its hook (ifany) has been invoked.
        */
        scriptLoaded(handler: (e: { detail: { script: string } }) => void):void;

        /**
        * Fired when the visibility of the widget changes.
        */
        visibleChanged(handler: (e: { detail: { value: boolean } }) => void):void;       
}
interface widgets_MyWidgets_ScriptRunner_private extends widgets_MyWidgets_ScriptRunner{
         
               
}