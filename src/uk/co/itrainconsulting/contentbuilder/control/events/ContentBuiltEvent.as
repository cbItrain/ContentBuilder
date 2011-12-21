package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class ContentBuiltEvent extends Event
	{
		public static const CONTENT_BUILT:String = "contentBuilt";
		
		public function ContentBuiltEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}