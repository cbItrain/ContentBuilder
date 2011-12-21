package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class DeleteItemEvent extends Event
	{
		public static const DELETE_LIST_ITEM : String = "DELETE_LIST_ITEM";
		
		public var itemIndex:int;
		
		public function DeleteItemEvent(type:String, itemIndex:int = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.itemIndex = itemIndex;
		}
	}
}