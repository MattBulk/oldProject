/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/19/13
 * Time: 5:10 PM
 * To change this template use File | Settings | File Templates.
 */
package components.shared {
import com.genome2d.components.GComponent;
import com.genome2d.components.particles.GSimpleEmitter;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.context.GBlendMode;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.factories.GTextureFactory;
import com.greensock.TweenLite;
import com.greensock.TweenMax;

import components.GrandPrixGame;
import components.TheTourGame;

import events.NavigationEvent;

import flash.geom.Vector3D;

import mutation.utils.MConstant;

import utils.Settings;

public class LevelFinalScreen extends GComponent {

    private var nextBtn:GSprite, background:GSprite, playBtn:GSprite;
    private var theScoreText2:GTextureText, theScoreText:GTextureText;
    private var offset:Number;
    private var resultText:GTextureText;
    private var bgTexture:GTexture;
    private var container:GNode;
    private var name:String;
    private var num:uint, sequence:uint;
    private var arr:Vector.<GSprite> = new Vector.<GSprite>();
    private var _starEmit:GSimpleEmitter;


    public function LevelFinalScreen(p_node:GNode) {

        super(p_node);

        offset = MConstant.STAGE_WIDTH * .5;
        container = GNodeFactory.createNode("containerOver");
        container.transform.setPosition(offset, MConstant.STAGE_HEIGHT * .4);
        this.node.addChild(container);

        bgTexture = GTextureFactory.createFromColor("white", 0xFFFFFF, 1, 1);

        background = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        background.textureId = "white";
        background.node.transform.setScale(offset * 1.5, MConstant.STAGE_HEIGHT * .6);
        background.node.transform.setPosition(0, 0);
        background.node.transform.alpha = .5;
        container.addChild(background.node);

        initTheTextScore();
        initTheButton();

        createStarts();
        initTheEmitter();

        sequence = 0;

    }

    /**
     * SET THE VISIBILITY OF THE SPRITES
     */

    public function visible(b:Boolean):void {

        if(!b) {
            theScoreText.node.active = false;
            theScoreText2.node.active = false;
            resultText.text = "TAP TO CONTINUE";
            resultText.node.transform.setPosition(-resultText.width * .5, resultText.height);
            playBtn.node.active = true;
        }
        else {
            theScoreText.node.active = true;
            theScoreText2.node.active = true;
            resultText.text = "";
            resultText.node.transform.setPosition(-resultText.width * .5, resultText.height);
            playBtn.node.active = false;
        }
    }

    private function initTheTextScore():void {

        theScoreText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        theScoreText.textureAtlasId = MConstant.FONT_ATLAS;
        theScoreText.text = "SCORE :";
        theScoreText.node.transform.setScale(.5, .5);
        theScoreText.node.transform.setPosition(background.node.transform.x - background.node.getWorldBounds().width * .45, -theScoreText.height);
        container.addChild(theScoreText.node);

        theScoreText2 = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        theScoreText2.textureAtlasId = MConstant.FONT_ATLAS;
        theScoreText2.align = 2;
        theScoreText2.text = "0";
        theScoreText2.node.transform.setScale(.5, .5);
        theScoreText2.node.transform.setPosition(background.node.getWorldBounds().width * .45, -theScoreText.height);
        container.addChild(theScoreText2.node);

        resultText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        resultText.textureAtlasId = MConstant.FONT_ATLAS;
        resultText.align = 1;
        resultText.node.transform.setScale(.8, .8);
        resultText.node.transform.setPosition(resultText.width * .5, resultText.height);
        container.addChild(resultText.node);

    }

    private function initTheButton():void
    {
        const replayBtn:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        replayBtn.textureId = "GUI_replay_btn";
        replayBtn.node.transform.setPosition(offset, MConstant.STAGE_HEIGHT - replayBtn.getWorldBounds().height * 1.3);
        node.addChild(replayBtn.node);

        const homeBtn:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        homeBtn.textureId = "GUI_home_btn";
        homeBtn.node.transform.setPosition(offset - homeBtn.getWorldBounds().width * 2, MConstant.STAGE_HEIGHT - replayBtn.getWorldBounds().height * 1.3);
        node.addChild(homeBtn.node);

        nextBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        nextBtn.textureId = "GUI_next_btn";
        nextBtn.node.transform.setPosition(offset + nextBtn.getWorldBounds().width * 2, MConstant.STAGE_HEIGHT - replayBtn.getWorldBounds().height * 1.3);
        node.addChild(nextBtn.node);

        playBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        playBtn.textureId = "GUI_play_gui_btn";
        playBtn.node.transform.setPosition(offset, MConstant.STAGE_HEIGHT * .5 - playBtn.cTexture.height * .8);
        node.addChild(playBtn.node);

        replayBtn.node.mouseEnabled = true;
        replayBtn.node.name = "replay";
        replayBtn.node.onMouseClick.add(triggerEvent);

        homeBtn.node.mouseEnabled = true;
        homeBtn.node.name = "levelScreen";
        homeBtn.node.onMouseClick.add(triggerEvent);

        playBtn.node.mouseEnabled = true;
        playBtn.node.name = "play";
        playBtn.node.onMouseClick.add(triggerEvent);
    }

    private function initTheEmitter():void {

        _starEmit = GNodeFactory.createNodeWithComponent(GSimpleEmitter) as GSimpleEmitter;
        _starEmit.textureId = "GUI_star";
        _starEmit.emit = false;
        _starEmit.emission = 30;
        _starEmit.energy = .5;
        _starEmit.initialScale = .3;
        _starEmit.initialVelocity = 250;
        _starEmit.initialVelocityVariance = 150;
        _starEmit.dispersionAngleVariance = 2 * Math.PI;
        _starEmit.initialScale = .3;
        _starEmit.initialScaleVariance = .1;
        _starEmit.endScale = 1.5;
        _starEmit.initialAlpha = .7;
        _starEmit.endAlpha = 0;
        _starEmit.blendMode = GBlendMode.ADD;

        container.addChild(_starEmit.node);

    }

    protected function createParticle(p_x:int, p_y:int):void {

        _starEmit.node.transform.setPosition(p_x, Math.abs(p_y));

        _starEmit.initialColor = 0xFF0000;
        _starEmit.endColor = 0xFFFF00;
        _starEmit.emit = true;
        _starEmit.forceBurst();
    }

    public function setTheStars(perc:uint, state:String, totScore:uint, arrivalPos:Array):void {

        visible(true);

        num = starsNum(perc);

        switch (state) {

            case "FUEL":
                num = 0;
                resultText.text = "NEED FUEL ?";
                break;
            case "FINISH_LINE":
                if(num == 0) resultText.text = "NO SHORTCUT !";
                else if(arrivalPos[0] == "THE_CAR" && num != 3) {
                    num = 0;
                    resultText.text = "DISQUALIFIED !";
                }
                else if(arrivalPos[0] == "THE_CAR" && num == 3) resultText.text = "VICTORY !";
                else {
                    num = 0;
                    resultText.text = "2ND PLACE !";
                }
                break;
        }

        arr[0].node.active = arr[1].node.active = arr[2].node.active = true;

        if(num > 0) TweenLite.delayedCall(.5, setStarts);

        resultText.node.transform.setPosition(-resultText.width * .5, resultText.height);

        theScoreText2.text = totScore.toString();

        if(Settings.LEVEL == 10 || Settings.ACTIVITY == 1) nextBtn.node.transform.visible = false;
        else {
            nextBtn.node.transform.visible = true;
            nextBtn.node.mouseEnabled = true;
            nextBtn.node.name = "nextLevel";
            nextBtn.node.onMouseClick.add(triggerEvent);
        }
    }

    private function setStarts():void {

        TweenLite.from(arr[sequence].node.transform, .5, {scaleX:1.2, scaleY:1.2, rotation:1.57});

        arr[sequence].textureId = "GUI_star";

        const localPoint:Vector3D = arr[sequence].node.transform.localToWorld(new Vector3D());

        createParticle(localPoint.x, localPoint.y);

        sequence++;

        Settings.SM.playSound("../sounds/END_POWER.mp3");

        if(sequence < num) TweenLite.delayedCall(1, setStarts);

    }

    private function starsNum(perc:uint):uint {

        if(perc < 70) num = 0;
        else {
            if(perc >= 70 && perc < 80) num = 1;
            else if(perc >= 80 && perc < 90) num = 2;
            else if(perc >= 90) num = 3;
        }
        return num;
    }

    private function createStarts():void {

        const starCont:GNode = GNodeFactory.createNode("starContainer");

        for (var X:uint = 0; X < 3; X++)
        {
            var star:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
            star.textureId = "GUI_starContainer";
            star.node.transform.x = star.node.getWorldBounds().width * 2 * (X % 3);
            star.node.active = false;
            starCont.addChild(star.node);
            arr.push(star);
        }

        container.addChild(starCont);

        starCont.transform.setPosition(0 - (star.node.getWorldBounds().width * 2), -star.node.getWorldBounds().height * 1.4);

    }

    private function triggerEvent(evt:GMouseSignal):void
    {
        TweenMax.killAll();

        name = evt.target.name;

        TweenLite.from(evt.target.transform, .2, {scaleX:1.1, scaleY:1.1});
        TweenLite.delayedCall(.3, fl_TimerHandler);

        Settings.SM.playSound("../sounds/SELECT.mp3");
    }


    protected function fl_TimerHandler():void
    {
        if(name == "levelScreen") node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "levelScreen"}, true));
        else if(name == "replay") node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "replay"}, true));
        else if(name == "play") {

            if(Settings.ACTIVITY == 2) (node.parent.getComponent(GrandPrixGame) as GrandPrixGame).onPlay();
            else (node.parent.getComponent(TheTourGame) as TheTourGame).onPlay();
        }
        else if(name == "nextLevel") {
            Settings.LEVEL++;
            node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "next_level"}, true));
        }

    }

    override public function dispose():void {

        bgTexture.dispose();
        super.dispose();
    }
}
}
