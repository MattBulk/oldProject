/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/15/13
 * Time: 10:27 PM
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

public class TheRivalCar extends GComponent {

    public var theCar:GSprite;

    public function TheRivalCar(p_node:GNode) {

        super(p_node);

        var iPlayer:IPlayers;

        switch (Settings.PLAYER) {

            case 1 :
                iPlayer = new IGirl();
                break;
            case 2 :
                iPlayer = new IBoy();
                break;
        }

        theCar = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        theCar.textureId =  iPlayer.texture;
        theCar.node.transform.setScale(.9,.9);
        theCar.node.transform.setPosition(0,20);

        this.node.addChild(theCar.node);
    }
}
}
