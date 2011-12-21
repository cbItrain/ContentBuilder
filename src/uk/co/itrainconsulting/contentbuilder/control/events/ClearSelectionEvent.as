package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class ClearSelectionEvent extends Event
	{
		public static var CLEAR_SELECTION:String = "CLEAR_SELECTION";
		public function ClearSelectionEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(ClearSelectionEvent.CLEAR_SELECTION, bubbles, cancelable);
		}
	}
}