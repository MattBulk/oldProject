package
{
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureAtlas;
	import com.genome2d.textures.factories.GTextureAtlasFactory;
	import com.genome2d.textures.factories.GTextureFactory;
	import com.genome2d.core.Genome2D;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import events.NavigationEvent;
	
	public class Assets {
		
		[Embed(source="assets/textures/SkyRaceAtlas.xml", mimeType="application/octet-stream")] private static var atlasXML:Class;
		[Embed(source="assets/textures/skyTile.png")] private static var SKYTILE:Class;
		[Embed(source="assets/fonts/theFont.fnt", mimeType="application/octet-stream")] public static const FontXML:Class;
		
		private static var instance:Assets = new Assets();
		public static var allTexture:Vector.<GTextureAtlas> = new Vector.<GTextureAtlas>();
		
		public static var textures:GTextureAtlas;
		public static var tileTexture:GTexture;
		public static var fontTexture:GTextureAtlas;
		
		private var assets:Array = ["assets/textures/SkyRaceAtlas.png","assets/fonts/theFont.png"];
		private var textureLoader:Loader;
		private var loadedBitmap:Bitmap;
		private var loadCount:int = 0;
		private var nextToLoad:int = 0;
		
		
		public function Assets() 
		{
			if ( instance ) throw Error("Library Class is Singleton.");
		}
		
		public static function getInstance():Assets {
			return instance;
		}
		
		public function initTheLoader(loadCount):void {
			
			textureLoader = new Loader();
			textureLoader.load(new URLRequest(assets[loadCount]));
			textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
		}
		
		private function onComplete(evt:Event):void
		{
			loadedBitmap = evt.currentTarget.loader.content as Bitmap;
			//loadedBitmap.bitmapData.dispose();
			//loadedBitmap = null;
			if(loadCount == 1) textures = GTextureAtlasFactory.createFromBitmapDataAndFontXML( "font", (loadedBitmap).bitmapData, XML(new FontXML));
			
			else textures = GTextureAtlasFactory.createFromBitmapDataAndXML("textures" + loadCount.toString(), (loadedBitmap).bitmapData, XML(new atlasXML));
			allTexture.push(textures);
			loadCount++;
			
			if (loadCount == assets.length) {
				
				tileTexture = GTextureFactory.createFromAsset("skyTile2", SKYTILE);
				Genome2D.getInstance().stage.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_STATE, {id: "LOADED"}, true));
				
			}
			else {
				nextToLoad++;
				initTheLoader(nextToLoad);
			}
		
		}
	}
}