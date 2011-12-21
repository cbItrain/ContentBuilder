package uk.co.itrainconsulting.components.colourpick.events
{
	import flash.events.Event;
	public class ColourPickEvent extends Event
	{
		/**
		 *  The <code>ColourPickEvent.CHANGE</code> constant defines the value of the
		 *  <code>type</code> property of the event that is dispatched when the user 
		 *  selects a color from the ColourPick control.
		 *
		 *  @eventType change
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const CHANGE:String = "change";
		public static const SELECTED:String = "selected";
		
		public var newColour:uint = 0xffffff;
		
		public function ColourPickEvent(newColour:uint, type:String = CHANGE)
		{
			super(type,true);
			this.newColour = newColour;
		}
		override public function clone():Event{
			var e:ColourPickEvent = new ColourPickEvent(newColour, type);
			return e;
		}
	}
}