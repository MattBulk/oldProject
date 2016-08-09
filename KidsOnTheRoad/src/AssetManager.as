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
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import events.NavigationEvent;

    public class AssetManager {


        private static var instance:AssetManager = new AssetManager();

        public static var allTexture:Vector.<GTextureAtlas> = new Vector.<GTextureAtlas>();
        public static var bitmapTexture:Vector.<GTexture> = new Vector.<GTexture>();
        public static var textures:GTextureAtlas;
        //TYPES
        public static const ATLAS:uint = 1;
        public static const FONT:uint = 2;
        public static const BITMAP:uint = 3;
        //OTHER
        private var _mainPath:String = "assets/";
        private var _assets:Vector.<Object> = new Vector.<Object>();
        private var _nextToLoad:uint = 0;
        private var _pathToLoad:String = "";
        //XML
        private var _xml_data:XML;
        private var _xmlLoaded:URLLoader;
        //TEXTURE
        private var _bitmapTexture:GTexture;
        private var _textureLoader:Loader;
        private var _loadedBitmap:Bitmap;


        public function AssetManager()
        {
            if ( instance ) throw Error("Library Class is Singleton.");
        }

        public static function getInstance():AssetManager {
            return instance;
        }

        //************************************************** SETTER AND GETTER METHODS ***********************************************

        public function set assetPath(mainPath:String):void {

             mainPath = mainPath;
        }

        public function get assetPath():String {

            return _mainPath;
        }

        //************************************************** ADD TO QUEUE ***********************************************

        public function addToQueue(type:uint, id:String, folder:String, path:String, xml:String = "null"):void {

            var obj:Object = new Object();

            obj.type = type;
            obj.id = id;
            obj.folder = folder + "/";
            obj.path = path;
            obj.xml = xml;

            _assets.push(obj);

        }

        //************************************************** LOAD THE QUEUE ***********************************************

        public function loadTheQueue():void {

            if(_assets[_nextToLoad].xml != "null") loadTheXML();

            else loadTheTexture();

        }

        private function loadTheXML():void {

            _pathToLoad = _mainPath + _assets[_nextToLoad].folder + _assets[_nextToLoad].xml;

            var xmlURL:URLRequest = new URLRequest(_pathToLoad);

            _xmlLoaded = new URLLoader(xmlURL);

            _xmlLoaded.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
            _xmlLoaded.addEventListener(Event.COMPLETE, loadTheAssets, false, 0, true);
        }

        private function loadTheAssets(evt:Event):void {

            _xml_data = XML(evt.target.data);

            _xmlLoaded.close();
            _xmlLoaded.removeEventListener(Event.COMPLETE, loadTheAssets);
            _xmlLoaded.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);

            loadTheTexture();

        }

        private function loadTheTexture():void {

            _pathToLoad = _mainPath + _assets[_nextToLoad].folder + _assets[_nextToLoad].path;

            _textureLoader = new Loader();

            _textureLoader.load(new URLRequest(_pathToLoad));
            _textureLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
            _textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
        }

        private function onComplete(evt:Event):void
        {
            _loadedBitmap = evt.currentTarget.loader.content as Bitmap;

            switch (_assets[_nextToLoad].type) {

                case 1 :
                    textures = GTextureAtlasFactory.createFromBitmapDataAndXML(_assets[_nextToLoad].id, (_loadedBitmap).bitmapData, _xml_data);
                    allTexture.push(textures);
                    break;
                case 2 :
                    textures = GTextureAtlasFactory.createFromBitmapDataAndFontXML(_assets[_nextToLoad].id, (_loadedBitmap).bitmapData, _xml_data);
                    allTexture.push(textures);
                    break;
                case 3 :
                    _bitmapTexture = GTextureFactory.createFromBitmapData(_assets[_nextToLoad].id, (_loadedBitmap).bitmapData);
                    bitmapTexture.push(_bitmapTexture);
                    break;
            }

            _nextToLoad++;

            _loadedBitmap.bitmapData.dispose();
            _loadedBitmap = null;

            if (_nextToLoad == _assets.length) {

                Genome2D.getInstance().stage.dispatchEvent(new NavigationEvent(NavigationEvent.LOADED_EVENT, {id: "LOADED"}, true));
                _assets.splice(0, _assets.length);
                _nextToLoad = 0;

            }

            else {

                _textureLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
                _textureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
                loadTheQueue();
            }

        }

        private static function onIOError(e:IOErrorEvent):void { trace("ERROR.ID : " + e.errorID) }

        //************************************************** DISPOSE THE ASSETS ***********************************************

        public static function disposeAtlasTexture(id:String):void {

            for (var i:uint =0; i <= allTexture.length-1; i++) {

                if(allTexture[i].id == id) {
                    allTexture[i].dispose();
                    allTexture.splice(i,1);
                }
            }
        }

        public static function disposeBitmapTexture(id:String):void {

            for (var i:uint =0; i <= bitmapTexture.length-1; i++) {

                if(bitmapTexture[i].id == id) {
                    bitmapTexture[i].dispose();
                    bitmapTexture.splice(i,1);
                }
            }
        }

	}
}