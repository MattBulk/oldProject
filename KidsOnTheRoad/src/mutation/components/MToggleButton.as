/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/12/13
 * Time: 12:48 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.components {
import com.genome2d.core.GNode;
import com.genome2d.signals.GMouseSignal;

public class MToggleButton extends MSimpleButton {

    protected var _defaultTexture:String;
    protected var _toggledTexture:String;

    public function MToggleButton(p_node:GNode) {

        super(p_node);

        this.node.mouseEnabled = true;
        this.node.onMouseClick.add(fn_toggle);
    }

    /**
     * PRIVATE METHOS
     */

    internal function fn_toggle(evt:GMouseSignal):void {

        if(!this.isSelected) {

            this.isSelected = true;
            this.textureId = _toggledTexture;

        }

        else {

            this.isSelected = false;
            this.textureId = _defaultTexture;
        }

    }

    /**
     * SETTER AND GETTER METHOD
     */

    public function set defaultTexture(value:String):void {

        _defaultTexture = value;
        this.textureId = _defaultTexture;
    }

    public function set toggledTexture(value:String):void {
        _toggledTexture = value;
    }
}
}
