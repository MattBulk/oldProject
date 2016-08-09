/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/12/13
 * Time: 3:16 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.components {

import com.genome2d.core.GNode;

public class MMovieButton extends MSimpleButton {

    protected var _frames:Array = [];
    protected var _currentFrame:uint;
    protected var _numFrames:uint;

    public function MMovieButton(p_node:GNode) {

        super(p_node);

        this.node.mouseEnabled = true;

    }

    public function next():void {

        if(_currentFrame == _numFrames) this.gotoFrame(0);

        else this.gotoFrame(_currentFrame + 1);

    }

    /**
     * PRIVATE METHODS
     *
     */

    public function gotoFrame(num:uint):void {

        textureId = _frames[num];
        _currentFrame = num;
    }

    /**
     * SETTER AND GETTER METHODS
     *
     */

    public function set frames(value:Array):void {

        _frames = value;
        _numFrames = _frames.length-1;

    }

    public function get currentFrame():uint {

        return _currentFrame;
    }

}
}
