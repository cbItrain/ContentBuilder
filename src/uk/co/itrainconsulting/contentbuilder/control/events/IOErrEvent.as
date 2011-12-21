package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class IOErrEvent extends Event
	{
		public static const IO_ERR:String = "ioErrIOErrEvent";
		
		public function IOErrEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}