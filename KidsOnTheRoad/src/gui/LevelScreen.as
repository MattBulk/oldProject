/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/13/13
 * Time: 5:28 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import com.greensock.TweenLite;
import events.NavigationEvent;
import mutation.components.MHeader;
import mutation.components.MMovieButton;
import mutation.components.MSimpleButton;
import mutation.components.MTiledButton;
import mutation.events.MEvent;
import mutation.screens.MPanelScreen;
import mutation.utils.MConstant;

import utils.Settings;
import utils.WriteTheFile;

public class LevelScreen extends MPanelScreen {

    private var buttonGroup:MTiledButton;

    public function LevelScreen(p_node:GNode) {

        super(p_node);

        init();
    }

    private function init():void {

        var header:MHeader = GNodeFactory.createNodeWithComponent(MHeader) as MHeader;

        header.textureId = MConstant.FONT_ATLAS;
        header.setScale = MConstant.TEXT_LARGE;
        header.title = "SELECT THE LEVEL";

        this.node.addChild(header.node);

        buttonGroup = GNodeFactory.createNodeWithComponent(MTiledButton) as MTiledButton;

        buttonGroup.sendData = [

            {text:"1", setScale:MConstant.TEXT_LARGE},
            {text:"2", setScale:MConstant.TEXT_LARGE},
            {text:"3", setScale:MConstant.TEXT_LARGE},
            {text:"4", setScale:MConstant.TEXT_LARGE},
            {text:"5", setScale:MConstant.TEXT_LARGE},
            {text:"6", setScale:MConstant.TEXT_LARGE},
            {text:"7", setScale:MConstant.TEXT_LARGE},
            {text:"8", setScale:MConstant.TEXT_LARGE},
            {text:"9", setScale:MConstant.TEXT_LARGE},
            {text:"10", setScale:MConstant.TEXT_LARGE}

        ];

        buttonGroup.gap = 1.3;
        buttonGroup.init(MSimpleButton, 10, "GUI_level_btn");
        buttonGroup.node.transform.setPosition(0 , -MConstant.STAGE_HEIGHT * .08);

        this.node.addChild(buttonGroup.node);

        var activity:MMovieButton = GNodeFactory.createNodeWithComponent(MMovieButton) as MMovieButton;
        activity.textureId = "GUI_tour";
        activity.frames = ["GUI_tour", "GUI_my_tracks", "GUI_grandprix"];
        activity.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .75);
        activity.node.onMouseClick.add(setActivity);
        node.addChild(activity.node);

        var back:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        back.textureId = "GUI_back_btn";
        back.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .9);
        node.addChild(back.node);

        back.node.mouseEnabled = true;
        back.node.onMouseClick.add(completeEvent);

    }

    private function setActivity(evt:GMouseSignal):void {

        Settings.SM.playSound("../sounds/SELECT.mp3");
        TweenLite.from(evt.target.transform, .2, {scaleX:1.1, scaleY:1.1});

        const btn:MMovieButton = (evt.target.getComponent(MMovieButton) as MMovieButton);

        btn.next();

        Settings.ACTIVITY = btn.currentFrame;

        setLabels();

    }

    private function setLabels():void {


        for(var i:uint=0; i<buttonGroup.groupVec.length; i++) {

            if(Settings.ACTIVITY == 1) {
                if(WriteTheFile.getInstance().slotXML.world[Settings.WORLD-1].slot[i] == "NEW") {

                    buttonGroup.groupVec[i].text = "EMPTY";
                    buttonGroup.groupVec[i].setScale = MConstant.TEXT_SMALL;
                }
                else {
                    buttonGroup.groupVec[i].text = WriteTheFile.getInstance().slotXML.world[Settings.WORLD-1].slot[i];
                    buttonGroup.groupVec[i].setScale = MConstant.TEXT_LARGE;
                }
            }
            else {
                buttonGroup.groupVec[i].text = (i + 1).toString();
                buttonGroup.groupVec[i].setScale = MConstant.TEXT_LARGE;
                buttonGroup.groupVec[i].node.name = (i + 1).toString();
            }
        }
    }

    private function completeEvent(evt:GMouseSignal):void {

        Settings.SM.playSound("../sounds/SELECT.mp3");
        TweenLite.from(evt.target.transform, .2, {scaleX:1.1, scaleY:1.1});
        TweenLite.delayedCall(.3, fl_TimerHandler);

        AssetManager.disposeAtlasTexture("world");
        AssetManager.disposeBitmapTexture("tile");

    }

    protected function fl_TimerHandler():void
    {
        node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));
        node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "player"}, true));
    }

    override public function onButtonTriggered(evt:MEvent):void
    {
        var btn:MSimpleButton = evt.params.id.getComponent(MSimpleButton) as MSimpleButton;

        if(btn.text == "EMPTY") return;

        Settings.LEVEL = uint(btn.text);

        Settings.SM.playSound("../sounds/SELECT.mp3");
        TweenLite.from(btn.node.transform, .2, {scaleX:1.1, scaleY:1.1});
        TweenLite.delayedCall(.5, delay);

    }

    protected function delay():void {

        node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id:"play"}, true));
        node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "bg"}, true));
    }


}
}
