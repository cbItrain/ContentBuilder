package uk.co.itrainconsulting.contentbuilder.model
{
	import flash.events.IEventDispatcher;
	
	import spark.skins.spark.HighlightBitmapCaptureSkin;
	
	import uk.co.itrainconsulting.common.events.ServiceEvent;
	import uk.co.itrainconsulting.contentbuilder.control.events.MessageEvent;

	public class MessageBean
	{
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Mediate(event="ServiceEvent.CONTENT_SAVED")]
		public function onContentSaved():void {
			showMessage("Presentation has been saved", null, "", "", true);
		}
		
		[Mediate(event="ServiceEvent.CONTENT_SAVE_FAILED")]
		public function onContentSaveFailure(se:ServiceEvent):void {
			showMessage("An Error has occured during the saving process", EnumMessageSeverity.MAJOR, se.data.description, se.data.technical);
		}
		
		[Mediate(event="ServiceEvent.CONTENT_LOAD_FAILED")]
		public function onContentLoadFailure(se:ServiceEvent):void {
			showMessage("An Error has occured during data loading process", EnumMessageSeverity.MAJOR, se.data.description, se.data.technical);
		}
		
		private function showMessage(message:String, severity:EnumMessageSeverity = null, description:String = "", additionalInfo:String = "", highPriority:Boolean = false):void {
			var me:MessageEvent = new MessageEvent(MessageEvent.SHOW_MESSAGE, true);
			me.message = message;
			me.description = description;
			me.additionalInfo = additionalInfo;
			me.highPriority = highPriority;
			if (!severity)
				severity = EnumMessageSeverity.NORMAL;
			me.messageSeverity = severity;
			dispatcher.dispatchEvent(me);
		}
	}
}