/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/5/13
 * Time: 8:23 PM
 * To change this template use File | Settings | File Templates.
 */

package mutation.screens {

import com.genome2d.components.GComponent;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;

import mutation.events.MEvent;

public class MScreenNavigation extends GComponent {

    protected var _screenVec:Vector.<Object> = new Vector.<Object>();
    protected var _class:Class;
    protected var _panelScreen:Object;
    protected var _complete:String;
    protected var _screenID:String;
    protected var _activeScreen:String;

    public function MScreenNavigation(p_node:GNode) {

        super(p_node);

        this.node.core.stage.addEventListener(MEvent.COMPLETE, closeScreen, false, 0, true);

        this.node.core.stage.addEventListener(MEvent.CHANGE_SCREEN, changeScreen, false, 0, true);
    }

    public function enqueueScreen(id:String, mScreen:MScreenNavigationItem):void {

        _class = mScreen.theClass;

        _complete = mScreen.complete;

        _screenID = id;

        addTheScreen();

    }

    internal function addTheScreen():void {

        _panelScreen = GNodeFactory.createNodeWithComponent(_class) as _class;

        _panelScreen.screenID = _screenID;
        _panelScreen.complete = _complete;

        _panelScreen.node.active = false;

        this.node.addChild(_panelScreen.node);

        _screenVec.push(_panelScreen);

    }

    internal function closeScreen(evt:MEvent):void {

        for(var i:uint=0; i<= _screenVec.length-1; i++) {

            if(_screenVec[i].screenID == _activeScreen) {

                _screenVec[i].activateListeners = false;
                showScreen(_screenVec[i].complete);
            }
        }
    }

    internal function changeScreen(evt:MEvent):void {

        showScreen(evt.params.id);
    }

    public function showScreen(id:String):void {

        for(var i:uint=0; i<= _screenVec.length-1; i++) {

            if(_screenVec[i].screenID == id) {
                _screenVec[i].activateListeners = true;
                _activeScreen = _screenVec[i].screenID;
            }
            else _screenVec[i].activateListeners = false;
        }
    }

}
}
