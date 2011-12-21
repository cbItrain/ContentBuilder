package uk.co.itrainconsulting.contentviewer.control.events
{
	import flash.events.Event;
	
	import uk.co.itrainconsulting.contentviewer.control.ContentViewController;
	
	
	public class ContentViewLoadedEvent extends Event
	{
		public var xml:XML;
		public var slideIndex:Number;
		public function ContentViewLoadedEvent(_xml:XML, slideIndex:Number = -1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			xml = _xml;
			this.slideIndex = slideIndex;
			super(ContentViewController.CONTENT_VIEW_LOADED, bubbles, cancelable);
		}
	}
}