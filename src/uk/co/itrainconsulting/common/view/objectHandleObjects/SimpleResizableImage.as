package uk.co.itrainconsulting.common.view.objectHandleObjects {

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.PixelSnapping;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;
    
    import mx.binding.utils.BindingUtils;
    import mx.controls.Image;
    import mx.events.PropertyChangeEvent;
    
    import uk.co.itrainconsulting.common.events.ImageRepositoryEvent;
    import uk.co.itrainconsulting.common.model.mediaObjects.ImageMedia;
    import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
    import uk.co.itrainconsulting.common.utils.DomainUtils;
    import uk.co.itrainconsulting.common.utils.ImageRepository;
    import uk.co.itrainconsulting.common.utils.LocalImageLoader;
    import uk.co.itrainconsulting.contentbuilder.model.fileupload.FileReferenceWrapper;


    public class SimpleResizableImage extends Image implements IModelAware {

        private var _model:ImageMedia;
		
		private var _oWidth:int = -1;
		private var _oHeight:int = -1;

        private static const _repository:ImageRepository=ImageRepository.getInstance();
        private static const _localLoader:LocalImageLoader=LocalImageLoader.getInstance();

        public function SimpleResizableImage(model:ImageMedia) {
            _model=model;
            if (_model)
                bindProperties();
            this.smoothBitmapContent=true;
            scaleContent=true;
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
            BindingUtils.bindProperty(this, "source", _model, "url");
            BindingUtils.bindProperty(this, "alpha", _model, "alpha");
            BindingUtils.bindProperty(this, "buttonMode", _model, "useHandCursor");
            BindingUtils.bindProperty(this, "useHandCursor", _model, "useHandCursor");
        }

        override public function get content():DisplayObject {
            var dispObj:DisplayObject;
            try {
                dispObj=super.content;
            } catch (e:SecurityError) {
                dispObj=null;
            }
            return dispObj;
        }
		
		public function get originalWidth():int {
			if (_oWidth > -1)
				return _oWidth;
			else if (content) {
				return contentWidth;
			} else {
				return width;
			}
		}
		
		public function get originalHeight():int {
			if (_oHeight > -1)
				return _oHeight;
			else if (content) {
				return contentHeight;
			} else {
				return height;
			}
		}

        override public function set source(value:Object):void {
            if (value is String) {
                var url:String=value as String;
                if (url) {
                    if (DomainUtils.isURLFromOutside(url))
                        super.source=url;
                    else {
                        var bd:BitmapData=_repository.imageData(url, true, this);
                        if (bd) {
                            source=new Bitmap(bd, PixelSnapping.AUTO, true);
                            this.dispatchEvent(new ImageRepositoryEvent(ImageRepositoryEvent.IMAGE_UPDATED));
                        }
                    }
                } else {
                    super.source=null;
                }
            } else if (value is ByteArray) {
                _localLoader.loadLocal(value as ByteArray, this);
            } else if (value is Bitmap) {
				_oWidth = (value as Bitmap).width;
				_oHeight = (value as Bitmap).height;
                super.source=value;
            } else {
				super.source=value;
			}
        }
    }
}