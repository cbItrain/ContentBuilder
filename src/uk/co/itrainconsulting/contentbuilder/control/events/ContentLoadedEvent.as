package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	import uk.co.itrainconsulting.contentbuilder.control.ContentController;
	
	
	public class ContentLoadedEvent extends Event
	{
		public static const CONTENT_LOADED:String = "ContentLoadedEventContentLoaded";
		
		public var xml:XML;
		
		public function ContentLoadedEvent(_xml:XML, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			xml = _xml;
			super(CONTENT_LOADED, bubbles, cancelable);
		}
		
		
		override public function clone() : Event
		{
			var e:ContentLoadedEvent = ContentLoadedEvent(super.clone());
			e.xml = this.xml;
			return e;
		}
	}
}