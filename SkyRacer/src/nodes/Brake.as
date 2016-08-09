package nodes
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.core.Genome2D;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureAlignType;
	import com.genome2d.textures.factories.GTextureFactory;
	
	public class Brake extends GComponent
	{
		private var brakeTexture:GTexture = Assets.allTexture[0].getTexture("brake_btn");
		private var brakeBtn:GSprite;
		
		public var bgTexture:GTexture; 
		private var brakeBar:GSprite;
		
		public function Brake(p_node:GNode)
		{
			super(p_node);

			init();
		}
		
		private function init():void
		{
			// TODO Auto Generated method stub
			brakeBtn = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			brakeBtn.setTexture(brakeTexture);
			brakeTexture.alignTexture(GTextureAlignType.TOP_LEFT);
			brakeBtn.node.transform.setPosition(brakeTexture.width >> 1, - brakeTexture.height);
			this.node.addChild(brakeBtn.node);
			
			brakeBtn.node.mouseEnabled = true;
			
			bgTexture = GTextureFactory.createFromColor("whiteBrake", 0xFFFFFF, Genome2D.getInstance().stage.stageWidth * .96, brakeTexture.height);
			
			brakeBar = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			brakeBar.setTexture(bgTexture);
			bgTexture.alignTexture(GTextureAlignType.TOP_LEFT);
			brakeBar.node.transform.setPosition(brakeTexture.width >> 1, - brakeTexture.height);
			brakeBar.node.transform.alpha = .2;
			this.node.addChild(brakeBar.node);
			
			this.node.putChildToBack(brakeBar.node);
			
			brakeBar.node.mouseEnabled = true;
		}

	}
}