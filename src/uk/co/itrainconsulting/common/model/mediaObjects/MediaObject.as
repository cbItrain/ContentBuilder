package uk.co.itrainconsulting.common.model.mediaObjects 
{

    import com.objecthandles.IMoveable;
    import com.objecthandles.IResizeable;
    
    import uk.co.itrainconsulting.common.model.EnumObjectType;
    import uk.co.itrainconsulting.contentbuilder.model.ChangeAwareModel;
    import uk.co.itrainconsulting.contentbuilder.model.Constants;

    [Bindable]
	[RemoteClass]
    public class MediaObject extends ChangeAwareModel implements IMediaObject, IResizeable, IMoveable {
        public var mediaType:EnumObjectType;
		
        public var x:Number;
        public var y:Number;
        public var width:Number;
        public var height:Number;
        public var rotation:Number;

        public var slideToGo:int=-1;
        public var useHandCursor:Boolean=false;
        public var urlToGo:String="";

        public var appearAt:Number=0;
        public var appearType:String=Constants.APPEAR_INSTANT;
        public var appearDuration:Number=0;

        public function MediaObject() {

        }

        public function setPos(x:Number, y:Number, w:Number, h:Number, r:Number=0):void {
            this.x=x;
            this.y=y;
            this.width=w;
            this.height=h;
            this.rotation=r;
        }

        public function parseXML(xml:XML):void {
            if (xml) {
                unlistenForChange();
                setPos(Number(xml.@x), Number(xml.@y), Number(xml.@width), Number(xml.@height), xml.@rotation ? Number(xml.@rotation) : 0);
                listenForChange();
            }
        }

        public function clone():MediaObject {
            var res:MediaObject=new MediaObject();
            res.unlistenForChange();
            res.setPos(x, y, width, height, rotation);
			res.mediaType = new EnumObjectType(mediaType.ordinal);
            res.listenForChange();
            return res;
        }
		
		protected function appendToXML(xml:XML):void {
			if (xml) {
				xml.@width= int(width);
				xml.@height = int(height);
				xml.@x = int(x);
				xml.@y = int(y);
				if (rotation)
					xml.@rotation = int(rotation);
				
				xml.@type = mediaType.ordinal;
			}
		}
		
		//overriden
		public function convertToXML():XML {
			return null;
		}
    }
}
