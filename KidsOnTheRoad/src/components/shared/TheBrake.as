/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/15/13
 * Time: 10:31 PM
 * To change this template use File | Settings | File Templates.
 */
package components.shared {
import com.genome2d.components.GComponent;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAlignType;
import com.genome2d.textures.factories.GTextureFactory;

import mutation.utils.MConstant;

public class TheBrake extends GComponent {

    private var _bgTexture:GTexture;

    public function TheBrake(p_node:GNode) {

        super(p_node);

        const brakeTexture:GTexture = GTexture.getTextureById("GUI_brake_btn");

        const brakeBtn:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        brakeBtn.setTexture(brakeTexture);
        brakeTexture.alignTexture(GTextureAlignType.TOP_LEFT);
        brakeBtn.node.transform.setPosition(0, - brakeTexture.height);
        this.node.addChild(brakeBtn.node);

        brakeBtn.node.mouseEnabled = true;

        _bgTexture = GTextureFactory.createFromColor("whiteBrake", 0xFFFFFF, MConstant.STAGE_WIDTH * .96, brakeTexture.height);

        const brakeBar:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        brakeBar.textureId = "whiteBrake";
        _bgTexture.alignTexture(GTextureAlignType.TOP_LEFT);
        brakeBar.node.transform.setPosition(0, - brakeTexture.height);
        brakeBar.node.transform.alpha = .2;
        this.node.addChild(brakeBar.node);

        this.node.putChildToBack(brakeBar.node);

        brakeBar.node.mouseEnabled = true;
    }

    override public function dispose():void {

        _bgTexture.dispose();
        super.dispose();

    }
}
}
