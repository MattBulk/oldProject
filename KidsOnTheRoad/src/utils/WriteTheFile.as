/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 7/25/13
 * Time: 11:05 AM
 * To change this template use File | Settings | File Templates.
 */
package utils {

    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.events.IOErrorEvent;
    import flash.filesystem.FileMode;
    import flash.events.ProgressEvent;
    import flash.events.OutputProgressEvent;

    public class WriteTheFile {

        private static var instance:WriteTheFile = new WriteTheFile();
        private var xmlFile:File;
        private var stream:FileStream;

        public var slotXML:XML;

        public var loadedTrack:XML;

        public function WriteTheFile() {

            if ( instance ) throw Error("Library Class is Singleton.");

        }

        public static function getInstance():WriteTheFile {
            return instance;
        }


        //************************************************** INIT THE SLOTS ***********************************************

        public function initTheSlots():void {

            xmlFile = File.documentsDirectory.resolvePath("slots.xml");

            stream = new FileStream();
            stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
            stream.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
            stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete, false, 0, true);

            if(xmlFile.exists) {
                stream.open(xmlFile, FileMode.READ);
                slotXML = new XML(stream.readUTFBytes(stream.bytesAvailable));
            }

            else {

                var xml:XML = <xml>
                    <world>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                    </world>
                    <world>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                    </world>
                    <world>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                        <slot>NEW</slot>
                    </world>
                </xml>;

                stream.openAsync(xmlFile, FileMode.UPDATE);
                stream.writeUTFBytes(xml);

                slotXML = new XML(xml);
            }

            stream.close();
            stream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            stream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete);
        }

        //************************************************** WRITE FILE ***********************************************

        private function onProgress(Event:ProgressEvent):void {
            trace("onProgress");
        }

        private function onProgressComplete(Event:OutputProgressEvent):void {

            trace("onProgressComplete");
        }

        private function onIOError(evt:IOErrorEvent):void
        {
            trace(evt);
        }

        public function writeXML(theFile:String, theString:String):void {

            xmlFile = File.documentsDirectory.resolvePath(theFile);

            stream = new FileStream();
            stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
            stream.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
            stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete, false, 0, true);

            stream.openAsync(xmlFile, FileMode.WRITE);
            stream.writeUTFBytes(theString);

            stream.close();
            stream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            stream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete);

        }

        public function deleteXML(theFile:String):void {

            xmlFile = File.documentsDirectory.resolvePath(theFile);
            xmlFile.deleteFile();
        }

        //************************************************** READ FILE ***********************************************

        public function loadXML(theFile:String):void {

            if(Settings.ACTIVITY == 1) xmlFile = File.documentsDirectory.resolvePath(theFile);
            else xmlFile = File.applicationDirectory.resolvePath(theFile);

            stream = new FileStream();
            stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
            stream.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
            stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete, false, 0, true);

            if(xmlFile.exists) {
                stream.open(xmlFile, FileMode.READ);
                loadedTrack = new XML(stream.readUTFBytes(stream.bytesAvailable));
            }

            stream.close();
            stream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            stream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete);
        }
    }
}
