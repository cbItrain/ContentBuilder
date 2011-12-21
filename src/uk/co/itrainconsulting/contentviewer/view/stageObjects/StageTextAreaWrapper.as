package uk.co.itrainconsulting.contentviewer.view.stageObjects
{
	import uk.co.itrainconsulting.common.model.mediaObjects.TextMedia;

	public class StageTextAreaWrapper extends StageTextAreaWrapperBase
	{
		private var _model:TextMedia;
		
		public function StageTextAreaWrapper(model:TextMedia)
		{
			super();
			this.model = model;
			if (model)
				txtTextArea.htmlText = model.htmlText;
		}
		
		[Bindable]
		override public function get model():TextMedia {
			return _model;
		}
		
		override public function set model(value:TextMedia):void {
			_model = value;
		}
	}
}