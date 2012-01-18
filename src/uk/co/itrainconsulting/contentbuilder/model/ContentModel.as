package uk.co.itrainconsulting.contentbuilder.model
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.media.Video;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.events.CloseEvent;
	import mx.events.DynamicEvent;
	
	import spark.components.Button;
	
	import uk.co.itrainconsulting.common.events.ServiceEvent;
	import uk.co.itrainconsulting.common.model.ContentProperties;
	import uk.co.itrainconsulting.common.model.EnumObjectType;
	import uk.co.itrainconsulting.common.model.Slide;
	import uk.co.itrainconsulting.common.model.mediaObjects.AudioMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.ButtonMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.ImageMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
	import uk.co.itrainconsulting.common.model.mediaObjects.ShapeMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.TextMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.VideoMedia;
	import uk.co.itrainconsulting.common.utils.Embeded;
	import uk.co.itrainconsulting.common.view.objectHandleObjects.AudioPlayer;
	import uk.co.itrainconsulting.common.view.objectHandleObjects.IModelAware;
	import uk.co.itrainconsulting.common.view.objectHandleObjects.SimpleResizableButton;
	import uk.co.itrainconsulting.common.view.objectHandleObjects.SimpleResizableImage;
	import uk.co.itrainconsulting.common.view.objectHandleObjects.SimpleResizableShape;
	import uk.co.itrainconsulting.common.view.objectHandleObjects.SimpleResizableText;
	import uk.co.itrainconsulting.common.view.objectHandleObjects.SimpleResizableVideo;
	import uk.co.itrainconsulting.content.common.model.ParamParser;
	import uk.co.itrainconsulting.contentbuilder.control.ContentController;
	import uk.co.itrainconsulting.contentbuilder.control.events.EditorEvent;
	

	[Bindable]
	public class ContentModel
	{
		public var isDebug:Boolean = false;
		public var isSaving:Boolean = false;
		public var debugUrl:String;
		public var lessonId:int;
		public var playerModulePath:String;
		public var slideScale:Number = 1;
		public var fitToPage:Boolean = true;
		public var selectedSlideOnly:Boolean = false;
		public var allowScaling:Boolean = false;
		
		public var contentProps:ContentProperties;
		public var listType:EnumObjectType;
		public var retrievedList:ArrayCollection;
		public var previewXML:XML;
		public var copiedType:EnumObjectType;
		public var copiedMedia:MediaObject;
		public var slides:SlidesCollection;
		public var templates:SlidesCollection;
		
		public var selectedResizableObject:IModelAware;
		
		private var _apiVersion:String = APIVersions.defaultVersion;
		private var _selectedType:EnumObjectType;
		private var _selectedSlide:Slide;
		private var _leaveAfterSave:Boolean = false;
		private var _closeHandler:String;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var undoRedoBean:UndoRedoBean;
		
		public function ContentModel()
		{
			trace("Model being created");
			init();
		}
		
		public function get selectedSlide():Slide
		{
			return _selectedSlide;
		}
		
		public function set selectedSlide(value:Slide):void
		{
			_selectedSlide = value;
		}
		
		private function init():void{
			contentProps = new ContentProperties();
			slides = new SlidesCollection(this);
			templates = new SlidesCollection(this);
			
			templates.disableWatch();
		}
		
		public function set apiVersion(value:String):void
		{
			if (APIVersions.isValid(value))
			{
				_apiVersion = value;
			}
		}
		
		public function get apiVersion():String
		{
			return _apiVersion;
		}
		
		private var _wrapperDispatcher:WrapperDispatcher;
		
		public function get wrapperDispatcher():WrapperDispatcher
		{
			return _wrapperDispatcher
		}
		
		public function set wrapperDispatcher(value:WrapperDispatcher):void
		{
			_wrapperDispatcher = value;
		}
		
		
		[Mediate(event="flashVarsReady")]
		public function setParams(de:DynamicEvent):void
		{
			var o:Object = de.flashvars;
			try
			{
				this.lessonId = o.lessonId;
				this.isDebug = o.debug.on;
				this.debugUrl = o.debug.url;			
				this.apiVersion = o.serviceSettings.apiVersion;			
				this.wrapperDispatcher = o.wrapperDispatcher;
				this.playerModulePath = o.playerModuleURL;
				
				_closeHandler = o.closeFunction;
				if (o.beforeUnloadFunction)
					ExternalInterface.addCallback(o.beforeUnloadFunction, unload);
			}
			catch(e:Error){}		
		}
		
		[Bindable]
		public function get selectedType():EnumObjectType
		{
			return _selectedType;
		}
		
		public function set selectedType(value:EnumObjectType):void
		{
			_selectedType = value;
			
			var clearFocusEvent:Event = new Event(ContentController.CLEAR_FOCUS, true);
			dispatchEvent(clearFocusEvent);
		}
		
		[Mediate(event="EditorEvent.REMOVE_SLIDES_SILENTLY")]
		public function onRemoveSlideSilently(ee:EditorEvent):void {
			if ((ee.additionalData is Array) && (ee.additionalData as Array).length) {
				slides.unlistenForChange();
				var indecies:Array = [];
				for each (var si:SlideIndex in ee.additionalData) {
					slides.removeSlideAt(si.index);
					indecies.push(si.index);
				}
				slides.listenForChange();
				var e:EditorEvent;
				if (slides.contains(selectedSlide)) {
					e = new EditorEvent(EditorEvent.RESELECT_SLIDE, true);
				} else {
					indecies.sort();
					var index:int = indecies.shift();
					e = new EditorEvent(EditorEvent.SLIDES_REMOVED_SILENTLY, true);
					e.additionalData = Math.min(slides.slidesCount, Math.max(index, 0));
				}
				dispatcher.dispatchEvent(e);
			}
		}
		
		[Mediate(event="EditorEvent.ADD_SLIDES_SILENTLY")]
		public function onAddSlideSilently(ee:EditorEvent):void {
			if ((ee.additionalData is Array) && (ee.additionalData as Array).length) {
				slides.unlistenForChange();
				for each (var si:SlideIndex in ee.additionalData) {
					slides.addSlide(si.slide, si.index);
				}
				slides.listenForChange();
			}
		}
		
		[Mediate(event="EditorEvent.REORDER_SLIDE_SILENTLY")]
		public function onReorderSlideSilently(ee:EditorEvent):void {
			if (ee.slide && ee.additionalData > -1) {
				var removeIndex:int = slides.getSlideIndex(ee.slide);
				if (removeIndex > -1) {
					slides.unlistenForChange();
					slides.addSlide(slides.removeSlideAt(removeIndex), ee.additionalData as int);
					slides.listenForChange();
					
					var ee:EditorEvent = new EditorEvent(EditorEvent.RESELECT_SLIDE, true);
					dispatcher.dispatchEvent(ee);
				}
			}
		}
		
		[Mediate(event="EditorEvent.REORDER_MEDIA")] //only sent by Undo/Redo bean
		public function onReorderMedia(ee:EditorEvent):void {
			if (ee.additionalData > -1) {
				var removeIndex:int = ee.slide.getStageObjectIndex(ee.media);
				if (removeIndex > -1) {//media objects belongs to the slide
					ee.slide.stageObjects.removeItemAt(removeIndex);
					ee.slide.addNewMediaAt(ee.media, ee.additionalData as int);
					
					var e:EditorEvent = new EditorEvent(EditorEvent.MEDIA_REORDERED, true);
					e.slide = ee.slide;
					e.media = ee.media;
					e.additionalData = ee.additionalData;
					e.silent = true;
					dispatcher.dispatchEvent(e);
				}
			}
		}
		
		[Mediate(event="EditorEvent.DELETE_MEDIA")]
		public function onDeleteMedia(ee:EditorEvent):void {
			var slide:Slide;
			var mo:MediaObject;
			var silently:Boolean = false;
			if (ee.slide) {//undo/redo request
				slide = ee.slide;
				mo = ee.media;
				silently = true;
			} else {
				slide = _selectedSlide;
				mo = selectedResizableObject.model;
			}
			if (slide && mo) {
				slide.deleteMedia(mo);
				sendEditorEvent(EditorEvent.MEDIA_DELETED, mo, slide, silently);
			}
		}
		
		[Mediate(event="EditorEvent.ADD_MEDIA")]
		public function onAddNewMedia(ee:EditorEvent):void {
			var mo:MediaObject;
			var silently:Boolean = false;
			var slide:Slide;
			if (ee.media) {//undo/redo request
				mo=ee.media;
				slide=ee.slide;
				silently = true;
			} else {
				switch ((ee.additionalData as EnumObjectType).ordinal) {
					case EnumObjectType.SHAPE.ordinal:
						mo=new ShapeMedia();
						break;
					case EnumObjectType.BUTTON.ordinal:
						mo=new ButtonMedia();
						break;
					case EnumObjectType.IMAGE.ordinal:
						mo=new ImageMedia(Embeded.IMAGE_PLACE_HOLDER);
						break;
					case EnumObjectType.TEXT.ordinal:
						mo=new TextMedia();
						break;
					case EnumObjectType.VIDEO.ordinal:
						mo=new VideoMedia();
						break;
					case EnumObjectType.AUDIO.ordinal:
						mo=new AudioMedia();
						break;
				}
				slide=_selectedSlide
			}
			if (mo && slide) {
				addMedia(slide, mo, silently);
			}
		}
		
		private function addMedia(slide:Slide, mo:MediaObject, silently:Boolean):void {
			slide.addNewMedia(mo);
			sendEditorEvent(EditorEvent.MEDIA_ADDED, mo, slide, silently);
		}
		
		[Mediate(event="mediaPasted")]
		public function onMediaPasted():void {
			if (_selectedSlide && copiedMedia) {
				copiedMedia.unlistenForChange();
				copiedMedia.x+=10;
				copiedMedia.y+=10;
				copiedMedia.listenForChange();
				addMedia(_selectedSlide, copiedMedia.clone(), false);
			}
		}
		
		[Mediate(event="ServiceEvent.CONTENT_SAVED")]
		[Mediate(event="ServiceEvent.CONTENT_SAVE_FAILED")]
		public function onSaveComplete(e:Event):void {
			isSaving = false;
			if (e.type == ServiceEvent.CONTENT_SAVED) {
				wrapperDispatcher.dispatchEvent("save_success");
				if (_leaveAfterSave)
					externalClose(false);
			} else if (e.type == ServiceEvent.CONTENT_SAVE_FAILED) {
				wrapperDispatcher.dispatchEvent("read_content_fault");
				_leaveAfterSave = false;
			}
		}
		
		public function saveContent():void {
			var newMediaEvent:Event=new Event(ContentController.SAVE_CONTENT, true);
			isSaving = true;
			dispatcher.dispatchEvent(newMediaEvent);
		}
		
		private function sendEditorEvent(type:String, mo:MediaObject, slide:Slide, silently:Boolean):void {
			var cee:EditorEvent = new EditorEvent(type, true);
			cee.slide = slide;
			cee.media = mo;
			cee.silent = silently;
			dispatcher.dispatchEvent(cee);
		}
		
		public function unload():Boolean {
			if (undoRedoBean.saveRequired || undoRedoBean.propertiesChanged) {
				close();
				return false;
			} else {
				return true;
			}
		}
		
		public function close():void {
			if (undoRedoBean.saveRequired || undoRedoBean.propertiesChanged) {
				Alert.show("You have unsaved changes.\nWould you like to save them before leaving the application?", "Closing application", Alert.YES | Alert.NO | Alert.CANCEL, FlexGlobals.topLevelApplication as Sprite, function(e:CloseEvent):void {
					if (e.detail == Alert.YES) {
						_leaveAfterSave=true;
						saveContent();
					} else if (e.detail == Alert.NO) {
						externalClose(false);
					}
				});
			} else {
				externalClose(false);
			}
		}
		
		private function externalClose(checkSaveStatus:Boolean = true):void {
			if (ExternalInterface.available && _closeHandler) {
				ExternalInterface.call(_closeHandler, checkSaveStatus);
			}
		}
	}
}