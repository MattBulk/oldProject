/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/13/13
 * Time: 1:06 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {

public class Settings {

    public static var PLAYER:uint;
    public static var WORLD:uint;
    public static var LEVEL:uint;
    public static var FOLDER:String;
    //OPTIONS
    public static var DIFFICULTY:uint; //easy medium hard
    public static var MODE:uint; //practice versus
    public static var ACTIVITY:uint; //tour my tracks race
    public static var CONTROLS:uint = 0;
    //BOOLEANS
    public static var MUTE:Boolean;
    public static var IPHONE5:Boolean;
    public static var OLD_DEVICE:Boolean;
    //BUILDER
    public static var AREA:uint;
    public static var SIZE:uint;
    public static var SLOT:uint;
    //OTHER
    public static var SCALE_FACTOR:Number;
    public static const SM:SoundEngine = SoundEngine.getInstance();
}

}
