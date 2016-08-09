/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/13/13
 * Time: 8:40 PM
 * To change this template use File | Settings | File Templates.
 */
package gui.builder {

import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import com.greensock.TweenLite;
import events.NavigationEvent;
import mutation.components.MActionButton;
import mutation.components.MHeader;
import mutation.components.MMovieButton;
import mutation.components.MTiledButton;
import mutation.events.MEvent;
import mutation.screens.MPanelScreen;
import mutation.utils.MConstant;

import utils.Settings;
import utils.WriteTheFile;

public class BuilderLevelScreen extends MPanelScreen {

    private var name:String;
    private var back:GSprite;
    private var deleteBtn:MMovieButton;
    private var buttonGroup:MTiledButton;
    private var DELETE:Boolean;

    public function BuilderLevelScreen(p_node:GNode) {

        super(p_node);

        init();
    }

    private function init():void {

        const header:MHeader = GNodeFactory.createNodeWithComponent(MHeader) as MHeader;

        header.textureId = MConstant.FONT_ATLAS;
        header.setScale = MConstant.TEXT_LARGE;
        header.title = "TRACK BUILDER";

        this.node.addChild(header.node);

        buttonGroup = GNodeFactory.createNodeWithComponent(MTiledButton) as MTiledButton;

        buttonGroup.sendData = [

            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"},
            {text:"", setScale:MConstant.TEXT_MEDIUM, actionId:"BUILDER_delete_x"}

        ];

        buttonGroup.gap = 1.3;
        buttonGroup.init(MActionButton, 10, "GUI_level_btn");

        buttonGroup.node.transform.y = -MConstant.STAGE_HEIGHT * .07;

        this.node.addChild(buttonGroup.node);

        back = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        back.textureId = "GUI_back_btn";
        back.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .9);
        node.addChild(back.node);

        back.node.mouseEnabled = true;
        back.node.name = "back";
        back.node.onMouseClick.add(onSignalEvent);

        deleteBtn = GNodeFactory.createNodeWithComponent(MMovieButton) as MMovieButton;
        deleteBtn.frames = ["BUILDER_delete", "BUILDER_ok_btn"];
        deleteBtn.textureId = "BUILDER_delete";
        deleteBtn.node.name = "delete";
        deleteBtn.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .75);
        node.addChild(deleteBtn.node);

        deleteBtn.node.onMouseClick.add(onSignalEvent);

    }

    private function onSignalEvent(evt:GMouseSignal):void {

        name = evt.target.name;
        Settings.SM.playSound("../sounds/SELECT.mp3");
        TweenLite.from(evt.target.transform, .2, {scaleX:1.1, scaleY:1.1});
        TweenLite.delayedCall(.3, fl_TimerHandler);

    }

    protected function fl_TimerHandler():void
    {
        switch (name) {

            case "back":
                node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));
                break;
            case "delete":
                if(deleteBtn.currentFrame == 0) {
                    back.node.active = false;
                    deletePhase(true);
                }
                else {
                    back.node.active = true;
                    deletePhase(false);
                }
                deleteBtn.next();
                break;

        }

    }

    private function deletePhase(b:Boolean):void {

        for(var i:uint=0; i<=buttonGroup.groupVec.length-1; i++) {

            if(buttonGroup.groupVec[i].text != "NEW") {

                buttonGroup.groupVec[i].actionBtn.node.active = b;
                buttonGroup.groupVec[i].actionMode = b;
            }
        }

        DELETE = b;
    }

    private function setTheLabels():void {

        for(var i:uint=0; i<=buttonGroup.groupVec.length-1; i++) {

            if(WriteTheFile.getInstance().slotXML.world[Settings.AREA].slot[i] == "NEW") {

                buttonGroup.groupVec[i].text = WriteTheFile.getInstance().slotXML.world[Settings.AREA].slot[i];
                buttonGroup.groupVec[i].node.name = (i + 1).toString();

            }
            else {
                buttonGroup.groupVec[i].text = WriteTheFile.getInstance().slotXML.world[Settings.AREA].slot[i];
                buttonGroup.groupVec[i].setScale = MConstant.TEXT_LARGE;
                buttonGroup.groupVec[i].node.name = "FULL";
            }

        }
    }

    override public function onFunctionTrigger(evt:MEvent):void {

        this[evt.params.id]();
    }

    override public function onButtonTriggered(evt:MEvent):void
    {
        const btn:MActionButton = evt.params.id.getComponent(MActionButton) as MActionButton;

        if(btn.actionMode || DELETE) return;

        else if(btn.node.name != "FULL") {

            Settings.SLOT = uint(btn.node.name);
            node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id:"builder"}, true));

        }
    }

    override public function onActionTriggered(evt:MEvent):void
    {
        //SET THE BUTTON LIKE FEATHERS AND GET THE INFO YOU NEED
        var btn:GSprite = evt.params.id.getComponent(GSprite) as GSprite;

        btn.node.active = false;

        //SET THE NUMBER AS STRING VARIABLE AND DELETE THE TRACK
        var number:String = (btn.node.parent.getComponent(MActionButton) as MActionButton).text;
        WriteTheFile.getInstance().slotXML.world[Settings.AREA].slot[uint(number)-1] = "NEW";
        WriteTheFile.getInstance().deleteXML((Settings.AREA + 1).toString() + "-"+ number + ".xml");
        //SET BUTTON PROPERTIES
        (btn.node.parent.getComponent(MActionButton) as MActionButton).setScale = MConstant.TEXT_MEDIUM;
        (btn.node.parent.getComponent(MActionButton) as MActionButton).text = "NEW";
        (btn.node.parent.getComponent(MActionButton) as MActionButton).actionMode = false;
        (btn.node.parent.getComponent(MActionButton) as MActionButton).node.name = "NEW";

        WriteTheFile.getInstance().writeXML("slots.xml", WriteTheFile.getInstance().slotXML);

        Settings.SM.playSound("../sounds/SELECT.mp3");
    }
}
}
