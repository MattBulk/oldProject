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
	
	import events.NavigationEvent;
	
	public class CarMenu extends GComponent
	{
		private var shopBtn:GSprite;
		private var backBtn:GSprite;
		private var offset:Number;
		private var shopBtnTexture:GTexture = Assets.allTexture[0].getTexture("shop_btn");
		private var backBtnTexture:GTexture = Assets.allTexture[0].getTexture("back_btn");

		private var name:String;
		
		private var timeLine:TimelineLite;
		
		public function CarMenu(p_node:GNode)
		{
			super(p_node);
			
			initTheButton();
			
			var label:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			label.setTextureAtlas(Assets.allTexture[1]);
			label.text = "CHOOSE YOUR CAR";
			label.node.transform.setPosition(node.core.stage.stageWidth/2 - label.width/2, 50);
			node.addChild(label.node);
			
		}
		
		private function initTheButton():void
		{
			offset = node.core.stage.stageWidth * .5
			
			shopBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			shopBtn.setTexture(shopBtnTexture);
			shopBtn.node.transform.setPosition(offset, node.core.stage.stageWidth);
			node.addChild(shopBtn.node);
			
			backBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			backBtn.setTexture(backBtnTexture);
			backBtn.node.transform.setPosition(offset, node.core.stage.stageWidth);
			node.addChild(backBtn.node);
			
		}
		
		public function tweenTheButton():void {
			
			timeLine = new TimelineLite();
			timeLine.append( new TweenLite(shopBtn.node.transform, 1, {y:node.core.stage.stageHeight - shopBtnTexture.height * 2, ease:Circ.easeIn}) );
			timeLine.append( new TweenLite(backBtn.node.transform, 1, {y:node.core.stage.stageHeight - backBtnTexture.height * 1, ease:Circ.easeIn}) , -.5 );
			
			shopBtn.node.mouseEnabled = true;
			shopBtn.node.onMouseClick.add(triggerShop);
			backBtn.node.mouseEnabled = true;
			backBtn.node.onMouseClick.add(triggerbackBtn);
			
		}
		
		private function triggerbackBtn(signal:GMouseSignal):void
		{
			name = "back";
			
			TweenLite.from(backBtn.node.transform, .2, {scaleX:1.1, scaleY:1.1});
			TweenLite.delayedCall(.3, fl_TimerHandler);
		}
		
		private function triggerShop(signal:GMouseSignal):void
		{
			name = "play";
			
			TweenLite.from(shopBtn.node.transform, .2, {scaleX:1.1, scaleY:1.1});
			TweenLite.delayedCall(.3, fl_TimerHandler);
		}
		
		protected function fl_TimerHandler():void
		{
			if(name == "back") node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "MAINFROMCARMENU"}, true));
			if(name == "play") node.core.stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "PLAY"}, true));
		}
		
	}
}