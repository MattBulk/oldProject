/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/12/13
 * Time: 10:40 AM
 * To change this template use File | Settings | File Templates.
 */
package mutation.utils {
import mutation.components.MActionButton;
import mutation.components.MMovieButton;
import mutation.components.MSimpleButton;
import mutation.components.MToggleButton;

public class MDecorator {

    public static function simpleBtn(btn:MSimpleButton, obj:Object):MSimpleButton {

        if(obj.textureId) btn.textureId = obj.textureId;
        btn.setScale = obj.setScale;
        btn.text = obj.text;
        btn.event = obj.event;
        btn.node.name = obj.name;

        if(obj.addIcon) {
            btn.addIcon = obj.addIcon;
            btn.iconFloat = obj.iconFloat;
        }

        return btn
    }

    public static function actionBtn(btn:MActionButton, obj:Object, fun:Function):MActionButton {

        btn.setScale = obj.setScale;
        btn.text = obj.text;
        btn.event = obj.event;

        btn.actionId = obj.actionId;
        btn.actionBtn.node.mouseEnabled = true;
        btn.actionBtn.node.onMouseClick.add(fun);

        return btn
    }

    public static function toggleBtn(btn:MToggleButton, obj:Object):MToggleButton {

        btn.event = obj.event;
        btn.defaultTexture = obj.defaultTexture;
        btn.toggledTexture = obj.toggledTexture;

        return btn;
    }

    public static function movieBtn(btn:MMovieButton, obj:Object):MMovieButton {

        btn.frames = obj.frames;
        btn.setScale = obj.setScale;
        btn.text = obj.text;
        btn.event = obj.event;
        btn.textureId = obj.frames[0];

        if(obj.labelPosition) btn.labelPosition = obj.labelPosition;

        return btn;
    }
}
}
