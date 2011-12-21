package uk.co.itrainconsulting.common.view.objectHandleObjects {
    import flash.events.MouseEvent;
    
    import mx.binding.utils.BindingUtils;
    import mx.events.PropertyChangeEvent;
    import mx.states.OverrideBase;
    
    import spark.components.Button;
    
    import uk.co.itrainconsulting.common.model.mediaObjects.ButtonMedia;
    import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;

    [Bindable]
    public class SimpleResizableButton extends Button implements IModelAware {
        public var _model:ButtonMedia;

        public function SimpleResizableButton(model:ButtonMedia) {
            _model=model;
            if (_model)
                bindProperties();
        }

        public function get model():MediaObject {
            return _model;
        }

        protected function bindProperties():void {
            BindingUtils.bindProperty(this, "x", _model, "x");
            BindingUtils.bindProperty(this, "y", _model, "y");
            BindingUtils.bindProperty(this, "width", _model, "width");
            BindingUtils.bindProperty(this, "height", _model, "height");
            BindingUtils.bindProperty(this, "rotation", _model, "rotation");
            BindingUtils.bindProperty(this, "label", _model, "label");
            BindingUtils.bindProperty(this, "alpha", _model, "alpha");
            BindingUtils.bindProperty(this, "useHandCursor", _model, "useHandCursor");
            BindingUtils.bindProperty(this, "buttonMode", _model, "useHandCursor");
			
			var thisButton:SimpleResizableButton = this;
			
            BindingUtils.bindSetter(function(value:int):void {
				thisButton.setStyle('cornerRadius', value);
            }, _model, "cornerRadius");
            BindingUtils.bindSetter(function(value:uint):void {
				thisButton.setStyle('chromeColor', value);
            }, _model, "colour");
            BindingUtils.bindSetter(function(value:int):void {
				thisButton.setStyle('fontSize', value);
            }, _model, "fontSize");
            BindingUtils.bindSetter(function(value:int):void {
				thisButton.setStyle('color', value);
            }, _model, "fontColour");
            BindingUtils.bindSetter(function(value:Number):void {
				thisButton.setStyle('textAlpha', value);
            }, _model, "labelAlpha");
        }
    }
}
