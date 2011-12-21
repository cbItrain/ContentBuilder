package uk.co.itrainconsulting.contentbuilder.model
{
	import mx.collections.ArrayCollection;
	
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.contentbuilder.control.ContentController;
	import uk.co.itrainconsulting.contentbuilder.control.events.SlideEvent;
	import uk.co.itrainconsulting.common.model.Slide;

	[Bindable]
	public class SlidesCollection extends SlideCollectionAware
	{
		
		public var model:ContentModel;
		
		
		
		public function getAll():ArrayCollection {
			return _slides;
		}
		
		public function getSlideAt(index:int):Slide {
			return _slides.getItemAt(index) as Slide;
		}
		
		public function getSlideIndex(s:Slide):int {
			return _slides.getItemIndex(s);
		}
		
		public function get slidesCount():int {
			return _slides != null ? _slides.length : 0;
		}
		
		public function removeSlideAt(index:int):Slide {
			return _slides.removeItemAt(index) as Slide;	
		}
		
		public function removeAllSlides():void {
			_slides.removeAll();
		}
		
		public function SlidesCollection(_model:ContentModel)
		{
			model = _model;
			super();
		}
		
		public function contains(slide:Slide):Boolean {
			return getSlideIndex(slide) > -1;
		}
		
		public function addNewSlide(index:int = 0):void{
			var s:Slide = new Slide();
			s.unlistenForChange();
			s.title = "New Slide";
			s.width = model.contentProps.width;
			s.height = model.contentProps.height;
			s.customDimensions = false;
			s.bgCol1 = model.contentProps.stageColors[0];
			s.bgCol2 = model.contentProps.stageColors[1];
			s.imageBGShowing = model.contentProps.hasBGImage;
			s.bgImage = model.contentProps.bgImage;
			s.bgImageMethod = model.contentProps.bgImageMethod;
			s.customBackground = false;
			s.listenForChange();
			_slides.addItemAt(s,index);
			var se:SlideEvent = new SlideEvent(ContentController.SLIDE_ADDED, s, true);
			dispatchEvent(se);
		}
		
		public function addSlide(s:Slide, index:int = 0, inform:Boolean = true):void {
			_slides.addItemAt(s,index);
			if (inform) {
				var se:SlideEvent = new SlideEvent(ContentController.SLIDE_ADDED, s, true);
				dispatchEvent(se);
			}
		}
		
		public function addSlideAt(slide:XML, index:int = -1):Slide {
			
			var s:Slide = new Slide();
			s.parseXML(slide, model.contentProps);
			if (index > -1) {
				_slides.addItemAt(s,index);
			} else {
				_slides.addItem(s);
			}
			return s;
		}
		
		public function removeDefaultsToExisting():void{
			var s:Slide;
			unlistenForChange();
			for (var i:int = 0, ix:int = _slides.length; i < ix; i++){
				s = getSlideAt(i);
				s.unlistenForChange();
				s.customBackground = true;
				s.customDimensions = true;
				if (s.bgImage != "")
				{
					s.backgroundType = EnumBGType.IMAGE;
				} else {
					s.backgroundType = EnumBGType.GRADIENT;
				}
				s.listenForChange();
			}
			listenForChange();
		}
		public function applyDefaultsToExisting():void{
			var s:Slide;
			unlistenForChange();
			for (var i:int = 0, ix:int = _slides.length; i < ix; i++){
				s = getSlideAt(i);
				s.unlistenForChange();
				if (!s.customDimensions){
					s.width = model.contentProps.width;
					s.height = model.contentProps.height;
				}
				if (!s.customBackground)
				{
					s.bgImage = model.contentProps.bgImage;
					s.bgImageMethod = model.contentProps.bgImageMethod;
					s.imageBGShowing = model.contentProps.hasBGImage;
					s.bgCol1 = model.contentProps.stageColors[0];
					s.bgCol2 = model.contentProps.stageColors[1];
				}
				s.listenForChange();
			}
			listenForChange();
		}
		public function applyDefaultsToAll():void{
			var s:Slide;
			unlistenForChange();
			for (var i:int = 0, ix:int = _slides.length; i < ix; i++){
				s = getSlideAt(i);
				s.unlistenForChange();
				s.customDimensions = false;
				s.customBackground = false;
				s.bgCol1 = model.contentProps.stageColors[0];
				s.bgCol2 = model.contentProps.stageColors[1];
				s.width = model.contentProps.width;
				s.height = model.contentProps.height;
				s.bgImage = model.contentProps.bgImage;
				s.bgImageMethod = model.contentProps.bgImageMethod;
				s.imageBGShowing = model.contentProps.hasBGImage;
				s.listenForChange();				
			}
			listenForChange();
		}
	}
}