package uk.co.itrainconsulting.common.model.mediaObjects {
    import uk.co.itrainconsulting.common.model.EnumObjectType;
    import uk.co.itrainconsulting.common.utils.DataUtil;
    import uk.co.itrainconsulting.contentbuilder.model.Constants;

    [Bindable]
	[RemoteClass]
    public class ImageMedia extends MediaObject {

        public var url:Object=null;
		public var alpha:Number = 1.0;
		
        public static function mediaFromXML(xml:XML):ImageMedia {
            var result:ImageMedia;
            if (xml) {
                result=new ImageMedia();
                result.parseXML(xml);
            }
            return result;
        }

        public function ImageMedia(url:Object="", display_name:String="") {
            unlistenForChange();
            this.url=url;
            mediaType=EnumObjectType.IMAGE;
			setPos(0, 0, 50, 50, 0);
            listenForChange();
        }

        override public function parseXML(xml:XML):void {
            if (xml) {
                super.parseXML(xml);
				unlistenForChange();
                url=String(xml.@url);
				alpha = DataUtil.getAlpha(xml.@alpha);
                useHandCursor=DataUtil.parseBoolean(xml.@useHandCursor);
				slideToGo = DataUtil.getGoToSlide(xml.@slideToGo);
                urlToGo=xml.@urlToGo ? xml.@urlToGo : "";
				listenForChange();
            }
        }

        override public function clone():MediaObject {
            var res:ImageMedia=new ImageMedia(url);
            res.unlistenForChange();
            res.setPos(x, y, width, height, rotation);
            res.slideToGo=slideToGo;
			res.alpha = alpha;
            res.urlToGo=urlToGo;
            res.useHandCursor=useHandCursor;
            res.listenForChange();
            return res;
        }
		
		override public function convertToXML():XML {
			var tag:XML = <slideObject></slideObject>;
			
			appendToXML(tag);			
			tag.@url=url;
			if (alpha < 1.0)
				tag.@alpha = alpha;
			if (useHandCursor)
				tag.@useHandCursor=useHandCursor;
			if (slideToGo != -1)
				tag.@slideToGo=slideToGo;
			if (urlToGo)
				tag.@urlToGo=urlToGo;
			
			return tag;
		}
    }
}
