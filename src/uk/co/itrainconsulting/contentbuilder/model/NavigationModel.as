package uk.co.itrainconsulting.contentbuilder.model
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.managers.DragManager;
	
	import org.swizframework.controller.AbstractController;
	
	import uk.co.itrainconsulting.common.model.EnumObjectType;
	import uk.co.itrainconsulting.contentbuilder.control.ContentController;
	import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
	import uk.co.itrainconsulting.common.model.mediaObjects.ShapeMedia;
	import uk.co.itrainconsulting.common.model.Slide;
	
	public class NavigationModel extends AbstractController
	{
		
		private var navigationAC:ArrayCollection = new ArrayCollection(); // key = MediaObject - value = slide index
		
		[Inject] [Bindable] public var contentModel:ContentModel;
		
		public function NavigationModel()
		{
			super();
		}
		
		[Mediate(event="contentBuilt")]
		public function onModelCreation():void {
			contentModel.slides.getAll().addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange, false, 10);
			for each (var s:Slide in contentModel.slides.getAll()) {
				for each (var o: Object in s.stageObjects){
					var so:MediaObject = o as MediaObject;
					switch (so.mediaType.ordinal) {
						case EnumObjectType.BUTTON.ordinal:
						case EnumObjectType.IMAGE.ordinal:
						case EnumObjectType.SHAPE.ordinal:
						case EnumObjectType.TEXT.ordinal:
							navigationAC.addItem(so);
						break;
					}
				}
			}
		}
		
		
		public function addMediaObject(mediaObject:MediaObject):void {
			navigationAC.addItem(mediaObject);
		}
		
		private function onCollectionChange(ev:CollectionEvent):void {
			switch (ev.kind) {
				case CollectionEventKind.ADD:
					newSlide(ev.location);
					dispatcher.dispatchEvent(new Event(ContentController.NAVIGATION_UPDATED, true));
					break;
				case CollectionEventKind.REMOVE:
					slideDeleted(ev.location, ev.items[0] as Slide);
					dispatcher.dispatchEvent(new Event(ContentController.NAVIGATION_UPDATED, true));
					break;
			}
		}
		
		private function slideDeleted(index:int, removedSlide:Slide):void {
			navigationAC.removeAll();
			onModelCreation();
			for each (var mo:MediaObject in navigationAC) {
				mo.unlistenForChange();
				if (mo.slideToGo >= 0) {
					if (mo.slideToGo > index) {
						mo.slideToGo--;
					} else if (mo.slideToGo == index) {
						if (DragManager.isDragging)
							mo.slideToGo = -100;
						else
							mo.slideToGo = -1;
					}
				}
				mo.listenForChange();
			}
//			for each (mo in removedSlide.stageObjects) {
//				if (mo.slideToGo > index)
//					mo.slideToGo--;
//			}
		}
//		
//		[Mediate(event="moveCanvasDown", priority="2")]
//		public function slideMoveDown():void {
//			var moveIndex:int = contentModel.slides.slides.getItemIndex(contentModel.selectedSlide);
//			for each (var mo:MediaObject in navigationAC) {
//				if (mo.slideToGo - 1 == moveIndex)
//					mo.slideToGo--;
//				else if (mo.slideToGo == moveIndex)
//					mo.slideToGo++;
//			}
//		}
//		
//		[Mediate(event="moveCanvasUp", priority="2")]
//		public function slideMoveUp():void {
//			var moveIndex:int = contentModel.slides.slides.getItemIndex(contentModel.selectedSlide);
//			for each (var mo:MediaObject in navigationAC) {
//				if (mo.slideToGo + 1 == moveIndex)
//					mo.slideToGo++;
//				else if (mo.slideToGo == moveIndex)
//					mo.slideToGo--; 
//			}
//		}
//		
//		[Mediate(event="duplicateSlide", priority="2")]
//		[Mediate(event="newSlide", priority="2")]
		private function newSlide(index:int):void {
			navigationAC.removeAll();
			onModelCreation();
			for each (var mo:MediaObject in navigationAC) {
				mo.unlistenForChange();
				if (mo.slideToGo >= 0) {
					if (mo.slideToGo >= index && mo.slideToGo < contentModel.slides.slidesCount - 1)
						mo.slideToGo++;
					else if (mo.slideToGo == index && mo.slideToGo == contentModel.slides.slidesCount - 1 )
						mo.slideToGo--;
						
				} else if (mo.slideToGo == -100) {
					mo.slideToGo = index;
				}
				mo.unlistenForChange();
			}
		}
		
	}
}