package uk.co.itrainconsulting.common.model.mediaObjects
{
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.contentbuilder.model.Constants;
	import uk.co.itrainconsulting.common.model.EnumObjectType;

	[Bindable]
	[RemoteClass]
	public class VideoMedia extends MediaObject
	{
		public var url:Object = null;
		public var autoplay:Boolean = false;
		public var mute:Boolean = false;
		public var loop:Boolean = false;
		public var displayName:String;
		public function VideoMedia()
		{
			unlistenForChange();
			mediaType = EnumObjectType.VIDEO;
			setPos(0, 0, 280, 200, 0);
			listenForChange();
		}
		
		override public function clone():MediaObject
		{
			var res:VideoMedia = new VideoMedia();
			res.unlistenForChange();
			res.setPos(x,y,width,height,rotation);
			res.url = url;
			res.autoplay = autoplay;
			res.mute = mute;
			res.loop = loop;
			res.listenForChange();
			return res;
		}
		
		override public function parseXML(xml:XML):void {
			if (xml) {
				super.parseXML(xml);
				unlistenForChange();
				url = String(xml.@url);
				displayName = xml.@displayName;
				autoplay = DataUtil.parseBoolean(xml.@autoPlay);
				loop = DataUtil.parseBoolean(xml.@loop);
				mute = DataUtil.parseBoolean(xml.@mute);
				listenForChange();
			}
		}
		
		public static function mediaFromXML(xml:XML):VideoMedia {
			var result:VideoMedia;
			if (xml) {
				result=new VideoMedia();
				result.parseXML(xml);
			}
			return result;
		}
		
		override public function convertToXML():XML {
			var tag:XML = <slideObject></slideObject>;
			
			appendToXML(tag);			
			
			tag.@url = url;
			tag.@displayName = displayName;
			if (autoplay)
				tag.@autoPlay = autoplay;
			if (loop)
				tag.@loop = loop;
			if (mute)
				tag.@mute = mute;
			
			return tag;
		}
	}
}