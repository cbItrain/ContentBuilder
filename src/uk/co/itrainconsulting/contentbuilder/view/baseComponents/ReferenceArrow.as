package uk.co.itrainconsulting.contentbuilder.view.baseComponents
{
	import com.dncompute.graphics.ArrowStyle;
	import com.dncompute.graphics.GraphicsUtil;
	
	import flash.geom.Point;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;
	
	import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
	import uk.co.itrainconsulting.contentbuilder.view.SlideThumbnail;
	
	public class ReferenceArrow extends UIComponent
	{
		public var startPoint:Point;
		public var endPoint:Point;
		public var relative : Boolean;
		
		private var _slideOriginIndex:int;
		private var _arrowStyle:ArrowStyle;
		private var _sourceMedia : MediaObject;
		
		public function ReferenceArrow(sourceMedia:MediaObject, slideOriginIndex:int = -1, relative:Boolean = false)
		{
			super();
			this._sourceMedia = sourceMedia;
			this.relative = relative;
			this.alpha = .4;
			
			_slideOriginIndex = slideOriginIndex;
			
			_arrowStyle = new ArrowStyle();
			_arrowStyle.shaftThickness = 1;
			_arrowStyle.headWidth = 10;
			_arrowStyle.headLength = 15;
			_arrowStyle.shaftPosition = .2;
			
			BindingUtils.bindSetter(onSlideToGoChange, sourceMedia, 'slideToGo');
		}
		
		private function onSlideToGoChange(newValue:int):void {
			if (newValue != -1) {
				toolTip = "Go to the ";
				toolTip += SlideReferenceFormatter.slideReferenceToString(newValue);
				toolTip += " slide";
			} else {
				toolTip = "";
			}
		}
		
		public function get sourceMedia():MediaObject {
			return this._sourceMedia;
		}
		
		public function get slideOriginIndex():int {
			return _slideOriginIndex;
		}
		
		public function clear():void {
			var colour:uint;
			if (relative)
				colour = 0xFF2A2A;
			else
				colour = 0x30DA30;
			graphics.clear();
			graphics.lineStyle(1,colour);
			graphics.beginFill(colour);
		}
		
		public function drawArrow(end:Point = null, start:Point = null):void {
			this.clear();
			
			if (!start)
				start = startPoint;
			if (!end)
				end = endPoint;
			if (start && end) {
				startPoint = start;
				endPoint = end;
				graphics.drawCircle(start.x, start.y, 3);
				GraphicsUtil.drawArrow(graphics, start, end, _arrowStyle);
			}
		}
		
	}
}