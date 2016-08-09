/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/7/13
 * Time: 2:53 PM
 * To change this template use File | Settings | File Templates.
 */
package mutation.screens {
public class MScreenNavigationItem {

    public var theClass:Class;
    public var complete:String;

    public function MScreenNavigationItem(screen:Class, complete:String) {

        this.theClass = screen;
        this.complete = complete;

    }
}
}
