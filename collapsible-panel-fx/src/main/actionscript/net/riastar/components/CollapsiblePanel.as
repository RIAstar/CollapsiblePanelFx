package net.riastar.components {

import flash.events.Event;
import flash.events.MouseEvent;

import spark.components.Panel;
import spark.components.supportClasses.ToggleButtonBase;


[Event("open", "flash.events.Event")]
[Event("close", "flash.events.Event")]

/** The collapsed state of the Panel: a smaller form than the <code>normal</code> state, but not entirely minimized. */
[SkinState("collapsed")]

/**
 * A Panel that can be collapsed to a smaller form, but not entirely minimized.
 * A typical example would be to collapse to just the titlebar and hide the content, but that depends entirely on the skin.
 *
 * @author RIAstar
 *
 * @see spark.components.Panel
 */
public class CollapsiblePanel extends Panel {

    /* ----------------- */
    /* --- skinparts --- */
    /* ----------------- */

    [SkinPart(required="true")]
    /** Clicking this skinpart will trigger collapsing/expanding. */
    public var collapseButton:ToggleButtonBase;


    /* ------------------ */
    /* --- properties --- */
    /* ------------------ */

    private var _isCollapsed:Boolean;
    /** Whether the Panel is actually collapsed or not. */
    [Bindable]
    public function get isCollapsed():Boolean {
        return _isCollapsed;
    }
    public function set isCollapsed(value:Boolean):void {
        var changed:Boolean = _isCollapsed != value;
        if (!changed) return;

        _isCollapsed = value;
        if (collapseButton) collapseButton.selected = value;

        invalidateSkinState();
        dispatchEvent(new Event(value ? Event.CLOSE : Event.OPEN));
    }

    override public function set title(value:String):void {
        super.title = value;
        if (collapseButton) collapseButton.label = value;
    }

    override public function get baselinePosition():Number {
        return getBaselinePositionForPart(collapseButton);
    }


    /* -------------------- */
    /* --- construction --- */
    /* -------------------- */

    public function CollapsiblePanel() {
        mouseEnabled = true;
    }

    /**
     * @private
     * @inheritDoc
     */
    override protected function partAdded(partName:String, instance:Object):void {
        super.partAdded(partName, instance);

        switch (instance) {
            case collapseButton:
                collapseButton.label = title;
                collapseButton.selected = _isCollapsed;
                collapseButton.mouseEnabled = true;
                collapseButton.addEventListener(MouseEvent.CLICK, toggleCollapsed);
                break;
            default:
                break;
        }
    }


    /* ----------------- */
    /* --- behaviour --- */
    /* ----------------- */

    /**
     * @private
     * @inheritDoc
     */
    override protected function getCurrentSkinState():String {
        return _isCollapsed ? 'collapsed' : super.getCurrentSkinState();
    }


    /**
     * Handles user clicks on the <code>clickZone</code> skinPart, essentially just toggling <code>isCollapsed</code>.
     *
     * @param event    the <code>CLICK</code> event
     */
    private function toggleCollapsed(event:MouseEvent = null):void {
        if (mouseEnabled) isCollapsed = !_isCollapsed;
    }


    /* ------------------- */
    /* --- destruction --- */
    /* ------------------- */

    /**
     * @private
     * @inheritDoc
     */
    override protected function partRemoved(partName:String, instance:Object):void {
        super.partRemoved(partName, instance);

        switch (instance) {
            case collapseButton:
                collapseButton.removeEventListener(MouseEvent.CLICK, toggleCollapsed);
                break;
            default:
                break;
        }
    }

}
}
