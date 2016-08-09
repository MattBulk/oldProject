/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/7/13
 * Time: 2:36 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.screens {

import com.genome2d.components.GComponent;
import com.genome2d.core.GNode;
import mutation.events.MEvent;

public class MPanelScreen extends GComponent {

    protected var _screenID:String;
    protected var _complete:String;
    protected var _activateListeners:Boolean;

    public function MPanelScreen(p_node:GNode) {

        super(p_node);

    }

    //************************************************** PUBLIC METHOD TO OVERRIDE ***********************************************

    public function onButtonTriggered(evt:MEvent):void
    {
        //GET THE COMPONENT
        //(evt.params.id.getComponent(MSimpleButton) as MSimpleButton).text = "HELLO";

        //SET THE BUTTON LIKE FEATHERS AND GET THE INFO YOU NEED
        //var btn:MSimpleButton = evt.params.id.getComponent(MSimpleButton) as MSimpleButton;

        //DISPATCH EVENT
        //node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGESCREEN, {id: btn.event}, true));

        //FIRE THE COMPLETE EVENT
        //if(btn.event == "complete")
        //else node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id: screenID} , true));
    }

    public function onActionTriggered(evt:MEvent):void
    {
        //SET THE BUTTON LIKE FEATHERS AND GET THE INFO YOU NEED
        //var btn:GSprite = evt.params.id.getComponent(GSprite) as GSprite;

        //GET THE PARENT COMPONENT AS SIMPLEBUTTON
        //(btn.node.parent.getComponent(MSimpleButton) as MSimpleButton).text = "CHANGE";
    }

    public function onFunctionTrigger(evt:MEvent):void {

    }

    //************************************************** SETTER AND GETTER METHODS ***********************************************

    public function get screenID():String {
        return _screenID;
    }

    public function set screenID(value:String):void {
        _screenID = value;
    }

    public function get complete():String {
        return _complete;
    }

    public function set complete(value:String):void {
        _complete = value;
    }

    public function get activateListeners():Boolean {
        return _activateListeners;
    }

    public function set activateListeners(value:Boolean):void {

        _activateListeners = value;

        if(_activateListeners) {

            this.node.core.stage.addEventListener(MEvent.TRIGGERED, onButtonTriggered, false, 0, true);
            this.node.core.stage.addEventListener(MEvent.ACTION_TRIGGERED, onActionTriggered, false, 0, true);
            this.node.core.stage.addEventListener(MEvent.FUNCTION, onFunctionTrigger, false, 0, true);
            this.node.active = true;
        }
        else {

            this.node.core.stage.removeEventListener(MEvent.TRIGGERED, onButtonTriggered);
            this.node.core.stage.removeEventListener(MEvent.ACTION_TRIGGERED, onActionTriggered);
            this.node.core.stage.removeEventListener(MEvent.FUNCTION, onFunctionTrigger);
            this.node.active = false;
        }
    }
}
}
