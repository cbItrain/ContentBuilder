package uk.co.itrainconsulting.contentviewer.model
{
	import uk.co.itrainconsulting.common.model.Slide;
	
	[Bindable]
	public class ViewSlide extends Slide
	{
		
		public var hasBeenVisited:Boolean = false;
		
		public function ViewSlide()
		{
			super();
			disableWatch();
		}
	}
}