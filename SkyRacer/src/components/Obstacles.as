package components
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureAlignType;
	
	public class Obstacles extends GComponent
	{
		private var _obstacleType:int;
		private var itemImage:GTexture;
		public var container:GSprite;
		
		public function Obstacles(p_node:GNode)
		{
			super(p_node);
		}
		
		public function init(obstacleType:int):void {
			
			_obstacleType = obstacleType;
			itemImage = Assets.allTexture[0].getTexture("obstacle_" + _obstacleType);
			itemImage.alignTexture(GTextureAlignType.CENTER);
			container = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			container.setTexture(itemImage);
			
			this.node.addChild(container.node);
		}
		
		public function get obstacleType():int
		{
			return _obstacleType;
		}
		
		
		public function disposeMe():void {
			
			container.dispose();
			this.node.active = false;
			
		}
		
	}
}