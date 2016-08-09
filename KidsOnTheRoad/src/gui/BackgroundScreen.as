/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/13/13
 * Time: 1:46 PM
 * To change this template use File | Settings | File Templates.
 */
package gui {

import com.genome2d.components.GComponent;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.core.GNode;
import com.genome2d.core.GNodeFactory;
import events.NavigationEvent;
import mutation.utils.MConstant;

import utils.Settings;

public class BackgroundScreen extends GComponent {

    private var background:GSprite;
    private var tiledBG:GNode;
    private var _tiled_array:Array = [];

    public function BackgroundScreen(p_node:GNode) {
        super(p_node);

        background = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        this.node.addChild(background.node);

        createTiledBG();

        this.node.core.stage.addEventListener(NavigationEvent.BACKGROUND_CHANGE, setTheBackGround, false, 0, true);
    }

    private function setTheBackGround(evt:NavigationEvent):void {

        switch (evt.params.id) {

            case "main":
                    background.node.active = true;
                    background.textureId = "main";
                    tiledBG.active = false;
                    break;
            case "player":
                    background.node.active = false;
                    tiledBG.active = true;
                    swapTiles("GUI_players_tile");
                    break;
            case "world":
                    background.node.active = true;
                    background.textureId = "worlds";
                    tiledBG.active = false;
                    break;
            case "bg":
                    background.node.active = true;
                    tiledBG.active = false;
                    if(Settings.WORLD == 1) background.textureId = "mountain";
                    else if(Settings.WORLD == 2) background.textureId = "city";
                    else background.textureId = "sea";
                    break;
            case "setting":
            case "builder":
                    background.node.active = false;
                    tiledBG.active = true;
                    swapTiles("GUI_settings_tile");
                    break;
        }

        if(Settings.IPHONE5) background.node.transform.setScale(1.11, 1.05);

        background.node.transform.setPosition(MConstant.STAGE_WIDTH * .5, MConstant.STAGE_HEIGHT * .5);
    }

    private function createTiledBG():void {

        tiledBG = GNodeFactory.createNode("settingCont");
        tiledBG.transform.setPosition(0,0);

        this.node.addChild(tiledBG);

        for (var X:uint = 0; X < 20; X++)
        {
            var tile:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
            tile.textureId = "GUI_settings_tile";
            tile.node.transform.alpha = .5;
            tile.node.transform.x = tile.node.getWorldBounds().width * (X % 5);
            tile.node.transform.y = tile.node.getWorldBounds().height * Math.floor(X / 5);

            tiledBG.addChild(tile.node);

            _tiled_array.push(tile);
        }

        tiledBG.active = false;
    }

    private function swapTiles(str:String):void {

        for each(var tile:GSprite in _tiled_array) {

            tile.textureId = str;
        }
    }
}
}
