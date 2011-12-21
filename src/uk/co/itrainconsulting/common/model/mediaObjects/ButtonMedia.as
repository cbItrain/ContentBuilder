package uk.co.itrainconsulting.common.model.mediaObjects
{
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	
	import uk.co.itrainconsulting.common.model.EnumObjectType;
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.contentbuilder.model.Constants;

	[Bindable]
	[RemoteClass]
	public class ButtonMedia extends MediaObject implements IMediaObject
	{
		public var label:String = "";
		public var cornerRadius:int = 0;
		public var fontSize:int = 14;
		public var fontColour:uint = 0x000000;
		public var labelAlpha:Number = 1;
		public var colour:uint = 0xffffff;
		public var alpha:Number = 1.0;
		
		public function ButtonMedia()
		{
			unlistenForChange();
			mediaType = EnumObjectType.BUTTON;
			setPos(0, 0, 100, 50);
			listenForChange();
		}
		
		override public function clone():MediaObject
		{
			var res:ButtonMedia = new ButtonMedia();
			res.unlistenForChange();
			res.setPos(x,y,width,height,rotation);
			res.label = label;
			res.slideToGo = slideToGo;
			res.cornerRadius = cornerRadius;
			res.fontSize = fontSize;
			res.fontColour = fontColour;
			res.labelAlpha = labelAlpha;
			res.colour = colour;
			res.alpha = alpha;
			res.slideToGo = slideToGo;
			res.urlToGo = urlToGo;
			res.useHandCursor = useHandCursor;
			res.listenForChange();
			return res;
		}
		
		override public function parseXML(xml:XML):void {
			if (xml) {
				super.parseXML(xml);
				unlistenForChange();
				label = xml.@label;
				cornerRadius = xml.@cornerRadius;
				fontColour = xml.@fontColour;
				fontSize = xml.@fontSize;
				colour = xml.@colour;
				alpha = DataUtil.getAlpha(xml.@alpha);
				labelAlpha = DataUtil.getAlpha(xml.@labelAlpha);
				slideToGo = DataUtil.getGoToSlide(xml.@slideToGo);
				urlToGo = xml.@urlToGo ? xml.@urlToGo : "";
				useHandCursor = DataUtil.parseBoolean(xml.@useHandCursor);
				listenForChange();
			}
		}
		
		public static function mediaFromXML(xml:XML):ButtonMedia {
			var result:ButtonMedia;
			if (xml) {
				result=new ButtonMedia();
				result.parseXML(xml);
			}
			return result;
		}
		
		override public function convertToXML():XML {
			var tag:XML = <slideObject></slideObject>;
			
			appendToXML(tag);			
			tag.@label = label;
			tag.@cornerRadius = cornerRadius;
			tag.@fontColour = fontColour;
			tag.@fontSize = fontSize;
			tag.@colour = colour;
			
			if (labelAlpha < 1.0)
				tag.@labelAlpha = labelAlpha;
			if (alpha < 1.0)
				tag.@alpha = alpha;
			if (slideToGo != -1)
				tag.@slideToGo = slideToGo;
			if (urlToGo)
				tag.@urlToGo = urlToGo;
			if (useHandCursor)
				tag.@useHandCursor = useHandCursor;
			
			return tag;
		}
	}
}