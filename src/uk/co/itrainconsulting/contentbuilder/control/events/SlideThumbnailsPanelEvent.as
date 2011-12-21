package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class SlideThumbnailsPanelEvent extends Event
	{
		
		public static const SHOW_EDITOR:String = "showEditorSlideThumbnailPanelEvent";
		
		public function SlideThumbnailsPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}