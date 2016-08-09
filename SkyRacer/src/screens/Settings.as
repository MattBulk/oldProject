package screens
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.components.renderables.GTextureText;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.signals.GMouseSignal;
	import com.genome2d.textures.GTexture;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import flash.net.*;
	
	import events.NavigationEvent;
	
	public class Settings extends GComponent
	{
		private var soundBtn:GSprite;
		private var backBtn:GSprite;
		private var twBtn:GSprite;
		private var fbBtn:GSprite;
		private var offset:Number;
		private var soundOnBtnTexture:GTexture = Assets.allTexture[0].getTexture("sound_on");
		private var soundOffBtnTexture:GTexture = Assets.allTexture[0].getTexture("sound_off");
		private var backBtnTexture:GTexture = Assets.allTexture[0].getTexture("back_btn");
		private var twitterTexture:GTexture = Assets.allTexture[0].getTexture("twitter");
		private var facebookTexture:GTexture = Assets.allTexture[0].getTexture("facebook");
		private var bestScore:GTextureText;
		
		private var timeLine:TimelineLite;
		
		public function Settings(p_node:GNode)
		{
			super(p_node);
			
			var label:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			label.setTextureAtlas(Assets.allTexture[1]);
			label.text = "SETTINGS";
			label.node.transform.setPosition(node.core.stage.stageWidth/2 - label.width/2, 80);
			node.addChild(label.node);
			
			bestScore = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			bestScore.setTextureAtlas(Assets.allTexture[1]);
			bestScore.text = "";
			bestScore.node.transform.setScale(.5,.5);
			node.addChild(bestScore.node);
			
			initTheButton();
			
		}
		
		private function initTheButton():void
		{
			offset = node.core.stage.stageWidth * .5
			
			soundBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			soundBtn.setTexture(soundOnBtnTexture);
			soundBtn.node.transform.setPosition(offset, node.core.stage.stageWidth);
			node.addChild(soundBtn.node);
			
			backBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			backBtn.setTexture(backBtnTexture);
			backBtn.node.transform.setPosition(offset, node.core.stage.stageWidth);
			node.addChild(backBtn.node);
			
			twBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			twBtn.setTexture(twitterTexture);
			twBtn.node.transform.setPosition(offset * .5, 320);
			node.addChild(twBtn.node);
			twBtn.node.mouseEnabled = true;
			twBtn.node.onMouseClick.add(twitterLaunch);
			
			fbBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			fbBtn.setTexture(facebookTexture);
			fbBtn.node.transform.setPosition(offset * 1.5, 320);
			node.addChild(fbBtn.node);
			fbBtn.node.mouseEnabled = true;
			fbBtn.node.onMouseClick.add(facebookLaunch);
			
			if(!SkyRacer.MAIN.SkySO.data.score) SkyRacer.MAIN.SkySO.data.score = 0;
			else {
				bestScore.text = "BEST DISTANCE : " + SkyRacer.MAIN.SkySO.data.score.toString() + " M";
				bestScore.node.transform.setPosition(node.core.stage.stageWidth/2 - bestScore.width/2, 200);
			}
			
		}
		
		public function tweenTheButton():void {
			
			timeLine = new TimelineLite();
			timeLine.append( new TweenLite(soundBtn.node.transform, 1, {y:node.core.stage.stageHeight - soundOnBtnTexture.height * 2, ease:Circ.easeIn}) );
			timeLine.append( new TweenLite(backBtn.node.transform, 1, {y:node.core.stage.stageHeight - backBtnTexture.height * 1, ease:Circ.easeIn}) , -.5 );
			
			soundBtn.node.mouseEnabled = true;
			soundBtn.node.onMouseClick.add(triggerSound);
			backBtn.node.mouseEnabled = true;
			backBtn.node.onMouseClick.add(triggerbackBtn);
			
		}
		
		private function twitterLaunch(signal:GMouseSignal):void
		{
			SkyRacer.MAIN.SM.playSound("../sounds/BUTTON.mp3");
			navigateToURL(new URLRequest("http://www.twitter.com/WrongGames"));
		}
		
		private function facebookLaunch(signal:GMouseSignal):void
		{
			SkyRacer.MAIN.SM.playSound("../sounds/BUTTON.mp3");
			navigateToURL(new URLRequest("http://www.facebook.com/WrongGames"));
		}
		
		private function triggerbackBtn(signal:GMouseSignal):void
		{
			SkyRacer.MAIN.SM.playSound("../sounds/BUTTON.mp3");
			TweenLite.from(backBtn.node.transform, .2, {scaleX:1.1, scaleY:1.1});
			TweenLite.delayedCall(.3, fl_TimerHandler);
		}
		
		private function triggerSound(signal:GMouseSignal):void
		{
			if(SkyRacer.MAIN.MUTE) { SkyRacer.MAIN.MUTE = false; SkyRacer.MAIN.SM.playSound("../sounds/MAIN.mp3", 0, -1);}
			else { SkyRacer.MAIN.MUTE = true; SkyRacer.MAIN.SM.stopSound("../sounds/MAIN.mp3");}
			SkyRacer.MAIN.SM.playSound("../sounds/BUTTON.mp3");
			TweenLite.from(soundBtn.node.transform, .2, {scaleX:1.1, scaleY:1.1});
			TweenLite.delayedCall(.3, fl_SetSound);
		}
		
		private function fl_SetSound():void
		{
			
			if(SkyRacer.MAIN.MUTE) soundBtn.setTexture(soundOffBtnTexture);
			else soundBtn.setTexture(soundOnBtnTexture);
		}
		
		protected function fl_TimerHandler():void
		{
			node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "MAINFROMSETTINGS"}, true));
		}
		
	}
}