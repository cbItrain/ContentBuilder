package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class NewMediaEvent extends Event
	{
		public function NewMediaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}