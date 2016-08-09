package nodes
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.textures.GTexture;
	
	import flash.geom.Point;
		
	public class Cloud extends GComponent
	{
		private var cloud:GSprite;
		private var dxCloud:Number;
		private var dyCloud:Number;
		
		public function Cloud(p_node:GNode)
		{
			super(p_node);
		}
		
		public function init(cloudPoint:Point, texture:GTexture):void {
			
			var num:int = 5;
			// TODO Auto Generated method stub
			for (var X:int=0; X< cloudPoint.x; X++) {
				
				dxCloud = Math.cos(Math.PI * 9 / 180) * num;
				dyCloud = Math.sin(Math.PI * 9 / 180) * num;
				
				for (var Y:int=0; Y< cloudPoint.y; Y++) {
					
					cloud = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
					cloud.setTexture(texture);
					cloud.blendMode = 4;
					cloud.node.transform.rotation = Math.random();
					cloud.node.transform.setScale(.7, .7);
					cloud.node.transform.x = (X + 10 * Math.random()) + dxCloud;
					cloud.node.transform.y = (Y * 25 + 10 * Math.random()) + dyCloud;
					this.node.addChild(cloud.node);
					
					num += 5;
				}
			}
		}
		
		public function disposeMe():void {
			
			this.node.disposeChildren();
			this.node.active = false;
			
		}
	}
}