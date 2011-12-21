package uk.co.itrainconsulting.contentviewer.control.events
{
	import flash.events.Event;
	
	public class ContentViewEvent extends Event
	{
		public static const CONTENT_VIEW_DECODED:String = "contentViewDecoded";
		
		public function ContentViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}