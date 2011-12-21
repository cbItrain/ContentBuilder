package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	import uk.co.itrainconsulting.common.model.Slide;
	
	public class RenderEvent extends Event
	{
		public static const RENDER_COMPLETE:String = "renderCompleteRenderEvent";
		public static const RENDER_REMOVED:String = "renderRemovedRenderEvent";
		
		public function RenderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}