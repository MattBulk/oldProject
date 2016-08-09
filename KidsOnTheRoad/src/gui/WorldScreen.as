/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/13/13
 * Time: 5:09 PM
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

public class WorldScreen extends MPanelScreen {

    private var name:String;

    public function WorldScreen(p_node:GNode) {
        super(p_node);

        init();
    }

    private function init():void {

        var header:MHeader = GNodeFactory.createNodeWithComponent(MHeader) as MHeader;

        header.textureId = MConstant.FONT_ATLAS;
        header.title = "WORLD AREA";

        this.node.addChild(header.node);

        var buttonGroup:MGroupButton = GNodeFactory.createNodeWithComponent(MGroupButton) as MGroupButton;

        buttonGroup.sendData = [

            {text:"", event:"levelScreen", textureId:"GUI_mountain_btn", name:"1" },
            {text:"", event:"levelScreen", textureId:"GUI_city_btn", name:"2" },
            {text:"", event:"levelScreen", textureId:"GUI_sea_btn", name:"3" }

        ];

        buttonGroup.direction = MConstant.HORIZONTAL_LAYOUT;
        buttonGroup.gap = 1.2;
        buttonGroup.init(MSimpleButton, 3, "GUI_sea_btn");

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
        TweenLite.from(evt.target.transform, .2, {scaleX:1.1, scaleY:1.1});
        TweenLite.delayedCall(.3, fl_TimerHandler);

    }

    protected function fl_TimerHandler():void
    {
        node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));
        node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "player"}, true));
    }

    override public function onButtonTriggered(evt:MEvent):void
    {
        const btn:MSimpleButton = evt.params.id.getComponent(MSimpleButton) as MSimpleButton;

        Settings.WORLD = uint(btn.node.name);

        const str:String = "world" + btn.node.name;
        AssetManager.getInstance().addToQueue(AssetManager.ATLAS, "world", Settings.FOLDER, str + ".png", str + ".xml");
        AssetManager.getInstance().addToQueue(AssetManager.BITMAP, "tile", Settings.FOLDER, "roadTile" + btn.node.name + ".png");
        AssetManager.getInstance().loadTheQueue();

        TweenLite.from(btn.node.transform, .3, {scaleX:1.1, scaleY:1.1});
        TweenLite.delayedCall(.5, delay);

        name = btn.event;

        Settings.SM.playSound("../sounds/SELECT.mp3");

    }

    protected function delay():void {

        node.core.stage.dispatchEvent(new MEvent(MEvent.CHANGE_SCREEN, {id: name}, true));
        node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "bg"}, true));
    }
}
}
