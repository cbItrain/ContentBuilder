package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class SlideScaleEvent extends Event
	{
		
		public static const FIT_TO_PAGE:String = "fitToPageSlideScaleEvent";
		public static const SCALE_SLIDE:String = "scaleSlideSlideScaleEvent";
		
		public function SlideScaleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}