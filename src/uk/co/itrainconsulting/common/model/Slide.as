package uk.co.itrainconsulting.common.model
{
	import mx.collections.ArrayCollection;
	
	import uk.co.itrainconsulting.common.model.mediaObjects.AudioMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.ButtonMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.ImageMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
	import uk.co.itrainconsulting.common.model.mediaObjects.ShapeMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.TextMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.VideoMedia;
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.common.utils.MediaUtils;
	import uk.co.itrainconsulting.contentbuilder.model.ChangeAwareModel;
	import uk.co.itrainconsulting.contentbuilder.model.EnumBGType;
	import uk.co.itrainconsulting.contentbuilder.model.EnumImageBGType;
	import uk.co.itrainconsulting.contentbuilder.utils.SlideUtils;

	[Bindable]
	[RemoteClass]
	public class Slide extends ChangeAwareModel
	{
		
		public var title:String = "";
		public var width:int = 0;
		public var height:int = 0;
		public var bgCol1:uint = 0;
		public var bgCol2:uint = 0;
		public var bgImage:Object = "";
		public var bgImageMethod:EnumImageBGType = EnumImageBGType.REPEAT;
		public var customDimensions:Boolean = false;
		public var customBackground:Boolean = false;
		public var backgroundType:EnumBGType = EnumBGType.DEFAULT;
		public var imageBGShowing:Boolean = false;
		public var stageObjects:ArrayCollection = new ArrayCollection();
		
		public var fromTemplate:Boolean = false;
		public var description:String = "";
		
		public function Slide(){}
		
		public function addXMLObject(o:XML):void {
			stageObjects.addItem(xmlToMediaObject(o));
		}
		
		public static function xmlToMediaObject(o:XML):MediaObject {
			var mo :MediaObject;
			var mediaType:EnumObjectType = MediaUtils.getMediaType(o.@type);
			switch (mediaType.ordinal) {
				case EnumObjectType.IMAGE.ordinal: mo = ImageMedia.mediaFromXML(o); break;
				case EnumObjectType.TEXT.ordinal: mo = TextMedia.mediaFromXML(o); break;
				case EnumObjectType.VIDEO.ordinal: mo = VideoMedia.mediaFromXML(o); break;
				case EnumObjectType.AUDIO.ordinal: mo = AudioMedia.mediaFromXML(o); break;
				case EnumObjectType.SHAPE.ordinal: mo = ShapeMedia.mediaFromXML(o); break;
				case EnumObjectType.BUTTON.ordinal: mo = ButtonMedia.mediaFromXML(o); break;
				
			}
			return mo;
		}
		
		public function addNewMedia(mo:MediaObject):void{
			stageObjects.addItemAt(mo,0);
		}
		
		public function addNewMediaAt(mo:MediaObject, index:int):void {
			stageObjects.addItemAt(mo, index);
		}
		
		public function deleteMedia(mo:MediaObject):void{
			stageObjects.removeItemAt(stageObjects.getItemIndex(mo));
		}
		
		public function moveObjectBack(mo:MediaObject):int{
			var currI:int = stageObjects.getItemIndex(mo);
			var totalItems:int = stageObjects.length;
			if (currI < totalItems-1)
				stageObjects.addItemAt(stageObjects.removeItemAt(currI),currI+1);
			return currI;
		}
		
		public function moveObjectForwards(mo:MediaObject):int{
			var currI:int = stageObjects.getItemIndex(mo);
			var totalItems:int = stageObjects.length;
			
			if (currI > 0)
				stageObjects.addItemAt(stageObjects.removeItemAt(currI),currI-1);
			return currI;
		}
		
		public function moveObjectToBack(img:MediaObject):int{
			var totalItems:int = stageObjects.length;
			var currI:int = stageObjects.getItemIndex(img);
			stageObjects.addItemAt(stageObjects.removeItemAt(currI),totalItems-1);
			return currI;
		}
		
		public function moveObjectToFront(img:MediaObject):int{
			var currI:int = stageObjects.getItemIndex(img);
			stageObjects.addItemAt(stageObjects.removeItemAt(currI),0);
			return currI;
		}
		
		public function getStageObjectIndex(mo:MediaObject):int {
			return stageObjects.getItemIndex(mo);
		}
		
		public function clone():Slide
		{
			var s:Slide = new Slide();
			s.unlistenForChange();
			s.backgroundType = this.backgroundType;
			s.bgCol1 = this.bgCol1;
			s.bgCol2 = this.bgCol2;
			s.bgImage = this.bgImage;
			s.bgImageMethod = this.bgImageMethod;
			s.customBackground = this.customBackground;
			s.customDimensions = this.customDimensions;
			s.height = this.height;
			s.imageBGShowing = this.imageBGShowing;
			s.title = this.title;
			s.width = this.width;
			for (var i:int = 0, ix:int = stageObjects.length; i < ix; i++)
			{
				s.stageObjects.addItem(this.stageObjects.getItemAt(i).clone());				
			}
			s.listenForChange();
			return s;
		}
		
		public function generateXML(defaults:ContentProperties):XML
		{
			var res:XML = <slide>
				</slide>;
			res.@title = title;
			if (customDimensions)
			{
				res.@customDimensions = customDimensions;
				res.@width = width;
				res.@height = height;
			}
			if (customBackground)
			{
				res.@customBackground = customBackground;
				res.@bgCol1 = bgCol1;
				res.@bgCol2 = bgCol2;
				if (imageBGShowing)
				{
					res.@bgImage = bgImage;
					res.@bgImageMethod = bgImageMethod.ordinal;
				}
			}
			var so:XML;
			for (var i:int = 0, ix:int = stageObjects.length; i < ix; i++)
			{
				res.appendChild((stageObjects.getItemAt(i) as MediaObject).convertToXML());
			}
			return res;
		}
		
		public function parseXML(xml:XML, defaults:ContentProperties):void {
			if (xml && defaults) {
				unlistenForChange();
				title = xml.@title;
				
				// Height and widths
				customDimensions = DataUtil.parseBoolean(xml.@customDimensions);
				if(customDimensions) {
					if (xml.@width == "" || xml.@width == undefined)
						width = defaults.width;
					else {
						width = int(xml.@width);
					}
					if (xml.@height == "" || xml.@height == undefined)
						height = defaults.height;
					else {
						height = int(xml.@height);
					}
				} else {
					width = defaults.width;
					height = defaults.height;
				}

				
				
				// BG
				customBackground = DataUtil.parseBoolean(xml.@customBackground);
				if (customBackground)
				{
					if (xml.@bgCol1 == "" || xml.@bgCol1 == undefined )
						bgCol1 = defaults.stageColors[0];
					else {
						bgCol1 = uint(xml.@bgCol1);	
					}
					if (xml.@bgCol2 == "" || xml.@bgCol2 == undefined)
						bgCol2 = defaults.stageColors[1];
					else {
						bgCol2 = uint(xml.@bgCol2);
					}
					backgroundType = EnumBGType.GRADIENT;
					if (xml.@bgImage != "" && xml.@bgImage != undefined)
					{
						bgImage = xml.@bgImage;
						if (xml.@bgImageMethod == "" || xml.@bgImageMethod == undefined)
							bgImageMethod = defaults.bgImageMethod;
						else 
							bgImageMethod = SlideUtils.getBackgroundImageMode(xml.@bgImageMethod);
						backgroundType = EnumBGType.IMAGE;
					} else if(defaults.hasBGImage){
						bgImage = defaults.bgImage;
						bgImageMethod = defaults.bgImageMethod;
					}
				} else {
					bgCol1 = defaults.stageColors[0];
					bgCol2 = defaults.stageColors[1];
					if (defaults.hasBGImage)
					{
						bgImage = defaults.bgImage;
						bgImageMethod = defaults.bgImageMethod;
					}
					backgroundType = EnumBGType.DEFAULT;
				}
				
				//templates
				fromTemplate = DataUtil.parseBoolean(xml.@fromTemplate);
				if (fromTemplate) {
					description = xml.@description;
				}

				imageBGShowing = ((backgroundType.equals(EnumBGType.DEFAULT) && defaults.hasBGImage) || backgroundType.equals(EnumBGType.IMAGE));
				
				var slideObjectsList:XMLList = xml.slideObject;
				for each(var col:XML in slideObjectsList)
				{
					addXMLObject(col);
				}
				listenForChange();
			}
		}
	}
}