package uk.co.itrainconsulting.common.events
{
	import flash.events.Event;
	
	public class LocalImageLoaderEvent extends Event
	{
		public static const IMAGE_LOADED:String = "LocalImageLoaderEventImageLoaded";
		public static const IMAGE_LOAD_ERROR:String = "LocalImageLoaderEventImageLoadError";
		
		public function LocalImageLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}