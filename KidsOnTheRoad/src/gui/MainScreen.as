/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/8/13
 * Time: 4:25 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {

import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import com.greensock.TweenLite;

import events.NavigationEvent;

import mutation.events.MEvent;
import mutation.screens.MPanelScreen;
import mutation.utils.MConstant;

import utils.Settings;

public class MainScreen extends MPanelScreen  {

    private var name:String;

    public function MainScreen(p_node:GNode) {

        super(p_node);

        init();

    }

    private function init():void {


        const offset:Number = MConstant.STAGE_WIDTH - MConstant.MARGIN;

        const play:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        play.textureId = "GUI_play_btn";
        play.node.transform.setPosition(offset - play.cTexture.width/2, MConstant.STAGE_HEIGHT * .6);
        node.addChild(play.node);

        const trackBuilder:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        trackBuilder.textureId = "GUI_builder";
        trackBuilder.node.transform.setPosition(offset - trackBuilder.cTexture.width/2, MConstant.STAGE_HEIGHT * .75);
        node.addChild(trackBuilder.node);
        
        const settings:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        settings.textureId = "GUI_set_btn";
        settings.node.transform.setPosition(offset - settings.cTexture.width/2, MConstant.STAGE_HEIGHT * .9);
        node.addChild(settings.node);

        play.node.mouseEnabled = true;
        play.node.name = "play";
        play.node.onMouseClick.add(triggerEvent);
        
        settings.node.mouseEnabled = true;
        settings.node.name = "settings";
        settings.node.onMouseClick.add(triggerEvent);
       
        trackBuilder.node.mouseEnabled = true;
        trackBuilder.node.name = "tb";
        trackBuilder.node.onMouseClick.add(triggerEvent);

    }

    private function triggerEvent(evt:GMouseSignal):void
    {

        switch (evt.target.name) {

            case "tb" :
                if(!Settings.MUTE) Settings.SM.stopSound("../sounds/MAIN.mp3");
                Settings.SM.playSound("../sounds/SELECT.mp3");
                break;
            case "play" :
                Settings.SM.playSound("../sounds/ENGINE_START.mp3");
                break;
            case "settings" :
                Settings.SM.playSound("../sounds/SETTINGS.mp3");
                break;

        }

        name = evt.target.name;

        TweenLite.from(evt.target.transform, .2, {scaleX:1.1, scaleY:1.1});
        TweenLite.delayedCall(.3, fl_TimerHandler);

    }

    protected function fl_TimerHandler():void
    {
        if(name == "settings") {
            node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGE_SCREEN, {id: "setting"}, true));
            node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "setting"}, true));
        }
        else if(name == "play") {
            node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGE_SCREEN, {id: "player"}, true));
            node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "player"}, true));
        }
        else if(name == "tb") {
            node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGE_SCREEN, {id: "builder_menu"}, true));
            node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "builder"}, true));
        }
    }
}
}
