/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/19/13
 * Time: 10:36 AM
 * To change this template use File | Settings | File Templates.
 */
package tools {
import mutation.utils.MConstant;

import utils.Settings;

public class SpeedVariables {

    //INPUT COMPONENT
    public var theSpeed:Number;
    public var turningSpeed:Number;
    public var decelerateValue:Number;
    //BOOSTER
    public var booster:Number;
    //AUTOPILOT
    public var autoSpeed:Number;
    public var brakePower:Number;
    //OLD DEVICES
    private var _fps:Number;
    //FUEL BAR
    public var fuelDecrease:Number;
    //RIVAL CAR
    public var bounceMultiplier:Number;
    public var rivalSpeed:Number;
    public var nextSegment:Number;
    public const distanceFromNextSegment:Number = 400 * Settings.SCALE_FACTOR;

    public function getVariables():void {

        if(Settings.OLD_DEVICE) _fps = 2;
        else _fps = 1;

        switch (Settings.DIFFICULTY) {

            case 0:
            case 1:
                theSpeed = .3 * Settings.SCALE_FACTOR;
                if(MConstant.STAGE_WIDTH == 480) turningSpeed = .3;
                else if(MConstant.STAGE_WIDTH == 2048) turningSpeed = .15;
                else turningSpeed = .25;
                decelerateValue = .005 * Settings.SCALE_FACTOR;
                autoSpeed = theSpeed - .2;
                brakePower = 1.2;
                fuelDecrease = .5 * _fps * Settings.SCALE_FACTOR;
                booster = .2 * Settings.SCALE_FACTOR;
                bounceMultiplier = .5 * Settings.SCALE_FACTOR;
                rivalSpeed = 5 * _fps * Settings.SCALE_FACTOR;
                nextSegment = 5 * Settings.SCALE_FACTOR * _fps;
                break;
            case 2:
                theSpeed = .5 * Settings.SCALE_FACTOR;
                if(MConstant.STAGE_WIDTH == 480) turningSpeed = .3;
                else if(MConstant.STAGE_WIDTH == 2048) turningSpeed = .15;
                else turningSpeed = .25;
                decelerateValue = .015 * Settings.SCALE_FACTOR;
                autoSpeed = theSpeed - .3;
                brakePower = 1.5;
                fuelDecrease = .8 * _fps * Settings.SCALE_FACTOR;
                booster = .3 * Settings.SCALE_FACTOR;
                bounceMultiplier = .7 * Settings.SCALE_FACTOR;
                rivalSpeed = 8 * _fps * Settings.SCALE_FACTOR;
                nextSegment = 10 * Settings.SCALE_FACTOR * _fps;
                break;
        }

    }
}
}
