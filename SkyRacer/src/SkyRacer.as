package
{
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.core.GConfig;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.core.Genome2D;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.factories.GTextureFactory;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import events.NavigationEvent;
	
	import screens.CarMenu;
	import screens.InGame;
	import screens.MenuScreen;
	import screens.Settings;
	
	import flash.net.SharedObject;
	
	public class SkyRacer extends Sprite
	{
		private var core:Genome2D;
		private var config:GConfig;
		private var inGame:InGame;
		private var menuScreen:MenuScreen;
		private var carMenu:CarMenu;
		private var settings:Settings;
		private var viewPortRectangle:Rectangle;
		private var blackRect:GSprite; 
		private var texture:GTexture;
		private var fl_TimerInstance:Timer;
		
		public static var MAIN:Object;
		public var MUTE:Boolean;
		public var SM:SoundEngine = SoundEngine.getInstance();
		public var SkySO:SharedObject;
		
		public var mobclix:MobclixInterface;
		private var displayingAd:Boolean;
		private var inited:Boolean = false;
		
		public function SkyRacer()
		{
			super();
			
			MAIN = this;
			
			SkySO = SharedObject.getLocal("SkyRacer");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.frameRate = 60;
			
			viewPortRectangle = new Rectangle();
			viewPortRectangle.width = 960;
			viewPortRectangle.height = 640;
			
			stage.addEventListener(Event.RESIZE, resizeStage, false, 0, true);
			
			
			core = Genome2D.getInstance();
			core.onInitialized.addOnce(onGenome2DInitialized);
			// Initialize Genome2D config, we need to specify area where Genome2D will be rendered
			// if we want the whole stage simply put the stage size there
			config = new GConfig(new Rectangle(0,0,viewPortRectangle.width, viewPortRectangle.height), "baseline");
			config.backgroundColor = 0x33CCFF;
			config.enableStats = false;
			config.antiAliasing = 0;
			// Initiaiize Genome2D
			Genome2D.getInstance().init(stage, config);
		}
		
		protected function resizeStage(event:Event):void
		{
			viewPortRectangle.width = stage.stageWidth;
			viewPortRectangle.height = stage.stageHeight;
			config.viewRect.width = viewPortRectangle.width;
			config.viewRect.height = viewPortRectangle.height;
		}
		
		protected function onGenome2DInitialized():void {
			
			Assets.getInstance().initTheLoader(0);
			
			core.stage.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			core.stage.addEventListener(events.NavigationEvent.CHANGE_STATE, onloadTheAssets);
			//preinit();
		}
		
		protected function onloadTheAssets(evt:NavigationEvent):void
		{
			init();
		}
		
		protected function mobclixEventFunction(event:MobclixEvent):void
		{
			
			trace("mobclixEventFunction:" + event.mobclixEvent);
			
			switch(event.mobclixEvent)
			{
				case MobclixInterface.EVENT_ADFINISHEDLOADING:
				{
					trace("loaded")
					break;
				}
				case MobclixInterface.EVENT_FAILEDTOLOAD:
				{
					trace("error")
					break;
				}
				case MobclixInterface.EVENT_FINISHEDTOUCHTHROUGH:
				{
					trace(MobclixInterface.EVENT_FINISHEDTOUCHTHROUGH);
					displayingAd = false;
					break;
				}
				case MobclixInterface.EVENT_WILLTOUCHTRHOUGH:
				{
					trace(MobclixInterface.EVENT_WILLTOUCHTRHOUGH);
					displayingAd = true;
					break;
				}
			}
		}
		
		protected function preinit():void
		{
			
			if (inited == false){
				
				inited = true; 
				// NOTE
				// Add mobclix to stage when Event.ADDED_TO_STAGE is called.  
				// Adding mobclix to the stage before hand can cause display issues.  
				//
				mobclix = new MobclixInterface();
				mobclix.addEventListener(MobclixEvent.UPDATE, mobclixEventFunction);
				// IOS ONLY!!
				// Replace the IS string with your application ID
				// Android will ignore this function.  
				//mobclix.initMobclixWithID("c311d813-4eda-4443-8a0b-28085310b466");
				mobclix.addMobclixToStage(MobclixInterface.AD_IPHONE320x50,0,0);
				// IOS ONLY!!
				// Android will ignore this function.  The ad is added to stage via the android manifest xml
				mobclix.getAd();
			}
		}
		
		public function saveHighScore( highScore:uint ):void
		{
			if(highScore > SkySO.data.score) {
				SkySO.data.score = highScore;
				SkySO.flush();
			}
		}
		
		private function closeMe(evt:Event):void
		{
			if(MUTE == false) SM.stopSound("../sounds/MAIN.mp3");
			this.addEventListener(Event.ACTIVATE, soundUP, false, 0, true);
		}
		
		private function soundUP(evt:Event):void {
			
			if(MUTE == false) SM.playSound("../sounds/MAIN.mp3", 0, -1);
			
			this.removeEventListener(Event.ACTIVATE, soundUP);
		}
		
		protected function init():void {
			
			menuScreen = GNodeFactory.createNodeWithComponent(MenuScreen) as MenuScreen;
			menuScreen.node.transform.setPosition(0,0);
			core.root.addChild(menuScreen.node);
			
			carMenu = GNodeFactory.createNodeWithComponent(CarMenu) as CarMenu;
			carMenu.node.transform.setPosition(0,0);
			core.root.addChild(carMenu.node);
			carMenu.node.active = false;
			
			settings = GNodeFactory.createNodeWithComponent(Settings) as Settings;
			settings.node.transform.setPosition(0,0);
			core.root.addChild(settings.node);
			settings.node.active = false;
			
			texture = GTextureFactory.createFromColor("black", 0x000000, config.viewRect.width, config.viewRect.height);
			
			SM.playSound("../sounds/MAIN.mp3",0,-1);
			
			this.addEventListener(Event.DEACTIVATE, closeMe, false, 0, true);
		}
		
		protected function onChangeScreen(evt:NavigationEvent):void
		{
			createTransition();
			
			switch (evt.params.id)
			{
				case "GOTOCARMENU":
					menuScreen.node.active = false;
					carMenu.node.active = true;
					carMenu.tweenTheButton();
					break;
				case "GOTOSETTINGS":
					menuScreen.node.active = false;
					settings.node.active = true;
					settings.tweenTheButton();
					break;
				case "PLAY":
					playTheGame();
					break;
				case "REPLAY":
					inGame.backToMain();
					inGame.node.disposeChildren();
					core.root.removeComponent(InGame) as InGame;
					playTheGame();
					break;
				case "MAINFROMCARMENU":
					menuScreen.node.active = true;
					carMenu.node.active = false;
					break;
				case "MAINFROMSETTINGS":
					menuScreen.node.active = true;
					settings.node.active = false;
					break;

				case "MAINFROMGAMEOVER":
					SkyRacer.MAIN.SM.setVolume(1, "../sounds/MAIN.mp3");
					menuScreen.node.active = true;
					inGame.backToMain();
					inGame.node.disposeChildren();
					core.root.removeComponent(InGame) as InGame;
					break;
			}
		}
		
		private function playTheGame():void {
			
			fl_TimerInstance = new Timer(500, 4);
			fl_TimerInstance.addEventListener(TimerEvent.TIMER_COMPLETE, initTheGame, false, 0, true);
			fl_TimerInstance.start();
			//carMenu.node.active = false;
			menuScreen.node.active = false;
		}
		
		private function createTransition():void {
			
			blackRect = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			blackRect.setTexture(texture);
			blackRect.node.transform.setPosition(config.viewRect.width * .5, config.viewRect.height * .5);
			core.root.addChild(blackRect.node);
			TweenLite.to(blackRect.node.transform, 2, {alpha:0, onComplete:blackRect.dispose});
			
		}
		
		
		protected function initTheGame(evt:TimerEvent):void {
			
			inGame = GNodeFactory.createNodeWithComponent(InGame) as InGame;
			inGame.node.transform.setPosition(0,0);
			core.root.addChild(inGame.node);
			
			fl_TimerInstance.stop();
			fl_TimerInstance.removeEventListener(TimerEvent.TIMER_COMPLETE, initTheGame);
		}
	}
}