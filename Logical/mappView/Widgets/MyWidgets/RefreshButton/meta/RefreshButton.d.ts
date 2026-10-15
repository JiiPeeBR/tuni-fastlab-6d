interface widgets_MyWidgets_RefreshButton{
        
        /**
        * Sets focus on the widget element, if it can be focused and keyboardOperation=true
        */
        focus(): void;

        /**
        * Remove an image.
        */
        removeImage(): void;

        /**
        * Remove mouseDownText.
        */
        removeMouseDownText(): void;

        /**
        * Remove text.
        */
        removeText(): void;

        /**
        * Sets the state of property "enable"
        */
        setEnable(value: boolean): void;

        /**
        * Sets an image.
        */
        setImage(image: ImagePath): void;

        /**
        * Sets the image when mouse down
        */
        setMouseDownImage(mouseDownImage: ImagePath): void;

        /**
        * Sets the visible text for pressed state. This method can remove an optional textkey.
        */
        setMouseDownText(text: string, keepKey?: boolean): void;

        /**
        * 
        */
        setStyle(value: StyleReference): void;

        /**
        * Sets the visible text. This method can remove an optional textkey.
        */
        setText(text: string, keepKey?: boolean): void;

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
        * Fired when element has double click.
        */
        doubleClick(handler: (e: { detail: { horizontalPos: string, verticalPos: string } }) => void):void;

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
        * Fired when widget enters mouseDown state
        */
        mouseDown(handler: (e: { detail: { horizontalPos: string, verticalPos: string } }) => void):void;

        /**
        * Fired when widget enters mouseUp state
        */
        mouseUp(handler: (e: { detail: { horizontalPos: string, verticalPos: string } }) => void):void;

        /**
        * Fired when element has OnDragEnd.
        */
        onDragEnd(handler: (e: { detail: { contentId: string, widgetId: string } }) => void):void;

        /**
        * Fired when element has onDragEnter.
        */
        onDragEnter(handler: (e: { detail: { contentId: string, widgetId: string } }) => void):void;

        /**
        * Fired when element has OnDragLeave.
        */
        onDragLeave(handler: (e: { detail: { contentId: string, widgetId: string } }) => void):void;

        /**
        * Fired when element has OnDragStart.
        */
        onDragStart(handler: (e: { detail: { contentId: string, widgetId: string } }) => void):void;

        /**
        * Fired when element has OnDrop.
        */
        onDrop(handler: (e: { detail: { contentId: string, widgetId: string } }) => void):void;

        /**
        * Fired when the visibility of the widget changes.
        */
        visibleChanged(handler: (e: { detail: { value: boolean } }) => void):void;       
}
interface widgets_MyWidgets_RefreshButton_private extends widgets_MyWidgets_RefreshButton{
         
               
}