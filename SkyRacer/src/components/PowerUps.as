package components
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureAlignType;
	
	public class PowerUps extends GComponent
	{
		private var _powerUpType:int;
		private var itemImage:GTexture;
		private var container:GSprite;
		
		public function PowerUps(p_node:GNode)
		{
			super(p_node);
		}
		
		public function init(powerUpType:int):void {
			
			_powerUpType = powerUpType;
			itemImage = Assets.allTexture[0].getTexture("item_" + _powerUpType);
			itemImage.alignTexture(GTextureAlignType.CENTER);
			container = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			container.setTexture(itemImage);
			
			this.node.addChild(container.node);
		}
		
		override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void {
			
			super.update(p_deltaTime, p_parentTransformUpdate, p_parentColorUpdate);
			
			if(_powerUpType == 10) return;
			else container.node.transform.rotation += .03;
			
		}
		
		public function get powerUpType():int
		{
			return _powerUpType;
		}
		
		
		public function disposeMe():void {
			
			container.dispose();
			this.node.active = false;
			
		}
		
	}
}