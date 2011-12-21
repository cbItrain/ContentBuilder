package uk.co.itrainconsulting.common.events
{
	import flash.events.Event;
	
	public class StateEvent extends Event
	{
		public var slideIndex:Number;
		
		public static const STATE_EVENT_READY:String = "StateEventReady";
		public static const STATE_EVENT_XML_PARSED:String = "StateEventXMLParsed";
		public static const STATE_EVENT_SLIDE_CHANGE:String = "StateEventSlideChange";
		public static const STATE_EVENT_ALL_SLIDES_VISITED:String = "StateEventAllSlidesVisited";
		
		public var data:Object;
		
		public function StateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}