package uk.co.itrainconsulting.common.events
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class ImageRepositoryEvent extends Event
	{
		public static const IMAGE_LOADED:String = "ImageRepositoryEventImageLoaded";
		public static const IMAGE_UPDATED:String = "ImageRepositoryEventImageUpdated";
		public static const IMAGE_NOT_LOADED:String = "ImageRepositoryEventImageNotLoaded";
		public static const IMAGE_NOT_UPDATED:String = "ImageRepositoryEventImageNotUpdated";
		public static const CACHE_CLEARED:String = "ImageRepositoryEventCacheCleared";
		
		public var bitmapData:BitmapData;
		public var url:String;
		public var data:Object;
		
		public function ImageRepositoryEvent(type:String, bitmapData:BitmapData = null, url:String = "", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.bitmapData = bitmapData;
			this.url = url;
		}
	}
}