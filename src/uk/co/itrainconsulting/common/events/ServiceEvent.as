package uk.co.itrainconsulting.common.events
{
	import flash.events.Event;
	
	public class ServiceEvent extends Event
	{
		public static const CONTENT_LOADED:String = "ServiceEventContentLoaded";
		public static const CONTENT_LOAD_FAILED:String = "ServiceEventContentLoadFailed";
		public static const CONTENT_SAVED:String = "ServiceEventContentSaved";
		public static const CONTENT_SAVE_FAILED:String = "ServiceEventContentSaveFailed";
		public static const ASSETS_LOAD_FAILED:String = "ServiceEventAssetsLoadFailed";
		public static const TEMPLATES_LOAD_FAILED:String = "ServiceEventTemplateLoadFailed";
		
		public var data:Object;
		
		public function ServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}