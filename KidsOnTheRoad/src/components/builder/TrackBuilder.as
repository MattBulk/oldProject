/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/14/13
 * Time: 8:15 PM
 * To change this template use File | Settings | File Templates.
 */
package components.builder {

import com.genome2d.components.GComponent;
import com.genome2d.components.renderables.GShape;
import com.genome2d.components.renderables.GSimpleShape;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.factories.GTextureFactory;
import com.greensock.TweenLite;

import events.NavigationEvent;

import flash.geom.Point;
import flash.geom.Rectangle;

import mutation.components.MSimpleButton;
import mutation.utils.MConstant;

import utils.RoadGenerator;

import utils.Settings;
import utils.WriteTheFile;

public class TrackBuilder extends GComponent {

    private var _WORLD:uint, _SLOT:uint;
    private var _rowAndColumn:uint;
    private var _BIG_CONT:GNode, _GUI:GNode, _THE_ROAD:GNode;
    private var _RECT_AREA:Rectangle;
    private var _tileTexture:GTexture, _limitTexture:GTexture, _stageTexture:GTexture;
    private var _oldDialed:String;
    private var _theXML:XML;
    private var _vertices:Vector.<Number>, _uvs:Vector.<Number>;
    private var _errorMenu:BuilderError;
    private var _spinalPoint:Point;
    private var _roadGenerator:RoadGenerator;
    private var _typeArr:Array = [];
    private var _radiusArr:Array = [];
    private var _arrayDialed:Array = [];
    
    private const _referenceTile:GTexture = GTexture.getTextureById("BUILDER_tile");

    public function TrackBuilder(p_node:GNode) {
        super(p_node);
    }

    public function init(AREA:uint, SIZE:uint, SLOT:uint):void {

        _WORLD = AREA;
        _SLOT = SLOT;

        //CREATE THE CONTAINER FOR THE TRACK BUILDER
        _BIG_CONT = GNodeFactory.createNode("_BIG_CONT");
        _BIG_CONT.transform.setPosition(MConstant.STAGE_WIDTH * .02, MConstant.STAGE_HEIGHT * .05);
        this.node.addChild(_BIG_CONT);

        //LOAD THE XML
        var xmlPath:String;
        if(Settings.OLD_DEVICE) xmlPath = "db/myOldTracks/" + AREA.toString() + "-" + SIZE.toString() + ".xml";
        else xmlPath = "db/myTracks/" + AREA.toString() + "-" + SIZE.toString() + ".xml";

        WriteTheFile.getInstance().loadXML(xmlPath);
        //SAVE THE LOADED XLM TO A LOCAL VARIABLE
        _theXML = WriteTheFile.getInstance().loadedTrack;

        //CREATE THE ROAD TILE TEXTURE
        _tileTexture = GTextureFactory.createFromColor("red", 0xFF0000, 1, 1);
        _limitTexture = GTextureFactory.createFromColor("green", 0x00FF00, 1, 1);
        _stageTexture = GTextureFactory.createFromColor("grey", 0xCCCCCC, 1, 1);
        //START TO BUILD THE SCENE
        addBuiltArea();

        addTheGUI();

        _roadGenerator = new RoadGenerator();
        
        roadBuilding();

    }

    /**
     * AREA
     */
    
    private function addBuiltArea():void {

        _rowAndColumn = _theXML.levels.tileNum;

        //SET THE RECTANGLE DIMENSIONS FOR THE AREA 
        _RECT_AREA = new Rectangle(0, 0, _rowAndColumn  * _referenceTile.width, _rowAndColumn * _referenceTile.height);

        //CREATE THE TWO SHAPES
        const area:GShape = GNodeFactory.createNodeWithComponent(GShape) as GShape;
        area.setTexture(_stageTexture);
        shapeCreator(area);
        _BIG_CONT.addChild(shapeCreator(area).node);

        //SET THE RECTANGLE TO THE MIDDLE AND CREATE THE BORDER SHAPE
        _RECT_AREA = new Rectangle(0, 0, (_rowAndColumn - 4)  * _referenceTile.width, (_rowAndColumn - 4) * _referenceTile.height);
        _RECT_AREA.x = area.node.transform.x;
        _RECT_AREA.y = area.node.transform.y;
        _RECT_AREA.offset(area.node.transform.x + _referenceTile.width * 2, area.node.transform.y + _referenceTile.height * 2);

        const border:GShape = GNodeFactory.createNodeWithComponent(GShape) as GShape;
        border.setTexture(_limitTexture);
        border.node.transform.alpha = .3;

        _BIG_CONT.addChild(shapeCreator(border).node);

        //CREATE THE ROAD AND POSITION IT
        _THE_ROAD = GNodeFactory.createNode("the_road");
        _BIG_CONT.addChild(_THE_ROAD);

        _THE_ROAD.transform.x = (_rowAndColumn * _referenceTile.width) / 2;
        _THE_ROAD.transform.y = (_rowAndColumn * _referenceTile.height) / 2;

        if(_rowAndColumn == 14) _BIG_CONT.transform.setScale(1.4, 1.4);
        else if(_rowAndColumn == 16) _BIG_CONT.transform.setScale(1.3, 1.3);
        else if(_rowAndColumn == 18) _BIG_CONT.transform.setScale(1.1, 1.1);
        else if(_rowAndColumn == 20) _BIG_CONT.transform.setScale(1, 1);
        else if(_rowAndColumn == 24) _BIG_CONT.transform.setScale(.85, .85);

    }

    private function shapeCreator(shape:GShape):GShape {

        const p1:Point = new Point(_RECT_AREA.topLeft.x, _RECT_AREA.topLeft.y);
        const p2:Point = new Point(_RECT_AREA.bottomRight.x, _RECT_AREA.bottomRight.y);
        const p3:Point = new Point(_RECT_AREA.topLeft.x, _RECT_AREA.bottomRight.y);
        const p4:Point = new Point(_RECT_AREA.bottomRight.x,_RECT_AREA.topLeft.y);

        _vertices = new <Number>[p1.x, p1.y, p2.x, p2.y, p3.x, p3.y,
            p1.x, p1.y, p2.x, p2.y, p4.x, p4.y];

        // Initialize texture coordinates
        _uvs = new <Number>[1,1,0,1,0,0,
            0,0,1,0,1,1];

        // Initialize shape with our vertices
        shape.init(_vertices, _uvs);

        return shape;
    }

    /**
     * GUI AND BUILDER ERROR
     */
    
    private function addTheGUI():void {

        _GUI = GNodeFactory.createNode("GUI");

        for (var X:uint = 0; X < 9; X++)
        {
            var levelBtn:MSimpleButton = GNodeFactory.createNodeWithComponent(MSimpleButton) as MSimpleButton;
            levelBtn.textureId = "GUI_level_btn";
            levelBtn.addIcon = "BUILDER_" + (X + 1).toString();
            levelBtn.node.transform.setScale(.9,.9);
            levelBtn.node.transform.x = levelBtn.node.getWorldBounds().width * (X % 3);
            levelBtn.node.transform.y = levelBtn.node.getWorldBounds().height * 1.1 * Math.floor(X / 3);
            levelBtn.node.name = (X + 1).toString();
            levelBtn.node.onMouseClick.add(triggerEvent);

            _GUI.addChild(levelBtn.node);
        }

        this.node.addChild(_GUI);

        const posX:Number = MConstant.STAGE_WIDTH - (levelBtn.textureWidth * 2.5);
        const posY:Number = MConstant.STAGE_HEIGHT * .15;

        _GUI.transform.setPosition(posX, posY);

        const back:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        back.textureId = "GUI_back_btn";
        back.node.transform.setPosition(MConstant.STAGE_WIDTH * .12, MConstant.STAGE_HEIGHT * .75);
        _GUI.addChild(back.node);

        const saveBtn:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        saveBtn.textureId = "BUILDER_save_btn";
        saveBtn.node.transform.setPosition(MConstant.STAGE_WIDTH * .12, MConstant.STAGE_HEIGHT * .6);
        _GUI.addChild(saveBtn.node);

        back.node.mouseEnabled = true;
        back.node.name = "back";
        back.node.onMouseClick.add(onSignalEvent);

        saveBtn.node.mouseEnabled = true;
        saveBtn.node.name = "save";
        saveBtn.node.onMouseClick.add(onSignalEvent);

        _errorMenu = GNodeFactory.createNodeWithComponent(BuilderError) as BuilderError;
        _errorMenu.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .5);
        _errorMenu.node.active = false;

        this.node.addChild(_errorMenu.node);
    }

    public function errorMenuOFF():void {

        _errorMenu.node.active = false;
        _GUI.active = true;
        
    }

    private function errorMenuON():void {

        _GUI.active = false;
        _errorMenu.node.active = true;

    }

    /**
     *
     * EVENTS AND SAVE SYSTEM
     */

    private function onSignalEvent(evt:GMouseSignal):void {

        if(evt.target.name == "save") checkBeforeWrite();
        else this.disposeMe();
    }

    private function checkBeforeWrite():void {

        switch (_rowAndColumn)
        {
            case 16 :
                if(_typeArr.length >= 9) xmlToSave();
                else {
                    errorMenuON();
                    _errorMenu.errorMessage("TOO SHORT", "TRACK MUST BE LONGER");
                }
                break;
            case 14 :
                if(_typeArr.length >= 9) xmlToSave();
                else {
                    errorMenuON();
                    _errorMenu.errorMessage("TOO SHORT", "TRACK MUST BE LONGER");
                }
                break;
            case 18 :
                if(_typeArr.length >= 16) xmlToSave();
                else {
                    errorMenuON();
                    _errorMenu.errorMessage("TOO SHORT", "TRACK MUST BE LONGER");
                }
                break;
            case 20 :
                if(_typeArr.length >= 16) xmlToSave();
                else {
                    errorMenuON();
                    _errorMenu.errorMessage("TOO SHORT", "TRACK MUST BE LONGER");
                }
                break;
            case 24 :
                if(_typeArr.length >= 25) xmlToSave();
                else {
                    errorMenuON();
                    _errorMenu.errorMessage("TOO SHORT", "TRACK MUST BE LONGER");
                }
                break;
        }
    }

    private function xmlToSave():void {

        _theXML.levels.curveType = _typeArr.toString();
        _theXML.levels.radiusType = _radiusArr.toString();

        const path:String = _WORLD.toString() + "-" + _SLOT + ".xml";

        WriteTheFile.getInstance().writeXML(path, _theXML);

        const slot:uint = _SLOT - 1;

        WriteTheFile.getInstance().slotXML.world[_WORLD-1].slot[slot] = _SLOT;
        WriteTheFile.getInstance().writeXML("slots.xml", WriteTheFile.getInstance().slotXML);

        this.disposeMe();

    }

    private function triggerEvent(evt:GMouseSignal):void {

        if(evt.target.name == "1" || evt.target.name == "2" || evt.target.name == "5" || evt.target.name == "6" || evt.target.name == "7" || evt.target.name == "8") {

            if(_oldDialed == evt.target.name) {

                errorMenuON();
                _errorMenu.errorMessage("ONE AFTER THE OTHER", "CHOOSE ANOTHER CURVE TYPE");
                return;

            }
        }

        switch(evt.target.name) {
            case "1" :
                if(_typeArr[_typeArr.length - 1] == 1) {
                    _typeArr.push(2);
                    _radiusArr.push(1);
                    _typeArr.push(1);
                    _radiusArr.push(10);
                    _arrayDialed.push(2);
                }
                else {
                    _typeArr.push(1);
                    _radiusArr.push(10);
                    _arrayDialed.push(1);
                }

                break;
            case "2" :
                if(_typeArr[_typeArr.length - 1] == 2 || _typeArr[_typeArr.length - 1] == 0 || !_typeArr.length) {
                    _typeArr.push(1);
                    _radiusArr.push(1);
                    _typeArr.push(2);
                    _radiusArr.push(10);
                    _arrayDialed.push(2);
                }
                else {
                    _typeArr.push(2);
                    _radiusArr.push(10);
                    _arrayDialed.push(1);
                }

                break;
            case "3" :
                if(_typeArr[_typeArr.length - 1] == 1) {
                    _typeArr.push(2);
                    _radiusArr.push(1);
                    _typeArr.push(0);
                    _radiusArr.push(5);
                    _arrayDialed.push(2);
                }
                else {
                    _typeArr.push(0);
                    _radiusArr.push(5);
                    _arrayDialed.push(1);
                }

                break;
            case "4" :
                if(_typeArr[_typeArr.length - 1] == 1) {
                    _typeArr.push(2);
                    _radiusArr.push(1);
                    _typeArr.push(0);
                    _radiusArr.push(10);
                    _arrayDialed.push(2);
                }
                else {
                    _typeArr.push(0);
                    _radiusArr.push(10);
                    _arrayDialed.push(1);
                }

                break;
            case "5" :
                if(_typeArr[_typeArr.length - 1] == 1) {
                    _typeArr.push(2);
                    _radiusArr.push(1);
                    _typeArr.push(1);
                    _radiusArr.push(19);
                    _arrayDialed.push(2);
                }
                else {
                    _typeArr.push(1);
                    _radiusArr.push(19);
                    _arrayDialed.push(1);
                }
                break;
            case "6" :
                if(_typeArr[_typeArr.length - 1] == 2 || !_typeArr.length || _typeArr[_typeArr.length - 1] == 0) {
                    _typeArr.push(1);
                    _radiusArr.push(1);
                    _typeArr.push(2);
                    _radiusArr.push(19);
                    _arrayDialed.push(2);
                }
                else {
                    _typeArr.push(2);
                    _radiusArr.push(19);
                    _arrayDialed.push(1);
                }

                break;
            case "7" :
                if(_typeArr[_typeArr.length - 1] == 1) {
                    _typeArr.push(2);
                    _radiusArr.push(1);
                    _typeArr.push(1);
                    _radiusArr.push(5);
                    _arrayDialed.push(2);
                }
                else {
                    _typeArr.push(1);
                    _radiusArr.push(5);
                    _arrayDialed.push(1);
                }
                break;
            case "8" :
                if(_typeArr[_typeArr.length - 1] == 2 || _typeArr[_typeArr.length - 1] == 0 || !_typeArr.length) {
                    _typeArr.push(1);
                    _radiusArr.push(1);
                    _typeArr.push(2);
                    _radiusArr.push(5);
                    _arrayDialed.push(2);
                }
                else {
                    _typeArr.push(2);
                    _radiusArr.push(5);
                    _arrayDialed.push(1);
                }
                break;
            case "9" :
                deleteThePiece();
                break;
        }

        _oldDialed = evt.target.name;

        Settings.SM.playSound("../sounds/SELECT.mp3");
        TweenLite.from(evt.target.transform, .2, {scaleX:1, scaleY:1});

        _THE_ROAD.disposeChildren();

        roadBuilding();

    }

    private function deleteThePiece():void {

        _typeArr.splice(_typeArr.length - _arrayDialed[_arrayDialed.length-1], _arrayDialed[_arrayDialed.length-1]);
        _radiusArr.splice(_radiusArr.length - _arrayDialed[_arrayDialed.length-1], _arrayDialed[_arrayDialed.length-1]);
        _arrayDialed.pop();
    }

    /**
     * ROAD BUILDING
     */
    
    private function roadBuilding():void {

        _roadGenerator.initGenerator(_typeArr, _radiusArr, int(_theXML.levels.startLine));

        createRoad();
        
    }

    private function createRoad():void {

        _vertices = new Vector.<Number>();
        _uvs = new Vector.<Number>();

        for(var i:int=0; i<_roadGenerator.arrayInside.length-1; i++) {

            _vertices.push(_roadGenerator.arrayInside[i].x, _roadGenerator.arrayInside[i].y, _roadGenerator.arrayOutside[i].x, _roadGenerator.arrayOutside[i].y, _roadGenerator.arrayOutside[i+1].x, _roadGenerator.arrayOutside[i+1].y,
                    _roadGenerator.arrayOutside[i+1].x, _roadGenerator.arrayOutside[i+1].y, _roadGenerator.arrayInside[i+1].x, _roadGenerator.arrayInside[i+1].y, _roadGenerator.arrayInside[i].x, _roadGenerator.arrayInside[i].y);

            _uvs.push(1,1,0,1,0,0,
                    0,0,1,0,1,1);

        }

        _spinalPoint = Point.interpolate(_roadGenerator.arrayInside[_roadGenerator.arrayInside.length-1],_roadGenerator.arrayOutside[_roadGenerator.arrayOutside.length-1], .5);

        _spinalPoint.x += _THE_ROAD.transform.x;
        _spinalPoint.y += _THE_ROAD.transform.y;

        const tileShape:GSimpleShape = GNodeFactory.createNodeWithComponent(GSimpleShape) as GSimpleShape;
        tileShape.setTexture(_tileTexture);

        tileShape.init(_vertices, _uvs);
        _THE_ROAD.addChild(tileShape.node);

        checkTheRoad();
    }

    private function checkTheRoad():void
    {

        if(checkPoint()) {

            errorMenuON();

            _errorMenu.errorMessage("KEEP THE DISTANCE", "YOU MAY INTERSECTING THE ROAD");

            deleteThePiece();

            _THE_ROAD.disposeChildren();

            roadBuilding();
        }

        if(!_RECT_AREA.containsPoint(_spinalPoint)) {

            errorMenuON();

            _errorMenu.errorMessage("LIMITED AREA", "BUILD IN THE GREEN AREA");

            deleteThePiece();

            _THE_ROAD.disposeChildren();
            
            roadBuilding();
        }
    }

    private function checkPoint():Boolean {

        var yes:Boolean = false;

        for (var Y:uint=0; Y<_roadGenerator.arrayInside.length-1; Y++)
        {
            for (var X:uint=0; X<_roadGenerator.arrayOutside.length-1; X++)
            {
                var d:Number = Math.round(Point.distance(_roadGenerator.arrayInside[Y], _roadGenerator.arrayOutside[X]));

                if(d < 35 * Settings.SCALE_FACTOR) return yes = true;
            }
        }

        return yes;
    }

    /**
     * DISPOSE
     */

    private function disposeMe():void {

        //CLEAR ARRAYS
        _typeArr.splice(0, _typeArr.length);
        _radiusArr.splice(0, _radiusArr.length);
        _tileTexture.dispose();
        _limitTexture.dispose();
        _stageTexture.dispose();
        _THE_ROAD.disposeChildren();

        //DISPOSE ERROR_SCREEN
        _errorMenu.disposeMe();

        this.node.disposeChildren();

        node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id:"builder_back"}, true));

    }

}
}
