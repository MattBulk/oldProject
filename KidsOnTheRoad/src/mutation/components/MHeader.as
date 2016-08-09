/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/11/13
 * Time: 9:24 AM
 * To change this template use File | Settings | File Templates.
 */
package mutation.components {
import com.genome2d.components.GComponent;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAlignType;

import flash.geom.Point;

import mutation.utils.MConstant;

public class MHeader extends GComponent {

    protected var _header:GTextureText;
    protected var _textureId:String;
    protected var _title:String;
    protected var _left:Object;
    protected var _right:Object;
    protected var _background:GSprite;

    protected var VALIDATED_LEFT_ITEM:Boolean;
    protected var VALIDATED_RIGHT_ITEM:Boolean;
    protected var VALIDATED_BACKGROUND:Boolean;

    private const HELPER_POINT:Point = new Point();

    public function MHeader(p_node:GNode) {

        super(p_node);

        _header = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;

        this.node.addChild(_header.node);

    }

    public function setElement(obj:Object, position:uint):void {

        if(position == MConstant.LEFT_ITEM && !VALIDATED_LEFT_ITEM) {

            _left = obj;

            VALIDATED_LEFT_ITEM = true;
            HELPER_POINT.setTo(_left.textureWidth * .5 + MConstant.MARGIN, _left.textureHeight * .5);

            _left.node.transform.setPosition(HELPER_POINT.x, HELPER_POINT.y);

            this.node.addChild(_left.node);
        }

        if(position == MConstant.RIGHT_ITEM && !VALIDATED_RIGHT_ITEM) {

            _right = obj;

            VALIDATED_RIGHT_ITEM = true;
            HELPER_POINT.setTo(MConstant.STAGE_WIDTH - (_right.textureWidth * .5 + MConstant.MARGIN), _right.textureHeight * .5);

            _right.node.transform.setPosition(HELPER_POINT.x, HELPER_POINT.y);
            this.node.addChild(_right.node);

        }

    }

    protected function validatePosition():void {

        _header.node.transform.setPosition((MConstant.STAGE_WIDTH - _header.width) * .5, _header.height * .5);
    }

    public function setBackground(textureId:String, scale:Boolean = true):void {

        if(VALIDATED_BACKGROUND) return;
        else VALIDATED_BACKGROUND = true;

        _background = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        _background.textureId = textureId;

        if(scale) _background.node.transform.scaleX = MConstant.STAGE_WIDTH;

        HELPER_POINT.setTo(_background.node.getWorldBounds().width * .5, _background.node.getWorldBounds().height * .5);

        _background.node.transform.setPosition(HELPER_POINT.x, HELPER_POINT.y);
        this.node.addChild(_background.node);

        this.node.putChildToBack(_background.node);

    }

    /**
     * setter methods
     */

    public function set setScale(scale:Number):void {

        _header.node.transform.setScale(scale, scale);
        this.validatePosition();

    }

    public function set title(value:String):void {

        _title = value;
        _header.text = _title;

        this.validatePosition();
    }

    public function set textureId(value:String):void {

        _textureId = value;
        _header.textureAtlasId = value;
    }
}
}
