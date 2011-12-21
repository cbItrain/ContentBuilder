package uk.co.itrainconsulting.contentbuilder.model
{
	import uk.co.itrainconsulting.common.model.Slide;

	public class SlideIndex
	{
		public var index:int;
		public var slide:Slide;
		
		public function SlideIndex(index:int, slide:Slide)
		{
			this.index = index;
			this.slide = slide;
		}
	}
}