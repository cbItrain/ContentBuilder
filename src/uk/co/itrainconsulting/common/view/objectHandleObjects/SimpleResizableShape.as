package uk.co.itrainconsulting.common.view.objectHandleObjects
{
	import mx.binding.utils.BindingUtils;
	
	import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
	import uk.co.itrainconsulting.common.model.mediaObjects.ShapeMedia;

	public class SimpleResizableShape extends SimpleResizableShapeBase
	{
		
		
		public function SimpleResizableShape(model:ShapeMedia)
		{
			this.model=model;
			
			if (_model)
				bindProperties();
		}
		
		private function bindProperties():void {
			BindingUtils.bindProperty(this, "x", _model, "x");
			BindingUtils.bindProperty(this, "y", _model, "y");
			BindingUtils.bindProperty(this, "width", _model, "width");
			BindingUtils.bindProperty(this, "height", _model, "height");
			BindingUtils.bindProperty(this, "rotation", _model, "rotation");
			BindingUtils.bindProperty(this, "useHandCursor", _model, "useHandCursor");
			BindingUtils.bindProperty(this, "buttonMode", _model, "useHandCursor");
		}
	}
}