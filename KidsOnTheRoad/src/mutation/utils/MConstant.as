/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/5/13
 * Time: 7:46 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.utils {

import com.genome2d.core.Genome2D;

import utils.Settings;

public class MConstant {

    public static const STAGE_WIDTH:uint = Genome2D.getInstance().stage.stageWidth;
    public static const STAGE_HEIGHT:uint = Genome2D.getInstance().stage.stageHeight;
    public static const MARGIN:uint = 20 * Settings.SCALE_FACTOR;
    //TEXT SCALE
    public static const TEXT_SMALL:Number = .3;
    public static const TEXT_MEDIUM:Number = .5;
    public static const TEXT_LARGE:Number = .8;
    public static const TEXT_STANDARD:Number = 1;
    public static const TEXT_EXTRALARGE:Number = 1.2;
    //POSITION
    public static const ICON_LEFT:uint = 0;
    public static const ICON_RIGHT:uint = 1;
    public static const ICON_TOP:uint = 2;
    public static const ICON_BOTTOM:uint = 3;
    public static const LABEL_LEFT:uint = 4;
    public static const LABEL_RIGHT:uint = 5;
    public static const LABEL_TOP:uint = 6;
    public static const LABEL_BOTTOM:uint = 7;
    //DEVICE LAYOUT
    public static const HORIZONTAL_LAYOUT:uint = 0;
    public static const VERTICAL_LAYOUT:uint = 1;
    //HEADER POSITION
    public static const LEFT_ITEM:uint = 1;
    public static const RIGHT_ITEM:uint = 2;
    //STATIC VARS
    public static const FONT_ATLAS:String = "ATLAS_FONT";

}
}
