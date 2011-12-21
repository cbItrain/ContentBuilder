package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	import uk.co.itrainconsulting.contentbuilder.model.EnumMessageSeverity;
	
	public class MessageEvent extends Event
	{
		public static const SHOW_MESSAGE:String = "EditorEventShowMessage";
		
		public var message:String;
		public var messageSeverity:EnumMessageSeverity;
		public var description:String;
		public var highPriority:Boolean = false;
		public var additionalInfo:String;
		
		public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}