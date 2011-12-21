package uk.co.itrainconsulting.contentviewer.view.stageObjects
{
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	
	import spark.components.RichEditableText;

	
	public class StageTextArea extends RichEditableText
	{
		public function StageTextArea()
		{
			super();
			editable = false;
			selectable = false;
			setStyle("contentBackgroundAlpha", 0);
			height = 300;
			width = 100;
			setStyle("borderVisible", false);
			editable = false;
		}
		
		public function set htmlText(value:String):void {
			this.textFlow = TextConverter.importToFlow(value, TextConverter.TEXT_FIELD_HTML_FORMAT);
		}
	}
}