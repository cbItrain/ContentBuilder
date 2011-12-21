package uk.co.itrainconsulting.contentviewer.model
{
	import flash.external.ExternalInterface;
	
	import mx.collections.ArrayCollection;
	
	import uk.co.itrainconsulting.common.model.Slide;
	
	[Bindable]
	public class ViewSlidesCollection
	{
		private var _slides:ArrayCollection;
		
		public var model:ContentViewModel;

		public function ViewSlidesCollection(model:ContentViewModel)
		{
			this.model = model;
			_slides = new ArrayCollection();
		}
		
		public function get slidesCount():int {
			return _slides != null ? _slides.length : 0;
		}
		
		public function getSlideIndex(s:Slide):int {
			return _slides.getItemIndex(s);
		}
		
		public function getSlideAt(index:int):Slide {
			return _slides.getItemAt(index) as Slide;
		}
		
		public function getAll():ArrayCollection {
			return _slides;
		}
		
		
		public function clearAllSlides():void{
			_slides.removeAll();
		}
		
		public function addSlideAt(slide:XML, index:int = -1):Slide {
			
			var s:Slide = new ViewSlide();
			s.parseXML(slide, model.contentProps);
			if (index > -1) {
				_slides.addItemAt(s,index);
			} else {
				_slides.addItem(s);
			}
			return s;
		}
	}
}