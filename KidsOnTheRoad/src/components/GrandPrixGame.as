/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/17/13
 * Time: 3:18 PM
 * To change this template use File | Settings | File Templates.
 */
package components {

import com.genome2d.components.GCamera;
import com.genome2d.components.GComponent;
import com.genome2d.components.particles.GSimpleEmitter;
import com.genome2d.components.renderables.GShape;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTileMap;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import com.greensock.TweenLite;
import components.shared.GetInput;
import components.shared.LevelFinalScreen;
import components.shared.TheGui;
import components.shared.TheCar;
import components.shared.TheRivalCar;
import events.NavigationEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import interfaces.IModality;
import interfaces.modalities.GrandPrix;

import mutation.utils.MConstant;
import tools.SpeedVariables;
import utils.Settings;
import utils.rad2deg;

public class GrandPrixGame extends GComponent {

    //INTERFACES
    private var iModality:IModality;
    //WORLD SPRITE
    private var _theWorld:GNode, _theRoad:GNode;
    private var _gameArea:Rectangle;
    private var _camArea:Rectangle;
    private var _camera:GCamera, _camera2:GCamera;
    private var _levelFinalScreen:LevelFinalScreen;
    //CARS
    private var _theCar:TheCar;
    private var _theRivalCar:TheRivalCar;
    private var _carPos:Point = new Point(0,0);
    //VERSUS MODE
    private var _rivalCarPos:Point = new Point(0,0);
    private var _pathToFollowVec:Array;
    private var _rivalSpeed:Number;
    //COLLISION DETECTION
    private var _bounceSpeed:Number = 0;
    private var _isTranspassing:Boolean = false;
    private var _hasTranspassing:Boolean = true;
    //GUI
    private var _gui:TheGui;
    private var _gameMode:String;
    //END VARIABLE
    private var _finishLine:GSprite;
    private var _raceArrival:Array = [];
    private var _hasRivalTranspassed:Boolean;
    //ITEMS
    private var _itemVec:Vector.<GSprite>;
    private var _spinalVec:Vector.<Point> = new Vector.<Point>();
    private var _totSpinalPoint:uint;
    private var _middleTileTexture:Number, _distanceToItem:Number;
    //SPEED CLASS VARIABLES
    private var _speedVariables:SpeedVariables;
    //EMITTERS
    private var _itemEmitter:GSimpleEmitter;
    private var _carEmitter:GSimpleEmitter;


    public function GrandPrixGame(p_node:GNode) {

        super(p_node);

        iModality = new GrandPrix();

        iModality.loadTheLevel();

        init();
    }

    private function init():void {

        _theWorld = GNodeFactory.createNode("theWorld");
        _theRoad = GNodeFactory.createNode("theRoad");

        this.node.addChild(_theWorld);

        //ADD THE TILE MAP
        const tileMap:GTileMap = iModality.tileMap;
        _theWorld.addChild(tileMap.node);

        tileMap.node.transform.x = (256 * Settings.SCALE_FACTOR) * (iModality.tileNum - 4) / 2;

        //ADD THE ROAD NODE IN FRONT THE TILE MAP
        _theWorld.addChild(_theRoad);
        _theRoad.transform.setPosition(0, 0);

        //ADD THE GAME AREA AND AREA FOR CHECK AUTOPILOT
        _gameArea = iModality.gameArea;
        _gameArea.offset(-_gameArea.width * .5 + tileMap.node.transform.x, -_gameArea.height * .5 + tileMap.node.transform.y);
        _camArea = new Rectangle(0, 0, MConstant.STAGE_WIDTH * .3, MConstant.STAGE_HEIGHT * .3); //CHECK IF CUT THE RECT HALF IN SIZE

        //ADD THE ROAD AS SHAPE
        const road_shape:GShape = iModality.theRoad;
        _theRoad.addChild(road_shape.node);

        //ADD THE GUI
        _gui = GNodeFactory.createNodeWithComponent(TheGui) as TheGui;
        this.node.addChild(_gui.node);
        _gui.theBrake.node.onMouseClick.add(onBrake);
        _gui.thePause.node.onMouseClick.add(onPause);

        //ADD THE CAMERAS
        _camera = GNodeFactory.createNodeWithComponent(GCamera) as GCamera;
        _camera.node.transform.setPosition(0,0);
        _camera.mask = 1;
        _camera2 = GNodeFactory.createNodeWithComponent(GCamera) as GCamera;
        _camera2.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .5);
        _camera2.mask = 2;

        this.node.addChild(_camera.node);
        this.node.addChild(_camera2.node);

        _theWorld.cameraGroup = 1;
        _gui.node.cameraGroup = 2;

        //ADD THE ITEMS
        addItems();

        //ADD THE CARS
        _speedVariables = new SpeedVariables();
        _speedVariables.getVariables();

        _theCar = iModality.theCar;
        _theWorld.addChild(_theCar.node);

        //ADD EMITTERS
        initTheEmitter();

        _carEmitter.node.transform.setPosition(-100 * Settings.SCALE_FACTOR, 0);

        _theCar.node.addChild(_carEmitter.node);
        _theCar.node.putChildToBack(_carEmitter.node);

        Settings.SM.playSound("../sounds/CAR_RUN.mp3",0, -1);
        Settings.SM.setVolume(.3, "../sounds/CAR_RUN.mp3");

        TweenLite.from(_theCar.node.transform , 2.5, {y : _theRoad.transform.y + MConstant.STAGE_HEIGHT * .2, onComplete:startTheCountDown});

        //ADD THE RIVAL CAR
        _rivalSpeed = _speedVariables.rivalSpeed;
        _pathToFollowVec = iModality.arrTrail;
        _theRivalCar = iModality.rivalCar;
        _theWorld.addChild(_theRivalCar.node);

        TweenLite.from(_theRivalCar.node.transform , 2, {y : _theRoad.transform.y + MConstant.STAGE_HEIGHT * .2});

        //SET THE MIDDLE OF THE TILE ROAD TEXTURE
        _middleTileTexture = iModality.middleTexture;

        //ADD THE FINAL PANEL SCREEN;
        _levelFinalScreen = GNodeFactory.createNodeWithComponent(LevelFinalScreen) as LevelFinalScreen;
        node.addChild(_levelFinalScreen.node);

        _levelFinalScreen.node.cameraGroup = 2;
        _levelFinalScreen.node.active = false;

        _gameMode = "IDLE";

        this.node.core.stage.addEventListener(NavigationEvent.GAME_STATE, gameEvents, false, 0, true);

    }

    /**
     * START THE COUNTING DOWN
     */

    private function startTheCountDown():void {

        _carPos.setTo(_theCar.node.transform.x, _theCar.node.transform.y);
        _gui.fl_TimerInstance.start();
    }

    /**
     * GET THE DIFFERENT GAME EVENTS CHANGE
     * @param evt
     */

    private function gameEvents(evt:NavigationEvent):void {

        switch (evt.params.id) {

            case "PLAY":
                (_theCar.node.getComponent(GetInput) as GetInput).setTheSpeed();
                Settings.SM.setVolume(1, "../sounds/CAR_RUN.mp3");
                _gameMode = evt.params.id;
                break;
            case "FINISH_LINE":
                _theCar.node.removeComponent(GetInput);
                _gameMode = "NULL";
                finalResult(evt.params.id, _spinalVec.length, _gui.scorePoints, _raceArrival);
                _gui.node.active = false;
                break;
        }
    }

    /**
     * MAIN GAME LOOP
     * @param p_deltaTime
     */

    override public function update(p_deltaTime:Number):void {

        switch (_gameMode)
        {
            case "NULL":
                return;
                break;
            case "IDLE":
                camerasPos();
                break;
            case "PLAY":
                (_theCar.node.getComponent(GetInput) as GetInput).getInput(p_deltaTime);
                camerasPos();
                checkPowerUp();
                checkBounds();
                checkRaceCompletion();
                if(_hasTranspassing) checkLap();
                checkCollision();
                if(_pathToFollowVec.length != 0) followThePath();
                break;
            case "AUTOPILOT":
                (_theCar.node.getComponent(GetInput) as GetInput).getInput(p_deltaTime);
                camerasPos();
                checkPowerUp();
                checkRaceCompletion();
                if(_hasTranspassing) checkLap();
                checkCollision();
                if(_pathToFollowVec.length != 0) followThePath();
                break;
            case "FINISH_LINE":
                (_theCar.node.getComponent(GetInput) as GetInput).getInput(p_deltaTime);
                camerasPos();
                (_theCar.node.getComponent(GetInput) as GetInput).decelerate(_gameMode);
                _camera.zoom += .005;
                if(iModality.isVersusMode()) checkCollision();
                break;
        }
    }

    /**
     * THIS SET THE POSITIONS FOR THE CAMERA AND THE CAMERA AREA FOR THE AUTOPILOT
     */

    private function camerasPos():void {

        _camera.node.transform.setPosition(_theCar.node.transform.x, _theCar.node.transform.y);
        _carPos.setTo(_theCar.node.transform.x, _theCar.node.transform.y);

        _camArea.x = _carPos.x - _camArea.width * .5;
        _camArea.y = _carPos.y - _camArea.height * .5;
    }

    /**
     * BRAKE EVENT IS HANDLED HERE
     * @param evt
     */

    private function onBrake(evt:GMouseSignal):void
    {
        Settings.SM.playSound("../sounds/BRAKE.mp3");
        (_theCar.node.getComponent(GetInput) as GetInput).BRAKEON = true;
        _gui.theBrake.node.transform.color = 0xFF0000;
        TweenLite.delayedCall(1, brakeOff);
    }

    private function brakeOff():void
    {
        (_theCar.node.getComponent(GetInput) as GetInput).BRAKEON = false;
        _gui.theBrake.node.transform.color = 0xFFFFFF;
    }

    /**
     * PAUSE EVENT
     */

    private function onPause(evt:GMouseSignal):void {

        _gameMode = "NULL";
        _gui.node.active = false;

        _levelFinalScreen.node.active = true;
        _levelFinalScreen.visible(false);

    }

    public function onPlay():void {

        _gameMode = "PLAY";
        _gui.node.active = true;

        _levelFinalScreen.node.active = false;
        _levelFinalScreen.visible(true);

    }

    public function finalResult(state:String, spinal:uint, score:uint, arrival:Array):void {

        _levelFinalScreen.node.active = true;
        _levelFinalScreen.setTheStars(iModality.getPercentage(spinal), state, score, arrival);
    }

    /**
     * ADD ELEMENTS
     */

    private function addItems():void {

        //ADD THE ITEMS TO THE ROAD
        _itemVec = iModality.itemVector(_theRoad);
        //ADD THE FINISH LINE
        _finishLine = iModality.finishLine;
        _theRoad.addChild(_finishLine.node);
        //SET DISTANCE TO ITEM
        _distanceToItem = _itemVec[0].cTexture.width * 1.2;

    }

    /**
     * GAME LOOP
     *
     * METHODS INSIDE THE GAME LOOP
     *
     *
     *
     */

    private function checkPowerUp():void
    {
        for (var i:int=_itemVec.length-1; i>=0; i--)
        {
            const itemsPoint:Point = new Point(_itemVec[i].node.transform.x, _itemVec[i].node.transform.y);

            _itemVec[i].node.transform.rotation += .03;

            if(Point.distance(_carPos, itemsPoint) < _distanceToItem && _itemVec[i].node.active == true) {

                createParticle(itemsPoint.x, itemsPoint.y, 0xFF0000);

                (_theCar.node.getComponent(GetInput) as GetInput).maxSpeed += _speedVariables.booster;

                _carEmitter.emission = 25;
                _carEmitter.emissionDelay = 0;
                _carEmitter.emissionTime = 10;
                _carEmitter.emissionVariance = 0;
                _carEmitter.energy = .8;
                _carEmitter.initialAlpha = .7;
                _carEmitter.endAlpha = 0;

                Settings.SM.stopSound("../sounds/CAR_RUN.mp3");
                Settings.SM.playSound("../sounds/CAR_BOOST.mp3",0, -1);

                _itemVec[i].node.active = false;

                _gui.updateScore(100);

                TweenLite.delayedCall(1, resetBooster);

                Settings.SM.playSound("../sounds/COIN.mp3");
            }

            if(Point.distance(_rivalCarPos, itemsPoint) < _distanceToItem && _itemVec[i].node.active == true) {

                _itemVec[i].node.active = false;

                _rivalSpeed += _speedVariables.booster * 10;
                TweenLite.delayedCall(1.5, setRivalSpeed);

                Settings.SM.playSound("../sounds/COIN.mp3");

            }

        }
    }

    /**
     * SET THE RIVAL SPEED BACK TO NORMAL
     */

    private function setRivalSpeed():void {

        _rivalSpeed = _speedVariables.rivalSpeed;
    }

    /**
     * SET THE BOOSTERS BACK TO LIFE
     */

    private function reactivateBoosterItems():void {

        for (var i:int=_itemVec.length-1; i>=0; i--)
        {
            _itemVec[i].node.active = true;
        }
    }

    /**
     * THE RIVAL CAR FOLLOWS THE PATH
     */

    public function followThePath():void {


        _rivalCarPos.setTo(_theRivalCar.node.transform.x, _theRivalCar.node.transform.y);

        if(Point.distance(_pathToFollowVec[0][_pathToFollowVec[0].length - 1], _rivalCarPos) < _speedVariables.distanceFromNextSegment * 1.2) {

            const wayPointRot:Number = Math.atan2((_rivalCarPos.y - _pathToFollowVec[0][_pathToFollowVec[0].length - 1].y), (_rivalCarPos.x - _pathToFollowVec[0][_pathToFollowVec[0].length - 1].x));

            _theRivalCar.node.transform.rotation = -1.57 + wayPointRot;

            const myAtan2:Number = Math.atan2(_pathToFollowVec[0][_pathToFollowVec[0].length - 1].y - _theRivalCar.node.transform.y, _pathToFollowVec[0][_pathToFollowVec[0].length - 1].x - _theRivalCar.node.transform.x);

            _theRivalCar.node.transform.x += Math.cos(myAtan2) * _rivalSpeed;
            _theRivalCar.node.transform.y += Math.sin(myAtan2) * _rivalSpeed;

            _rivalCarPos.x = _theRivalCar.node.transform.x;
            _rivalCarPos.y = _theRivalCar.node.transform.y;

            if(Point.distance(_pathToFollowVec[0][_pathToFollowVec[0].length - 1], _rivalCarPos) < _speedVariables.nextSegment) {

                _theRivalCar.node.transform.x = _pathToFollowVec[0][_pathToFollowVec[0].length - 1].x;
                _theRivalCar.node.transform.y = _pathToFollowVec[0][_pathToFollowVec[0].length - 1].y;
                _pathToFollowVec[0].pop();
                if(_pathToFollowVec[0].length == 0) _pathToFollowVec.shift();
            }
        }
    }

    /**
     * CHECK COLLISIONS BETWEEN THE CARS
     */

    private function checkCollision():void
    {

        if(_theRivalCar.theCar.hitTestObject(_theCar.theCar)) {

            const wayPointRot:Number = Math.atan2((_rivalCarPos.y - _carPos.y), (_rivalCarPos.x - _carPos.x));

            _theCar.node.transform.x -= Math.cos(wayPointRot) * _speedVariables.bounceMultiplier * _bounceSpeed;
            _theCar.node.transform.y -= Math.sin(wayPointRot) * _speedVariables.bounceMultiplier * _bounceSpeed;

            _theRivalCar.node.transform.x += Math.cos(wayPointRot) * _speedVariables.bounceMultiplier * _bounceSpeed;
            _theRivalCar.node.transform.y += Math.sin(wayPointRot) * _speedVariables.bounceMultiplier * _bounceSpeed;

            if(_bounceSpeed > 20) {

                _bounceSpeed = 0;
                _rivalSpeed =  _speedVariables.rivalSpeed;
            }
            else {
                _bounceSpeed += _bounceSpeed + .2;
                (_theCar.node.getComponent(GetInput) as GetInput).speed -= .05;
                _rivalSpeed -= .03;
            }

            if(!Settings.SM.isPlayingAndPlay("../sounds/HIT_CAR.mp3")) Settings.SM.playSound("../sounds/HIT_CAR.mp3");
        }

        if(_theRivalCar.theCar.hitTestObject(_finishLine) && !_hasRivalTranspassed) {

            _hasRivalTranspassed = true;

            reactivateBoosterItems();

            if(_pathToFollowVec.length > 1) TweenLite.delayedCall(2, resetArrival);

            else {

                _raceArrival.push("THE_RIVAL");

                const angle:Number = rad2deg(-1.57 + _theRivalCar.node.transform.rotation);

                const dx:Number = Math.cos(Math.PI * angle / 180) * _speedVariables.distanceFromNextSegment;
                const dy:Number = Math.sin(Math.PI * angle / 180) * _speedVariables.distanceFromNextSegment;

                TweenLite.to(_theRivalCar.node.transform, 1, {x:_theRivalCar.node.transform.x + dx, y:_theRivalCar.node.transform.y + dy});

            }
        }
    }

    private function resetArrival():void { _hasRivalTranspassed = false }

    /**
     *  AUTOPILOT
     */

    private function checkBounds():void {

        if(!_gameArea.containsRect(_camArea)) {

            _gameMode = "AUTOPILOT";

            _gui.autoPilotText.node.transform.visible = true;

            (_theCar.node.getComponent(GetInput) as GetInput).speed -= _speedVariables.brakePower;
            (_theCar.node.getComponent(GetInput) as GetInput).maxSpeed = _speedVariables.autoSpeed;
            (_theCar.node.getComponent(GetInput) as GetInput).AUTOPILOT = true;

            var wayPointRot:Number = Math.atan2((_theWorld.transform.y - _carPos.y), (_theWorld.transform.x - _carPos.x));

            TweenLite.to(_theCar.node.transform, 1.5, {rotation:wayPointRot});
            TweenLite.delayedCall(2, backToAutoPilot);

            Settings.SM.playSound("../sounds/HEY.mp3");

        }
    }

    private function backToAutoPilot():void {

        _gameMode = "PLAY";
        _gui.autoPilotText.node.transform.visible = false;
        (_theCar.node.getComponent(GetInput) as GetInput).setTheSpeed();
        (_theCar.node.getComponent(GetInput) as GetInput).AUTOPILOT = false;
    }

    /**
     * CHECK THE ROAD AND THE CAR
     */

    private function checkLap():void {

        _isTranspassing = false;

        if(_theCar.theCar.hitTestObject(_finishLine)) _isTranspassing = true;

        if(_isTranspassing == true) {

            _hasTranspassing = false;

            if(checkLapCompletion() || _gui.lap == 0) {

                _gui.lap = 1;

                if(_gui.lap == 2 || _gui.lap == 3) Settings.SM.playSound("../sounds/GO_LAP.mp3");
                if(_gui.lap == 4) {
                    _gameMode = "FINISH_LINE";
                    _gui.theBrake.node.onMouseClick.remove(onBrake);
                    _raceArrival.push("THE_CAR");
                    return;
                }

                _gui.updateLapLabel();

                reactivateBoosterItems();
            }

            else {

                _gui.autoPilotText.node.transform.visible = true;
                _gui.autoPilotText.text = "LAP INVALID !";

                Settings.SM.playSound("../sounds/BUZZER.mp3");
            }

            resetCheckPoints();

            TweenLite.delayedCall(2, resetBoolean);

        }
    }

    private function resetBoolean():void {

        _hasTranspassing = true;
        _gui.autoPilotText.node.transform.visible = false;
        _gui.autoPilotText.text = "AUTOPILOT";
    }

    /**
     * METHOD LOOKS IF THE CAR IS ON TRACK
     */

    private function checkRaceCompletion():void {

        for(var o:int=_spinalVec.length-1; o>=0; o--) if (Point.distance(_spinalVec[o], _carPos) <= _middleTileTexture) _spinalVec.splice(o,1);
    }

    /**
     * CHECK THE PERCENTAGE FOR EACH LAP
     */

    private function checkLapCompletion():Boolean {

        var b:Boolean = false;

        const percentage:uint = Math.round((_totSpinalPoint - _spinalVec.length) * 100 / _totSpinalPoint);

        if(percentage > 90) b = true;

        return b;
    }

    private function resetCheckPoints():void {

        _spinalVec.splice(0, _spinalVec.length);

        for(var i:uint=0; i<iModality.spinalVec.length; i++) {

            _spinalVec.push(iModality.spinalVec[i]);
        }

        _totSpinalPoint = _spinalVec.length;

    }

    /**
     * BOOSTER ITEM
     */

    private function resetBooster():void {

        (_theCar.node.getComponent(GetInput) as GetInput).setTheSpeed();

        Settings.SM.playSound("../sounds/CAR_RUN.mp3",0, -1);
        Settings.SM.stopSound("../sounds/CAR_BOOST.mp3");

        _carEmitter.emission = 10;
        _carEmitter.emissionDelay = .5;
        _carEmitter.emissionTime = 10;
        _carEmitter.emissionVariance = 0;
        _carEmitter.energy = .5;
        _carEmitter.initialAlpha = .5;
        _carEmitter.endAlpha = 0;
    }

    /**
     * PARTICLE SYSTEM
     */

    private function initTheEmitter():void {

        _itemEmitter = GNodeFactory.createNodeWithComponent(GSimpleEmitter) as GSimpleEmitter;
        _itemEmitter.textureId = "GUI_smokeParticle";
        _itemEmitter.emit = false;
        _itemEmitter.emission = 20;
        _itemEmitter.energy = .5;
        _itemEmitter.initialScale = .3;
        _itemEmitter.initialVelocity = 250;
        _itemEmitter.initialVelocityVariance = 150;
        _itemEmitter.dispersionAngleVariance = 2 * Math.PI;
        _itemEmitter.initialScale = .3;
        _itemEmitter.initialScaleVariance = .1;
        _itemEmitter.endScale = 2;
        _itemEmitter.initialAlpha = .7;
        _itemEmitter.endAlpha = 0;

        _theWorld.addChild(_itemEmitter.node);

        _carEmitter = GNodeFactory.createNodeWithComponent(GSimpleEmitter) as GSimpleEmitter;
        _carEmitter.textureId = "GUI_waterParticle";
        _carEmitter.emit = true;
        _carEmitter.emission = 10;
        _carEmitter.emissionDelay = .5;
        _carEmitter.emissionTime = 10;
        _carEmitter.emissionVariance = 0;
        _carEmitter.energy = .5;
        _carEmitter.energyVariance = 0;
        _carEmitter.dispersionAngle = -1.5;
        _carEmitter.dispersionAngleVariance = 0.3;
        _carEmitter.dispersionXVariance = 3;
        _carEmitter.dispersionYVariance = 10;
        _carEmitter.initialScale = .5;
        _carEmitter.endScale = 2;
        _carEmitter.initialScaleVariance = 0.5;
        _carEmitter.endScaleVariance = 0;
        _carEmitter.initialVelocity = 98;
        _carEmitter.initialVelocityVariance = 30;
        _carEmitter.initialAcceleration = 0;
        _carEmitter.initialAccelerationVariance = 0;
        _carEmitter.initialAngle = 0;
        _carEmitter.initialAngleVariance = 3.14;
        _carEmitter.initialColor = 0xFFFFFF;
        _carEmitter.endColor = 0xFFFFFF;
        _carEmitter.initialAlpha = .6;
        _carEmitter.initialAlphaVariance = 0;
        _carEmitter.endAlpha = 0;
        _carEmitter.endAlphaVariance = 0;

    }

    protected function createParticle(p_x:int, p_y:int, color:int):void {

        _itemEmitter.node.transform.setPosition(p_x,p_y);
        _itemEmitter.initialColor = color;
        _itemEmitter.endColor = color;
        _itemEmitter.emit = true;
        _itemEmitter.forceBurst();
    }

    /**
     * GAME DISPOSE
     */

    override public function dispose():void {

        Settings.SM.stopSound("../sounds/CAR_RUN.mp3");

        if(_theCar.node.hasComponent(GetInput)) (_theCar.node.getComponent(GetInput) as GetInput).dispose();

        this.node.core.stage.removeEventListener(NavigationEvent.GAME_STATE, gameEvents);
        this.node.disposeChildren();

        super.dispose();
    }

}
}
