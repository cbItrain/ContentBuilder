package uk.co.itrainconsulting.contentviewer.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.events.PropertyChangeEvent;
	
	import uk.co.itrainconsulting.common.events.StateEvent;
	import uk.co.itrainconsulting.common.model.ContentProperties;
	import uk.co.itrainconsulting.common.model.Slide;

	public class ContentViewModel
	{
		[Dispatcher] public var dispatcher:IEventDispatcher;
		
		[Bindable] public var contentProps:ContentProperties;
		[Bindable] public var slides:ViewSlidesCollection;
		[Bindable] public var showingCanvas:int = 0; 
		[Bindable] public var preppingCanvas:int = 0; 
		[Bindable] public var singleSlideMode:Boolean = false;
		
		[Bindable] public var topGap:Number = 0;
		[Bindable] public var bottomGap:Number = 0;
		[Bindable] public var rightGap:Number = 0;
		[Bindable] public var leftGap:Number = 0;
		
		[Bindable] public var allowScaling:Boolean = false;
		
		
		private var _selectedCanvas:Slide;
		private var _showSlideList:Boolean = false;
		private var _visitedIndecies:Array = [];
		
		[Bindable]
		public function get selectedCanvas():Slide {
			return _selectedCanvas;
		}
		
		public function set selectedCanvas(value:Slide):void {
			_selectedCanvas = value;
		}
		
		[Mediate(event="prepSlide")]
		public function onPrepSlide():void {
			selectedCanvas = slides.getSlideAt(preppingCanvas);
			
			var se:StateEvent = new StateEvent(StateEvent.STATE_EVENT_SLIDE_CHANGE, true);
			se.data = _selectedCanvas;
			se.slideIndex = preppingCanvas;
			dispatcher.dispatchEvent(se);
			
			if (_visitedIndecies.indexOf(preppingCanvas) < 0) {
				_visitedIndecies.push(preppingCanvas);
				if (_visitedIndecies.length == slides.slidesCount)
					allSlidesVisited();
			}
		}
		
		private function allSlidesVisited():void {
			dispatcher.dispatchEvent(new StateEvent(StateEvent.STATE_EVENT_ALL_SLIDES_VISITED, true));
		}
		
		public function ContentViewModel()
		{
			init();
		}
		
		private function init():void{
			contentProps = new ContentProperties();
			slides = new ViewSlidesCollection(this);
		}
		
		[Bindable]
		public function set showSlideList(value:Boolean):void {
			_showSlideList = value;
		}
		
		public function get showSlideList():Boolean {
			return _showSlideList;
		}
		
		public function updateContentProperties(xmlList:XMLList):void {
			contentProps.setup(xmlList);
			showSlideList = contentProps.showSlideList;
		}
		
		public function reset():void {
			_visitedIndecies.splice(0, _visitedIndecies.length);
		}
	}
}