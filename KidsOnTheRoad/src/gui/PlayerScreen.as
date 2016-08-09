/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/8/13
 * Time: 5:18 PM
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
import mutation.components.MSimpleButton;
import mutation.events.MEvent;
import mutation.screens.MPanelScreen;
import mutation.utils.MConstant;

import utils.Settings;

public class PlayerScreen extends MPanelScreen {

    private var name:String;

    public function PlayerScreen(p_node:GNode) {

        super(p_node);

        init();
    }

    private function init():void {

        var header:MHeader = GNodeFactory.createNodeWithComponent(MHeader) as MHeader;

        header.textureId = MConstant.FONT_ATLAS;
        header.title = "WHO IS DRIVING?";

        this.node.addChild(header.node);

        var buttonGroup:MGroupButton = GNodeFactory.createNodeWithComponent(MGroupButton) as MGroupButton;

        buttonGroup.sendData = [

            {text:"", event:"world", textureId:"BUILDER_boy_btn", name:"boy" },
            {text:"", event:"world", textureId:"BUILDER_girl_btn", name:"girl" }

        ];

        buttonGroup.direction = MConstant.HORIZONTAL_LAYOUT;
        buttonGroup.gap = 1.5;
        buttonGroup.init(MSimpleButton, 2, "GUI_level_btn");

        this.node.addChild(buttonGroup.node);

        var back:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        back.textureId = "GUI_back_btn";
        back.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .9);
        node.addChild(back.node);

        back.node.mouseEnabled = true;
        back.node.onMouseClick.add(completeEvent);

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
        var btn:MSimpleButton = evt.params.id.getComponent(MSimpleButton) as MSimpleButton;

        switch (btn.node.name) {

            case "boy":
                    Settings.PLAYER = 1;
                break;
            case "girl":
                    Settings.PLAYER = 2;
                break;
        }

        TweenLite.from(btn.node.transform, .2, {scaleX:1.1, scaleY:1.1});
        TweenLite.delayedCall(.3, delay);

        name = btn.event;

        Settings.SM.playSound("../sounds/SELECT.mp3");

    }

    protected function delay():void {

        node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGE_SCREEN, {id: name}, true));
        node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "world"}, true));
    }

}
}
