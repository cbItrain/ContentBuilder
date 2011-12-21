package uk.co.itrainconsulting.common.view.objectHandleObjects
{
	import mx.binding.utils.BindingUtils;
	import mx.events.PropertyChangeEvent;
	
	import spark.components.VideoPlayer;
	
	import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
	import uk.co.itrainconsulting.common.model.mediaObjects.VideoMedia;
	
	public class SimpleResizableVideo extends VideoPlayer implements IModelAware
	{
		protected var _model:VideoMedia;
		
		public function SimpleResizableVideo(model:VideoMedia)
		{
			_model = model;
			if (_model)
				bindProperties();
			autoPlay = false;
			loop = true;
		}
		override public function stop():void{
			if (source != null && source != "")
				super.stop();
		}

		public function get model():MediaObject
		{
			return _model;
		}
		
		protected function bindProperties():void
		{
			BindingUtils.bindProperty(this, "x", _model, "x");
			BindingUtils.bindProperty(this, "y", _model, "y");
			BindingUtils.bindProperty(this, "width", _model, "width");
			BindingUtils.bindProperty(this, "height", _model, "height");
			BindingUtils.bindProperty(this, "rotation", _model, "rotation");
			BindingUtils.bindProperty(this, "source", _model, "url");
		}
	}
}