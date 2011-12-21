package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class MainMenuEvent extends Event
	{
		public static const SHOW_CONNECTORS:String = "showConnectorsMainMenuEvent";
		public static const HIDE_CONNECTORS:String = "hideConnectorsMainMenuEvent";
		public static const DRAG_ENTER : String = "dragEnterMainMenuEvent";
		public static const DRAG_COMPLETE : String = "dragCompleteMainMenuEvent";
		public static const DRAG_DROP : String = "dragDropMainMenuEvent";
		
		public var draggedData:Object;
		
		public function MainMenuEvent(type:String, bubbles:Boolean=false, draggedData:Object = null, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.draggedData = draggedData;
		}
	}
}