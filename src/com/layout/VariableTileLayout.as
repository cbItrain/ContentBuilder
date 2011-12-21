package com.layout
{
	import flash.display.DisplayObject;
	
	import mx.core.ILayoutElement;
	
	import spark.components.Group;
	import spark.layouts.supportClasses.LayoutBase;
	
	public class VariableTileLayout extends LayoutBase
	{
		[Bindable] public var rowCount:Number = 1;
		
		public function VariableTileLayout()
		{
			super();
		}
		
		override public function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			if (!target)
				return;
			
			var layoutElement:ILayoutElement;
			var visualElement:Group;
			var count:uint = target.numElements;
			
			var _rowCount:Number = 1;
			
			var _x : Number;
			var _y: Number;
			
			var cWidth : Number = 0;
			var cHeight : Number = 0;
			
			for (var i:int = 0; i < count; i++)
			{
				layoutElement = target.getElementAt(i);
				visualElement = target.getElementAt(i) as Group;
				
				if (!layoutElement || !layoutElement.includeInLayout)
					continue;
				
				if (w > cWidth + visualElement.measuredWidth) {
					layoutElement.setLayoutBoundsPosition(_x, _y);
					cWidth += visualElement.measuredWidth + 5;
				} else {
					_x = cWidth = 0;	
					cHeight += visualElement.measuredHeight + 5;
					_y = cHeight;
					layoutElement.setLayoutBoundsPosition(_x, _y);
					cWidth  = visualElement.measuredWidth + 5;
					_rowCount++;
				}
				
				_x = cWidth;
			} 
			rowCount = _rowCount;
		}

	}

}