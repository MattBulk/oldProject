/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/16/13
 * Time: 3:04 PM
 * To change this template use File | Settings | File Templates.
 */
package interfaces {
import com.genome2d.components.renderables.GShape;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTileMap;
import com.genome2d.core.GNode;

import components.shared.TheCar;
import components.shared.TheRivalCar;

import flash.geom.Point;

import flash.geom.Rectangle;

public interface IModality {

    function loadTheLevel():void
    function get tileMap():GTileMap;
    function get gameArea():Rectangle;
    function get theRoad():GShape;
    function get theCar():TheCar;
    function get rivalCar():TheRivalCar;
    function itemVector(node:GNode):Vector.<GSprite>;
    function get finishLine():GSprite;
    function get spinalVec():Vector.<Point>;
    function get middleTexture():Number;
    function get isFuelActive():Boolean;
    function getPercentage(spinal:uint):uint;
    function isVersusMode():Boolean;
    function get pathVec():Vector.<Point>;
    function get arrTrail():Array;
    function get tileNum():uint;
}

}
