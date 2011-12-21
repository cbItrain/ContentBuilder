package uk.co.itrainconsulting.common.model
{
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.contentbuilder.utils.SlideUtils;
	import uk.co.itrainconsulting.contentbuilder.model.EnumImageBGType;

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
		public function setup(props:XMLList):void{
			title = props.@title;
			height = props.@height;
			width = props.@width;
			bgColor = props.@backgroundColor;
			bgImage = props.@bgImage;
			showSlideList = DataUtil.parseBoolean(props.@showSlideList);
			if (bgImage != "")
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