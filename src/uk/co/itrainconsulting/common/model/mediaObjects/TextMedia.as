package uk.co.itrainconsulting.common.model.mediaObjects
{
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	import uk.co.itrainconsulting.common.model.EnumObjectType;
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.contentbuilder.model.Constants;

	[Bindable]
	[RemoteClass]
	public class TextMedia extends MediaObject implements IMediaObject
	{
		public var htmlText:String;
		
		public var advTextMode:Boolean;
		public var textChain:ArrayCollection = new ArrayCollection();
		public var currentLayerInd:int = -1;
		public var timeInterval:int = 0;
		
		public function TextMedia(_htmlText:String = null,_advTextMode:Boolean = false,_textChain:ArrayCollection = null)
		{
			unlistenForChange();
			advTextMode = _advTextMode;
			if (advTextMode) {
				textChain = _textChain;
			} else {
				htmlText = _htmlText;
			}
			mediaType = EnumObjectType.TEXT;
			setPos(10, 10, 200, 120);
			listenForChange();
		}
		
		override public function clone():MediaObject
		{
			var res:TextMedia = new TextMedia(htmlText);
			res.unlistenForChange();
			res.advTextMode = advTextMode;
			res.textChain = new ArrayCollection(textChain.toArray());	
			res.currentLayerInd = currentLayerInd;
			res.timeInterval = timeInterval;
			res.setPos(x,y,width,height,rotation);
			res.slideToGo = slideToGo;
			res.urlToGo = urlToGo;
			res.useHandCursor = useHandCursor;
			res.listenForChange();
			return res;
		}
		
		public static function mediaFromXML(xml:XML):TextMedia {
			var result:TextMedia;
			if (xml) {
				result=new TextMedia();
				result.parseXML(xml);
			}
			return result;
		}
		
		
		
		override public function parseXML(xml:XML):void {
			if (xml) {		
				super.parseXML(xml);
				unlistenForChange();
				advTextMode = DataUtil.parseBoolean(xml.@advTextMode);
				var textObjectsList:XMLList = xml.text;
				if (advTextMode) {
					for each(var t:XML in textObjectsList)
					{
						textChain.addItem(t);
					}
					timeInterval = Number(xml.@timeInterval);
				} else {
					for each(var s:XML in textObjectsList)
					{
						htmlText = s;
					}
				}
				slideToGo = DataUtil.getGoToSlide(xml.@slideToGo);
				urlToGo = xml.@urlToGo ? xml.@urlToGo : "";
				useHandCursor=DataUtil.parseBoolean(xml.@useHandCursor);
				
				listenForChange();
			}
		}
		
		override public function convertToXML():XML {
			var tag:XML = <slideObject></slideObject>;
			
			appendToXML(tag);			
			
			if (advTextMode) {
				for each(var t:String in textChain)
				{
					tag.appendChild(XML("<text><![CDATA[" + t + "]]></text>"));
				}
				tag.@timeInterval = timeInterval;
				tag.@advTextMode = advTextMode;
			} else {
				tag.appendChild(XML("<text><![CDATA[" + htmlText + "]]></text>"));
			}
			if (slideToGo != -1)
				tag.@slideToGo = slideToGo;
			if (urlToGo)
				tag.@urlToGo = urlToGo;
			if (useHandCursor)
				tag.@useHandCursor=useHandCursor;
			
			return tag;
		}
	}
}