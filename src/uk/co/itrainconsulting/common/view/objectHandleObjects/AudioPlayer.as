package uk.co.itrainconsulting.common.view.objectHandleObjects
{
	import mx.binding.utils.BindingUtils;
	
	import uk.co.itrainconsulting.common.model.mediaObjects.AudioMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;

	public class AudioPlayer extends AudioPlayerBase
	{		
		private var _model:AudioMedia;

		public function AudioPlayer(model:AudioMedia)
		{
			_model=model;
			if (_model)
				bindProperties();
		}
		
		override public function get model():MediaObject {
			return _model;
		}
		
		protected function bindProperties():void {
			BindingUtils.bindProperty(this, "x", _model, "x");
			BindingUtils.bindProperty(this, "y", _model, "y");
			BindingUtils.bindProperty(this, "width", _model, "width");
			BindingUtils.bindProperty(this, "height", _model, "height");
			BindingUtils.bindProperty(this, "rotation", _model, "rotation");
			BindingUtils.bindSetter(function (value:String):void {
				source = value;
				if (source)
					initSound();
			}, _model, "url");
		}
	}
}