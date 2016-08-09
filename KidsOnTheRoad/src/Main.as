package
{

import com.genome2d.core.GConfig;
import com.genome2d.core.GNodeFactory;
import com.genome2d.core.Genome2D;
import components.GrandPrixGame;
import components.TheTourGame;
import components.builder.TrackBuilder;
import gui.BackgroundScreen;
import gui.LevelScreen;
import gui.MainScreen;
import gui.PlayerScreen;
import gui.SettingScreen;
import gui.WorldScreen;
import events.NavigationEvent;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import gui.builder.BuilderLevelScreen;
import gui.builder.BuilderScreen;
import mutation.events.MEvent;
import mutation.screens.MScreenNavigation;
import mutation.screens.MScreenNavigationItem;

import utils.Settings;
import utils.WriteTheFile;

public class Main extends Sprite {

    private var _background:BackgroundScreen;
    private var _screenNavigation:MScreenNavigation;
    private var _trackBuilder:TrackBuilder;
    private var _theGame:Object;
    private var _core:Genome2D;

    public function Main()
    {
        super();

        stage.frameRate = 60;

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        stage.addEventListener(Event.RESIZE, resizeStage, false, 0, true);

        _core = Genome2D.getInstance();

        const config:GConfig = new GConfig(getViewPortRect(), "baseline");
        config.backgroundColor = 0x000000;
        //config.enableStats = true;
        //config.showExtendedStats = true;
        config.useFastMem = true;
        config.antiAliasing = 0;

        _core.onInitialized.addOnce(onGenome2DInitialized);
        _core.init(stage, config);

    }

    protected function resizeStage(evt:Event):void
    {
        _core.config.viewRect = getViewPortRect();
    }

    protected function getViewPortRect() : Rectangle
    {
        return new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
    }

    protected function onGenome2DInitialized():void {

        switch (stage.stageWidth) {
            case 480:
                stage.frameRate = 30;
                Settings.OLD_DEVICE = true;
                Settings.SCALE_FACTOR = .5;
                Settings.FOLDER = "0";
                break;
            case 960:
                Settings.FOLDER = "1";
                Settings.SCALE_FACTOR = 1;
                break;
            case 1024:
                Settings.FOLDER = "1";
                Settings.SCALE_FACTOR = 1;
                break;
            case 1136:
                Settings.FOLDER = "1";
                Settings.IPHONE5 = true;
                Settings.SCALE_FACTOR = 1;
                break;
            case 2048:
                Settings.FOLDER = "2";
                Settings.SCALE_FACTOR = 2;
                break;
            default :
                Settings.FOLDER = "1";
                Settings.SCALE_FACTOR = 1;
                break;
        }

        AssetManager.getInstance().addToQueue(AssetManager.ATLAS, "GUI", Settings.FOLDER, "gui.png", "gui.xml");
        AssetManager.getInstance().addToQueue(AssetManager.BITMAP, "main", Settings.FOLDER, "main.png");
        AssetManager.getInstance().addToQueue(AssetManager.BITMAP, "worlds", Settings.FOLDER, "world-selection.png");
        AssetManager.getInstance().addToQueue(AssetManager.BITMAP, "mountain", Settings.FOLDER, "background1.png");
        AssetManager.getInstance().addToQueue(AssetManager.BITMAP, "city", Settings.FOLDER, "background2.png");
        AssetManager.getInstance().addToQueue(AssetManager.BITMAP, "sea", Settings.FOLDER, "background3.png");
        AssetManager.getInstance().addToQueue(AssetManager.ATLAS, "BUILDER", Settings.FOLDER, "builder.png", "builder.xml");
        AssetManager.getInstance().addToQueue(AssetManager.FONT, "ATLAS_FONT", Settings.FOLDER, "theFont.png", "theFont.fnt");
        AssetManager.getInstance().loadTheQueue();

        WriteTheFile.getInstance().initTheSlots();

        _core.stage.addEventListener(NavigationEvent.LOADED_EVENT, onLoadedTheAssets, false, 0, true);

    }

    //*************************************************** ASSETS ***************************************************//

    protected function onLoadedTheAssets(evt:NavigationEvent):void
    {
        _core.stage.removeEventListener(NavigationEvent.LOADED_EVENT, onLoadedTheAssets);

        _background = GNodeFactory.createNodeWithComponent(BackgroundScreen) as BackgroundScreen;
        _core.root.addChild(_background.node);

        _core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.BACKGROUND_CHANGE, {id: "main"}, true));
        _core.stage.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeEvent, false, 0, true);
        _core.stage.addEventListener(NavigationEvent.LOADED_EVENT, loadedWorld, false, 0, true);

        initTheGui();

        Settings.SM.playSound("../sounds/MAIN.mp3",0, -1);

    }

    protected static function loadedWorld(evt:NavigationEvent):void {

        trace("loaded");
    }

    //*************************************************** GUI ***************************************************//

    protected function initTheGui():void {


        _screenNavigation = GNodeFactory.createNodeWithComponent(MScreenNavigation, "screenNavigator") as MScreenNavigation;

        _core.root.addChild(_screenNavigation.node);

        _screenNavigation.enqueueScreen("main", new MScreenNavigationItem(MainScreen, ""));
        _screenNavigation.enqueueScreen("setting", new MScreenNavigationItem(SettingScreen, "main"));
        _screenNavigation.enqueueScreen("player", new MScreenNavigationItem(PlayerScreen, "main"));
        _screenNavigation.enqueueScreen("world", new MScreenNavigationItem(WorldScreen, "player"));
        _screenNavigation.enqueueScreen("levelScreen", new MScreenNavigationItem(LevelScreen, "world"));
        //BUILDER
        _screenNavigation.enqueueScreen("builder_menu", new MScreenNavigationItem(BuilderScreen, "main"));
        _screenNavigation.enqueueScreen("builder_levelScreen", new MScreenNavigationItem(BuilderLevelScreen, "builder_menu"));
        _screenNavigation.showScreen("main");

    }

    //*************************************************** GAME EVENTS ***************************************************//

    protected function onChangeEvent(evt:NavigationEvent):void {

        switch (evt.params.id) {

            case "play":
                initTheGame();
                if(!Settings.MUTE) Settings.SM.setVolume(.4, "../sounds/MAIN.mp3");
                break;
            case "replay":
                replayAndLevel();
                break;
            case "next_level":
                replayAndLevel();
                break;
            case "levelScreen":
                backToLevelScreen();
                if(!Settings.MUTE) Settings.SM.setVolume(1, "../sounds/MAIN.mp3");
                break;
            case "builder":
                createTrackBuilder();
                break;
            case "builder_back":
                removeTrackBuilder();
                break;
        }

    }

    internal function initTheGame():void {

        _screenNavigation.node.active = false;
        _background.node.active = false;

        if(Settings.ACTIVITY == 2) _theGame = GNodeFactory.createNodeWithComponent(GrandPrixGame) as GrandPrixGame;
        else _theGame = GNodeFactory.createNodeWithComponent(TheTourGame) as TheTourGame;
        _core.root.addChild(_theGame.node);
    }

    internal function replayAndLevel():void {

        _theGame.dispose();
        _core.root.removeChild(_theGame.node);

        initTheGame();
    }

    internal function backToLevelScreen():void {

        _screenNavigation.node.active = true;
        _background.node.active = true;

        _theGame.dispose();
        _core.root.removeChild(_theGame.node);
    }

    //*************************************************** TRACK BUILDER ***************************************************//

    internal function createTrackBuilder():void {

        //SET TRACK BUILDER ACTIVITY
        Settings.ACTIVITY = 0;

        _trackBuilder = GNodeFactory.createNodeWithComponent(TrackBuilder) as TrackBuilder;
        _trackBuilder.init(Settings.AREA + 1, Settings.SIZE + 1, Settings.SLOT);

        _core.root.addChild(_trackBuilder.node);
        _screenNavigation.node.active = false;

    }

    internal function removeTrackBuilder():void {

        _trackBuilder.dispose();
        _core.root.removeChild(_trackBuilder.node);
        _screenNavigation.node.active = true;
        _core.stage.dispatchEvent(new MEvent(MEvent.FUNCTION, {id: "setTheLabels"}, true));
    }
}
}