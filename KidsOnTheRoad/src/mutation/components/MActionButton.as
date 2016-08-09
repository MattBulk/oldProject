/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 5/24/13
 * Time: 9:54 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.components {

import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureBase;

public class MActionButton extends MSimpleButton {

    protected var _actionMode:Boolean;

    public var actionBtn:GSprite;

    public function MActionButton(p_node:GNode) {

        super(p_node);

        actionBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;

        node.addChild(actionBtn.node);

        actionBtn.node.active = false;
    }

    //************************************************** SETTER AND GETTER METHODS ***********************************************

    public function set actionId(id:String):void {

        actionBtn.textureId = id;

        actionBtn.node.transform.setPosition(actionBtn.node.getWorldBounds().width * .9, -actionBtn.node.getWorldBounds().height * .9);

    }

    public function get actionMode():Boolean {
        return _actionMode;
    }

    public function set actionMode(value:Boolean):void {
        _actionMode = value;
    }
}
}
