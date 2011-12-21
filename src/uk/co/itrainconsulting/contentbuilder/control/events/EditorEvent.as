package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	import uk.co.itrainconsulting.common.model.Slide;
	import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
	
	public class EditorEvent extends Event
	{
		public static const ADD_MEDIA:String = "EditorEventAddMedia";
		public static const DELETE_MEDIA:String = "EditorEventDeleteMedia";
		public static const MEDIA_ADDED:String = "EditorEventMediaAdded";
		public static const MEDIA_DELETED:String = "EditorEventMediaDeleted";
		public static const REORDER_MEDIA:String = "EditorEventReorderMedia";
		public static const MEDIA_REORDERED:String = "EditorEventItemReordered";
		public static const MEDIA_SELECT:String = "EditorEventMediaSelect";
		public static const DISABLE_PROPERTY_CHANGE_TRACKING:String = "EditorEventDisablePropertyChangeTracking";
		public static const ENABLE_PROPERTY_CHANGE_TRACKING:String = "EditorEventEnablePropertyChangeTracking";
		public static const REORDER_SLIDE_SILENTLY:String = "EditorEventReorderSlideSilently";
		public static const REMOVE_SLIDES_SILENTLY:String = "EditorEventRemoveSlidesSilently";
		public static const ADD_SLIDES_SILENTLY:String = "EditorEventAddSlidesSilently";
		public static const CHANGE_SLIDE_SELECTION:String = "EditorEventChangeSlideSelection";
		public static const SLIDES_ADDED_SILENTLY:String = "EditorEventSlidesAddedSilently";
		public static const SLIDES_REMOVED_SILENTLY:String = "EditorEventSlidesRemovedSilently";
		public static const SLIDE_UPDATED:String = "EditorEventSlideUpdated";
		public static const UNDO:String = "EditorEventUndo";
		public static const REDO:String = "EditorEventRedo";
		public static const DELETE_SLIDE:String = "EditorEventDeleteSlide";
		public static const SLIDE_DELETED:String = "EditorEventSlideDeleted";
		public static const RESELECT_SLIDE:String = "EditorEventReselectSlide";
		public static const CONTENT_PROPERTIES_CHANGE:String = "EditorEventContentPropertiesChange";
		
		public var media:MediaObject;
		public var slide:Slide;
		public var additionalData:Object;
		public var silent:Boolean = false;
		
		public function EditorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}