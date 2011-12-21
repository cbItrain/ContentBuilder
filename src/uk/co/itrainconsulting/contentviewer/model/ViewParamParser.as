package uk.co.itrainconsulting.contentviewer.model
{
	import spark.components.Application;
	
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.content.common.model.ParamParser;
	
	public class ViewParamParser extends ParamParser
	{
		public function ViewParamParser(context:Application)
		{
			super(context);
		}
		
		override public function parseFlashVars() : Object
		{
			var o:Object = super.parseFlashVars();
			o.showEndMessage = DataUtil.parseBoolean(context.parameters.showEndMessage);
			o.nextPageType = context.parameters.nextPageType;
			o.showSlideList = context.parameters.showSlideList;
			
			o.trackFunction = String(context.parameters.trackFunction);
			o.nextPageFunction = String(context.parameters.nextPageFunction);
			
			o.getAllSlidesFunction = context.parameters.getAllSlidesFunction;
			o.getCurrentSlideIndexFunction = context.parameters.getCurrentSlideIndexFunction;
			o.setNewContentFunction = context.parameters.setNewContentFunction;
			o.changeShowSlideListFunction = context.parameters.changeShowSlideListFunction;
			o.getSlidesCountFunction = context.parameters.getSlidesCountFunction;
			o.showLastSlideFunction = context.parameters.showLastSlideFunction;
			o.showFirstSlideFunction = context.parameters.showFirstSlideFunction;
			o.showPreviousSlideFunction = context.parameters.showPreviousSlideFunction;
			o.showNextSlideFunction = context.parameters.showNextSlideFunction;
			o.showSlideAtFunction = context.parameters.showSlideAtFunction;
			o.loadContentFunction = context.parameters.loadContentFunction;
			
			o.topGap = context.parameters.topGap;
			o.rightGap = context.parameters.rightGap;
			o.bottomGap = context.parameters.bottomGap;
			o.leftGap = context.parameters.leftGap;
			return o;
		}
	}
}