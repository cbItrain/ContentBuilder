package uk.co.itrainconsulting.common.model
{
	import mx.utils.ObjectUtil;
	
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.contentbuilder.model.EnumImageBGType;
	import uk.co.itrainconsulting.contentbuilder.utils.SlideUtils;

	[Bindable]
	public class ContentProperties
	{
		public var title:String;
		public var width:Number;
		public var height:Number;
		public var bgColor:uint;
		public var bgImage:Object;
		public var bgImageMethod:EnumImageBGType;
		public var hasBGImage:Boolean = false;
		public var showSlideList:Boolean = true;
		public var stageColors:Array = [];
		
		public function ContentProperties()
		{
			
		}
		
		public function getDeepCopy():ContentProperties {
			var result:ContentProperties = new ContentProperties();
			result.title = this.title;
			result.width = this.width;
			result.height = this.height;
			result.bgColor = this.bgColor;
			result.bgImage = (this.bgImage is String) ? this.bgImage : ObjectUtil.copy(this.bgImage);
			result.bgImageMethod = this.bgImageMethod;
			result.hasBGImage = this.hasBGImage;
			result.showSlideList = this.showSlideList;
			this.stageColors.forEach(function (o:Object, i:int, array:Array):void {
				result.stageColors.push(o);
			});
			return result;
		}
		
		public function equals(cp:ContentProperties):Boolean {
//			return this.title == cp.title && this.width == cp.width && this.height == cp.height
//				&& this.bgColor == cp.bgColor && ObjectUtil.compare(this.bgImage, cp.bgImage) == 0
//				&& this.hasBGImage == cp.hasBGImage && this.showSlideList == cp.showSlideList
//				&& this.stageColors.toString() == cp.stageColors.toString();
			return ObjectUtil.compare(cp, this, 0) == 0;
		}
		
		public function setup(props:XMLList):void{
			title = props.@title;
			height = props.@height;
			width = props.@width;
			bgColor = props.@backgroundColor;
			bgImage = props.@bgImage as String;
			showSlideList = DataUtil.parseBoolean(props.@showSlideList);
			if (bgImage)
				hasBGImage = true;
			bgImageMethod = SlideUtils.getBackgroundImageMode(props.@bgImageMethod);
			var stageColorsList:XMLList = props.stageColors.color;
			for each(var col:XML in stageColorsList)
			{
				stageColors.push(uint(col));
			}
		}
	}
}