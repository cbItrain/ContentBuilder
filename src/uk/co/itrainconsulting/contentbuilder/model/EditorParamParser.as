package uk.co.itrainconsulting.contentbuilder.model
{
	import spark.components.Application;
	
	import uk.co.itrainconsulting.content.common.model.ParamParser;
	
	public class EditorParamParser extends ParamParser
	{
		public function EditorParamParser(context:Application)
		{
			super(context);
		}
		
		override public function parseFlashVars() : Object
		{
			var o:Object = super.parseFlashVars();
			o.beforeUnloadFunction = context.parameters.beforeUnloadFunction;
			o.serviceSettings.update = {};
			o.serviceSettings.update.url = context.parameters.saveContent;
			o.serviceSettings.searchAssests = {};
			o.serviceSettings.searchAssests.url = context.parameters.getList;
			
			o.pageId = context.parameters.pageId;
			return o;
		}
	}
}