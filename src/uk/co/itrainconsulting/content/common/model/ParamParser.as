package uk.co.itrainconsulting.content.common.model
{
	import spark.components.Application;
	
	import uk.co.itrainconsulting.common.utils.DataUtil;
	import uk.co.itrainconsulting.contentbuilder.model.WrapperDispatcher;

	public class ParamParser
	{
		protected var context:Application;
		
		public function ParamParser(context:Application)
		{
			this.context = context;
		}
		
		public function parseFlashVars():Object
		{
			var lessonId:int = context.parameters.id ? Number(context.parameters.id) : Number(context.parameters.lessonId);
			var o:Object = {};
			o.lessonId = lessonId;
			o.published = context.parameters.published;
			o.allowScaling = DataUtil.parseBoolean(context.parameters.allowScaling);
			o.loadContentURL = context.parameters.loadContentURL;
			o.playerModuleURL = (context.parameters.playerModuleURL) ? context.parameters.playerModuleURL : "PlayerModule.swf";
			o.saveContentURL = context.parameters.saveContentURL;
			o.getAttachmentsURL = context.parameters.getAttachmentsURL;
			o.getAssetsURL = context.parameters.getAssetsURL;
			o.getTemplateURL = context.parameters.getTemplateURL;
			o.uploadAttachmentURL = context.parameters.uploadAttachmentURL;
			o.uploadAssetsURL = context.parameters.uploadAssetsURL;
			
			o.debug = {};
			o.serviceSettings = {};
			o.serviceSettings.apiVersion = context.parameters.apiVersion;
			o.debug.on = DataUtil.parseBoolean(context.parameters.isDebug);
			o.debug.url = context.parameters.debugUrl;
			var wdn:String = context.parameters.dispatcherName;
			o.wrapperDispatcher = WrapperDispatcher.create(wdn);
			o.closeFunction = context.parameters.closeFunction;
			
			return o;
		}
	}
}