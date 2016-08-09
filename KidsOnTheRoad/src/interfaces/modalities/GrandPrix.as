/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/21/13
 * Time: 4:41 PM
 * To change this template use File | Settings | File Templates.
 */
package interfaces.modalities {
import com.genome2d.components.renderables.GShape;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTileMap;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import components.shared.TheCar;
import components.shared.TheRivalCar;

import flash.geom.Point;
import flash.geom.Rectangle;

import interfaces.IModality;

import tools.BuildTheGameArea;

import utils.Settings;

public class GrandPrix implements IModality {

    private var _builder:BuildTheGameArea;
    private var _middleTexture:Number;

    public function loadTheLevel():void {

        _builder = new BuildTheGameArea();
        _builder.init();
    }

    public function get tileMap():GTileMap {

        return _builder.createTheTileMap();
    }

    public function get gameArea():Rectangle {

        return _builder.createGameArea();
    }

    public function get theRoad():GShape {

        return _builder.createTheRoad();
    }

    public function get theCar():TheCar {

        const theCar:TheCar = GNodeFactory.createNodeWithComponent(TheCar) as TheCar;
        _middleTexture = _builder.tileTexture.width >> 1;
        theCar.node.transform.setPosition((_middleTexture + _middleTexture/1.8), 0);

        return theCar;
    }

    public function get rivalCar():TheRivalCar {

        const theRivalCar:TheRivalCar = GNodeFactory.createNodeWithComponent(TheRivalCar) as TheRivalCar;
        theRivalCar.node.transform.setPosition(_middleTexture/1.8, 0);
        return theRivalCar;
    }

    public function itemVector(node:GNode):Vector.<GSprite> {

        return _builder.boosterVec(node);
    }

    public function get finishLine():GSprite {

        return _builder.createFinishLine();
    }

    public function get spinalVec():Vector.<Point> {

        return _builder.spinalVec;
    }

    public function get middleTexture():Number {

        return _middleTexture;
    }

    public function get isFuelActive():Boolean {

        if(Settings.DIFFICULTY == 0) return false;
        else return true;
    }

    public function getPercentage(spinal:uint):uint {

        const percentage:uint = Math.round((_builder.spinalPointTot - spinal) * 100 / _builder.spinalPointTot);

        return percentage;

    }

    public function isVersusMode():Boolean {

        if(Settings.MODE == 1) return false;
        else return true;
    }

    public function get pathVec():Vector.<Point> {

        _builder.createPath();
        return _builder.pathVec;
    }

    public function get arrTrail():Array {

        _builder.createPathGrandPrix();
        return _builder.arrTrails;
    }

    public function get tileNum():uint {

        return _builder.tileNum;
    }
}
}
