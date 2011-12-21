package uk.co.itrainconsulting.common.model.mediaObjects
{
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.contentbuilder.model.Constants;
	import uk.co.itrainconsulting.common.model.EnumObjectType;

	[Bindable]
	[RemoteClass]
	public class AudioMedia extends MediaObject
	{
		public var url:Object;
		public var autoPlay:Boolean;
		public var muted:Boolean;
		public var loop:Boolean;
		public var displayName:String;
		public function AudioMedia()
		{
			unlistenForChange();
			mediaType = EnumObjectType.AUDIO;
			setPos(10,10,175,30,0);
			autoPlay = false;
			loop = false;
			muted = false;
			listenForChange();
		}
		override public function clone():MediaObject
		{
			var res:AudioMedia = new AudioMedia();
			res.unlistenForChange();
			res.url = url;
			res.setPos(x,y,width,height,rotation);
			res.autoPlay = autoPlay;
			res.muted = muted;
			res.loop = loop;
			res.displayName = displayName; 
			res.listenForChange();
			return res;
		}
		
		override public function parseXML(xml:XML):void {
			if (xml) {
				super.parseXML(xml);
				unlistenForChange();
				displayName = xml.@displayName;
				url = String(xml.@url);
				autoPlay = DataUtil.parseBoolean(xml.@autoPlay);
				loop = DataUtil.parseBoolean(xml.@loop);
				muted = DataUtil.parseBoolean(xml.@mute);
				listenForChange();
			}
		}
		
		public static function mediaFromXML(xml:XML):AudioMedia {
			var result:AudioMedia;
			if (xml) {
				result=new AudioMedia();
				result.parseXML(xml);
			}
			return result;
		}
		
		override public function convertToXML():XML {
			var tag:XML = <slideObject></slideObject>;
			
			appendToXML(tag);			
			tag.@displayName = displayName;
			tag.@url = url;
			if (autoPlay)
				tag.@autoPlay = autoPlay;
			if (loop)
				tag.@loop = loop;
			if (muted)
				tag.@muted = muted;
			
			return tag;
		}
	}
}