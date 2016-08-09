/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/15/13
 * Time: 10:15 PM
 * To change this template use File | Settings | File Templates.
 */
package components.shared {
import com.genome2d.components.GComponent;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;

import interfaces.IBoy;
import interfaces.IGirl;

import interfaces.IPlayers;

import utils.Settings;
import utils.deg2rad;

public class TheCar extends GComponent {

    public var theCar:GSprite;

    public function TheCar(p_node:GNode) {

        super(p_node);

        var iPlayer:IPlayers;

        switch (Settings.PLAYER) {

            case 1 :
                iPlayer = new IBoy();
                break;
            case 2 :
                iPlayer = new IGirl();
                break;
        }

        theCar = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        theCar.textureId = iPlayer.texture;
        theCar.node.transform.setScale(.9, .9);

        theCar.node.transform.setPosition(-20, 0);
        theCar.node.transform.rotation = deg2rad(90);
        this.node.addChild(theCar.node);

        this.node.addComponent(GetInput);
    }
}
}
