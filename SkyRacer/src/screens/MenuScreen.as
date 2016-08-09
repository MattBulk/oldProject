package screens
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.signals.GMouseSignal;
	import com.genome2d.textures.GTexture;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import flash.desktop.NativeApplication;
	
	import events.NavigationEvent;
	
	import nodes.Welcome;

	public class MenuScreen extends GComponent
	{
		private var welcome:Welcome;
		private var play:GSprite;
		private var exit:GSprite;
		private var settings:GSprite;
		private var offset:Number;
		private var playTexture:GTexture = Assets.allTexture[0].getTexture("play_btn");
		private var settingsTexture:GTexture = Assets.allTexture[0].getTexture("set_btn");
		private var exitTexture:GTexture = Assets.allTexture[0].getTexture("exit_btn");
		private var name:String;
		
		private var timeLine:TimelineLite;
		
		public function MenuScreen(p_node:GNode)
		{
			super(p_node);
			
			initTheWelcome();
			initTheButton();
		}
		
		private function initTheWelcome():void
		{
			offset = node.core.stage.stageWidth * .5 - (25 * 35) * .5;
			
			welcome = GNodeFactory.createNodeWithComponent(Welcome) as Welcome;
			welcome.node.transform.setPosition(offset, 90);
			this.node.addChild(welcome.node);
			
		}
		
		private function initTheButton():void
		{
			offset = node.core.stage.stageWidth * .5
			
			play = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			play.setTexture(playTexture);
			play.node.transform.setPosition(offset, node.core.stage.stageWidth);
			node.addChild(play.node);
			
			settings = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			settings.setTexture(settingsTexture);
			settings.node.transform.setPosition(offset, node.core.stage.stageWidth);
			node.addChild(settings.node);
			
			exit = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			exit.setTexture(exitTexture);
			exit.node.transform.setPosition(150, node.core.stage.stageHeight - settingsTexture.height);
			node.addChild(exit.node);
			
			timeLine = new TimelineLite();
			timeLine.append( new TweenLite(play.node.transform, 1, {y:node.core.stage.stageHeight - playTexture.height * 2, ease:Circ.easeIn}) );
			timeLine.append( new TweenLite(settings.node.transform, 1, {y:node.core.stage.stageHeight - settingsTexture.height, ease:Circ.easeIn}) , -.5 );
			
			play.node.mouseEnabled = true;
			play.node.onMouseClick.add(triggerPlay);
			settings.node.mouseEnabled = true;
			settings.node.onMouseClick.add(triggerSettings);
			
			exit.node.mouseEnabled = true;
			exit.node.onMouseClick.add(triggerExit);

		}
		
		private function triggerExit(signal:GMouseSignal):void
		{
			name = "exit";
			SkyRacer.MAIN.SM.playSound("../sounds/BUTTON.mp3");
			TweenLite.from(exit.node.transform, .2, {scaleX:1.1, scaleY:1.1});
			TweenLite.delayedCall(.3, fl_TimerHandler);
		}
		
		private function triggerSettings(signal:GMouseSignal):void
		{
			name = "settings";
			SkyRacer.MAIN.SM.playSound("../sounds/BUTTON.mp3");
			TweenLite.from(settings.node.transform, .2, {scaleX:1.1, scaleY:1.1});
			TweenLite.delayedCall(.3, fl_TimerHandler);
		}
		
		protected function fl_TimerHandler():void
		{
			if(name == "settings") node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "GOTOSETTINGS"}, true));
			if(name == "play") node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "PLAY"}, true));
			if(name == "exit") NativeApplication.nativeApplication.exit(0);
		}
		
		private function triggerPlay(signal:GMouseSignal):void
		{
			name = "play";
			SkyRacer.MAIN.SM.playSound("../sounds/BUTTON.mp3");
			TweenLite.from(play.node.transform, .2, {scaleX:1.1, scaleY:1.1});
			TweenLite.delayedCall(.3, fl_TimerHandler);
		}
	
	}
}