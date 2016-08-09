/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/8/13
 * Time: 5:10 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {

import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import com.greensock.TweenLite;
import events.NavigationEvent;
import mutation.components.MGroupButton;
import mutation.components.MHeader;
import mutation.components.MMovieButton;
import mutation.events.MEvent;
import mutation.screens.MPanelScreen;
import mutation.utils.MConstant;

import utils.Settings;

public class SettingScreen extends MPanelScreen {

    public function SettingScreen(p_node:GNode) {

        super(p_node);

        init();

    }

    private function init():void {

        const header:MHeader = GNodeFactory.createNodeWithComponent(MHeader) as MHeader;

        header.textureId = "ATLAS_FONT";
        header.title = "SETTINGS";

        this.node.addChild(header.node);

        const buttonGroup:MGroupButton = GNodeFactory.createNodeWithComponent(MGroupButton) as MGroupButton;

        buttonGroup.sendData = [

            {frames:["GUI_level_01", "GUI_level_02", "GUI_level_03"], text:"", event:"level"},
            {frames:["GUI_mode_01", "GUI_mode_02"], text:"", event:"mode"},
            {frames:["GUI_touch", "GUI_tilt"], text:"", event:"controls"},
            {frames:["GUI_sound_on", "GUI_sound_off"], text:"", event:"sound"}
        ];

        buttonGroup.direction = MConstant.VERTICAL_LAYOUT;
        buttonGroup.gap = 1.3;
        buttonGroup.init(MMovieButton, 4, "GUI_level_01");

        this.node.addChild(buttonGroup.node);

        const back:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        back.textureId = "GUI_back_btn";
        back.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .9);
        node.addChild(back.node);

        back.node.mouseEnabled = true;
        back.node.onMouseClick.add(completeEvent);

        buttonGroup.groupVec[0].gotoFrame(1);

        Settings.DIFFICULTY = buttonGroup.groupVec[0].currentFrame;
        Settings.MODE = buttonGroup.groupVec[1].currentFrame;

    }

    private function completeEvent(evt:GMouseSignal):void {

        Settings.SM.playSound("../sounds/SELECT.mp3");
        TweenLite.from(evt.target.transform, .2, {scaleX:1.2, scaleY:1.2});
        TweenLite.delayedCall(.3, fl_TimerHandler);

    }

    protected function fl_TimerHandler():void
    {
        node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));
        node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "main"}, true));
    }

    override public function onButtonTriggered(evt:MEvent):void
    {
        const btn:MMovieButton = evt.params.id.getComponent(MMovieButton) as MMovieButton;

        btn.next();

        switch (btn.event) {

            case "sound" :
                if(Settings.MUTE) { Settings.MUTE = false; Settings.SM.playSound("../sounds/MAIN.mp3", 0, -1); }
                else { Settings.MUTE = true; Settings.SM.stopSound("../sounds/MAIN.mp3"); }
                break;
            case "level" :
                Settings.DIFFICULTY = btn.currentFrame;
                break;
            case "controls" :
                Settings.CONTROLS = btn.currentFrame;
                break;
            case "mode" :
                Settings.MODE = btn.currentFrame;
                break;

        }

        Settings.SM.playSound("../sounds/SELECT.mp3");
        TweenLite.from(btn.node.transform, .2, {scaleX:1.1, scaleY:1.1});

    }
}
}
