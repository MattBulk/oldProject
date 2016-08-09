/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/17/13
 * Time: 4:01 PM
 * To change this template use File | Settings | File Templates.
 */
package tools {
import utils.*;

import com.genome2d.components.renderables.GShape;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTile;
import com.genome2d.components.renderables.GTileMap;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.textures.GTexture;
import flash.geom.Point;
import flash.geom.Rectangle;

public class BuildTheGameArea {

    //XML
    private var _theXML:XML;
    private var _tileSetVec:Vector.<GTile>;
    private var _typeArr:Array;
    private var _radiusArr:Array;
    private var _arrayBlock:Array;
    private var _tileSize:uint;
    //ROAD
    private const roadTrailGenerator:RoadTrailGenerator = new RoadTrailGenerator();

    public const tileTexture:GTexture = GTexture.getTextureById("tile");

    public var spinalPointTot:int;
    public var spinalVec:Vector.<Point> = new Vector.<Point>();
    public var pathVec:Vector.<Point> = new Vector.<Point>();

    //GRANDPRIX
    public var trailOne:Vector.<Point> = new Vector.<Point>();
    public var trailTwo:Vector.<Point> = new Vector.<Point>();
    public var trailThree:Vector.<Point> = new Vector.<Point>();

    public var arrTrails:Array = [];

    public var tileNum:uint;

    public function init():void {

        var xmlPath:String;
        if(Settings.ACTIVITY == 0) {

            if(Settings.OLD_DEVICE) xmlPath = "db/oldtour/" + Settings.WORLD.toString() + "-" + Settings.LEVEL.toString() + ".xml";
            else xmlPath = "db/tour/" + Settings.WORLD.toString() + "-" + Settings.LEVEL.toString() + ".xml";
        }

        else if(Settings.ACTIVITY == 1) xmlPath = Settings.WORLD.toString() + "-" + Settings.LEVEL.toString() + ".xml";

        else if(Settings.ACTIVITY == 2) xmlPath = "db/grandprix/" + Settings.WORLD.toString() + "-" + Settings.LEVEL.toString() + ".xml";

        WriteTheFile.getInstance().loadXML(xmlPath);
        _theXML = WriteTheFile.getInstance().loadedTrack;

        manipulateXML();

    }

    /**
     * XML
     */

    private function manipulateXML():void {

        const curveType:String = _theXML.levels.curveType;
        _typeArr = curveType.split(",");

        const radiusType:String = _theXML.levels.radiusType;
        _radiusArr = radiusType.split(",");

        const tileSet:String = _theXML.levels.tileType;
        const tileSetArr:Array = tileSet.split(",");

        tileNum = _theXML.levels.tileNum;

        _tileSetVec = new Vector.<GTile>();

        for(var i:int=0; i<tileSetArr.length; i++) {

            var tile:GTile = new GTile();
            tile.textureId = "world_tile_" + tileSetArr[i];
            _tileSetVec.push(tile);
        }

    }

    /**
     * THIS CREATE THE TILEMAP FOR EACH LEVEL
     */

    public function createTheTileMap():GTileMap {

        _tileSize = 256 * Settings.SCALE_FACTOR;

        var tileMap:GTileMap = GNodeFactory.createNodeWithComponent(GTileMap, "tile_map") as GTileMap;
        tileMap.setTiles(_tileSetVec, tileNum, tileNum, _tileSize, _tileSize, false);

        return tileMap;
    }

    /**
     * THE AREA FOR THE ENTIRE WORLD AREA
     * @return
     */

    public function createGameArea():Rectangle {

        var rect:Rectangle = new Rectangle(0, 0, tileNum * _tileSize, tileNum * _tileSize);

        return rect;
    }

    /**
     * THE ROAD IS CREATED BY THIS CLASS
     * @return
     */

    public function createTheRoad():GShape {

        roadTrailGenerator.initGenerator(_typeArr, _radiusArr, uint(_theXML.levels.startLine));

        const vertices:Vector.<Number> = new Vector.<Number>();
        const uvs:Vector.<Number> = new Vector.<Number>();

        var spinalPoint:Point = new Point(0,0);

        for(var i:int=0; i<roadTrailGenerator.arrayInside.length-1; i++) {

            vertices.push(roadTrailGenerator.arrayInside[i].x, roadTrailGenerator.arrayInside[i].y, roadTrailGenerator.arrayOutside[i].x, roadTrailGenerator.arrayOutside[i].y, roadTrailGenerator.arrayOutside[i+1].x, roadTrailGenerator.arrayOutside[i+1].y,
                    roadTrailGenerator.arrayOutside[i+1].x, roadTrailGenerator.arrayOutside[i+1].y, roadTrailGenerator.arrayInside[i+1].x, roadTrailGenerator.arrayInside[i+1].y, roadTrailGenerator.arrayInside[i].x, roadTrailGenerator.arrayInside[i].y);


            uvs.push(1,1,0,1,0,0,
                    0,0,1,0,1,1);

            spinalPoint = Point.interpolate(roadTrailGenerator.arrayInside[i],roadTrailGenerator.arrayOutside[i+1], .5);

            spinalVec.push(spinalPoint);

        }

        spinalPointTot = spinalVec.length;

        const shape:GShape = GNodeFactory.createNodeWithComponent(GShape) as GShape;
        shape.setTexture(tileTexture);
        shape.init(vertices, uvs);

        return shape;

    }

    /**
     * THIS CLASS CREATE THE OBJECTS : COINS, FUEL, BOOST
     */

    public function itemsArray(node:GNode):Vector.<GSprite> {

        //DECIDE HOW MANY OBJECTS ON THE ROAD
        const num:uint = 12;
        const objects:int = Math.round((spinalPointTot * 3 - num) / 18);
        const oldDivider:int = Math.round(objects / num);
        //RANDOMIZE THE OBJECTS ON THE ROAD
        _arrayBlock = NumberGenerator.makeSequence(roadTrailGenerator.arrayPoints.length - num, 20, objects);
        _arrayBlock.shift();
        //INIT THE ITEM VECTOR
        const vecItems:Vector.<GSprite> = new Vector.<GSprite>();
        //THIS THE BOOST POWER UP
        var powerUp:GSprite;
        powerUp = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        powerUp.textureId = "GUI_item_1";
        powerUp.node.name = "1";
        powerUp.node.transform.setPosition(roadTrailGenerator.arrayPoints[_arrayBlock[Math.floor(_arrayBlock.length * .5)]].x,
                                           roadTrailGenerator.arrayPoints[_arrayBlock[Math.floor(_arrayBlock.length * .5)]].y);

        node.addChild(powerUp.node);
        vecItems.push(powerUp);
        //SPLICE THE BOOST POWER UP POSITION FROM THE RANDOM ARRAY
        _arrayBlock.splice(Math.floor(_arrayBlock.length * .5), 1);
        //ADD THE FUEL ITEMS IF NOT EASY DIFFICULTY
        if(Settings.DIFFICULTY != 0) {

            const divider:int = Math.round(_arrayBlock.length / oldDivider);

            for (var f:int = 1; f < oldDivider; f++) {

                powerUp = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
                powerUp.textureId = "GUI_item_0";
                powerUp.node.name = "0";
                powerUp.node.transform.setPosition(roadTrailGenerator.arrayPoints[_arrayBlock[divider * f]].x, roadTrailGenerator.arrayPoints[_arrayBlock[divider * f]].y);

                node.addChild(powerUp.node);
                vecItems.push(powerUp);

                for (var i:int=_arrayBlock.length-1; i>=0; i--) {

                    if(_arrayBlock[i] == _arrayBlock[divider * f]) _arrayBlock.splice(i, 1);
                }
            }
        }
        //ADD COINS ITEMS
        for (var m:int=_arrayBlock.length-1; m>=0; m--) {

            powerUp = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
            powerUp.textureId = "GUI_item_2";
            powerUp.node.name = "2";
            powerUp.node.transform.setPosition(roadTrailGenerator.arrayPoints[_arrayBlock[m]].x, roadTrailGenerator.arrayPoints[_arrayBlock[m]].y);

            node.addChild(powerUp.node);
            vecItems.push(powerUp);
        }

        return vecItems;
    }

    /**
     * CREATE THE FINISH LINE
     */

    public function createFinishLine():GSprite {

        const finishLineRot:Number = Math.atan2((roadTrailGenerator.arrayInside[roadTrailGenerator.arrayInside.length-1].y - roadTrailGenerator.arrayOutside[roadTrailGenerator.arrayInside.length-1].y),
                                                (roadTrailGenerator.arrayInside[roadTrailGenerator.arrayOutside.length-1].x - roadTrailGenerator.arrayOutside[roadTrailGenerator.arrayOutside.length-1].x));

        const finishLine:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;

        finishLine.textureId = "GUI_finishLine";
        finishLine.node.transform.setPosition(spinalVec[spinalVec.length - 1].x, spinalVec[spinalVec.length - 1].y);
        finishLine.node.transform.rotation = finishLineRot;

        return finishLine;
    }

    /**
     * METHOD FOR CREATING THE RIVAL CAR PATH
     */
    public function createPath():void {

        for(var i:int=roadTrailGenerator.arrayPoints.length-1; i>=0; i--) {

            if(i % 3 == 2) {

                pathVec.push(new Point(Math.floor(roadTrailGenerator.arrayPoints[i].x), Math.floor(roadTrailGenerator.arrayPoints[i].y)));
            }
        }

        pathVec.pop();

        removeDuplicate(pathVec);

    }

    /**
     * METHOD FOR REMOVING THE ARRAY
     */

    private static function removeDuplicate(arr:Vector.<Point>):void {

        var i:int;
        var j:int;

        for (i = 0; i < arr.length - 1; i++){
            for (j = i + 1; j < arr.length; j++){

                if(Point.distance(arr[i], arr[j]) < 100) {

                    if(arr[i].x - arr[j].x < 3 && arr[i].y - arr[j].y < 3) {

                        arr.splice(j,1);
                        j--;
                    }
                }
            }
        }
    }

    /**
     * METHODS FOR THE GRANDPRIX STARTS HERE
     */

    public function createPathGrandPrix():void {

        for(var i:int=roadTrailGenerator.arrayPoints.length-1; i>=0; i--) {

            if(i % 3 == 0) trailOne.push(new Point(Math.floor(roadTrailGenerator.arrayPoints[i].x), Math.floor(roadTrailGenerator.arrayPoints[i].y)));
            if(i % 3 == 1) trailTwo.push(new Point(Math.floor(roadTrailGenerator.arrayPoints[i].x), Math.floor(roadTrailGenerator.arrayPoints[i].y)));
            if(i % 3 == 2) trailThree.push(new Point(Math.floor(roadTrailGenerator.arrayPoints[i].x), Math.floor(roadTrailGenerator.arrayPoints[i].y)));
        }

        removeDuplicate(trailOne);
        removeDuplicate(trailTwo);
        removeDuplicate(trailThree);

        arrTrails.push(trailOne, trailTwo, trailThree);

    }

    /**
     * METHOD FOR ADD BOOSTER ELEMENT TO THE GAME
     */

    public function boosterVec(node:GNode):Vector.<GSprite> {

        //DECIDE HOW MANY OBJECTS ON THE ROAD
        const num:uint = 12;
        const objects:int = Math.round((spinalPointTot * 3 - num) / 18);
        //RANDOMIZE THE OBJECTS ON THE ROAD
        _arrayBlock = NumberGenerator.makeSequence(roadTrailGenerator.arrayPoints.length - num, 80, objects);
        _arrayBlock.shift();
        //INIT THE ITEM VECTOR
        const vecItems:Vector.<GSprite> = new Vector.<GSprite>();
        //THIS THE BOOST POWER UP
        var powerUp:GSprite;
        //ADD COINS ITEMS
        for (var m:int=_arrayBlock.length-1; m>=0; m--) {

            powerUp = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
            powerUp.textureId = "GUI_item_1";
            powerUp.node.transform.setPosition(roadTrailGenerator.arrayPoints[_arrayBlock[m]].x, roadTrailGenerator.arrayPoints[_arrayBlock[m]].y);

            node.addChild(powerUp.node);
            vecItems.push(powerUp);
        }

        return vecItems;

    }
}
}
