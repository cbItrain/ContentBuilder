package uk.co.itrainconsulting.common.utils {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.utils.Dictionary;
    
    import mx.controls.Image;
    
    import uk.co.itrainconsulting.common.events.ImageRepositoryEvent;
    import uk.co.itrainconsulting.common.utils.loader.ImageLoader;

    public class ImageRepository extends EventDispatcher {
        [Bindable]
        [Embed(source="assets/basicBlackPreloader.swf")]
        public static var loaderSpinner:Class;

        public static var CACHE_SIZE:int=30;

        private static var _repository:Dictionary=new Dictionary();
        private static var _loadQueue:Vector.<String>=new Vector.<String>();
        private static var _loadHistory:Vector.<String>=new Vector.<String>();

        private static var _imageRIList:Vector.<ImageRepositoryItem>=new Vector.<ImageRepositoryItem>();

        private var _current:String;
        private var _loader:ImageLoader;

        private static var _instance:ImageRepository;

        public function ImageRepository() {
            _loader=new ImageLoader();
            _loader.addEventListener(Event.COMPLETE, onLoadComplete);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        }

        public function clearCache(listOfURLs:Array, destroy:Boolean=false):void {
            for each (var s:String in listOfURLs) {
                if (s) {
                    if (destroy) {
                        var bd:BitmapData=_repository[s];
                        bd.dispose();
                    }
                    _repository[s]=null;
                }
                var index:int=_loadHistory.indexOf(s);
                if (index > -1)
                    _loadHistory.splice(index, 1);
            }
            var ire:ImageRepositoryEvent=new ImageRepositoryEvent(ImageRepositoryEvent.CACHE_CLEARED);
            ire.data=listOfURLs;
            dispatchEvent(ire);
        }

        public function cacheLimitReached():Boolean {
            return CACHE_SIZE <= _loadHistory.length;
        }

        public static function getInstance():ImageRepository {
            if (!_instance)
                _instance=new ImageRepository();
            return _instance;
        }

        private function updateCache(url:String):void {
            _loadHistory.push(url);
            //Clear cache if necessary
            if (_loadHistory.length > CACHE_SIZE) { //clear cache
                var removed:String=_loadHistory.shift();
                var bd:BitmapData=_repository[removed] as BitmapData;
                if (bd) {
                    _repository[removed]=null;
                }
            }
        }

        public function imageData(url:String, important:Boolean=true, image:Image=null):BitmapData {
            var result:BitmapData=_repository[url] as BitmapData;
            if (image)
                cleanImageList(image, important);
            if (!result) {
                updateLists(url, image);
                if (_current != url) {
                    if (important)
                        _loadQueue.unshift(url);
                    else
                        _loadQueue.push(url);
                }
                loadQueue();
            }
            return result;
        }

        private function updateLists(url:String, image:Image):void {
            cleanRepository(url);
            if (image) {
                _imageRIList.push(new ImageRepositoryItem(url, image));
            }
        }

        private function cleanImageList(image:Image, important:Boolean):void {
            if (_imageRIList.length) {
                var i:int;
                var removedItem:ImageRepositoryItem;
                var removed:Boolean=false
                if (important) {
                    for (i=_imageRIList.length - 1; i >= 0; i--) {
                        removedItem=_imageRIList[i];
                        if (removedItem.image == image) {
                            _imageRIList.splice(i, 1);
                            removed=true;
                            break;
                        }
                    }
                } else {
                    for (i=0; i < _imageRIList.length; i++) {
                        removedItem=_imageRIList[i];
                        if (removedItem.image == image) {
                            _imageRIList.splice(i, 1);
                            removed=true;
                            break;
                        }
                    }
                }
                if (removed && _current != removedItem.url) {
                    cleanRepository(removedItem.url);
                }
            }
        }

        private function cleanRepository(url:String):void {
            var index:int=_loadQueue.indexOf(url);
            if (index > -1)
                _loadQueue.splice(index, 1);
        }

        private function checkImageQueue():void {
            if (_imageRIList.length) {
                for each (var iri:ImageRepositoryItem in _imageRIList) {
                    _loadQueue.push(iri.url);
                }
                loadQueue();
            }
        }

        private function loadQueue():void {
            if (!_current) {
                if (_loadQueue.length) {
                    _current=_loadQueue.shift();
                    _loader.load(_current);
                } else {
                    checkImageQueue();
                }
            }
        }

        private function onLoadComplete(e:Event):void {
            var bitmapData:BitmapData=new BitmapData(_loader.contentWidth, _loader.contentHeight, true, 0x00ffffff);
            bitmapData.draw(_loader.content);
            _repository[_current]=bitmapData;
            updateCache(_current);
            var ire:ImageRepositoryEvent=new ImageRepositoryEvent(ImageRepositoryEvent.IMAGE_LOADED, bitmapData, _current, true);
            updateImages(_current, bitmapData);
            _current=null;
            loadQueue();
            dispatcheNotificationEvent(ire);
        }

        private function dispatcheNotificationEvent(e:Event):void {
            dispatchEvent(e);
        }

        private function updateImages(url:String, bitmapData:BitmapData, loaded:Boolean=true):void {
            var iri:ImageRepositoryItem;
            var ire:ImageRepositoryEvent;
            for (var i:int=0; i < _imageRIList.length; i++) {
                iri=_imageRIList[i];
                if (iri.url == url) {
                    if (loaded) {
                        iri.image.source=new Bitmap(bitmapData);
                        ire=new ImageRepositoryEvent(ImageRepositoryEvent.IMAGE_UPDATED);
                        ire.bitmapData=bitmapData;
                    } else {
                        ire=new ImageRepositoryEvent(ImageRepositoryEvent.IMAGE_NOT_UPDATED);
                    }
                    iri.image.dispatchEvent(ire);
                    _imageRIList.splice(i, 1);
                }
            }
        }

        public function isLoading():Boolean {
            return _current != null;
        }

        private function onError(e:Event):void {
            var ire:ImageRepositoryEvent=new ImageRepositoryEvent(ImageRepositoryEvent.IMAGE_NOT_LOADED, null, _current, true);
            updateImages(_current, null, false);
            _repository[_current]=new BitmapData(1, 1);
            _current=null;
            loadQueue();
            dispatcheNotificationEvent(ire);
        }

        public static function isBitmapAvailable(bitmap:BitmapData):Boolean {
            return bitmap.width > 1 && bitmap.height > 1;
        }

        public static function setCacheSize(count:Number):void {
            if (count && !isNaN(count)) {
                CACHE_SIZE=count;
            }
        }
    }
}
