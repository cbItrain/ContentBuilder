package uk.co.itrainconsulting.content.common.model
{
	import flash.external.ExternalInterface;
	
	import mx.core.FlexGlobals;
	
	import uk.co.itrainconsulting.common.events.StateEvent;
	import uk.co.itrainconsulting.contentbuilder.model.WrapperDispatcher;
	import uk.co.itrainconsulting.contentviewer.model.ViewSlide;

	public class ExternalInterfaceAware
	{
		private var _externallyAware:IExternalInterfaceAwareApplication;
		private var _wrapperDispatcher:WrapperDispatcher;
		private var _flashVars:Object;
		
		[Mediate(event="StateEvent.STATE_EVENT_READY")]
		public function ready(se:StateEvent):void {
			if (FlexGlobals.topLevelApplication is ContentPlayer) {
				_externallyAware = (FlexGlobals.topLevelApplication as ContentPlayer).previewerContent;
				_flashVars = (FlexGlobals.topLevelApplication as ContentPlayer).flashVars;
				_wrapperDispatcher = _flashVars.wrapperDispatcher;
			}
			addCallbacks();
			_wrapperDispatcher.dispatchEvent("ready");
			
		}
		
		[Mediate(event="StateEvent.STATE_EVENT_XML_PARSED")]
		public function xmlParsed(se:StateEvent):void {
			_wrapperDispatcher.dispatchEvent("parsed");
		}
		
		[Mediate(event="StateEvent.STATE_EVENT_SLIDE_CHANGE")]
		public function slideChange(se:StateEvent):void {
			if (se.data is ViewSlide) {
				var vs:ViewSlide = se.data as ViewSlide;
				_wrapperDispatcher.dispatchEvent("slideChange",vs.width, vs.height, se.slideIndex);
			} else {
				_wrapperDispatcher.dispatchEvent("slideChange");
			}
		}
		
		[Mediate(event="StateEvent.STATE_EVENT_ALL_SLIDES_VISITED")]
		public function onAllSlidesVisited(se:StateEvent):void {
			_wrapperDispatcher.dispatchEvent("AllSlidesVisited");
		}
		
		
		private function addCallbacks():void {
			if (ExternalInterface.available) {
				if(_flashVars.getAllSlidesFunction)
					ExternalInterface.addCallback(_flashVars.getAllSlidesFunction, _externallyAware.getSlidesBasicData);
				if(_flashVars.getCurrentSlideIndexFunction)
					ExternalInterface.addCallback(_flashVars.getCurrentSlideIndexFunction, _externallyAware.getCurrentSlideIndex);
				if(_flashVars.setNewContentFunction)
					ExternalInterface.addCallback(_flashVars.setNewContentFunction, _externallyAware.setNewContent);
				if(_flashVars.changeShowSlideListFunction)
					ExternalInterface.addCallback(_flashVars.changeShowSlideListFunction, _externallyAware.changeShowSlideList);
				if(_flashVars.getSlidesCountFunction)
					ExternalInterface.addCallback(_flashVars.getSlidesCountFunction, _externallyAware.getSlidesCount);
				if(_flashVars.showLastSlideFunction)
					ExternalInterface.addCallback(_flashVars.showLastSlideFunction, _externallyAware.showLastSlide);
				if(_flashVars.showFirstSlideFunction)
					ExternalInterface.addCallback(_flashVars.showFirstSlideFunction, _externallyAware.showFirstSlide);
				if(_flashVars.showPreviousSlideFunction)
					ExternalInterface.addCallback(_flashVars.showPreviousSlideFunction, _externallyAware.showPreviousSlide);
				if(_flashVars.showNextSlideFunction)
					ExternalInterface.addCallback(_flashVars.showNextSlideFunction, _externallyAware.showNextSlide);
				if(_flashVars.showSlideAtFunction)
					ExternalInterface.addCallback(_flashVars.showSlideAtFunction, _externallyAware.showSlideAt);
				if(_flashVars.loadContentFunction)
					ExternalInterface.addCallback(_flashVars.loadContentFunction, _externallyAware.loadContent);
			}
		}
	}
}