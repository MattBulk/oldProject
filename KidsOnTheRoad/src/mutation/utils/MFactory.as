/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/10/13
 * Time: 11:12 AM
 * To change this template use File | Settings | File Templates.
 */
package mutation.utils {
import com.genome2d.core.GNodeFactory;

import mutation.components.MBackButton;
import mutation.components.MSimpleButton;

public class MFactory {


    public static function createBackBtn(textureId:String, text:String = ""):MBackButton {

        var btn:MBackButton = GNodeFactory.createNodeWithComponent(MBackButton) as MBackButton;

        btn.textureId = textureId;
        btn.text = text;
        return btn;
    }

    public static function createBasicBtn(textureId:String, text:String = ""):MSimpleButton {

        var btn:MSimpleButton = GNodeFactory.createNodeWithComponent(MSimpleButton) as MSimpleButton;

        btn.textureId = textureId;
        btn.text = text;
        return btn;
    }
}
}
