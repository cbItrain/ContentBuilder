package uk.co.itrainconsulting.common.model.mediaObjects
{
	import uk.co.itrainconsulting.common.model.EnumObjectType;
	import uk.co.itrainconsulting.common.model.EnumShapeType;
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.common.utils.ShapeUtils;
	import uk.co.itrainconsulting.contentbuilder.model.Constants;

	[Bindable]
	[RemoteClass]
	public class ShapeMedia extends MediaObject implements IMediaObject
	{
		public var shapeType:EnumShapeType;
		public var rectRadius:Number = 0;
		public var lineColour:uint = 0x000000;
		public var lineAlpha:Number = 1;
		public var lineWeight:Number = 1;
		public var fillIsGradient:Boolean = false;
		public var fillColour1:uint = 0xffffff;
		public var fillColour2:uint = 0xcccccc;
		public var fillAlpha:Number = 1;
		public var arrows:String = "none";
		public var arrowLength:Number = 10;
		public var arrowWidth:Number = 4;
		
		
		public function ShapeMedia()
		{
			unlistenForChange();
			mediaType = EnumObjectType.SHAPE;
			shapeType = EnumShapeType.RECTANGLE;
			setPos(10,10,50,50,0);
			listenForChange();
		}
		override public function clone():MediaObject
		{
			var res:ShapeMedia = new ShapeMedia();
			res.unlistenForChange();
			res.setPos(x,y,width,height,rotation);
			res.shapeType = shapeType;
			res.rectRadius = rectRadius;
			res.lineAlpha = lineAlpha;
			res.lineColour = lineColour;
			res.lineWeight = lineWeight;
			res.fillAlpha = fillAlpha;
			res.fillColour1 = fillColour1;
			res.fillColour2 = fillColour2;
			res.useHandCursor = useHandCursor;
			res.fillIsGradient = fillIsGradient;
			res.arrows = arrows;
			res.arrowLength = arrowLength;
			res.arrowWidth = arrowWidth;
			res.slideToGo = slideToGo;
			res.urlToGo = urlToGo;
			
			res.listenForChange();
			return res;
		}
		
		override public function parseXML(xml:XML):void {
			if (xml) {				
				super.parseXML(xml);
				
				unlistenForChange();
				
				shapeType = ShapeUtils.getShapeType(xml.@shapeType);
				rectRadius = xml.@rectRadius;
				lineColour = xml.@lineColour;
				lineAlpha = xml.@lineAlpha;
				lineWeight = xml.@lineWeight;
				fillIsGradient = DataUtil.parseBoolean(xml.@fillIsGradient);
				fillColour1 = xml.@fillColour1;
				fillColour2 = xml.@fillColour2;
				fillAlpha = xml.@fillAlpha;
				arrows = xml.@arrows;
				useHandCursor = DataUtil.parseBoolean(xml.@useHandCursor);
				arrowLength = xml.@arrowLength;
				arrowWidth = xml.@arrowWidth;
				
				slideToGo = DataUtil.getGoToSlide(xml.@slideToGo);
				urlToGo = xml.@urlToGo ? xml.@urlToGo : "";
				
				listenForChange();
			}
		}
		
		public static function mediaFromXML(xml:XML):ShapeMedia {
			var result:ShapeMedia;
			if (xml) {
				result=new ShapeMedia();
				result.parseXML(xml);
			}
			return result;
		}
		
		override public function convertToXML():XML {
			var tag:XML = <slideObject></slideObject>;
			
			appendToXML(tag);			
			
			tag.@shapeType = shapeType.ordinal;
			tag.@rectRadius = rectRadius;
			tag.@lineColour = lineColour;
			tag.@lineAlpha = lineAlpha;
			tag.@lineWeight = lineWeight;
			tag.@fillColour1 = fillColour1;
			tag.@fillColour2 = fillColour2;
			tag.@fillAlpha = fillAlpha;
			tag.@arrows = arrows;
			tag.@useHandCursor = useHandCursor;
			tag.@arrowLength = arrowLength;
			tag.@arrowWidth = arrowWidth;
			if (fillIsGradient)
				tag.@fillIsGradient = fillIsGradient;
			if (slideToGo != -1)
				tag.@slideToGo = slideToGo;
			if (urlToGo)
				tag.@urlToGo = urlToGo;
			
			return tag;
		}
	}
}