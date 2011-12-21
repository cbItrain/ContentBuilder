package uk.co.itrainconsulting.contentbuilder.control.events
{
	
	import flash.events.Event;
	
	import uk.co.itrainconsulting.common.model.Slide;
	
	public class SlideEvent extends Event
	{
		public var slide:Slide;
		public function SlideEvent(type:String, _slide:Slide, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			slide = _slide;
			super(type, bubbles, cancelable);
		}
		
		override public function clone() : Event
		{
			var e : SlideEvent = SlideEvent(super.clone());
			e.slide = this.slide;
			return e
		}
	}
}