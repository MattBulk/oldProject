/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/8/13
 * Time: 9:28 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.components {
import com.genome2d.components.GComponent;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.signals.GMouseSignal;

import mutation.events.MEvent;
import mutation.utils.MConstant;
import mutation.utils.MDecorator;

public class MTiledButton extends GComponent {

    protected var _groupVec:Vector.<Object> = new Vector.<Object>();
    protected var _dataProvided:Vector.<Object> = new Vector.<Object>();
    protected var _layout:uint;
    protected var _gap:Number = 0;

    private var container:GNode;
    private var button:MSimpleButton;
    private var colums:uint = 0;
    private var row:uint = 0;

    public function MTiledButton(p_node:GNode) {

        super(p_node);
    }

    public function init(itemClass:Class, num:uint, textureId:String, fontAtlas:String = MConstant.FONT_ATLAS):void {

        container = new GNode("container");

        this.node.addChild(container);

        for(var i:uint=0; i<num; i++) {

            button = GNodeFactory.createNodeWithComponent(itemClass) as itemClass;

            button.textureAtlasId = fontAtlas;
            button.textureId = textureId;

            //ADD OPTIONS

            switch (itemClass) {

                case MSimpleButton :
                    MDecorator.simpleBtn(button as MSimpleButton, _dataProvided[i]);
                    break;
                case MActionButton :
                    MDecorator.actionBtn(button as MActionButton, _dataProvided[i], triggerEventAction);
                    break;
                case MToggleButton :
                    MDecorator.toggleBtn(button as MToggleButton, _dataProvided[i]);
                    break;
                case MMovieButton :
                    MDecorator.movieBtn(button as MMovieButton, _dataProvided[i]);
                    break;
                default :
                    throw new Error("THIS TYPE OF CLASS IS NOT SUPPORTED");
                    break;
            }

            //ENABLE MOUSE ADD ATTACH SIGNAL
            button.node.onMouseClick.add(triggerEvent);

            container.addChild(button.node);

            _groupVec.push(button);

        }

        findRowsAndColums();

        var containerWidth:Number;
        var containerHeight:Number;

        var totalRows:Number = Math.ceil(num/colums);

        containerWidth = button.textureWidth * _gap * colums - (button.textureWidth * _gap - button.textureWidth);
        containerHeight = button.textureHeight * _gap * totalRows - (button.textureHeight * _gap - button.textureHeight);

        container.transform.x = (MConstant.STAGE_WIDTH - containerWidth + button.textureWidth) * .5;
        container.transform.y = (MConstant.STAGE_HEIGHT - containerHeight + button.textureHeight) * .5;

    }

    //************************************************** PRIVATE METHODS ***********************************************

    private function triggerEvent(evt:GMouseSignal):void {

        node.core.stage.dispatchEvent(new MEvent(MEvent.TRIGGERED, {id: evt.target}, true));
    }

    private function triggerEventAction(evt:GMouseSignal):void {

        node.core.stage.dispatchEvent(new MEvent(MEvent.ACTION_TRIGGERED, {id: evt.target}, true));
    }

    private function findRowsAndColums():void {

        var rndNum:Number;
        do
        {
            rndNum = button.textureWidth * colums * _gap;
            colums++;
        }
        while(rndNum < MConstant.STAGE_WIDTH - button.textureWidth * _gap);

//        do
//        {
//            rndNum = button.textureHeight * colum * _gap;
//            colum++;
//        }
//        while(rndNum <= Constant.STAGE_HEIGHT - button.textureHeight * _gap);

        colums--;

        for(var i:uint=0; i<_groupVec.length; i++) {

            _groupVec[i].node.transform.x = button.textureWidth * _gap * (i % colums);
            _groupVec[i].node.transform.y = button.textureHeight * _gap * Math.floor(i / colums);
        }

    }

    //************************************************** SETTER AND GETTER METHODS ***********************************************

    public function set sendData(arr:Array):void {

        _dataProvided = Vector.<Object>(arr);

    }

    public function set direction(layout:uint):void {

        _layout = layout;
    }

    public function set gap(gap:Number):void {

        _gap = gap;

    }

    public function get groupVec():Vector.<Object> {
        return _groupVec;
    }

    public function set groupVec(value:Vector.<Object>):void {
        _groupVec = value;
    }
}
}
