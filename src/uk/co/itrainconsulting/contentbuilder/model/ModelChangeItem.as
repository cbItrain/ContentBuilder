package uk.co.itrainconsulting.contentbuilder.model
{

	public class ModelChangeItem
	{
		public static const PROPERTY_CHANGE:String = "ModelChangeItemPropertyChange";
		public static const DIMENSION_CHANGE:String = "ModelChangeItemDimensionChange";
		public static const POSITION_CHANGE:String = "ModelChangeItemPositionChange";
		public static const ITEM_ADDED:String = "ModelChangeItemItemAdded";
		public static const ITEM_REMOVED:String = "ModelChangeItemItemRemoved";
		public static const SLIDES_ADDED:String = "ModelChangeItemSlidesAdded";
		public static const SLIDES_REMOVED:String = "ModelChangeItemSlidesRemoved";
		public static const SLIDE_REORDERED:String = "ModelChangeItemSlideReordered";
		public static const SLIDE_SELECTION_CHANGE:String = "ModelChangeItemSlideSelectionChange";
		public static const ITEM_REORDERED:String = "ModelChangeItemItemReordered";
		
		public var parent:Object;
		public var reference:Object;
		public var propertyName:String;
		public var newValue:Object;
		public var oldValue:Object;
		public var type:String;
		
		public function ModelChangeItem()
		{
		}
	}
}