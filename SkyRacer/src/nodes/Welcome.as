package nodes
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.textures.GTexture;
	
	import flash.utils.ByteArray;
	
	public class Welcome extends GComponent
	{
		[Embed(source="/assets/mainTitle.xml", mimeType="application/octet-stream")] public static var tileXML:Class;
		
		private var xmldata:XML;
		private var tileTexture:GTexture = Assets.allTexture[0].getTexture("cloud_tile");
		private var theTile:GSprite;
		
		
		public function Welcome(p_node:GNode)
		{
			super(p_node);

			var ba:ByteArray = (new tileXML) as ByteArray;
			var s:String = ba.readUTFBytes( ba.length );
			xmldata = new XML(s);
			
			tileTexture.alignTexture(2);
			onAddedToStage();
			
		}
		
		private function onAddedToStage():void
		{
			for (var i:int=0; i<xmldata.levels.tile.length(); i++) {

				theTile = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
				theTile.setTexture(tileTexture);
				theTile.blendMode = 4;
				theTile.node.transform.setScale(.6,.6);
				theTile.node.transform.setPosition(xmldata.levels.tile[i].xp, xmldata.levels.tile[i].yp);
				node.addChild(theTile.node);
			}
		}
	}
}