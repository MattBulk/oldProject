/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/18/13
 * Time: 9:45 AM
 * To change this template use File | Settings | File Templates.
 */
package components.shared {
import com.genome2d.components.GComponent;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAlignType;
import com.genome2d.textures.factories.GTextureFactory;
import events.NavigationEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import mutation.utils.MConstant;
import utils.Settings;
import utils.deg2rad;

public class TheGui extends GComponent {

    private const _fuelTexture:GTexture = GTextureFactory.createFromColor("red", 0xFF0000, 1, 10);
    private var _valueText:GTextureText, _counterText:GTextureText, _lapNumText:GTextureText;
    private var _scorePoints:uint = 0;
    private var _lap:uint = 0;
    
    public var fuelBar:GSprite;
    public var theBrake:TheBrake;
    public var fl_TimerInstance:Timer;
    public var autoPilotText:GTextureText;
    public var thePause:GSprite;

    public function TheGui(p_node:GNode) {

        super(p_node);

        init();

        setCountdown();
    }

    public function init():void {

        //ADD THE FUEL BAR
        fuelBar = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        fuelBar.textureId = "red";
        _fuelTexture.alignTexture(GTextureAlignType.TOP_LEFT);
        fuelBar.node.transform.scaleX = MConstant.STAGE_WIDTH;
        fuelBar.node.transform.setPosition(0, 0);
        this.node.addChild(fuelBar.node);

        //TEXTFIELD FOR THE SCORE
        const _theScoreText:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        _theScoreText.textureAtlasId = MConstant.FONT_ATLAS;
        _theScoreText.text = "SCORE: ";
        _theScoreText.node.transform.setScale(.4, .4);
        _theScoreText.node.transform.setPosition(MConstant.MARGIN, MConstant.MARGIN + _fuelTexture.height);
        this.node.addChild(_theScoreText.node);

        //TEXTFIELD FOR THE NUMERIC VALUE
        _valueText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        _valueText.textureAtlasId = MConstant.FONT_ATLAS;
        _valueText.text = "0";
        _valueText.node.transform.setPosition(_theScoreText.width * 1.1, MConstant.MARGIN + (_fuelTexture.height * .5) );
        _valueText.node.transform.setScale(.5, .5);
        this.node.addChild(_valueText.node);

        //TEXTFIELD FOR THE TRACK
        const _levelText:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        _levelText.textureAtlasId = MConstant.FONT_ATLAS;
        _levelText.text = "TRACK: " + Settings.LEVEL;
        _levelText.node.transform.setScale(.4, .4);
        _levelText.node.transform.setPosition(MConstant.MARGIN, _theScoreText.node.transform.y + _levelText.height + MConstant.MARGIN);
        this.node.addChild(_levelText.node);

        //TEXTFIELD FO THE AUTOPILOT
        autoPilotText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        autoPilotText.textureAtlasId = MConstant.FONT_ATLAS;
        autoPilotText.text = "AUTOPILOT";
        autoPilotText.node.transform.setScale(.6, .6);
        autoPilotText.node.transform.setPosition(MConstant.STAGE_WIDTH * .5 - autoPilotText.width * .5, MConstant.STAGE_HEIGHT * .15);
        autoPilotText.node.transform.visible = false;
        this.node.addChild(autoPilotText.node);

        //SET THE ARROWS FOR DIRECTIONS
        var arrowLeft:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        arrowLeft.textureId = "GUI_arrow";
        arrowLeft.node.transform.setPosition(arrowLeft.cTexture.width * .5 + MConstant.MARGIN, MConstant.STAGE_HEIGHT * .5);
        this.node.addChild(arrowLeft.node);

        var arrowRight:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        arrowRight.textureId = "GUI_arrow";
        arrowRight.node.transform.setPosition(MConstant.STAGE_WIDTH - arrowRight.cTexture.width * .5 - MConstant.MARGIN, MConstant.STAGE_HEIGHT * .5);
        arrowRight.node.transform.rotation = deg2rad(180);
        this.node.addChild(arrowRight.node);

        //THE BRAKE AND ITS BAR
        theBrake = GNodeFactory.createNodeWithComponent(TheBrake) as TheBrake;
        theBrake.node.transform.setPosition((MConstant.STAGE_WIDTH * .5 - theBrake.node.getWorldBounds().width * .5), MConstant.STAGE_HEIGHT * 0.98);
        theBrake.node.mouseEnabled = true;
        this.node.addChild(theBrake.node);

        //THE PAUSE BUTTON
        thePause = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        thePause.textureId = "GUI_pause_btn";
        thePause.node.transform.setPosition(MConstant.STAGE_WIDTH - thePause.cTexture.width/2 - MConstant.MARGIN, thePause.cTexture.height/2 + MConstant.MARGIN);
        thePause.node.active = false;
        thePause.node.mouseEnabled = true;
        this.node.addChild(thePause.node);

        if(Settings.ACTIVITY == 2) {

            const _lapsText:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
            _lapsText.textureAtlasId = MConstant.FONT_ATLAS;
            _lapsText.text = "LAPS: ";
            _lapsText.node.transform.setScale(.4, .4);
            _lapsText.node.transform.setPosition(MConstant.MARGIN, _levelText.node.transform.y + _levelText.height + MConstant.MARGIN);
            this.node.addChild(_lapsText.node);

            //TEXTFIELD FOR THE NUMERIC VALUE
            _lapNumText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
            _lapNumText.textureAtlasId = MConstant.FONT_ATLAS;
            _lapNumText.text = "0/3";
            _lapNumText.node.transform.setPosition(_lapsText.width * 1.1, _lapsText.node.transform.y);
            _lapNumText.node.transform.setScale(.4, .4);
            this.node.addChild(_lapNumText.node);

            fuelBar.node.active = false;
        }

        if(Settings.CONTROLS == 1) arrowLeft.node.transform.visible = arrowRight.node.transform.visible = false;

    }

    protected function setCountdown():void {

        fl_TimerInstance = new Timer(1000);
        fl_TimerInstance.addEventListener(TimerEvent.TIMER, fl_TimerHandler, false, 0, true);

        _counterText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        _counterText.textureAtlasId = MConstant.FONT_ATLAS;
        _counterText.text = "03";
        _counterText.node.transform.setPosition(MConstant.STAGE_WIDTH * .5 - _counterText.width * .5, MConstant.STAGE_HEIGHT * .15);

        this.node.addChild(_counterText.node);
    }

    protected function fl_TimerHandler(evt:TimerEvent):void
    {

        switch (fl_TimerInstance.currentCount) {

            case 1:
                _counterText.text = "02";
                Settings.SM.playSound("../sounds/SECOND.mp3");
                break;
            case 2:
                _counterText.text = "01";
                Settings.SM.playSound("../sounds/SECOND.mp3");
                break;
            case 3:
                _counterText.text = "GO";
                Settings.SM.playSound("../sounds/GO.mp3");
                break;
            case 4:
                removeCountDown();
                this.node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.GAME_STATE, {id: "PLAY"}, true));
                break;
        }
    }

    public function removeCountDown():void {

        _counterText.dispose();
        thePause.node.active = true;

        this.node.removeChild(_counterText.node);

        fl_TimerInstance.stop();
        fl_TimerInstance.removeEventListener(TimerEvent.TIMER, fl_TimerHandler);
    }

    public function updateScore(score:int):void {

        _scorePoints += score;
        _valueText.text = _scorePoints.toString();
    }

    override public function dispose():void {

        _fuelTexture.dispose();
        super.dispose();
    }

    public function get scorePoints():uint {
        return _scorePoints;
    }

    public function set lap(laps:uint):void {

        _lap += laps;
    }

    public function get lap():uint {

        return _lap;
    }

    public function updateLapLabel():void {

        _lapNumText.text = lap.toString() + "/3";
    }
}
}
