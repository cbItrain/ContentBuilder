package uk.co.itrainconsulting.common.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	
	import uk.co.itrainconsulting.common.events.LocalImageLoaderEvent;

	public class LocalImageLoader
	{
		private static var _instance:LocalImageLoader;
		
		private var _current:LocalImageLoaderItem;
		private var _loader:Loader;
		private var _queue:Vector.<LocalImageLoaderItem> = new Vector.<LocalImageLoaderItem>();
		
		public static function getInstance():LocalImageLoader {
			if (!_instance)
				_instance = new LocalImageLoader();
			return _instance;
		}
		
		public function LocalImageLoader() {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		public function loadLocal(data:ByteArray, image:Image, important:Boolean = true):void {
			if (data && image) {
				clearQueue(image);
				if (important) {
					_queue.unshift(new LocalImageLoaderItem(data, image));
				} else {
					_queue.push(new LocalImageLoaderItem(data, image));
				}
				load();
			}
		}
		
		private function clearQueue(image:Image):void {
			for (var i:int = 0; i < _queue.length; i++) {
				if (_queue[i].image == image) {
					_queue.splice(i, 1);
					return;
				}
			}
		}
		
		private function load():void {
			if (!_current) {
				if (_queue.length) {
					_current=_queue.shift();
					_loader.loadBytes(_current.data);
				}
			}
		}
		
		private function onLoadComplete(e:Event):void {
			var bitmapData:BitmapData=new BitmapData(_loader.content.width, _loader.content.height, true, 0x00ffffff);
			bitmapData.draw(_loader.content);
			updateImage(_current.image, bitmapData);
			_current=null;
			load();
		}
		
		private function updateImage(image:Image, bd:BitmapData):void {
			image.source = new Bitmap(bd, PixelSnapping.AUTO, true);

			image.dispatchEvent(new LocalImageLoaderEvent(LocalImageLoaderEvent.IMAGE_LOADED));
		}
		
		private function onError(e:Event):void {
			
		}
	}
}