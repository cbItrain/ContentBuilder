package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class CopyPasteEvent extends Event
	{
		public static const PASTE:String = "pasteEvent";
		
		public var text:String;
		
		public function CopyPasteEvent(type:String, text:String = "", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.text = text;
		}
	}
}