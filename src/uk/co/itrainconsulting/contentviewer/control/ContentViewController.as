package uk.co.itrainconsulting.contentviewer.control
{
	
	import flash.events.Event;
	
	import mx.events.DynamicEvent;
	
	import org.swizframework.controller.AbstractController;
	
	import uk.co.itrainconsulting.common.events.StateEvent;
	import uk.co.itrainconsulting.contentviewer.control.events.ContentViewEvent;
	import uk.co.itrainconsulting.contentviewer.control.events.ContentViewLoadedEvent;
	import uk.co.itrainconsulting.contentviewer.model.ContentViewModel;
	import uk.co.itrainconsulting.contentviewer.model.ViewSlide;
	
	public class ContentViewController extends AbstractController
	{	
		public static const CONTENT_VIEW_LOADED:String = "contentViewLoaded";
		public static const PREP_SLIDE:String = "prepSlide";
		public static const SLIDE_PREPPED:String = "slidePrepped";
		public static const CLEAR_STAGE:String = "clearStage";
		public static const SHOW_END_DIALOGUE:String = "showEndDialogue";
		
		[Inject] [Bindable] public var contentViewModel:ContentViewModel;
		
		public function ContentViewController()
		{
			super();
		}
		
		[Mediate(event="contentViewLoaded", properties="xml, slideIndex")]
		public function handleXMLLoaded(xml:XML, slideIndex:Number):void{
			dispatcher.dispatchEvent(new Event(ContentViewController.CLEAR_STAGE, true));
			contentViewModel.slides.clearAllSlides();
			if (xml is XML){
				contentViewModel.updateContentProperties(xml.properties);
			}
			var slidesList:XMLList = xml.slides.slide;
			for each(var col:XML in slidesList){
				contentViewModel.slides.addSlideAt(col);
			}
			contentViewModel.preppingCanvas = 0;
			if (slideIndex != -1)
				contentViewModel.preppingCanvas = slideIndex;
			dispatcher.dispatchEvent(new Event(ContentViewEvent.CONTENT_VIEW_DECODED, true));
			dispatcher.dispatchEvent(new StateEvent(StateEvent.STATE_EVENT_XML_PARSED, true));
			dispatcher.dispatchEvent(new Event(PREP_SLIDE, true));
		}	
	}
}