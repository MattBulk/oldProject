/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/18/13
 * Time: 11:35 AM
 * To change this template use File | Settings | File Templates.
 */
package components.shared {
import com.genome2d.components.GComponent;
import com.genome2d.core.GNode;
import com.genome2d.core.Genome2D;

import events.NavigationEvent;

import flash.events.AccelerometerEvent;

import flash.events.MouseEvent;
import flash.sensors.Accelerometer;

import mutation.utils.MConstant;

import tools.SpeedVariables;

import utils.Settings;

import utils.deg2rad;

import utils.rad2deg;

public class GetInput extends GComponent {

    private var _touchX:Number;
    private var _touchY:Number;

    private const _acceleration:Number = .0020;
    private const _deceleration:Number = .0002;
    private var _turnSpeed:Number;

    public var maxSpeed:Number = 0;
    public var setSpeed:Number;
    public var speed:Number = 0;

    private var _thisAngle:Number;
    private var _carMove:Number;
    private var _dxCar:Number;
    private var _dyCar:Number;

    private var _speedVars:SpeedVariables = new SpeedVariables();
    private var _acc:Accelerometer;
    
    public var BRAKEON:Boolean;
    public var AUTOPILOT:Boolean;
    
    public function GetInput(p_node:GNode) {

        super(p_node);

        this.node.transform.rotation = deg2rad(-90);

        _speedVars.getVariables();

        setSpeed = _speedVars.theSpeed;
        _turnSpeed = _speedVars.turningSpeed;

        if(Settings.CONTROLS == 0) {

            this.node.core.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
            this.node.core.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUP, false, 0, true);
        }

        else {

            _acc = new Accelerometer();
            _acc.addEventListener(AccelerometerEvent.UPDATE, accUpdate, false, 0, true);
            _touchY = MConstant.STAGE_HEIGHT * .5;
        }

    }

    /**
     * CONTROLS
     * @param event
     */

    protected function accUpdate(evt:AccelerometerEvent):void {

        if(AUTOPILOT) return;
        if(evt.accelerationX < -.2) _touchX = MConstant.STAGE_WIDTH * .7;
        else if(evt.accelerationX > .2) _touchX = MConstant.STAGE_WIDTH * .3;
        else if(evt.accelerationX > -.2 && evt.accelerationX < .2) _touchX = MConstant.STAGE_WIDTH * .5;

    }

    protected function mouseUP(evt:MouseEvent):void
    {
        _touchX = MConstant.STAGE_WIDTH * .5;
    }

    protected function mouseDown(evt:MouseEvent):void
    {
        if(AUTOPILOT) return;
        _touchX = Genome2D.getInstance().stage.mouseX;
        _touchY = Genome2D.getInstance().stage.mouseY;
    }

    public function getInput(touchDelta:Number):void
    {

        if(BRAKEON) speed -= _deceleration * touchDelta;
        else speed += _acceleration * touchDelta;

        if(_touchX > MConstant.STAGE_WIDTH * .5 + MConstant.STAGE_WIDTH * .1 && _touchY < MConstant.STAGE_HEIGHT * .8) {

            this.node.transform.rotation += deg2rad((speed) * _turnSpeed * touchDelta);

        }

        if(_touchX < MConstant.STAGE_WIDTH * .5 - MConstant.STAGE_WIDTH * .1 && _touchY < MConstant.STAGE_HEIGHT * .8) {

            this.node.transform.rotation -= deg2rad((speed) * _turnSpeed * touchDelta);

        }

        if (speed > maxSpeed)
        {
            speed = maxSpeed;
        }
        else if (speed > 0)
        {
            speed -=  _deceleration * touchDelta;
            if (speed < 0)
            {
                speed = 0;
            }
        }
        else if (speed < 0)
        {
            speed +=  _deceleration * touchDelta;
            if (speed > 0)
            {
                speed = 0;
            }
        }
        // if moving, then move car and check status
        if (speed != 0)
        {
            _thisAngle = rad2deg(this.node.transform.rotation);

            _carMove = speed * touchDelta;

            _dxCar = Math.cos(Math.PI * _thisAngle / 180) * _carMove;
            _dyCar = Math.sin(Math.PI * _thisAngle / 180) * _carMove;

            this.node.transform.x += _dxCar;
            this.node.transform.y += _dyCar;
        }
    }

    /**
     * SET MAX SPEED TO THE SET SPEED
     */

    public function setTheSpeed():void {

        maxSpeed = setSpeed;

    }

    /**
     * DECELERATE THE CAR UNTIL IT REACHES THE ZERO
     */
    public function decelerate(gameStage:String):void {

        if(maxSpeed <= 0) {

            maxSpeed = 0;
            this.node.core.stage.dispatchEvent(NavigationEvent(new NavigationEvent(NavigationEvent.GAME_STATE, {id: gameStage}, true)));
        }
        else {

            maxSpeed -= _speedVars.decelerateValue;
            Settings.SM.setVolume(maxSpeed, "../sounds/CAR_RUN.mp3");
        }
    }

    override public function dispose():void {

        if(Settings.CONTROLS == 0) {

            this.node.core.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            this.node.core.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUP);
        }

        else
            _acc.removeEventListener(AccelerometerEvent.UPDATE, accUpdate);

    }


}
}
