package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ShowReferenceEvent extends Event
	{
		public static const SHOW_REFERENCE:String = "showReference";
		
		public var slideToGo:int;
		public var urlToGo:String;
		public var centerPoint:Point;
		
		public function ShowReferenceEvent(type:String, slideToGo:int = -1, urlToGo:String = "", centerPoint:Point = null , bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.slideToGo = slideToGo;
			this.urlToGo = urlToGo;
			this.centerPoint = centerPoint;
		}
	}
}