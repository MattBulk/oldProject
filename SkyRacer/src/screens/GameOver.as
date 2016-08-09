package screens
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.components.renderables.GTextureText;
	import com.genome2d.context.postprocesses.GGlowPP;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.signals.GMouseSignal;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.factories.GTextureFactory;
	import com.greensock.TweenLite;
	
	import events.NavigationEvent;
	
	public class GameOver extends GComponent
	{
		private var replayBtn:GSprite;
		private var homeBtn:GSprite;
		private var offset:Number;
		private var replayBtnTexture:GTexture = Assets.allTexture[0].getTexture("replay_btn");
		private var homeBtnTexture:GTexture = Assets.allTexture[0].getTexture("home_btn");
		private var textDistance:GTextureText;
		private var theScoreText:GTextureText;
		private var theMoneyText:GTextureText;
		
		private var textDistance2:GTextureText;
		private var theScoreText2:GTextureText;
		private var theMoneyText2:GTextureText;
		
		private var shareScore:GTextureText;
		
		private var bgTexture:GTexture; 
		private var background:GSprite;
		private var name:String;
		private var blur:GGlowPP;
		
		public function GameOver(p_node:GNode)
		{
			super(p_node);
			
			offset = node.core.stage.stageWidth * .5;
			bgTexture = GTextureFactory.createFromColor("white", 0xFFFFFF, offset * 1.5, 400);
			
			background = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			background.setTexture(bgTexture);
			background.node.transform.setPosition(offset, node.core.stage.stageHeight * .5 - 100);
			blur = new GGlowPP;
			blur.color = 0xFFFFFF;
			blur.blurX = 20;
			blur.blurY = 20;
			background.node.postProcess = blur;
			background.node.transform.alpha = .5;
			this.node.addChild(background.node);
			
			initTheButton();
		}
		
		public function setTheScore(totDistance:int, totScore:int, totMoney:int):void
		{
			// TODO Auto Generated method stub
			textDistance = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			textDistance.setTextureAtlas(Assets.allTexture[1]);
			textDistance.text = "DISTANCE :"
			textDistance.node.transform.setScale(.6, .6);
			textDistance.node.transform.setPosition(background.node.transform.x - bgTexture.width * .45, background.node.transform.y - 150);
			this.node.addChild(textDistance.node);
			
			theScoreText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			theScoreText.setTextureAtlas(Assets.allTexture[1]);
			theScoreText.text = "SCORE :"
			theScoreText.node.transform.setScale(.6, .6);
			theScoreText.node.transform.setPosition(background.node.transform.x - bgTexture.width * .45, background.node.transform.y - 50);
			this.node.addChild(theScoreText.node);
			
			theMoneyText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			theMoneyText.setTextureAtlas(Assets.allTexture[1]);
			theMoneyText.text = "MONEY :"
			theMoneyText.node.transform.setScale(.6, .6);
			theMoneyText.node.transform.setPosition(background.node.transform.x - bgTexture.width * .45, background.node.transform.y + 50);
			this.node.addChild(theMoneyText.node);
			
			textDistance2 = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			textDistance2.setTextureAtlas(Assets.allTexture[1]);
			textDistance2.text = totDistance.toString();
			textDistance2.align = 1;
			textDistance2.node.transform.setScale(.8, .8);
			textDistance2.node.transform.setPosition(bgTexture.width * 1.1, background.node.transform.y - 160);
			this.node.addChild(textDistance2.node);
			
			theScoreText2 = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			theScoreText2.setTextureAtlas(Assets.allTexture[1]);
			theScoreText2.align = 1;
			theScoreText2.text = totScore.toString();
			theScoreText2.node.transform.setScale(.8, .8);
			theScoreText2.node.transform.setPosition(bgTexture.width * 1.1, background.node.transform.y - 60);
			this.node.addChild(theScoreText2.node);
			
			theMoneyText2 = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			theMoneyText2.setTextureAtlas(Assets.allTexture[1]);
			theMoneyText2.text = totMoney.toString();
			theMoneyText2.align = 1;
			theMoneyText2.node.transform.setScale(.8, .8);
			theMoneyText2.node.transform.setPosition(bgTexture.width * 1.1, background.node.transform.y + 40);
			this.node.addChild(theMoneyText2.node);
			
			SkyRacer.MAIN.saveHighScore(totDistance);

		}
		
		private function initTheButton():void
		{
			
			replayBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			replayBtn.setTexture(replayBtnTexture);
			replayBtn.node.transform.setPosition(offset, node.core.stage.stageHeight - replayBtnTexture.height * 2.3);
			node.addChild(replayBtn.node);
			
			homeBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			homeBtn.setTexture(homeBtnTexture);
			homeBtn.node.transform.setPosition(offset, node.core.stage.stageHeight - homeBtnTexture.height * 1);
			node.addChild(homeBtn.node);
			
			replayBtn.node.mouseEnabled = true;
			replayBtn.node.onMouseClick.add(triggerShop);
			homeBtn.node.mouseEnabled = true;
			homeBtn.node.onMouseClick.add(triggerhomeBtn);
			
		}
		
		private function triggerhomeBtn(signal:GMouseSignal):void
		{
			TweenLite.from(homeBtn.node.transform, .2, {scaleX:1.1, scaleY:1.1});
			TweenLite.delayedCall(.3, fl_TimerHandler);
			SkyRacer.MAIN.SM.playSound("../sounds/BUTTON.mp3");
			name = "home";
		}
		
		private function triggerShop(signal:GMouseSignal):void
		{
			TweenLite.from(replayBtn.node.transform, .2, {scaleX:1.1, scaleY:1.1});
			TweenLite.delayedCall(.3, fl_TimerHandler);
			SkyRacer.MAIN.SM.playSound("../sounds/BUTTON.mp3");
			name = "replay";
		}
		
		protected function fl_TimerHandler():void
		{
			if(name == "home") node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "MAINFROMGAMEOVER"}, true));
			if(name == "replay") node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "REPLAY"}, true));
			
			
			bgTexture.dispose();
			this.node.disposeChildren();
			this.node.dispose();
		}
	}
}