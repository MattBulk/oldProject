/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/10/13
 * Time: 11:02 AM
 * To change this template use File | Settings | File Templates.
 */
package mutation.components {
import com.genome2d.core.GNode;
import com.genome2d.signals.GMouseSignal;

import mutation.events.MEvent;

public class MBackButton extends MSimpleButton {

    public function MBackButton(p_node:GNode) {

        super(p_node);

        this.node.mouseEnabled = true;
        this.node.onMouseClick.add(completeEvent);
    }

    public function completeEvent(evt:GMouseSignal):void {

        node.core.stage.dispatchEvent(new MEvent(MEvent.COMPLETE, {id:""}, true));

    }

}
}
