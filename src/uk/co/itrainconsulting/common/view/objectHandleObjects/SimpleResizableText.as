package uk.co.itrainconsulting.common.view.objectHandleObjects {
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.ui.Keyboard;
    
    import flashx.textLayout.conversion.ConversionType;
    import flashx.textLayout.conversion.TextConverter;
    import flashx.textLayout.elements.TextFlow;
    
    import itrain.co.uk.components.InPlaceTextEditor;
    import itrain.co.uk.events.InPlaceTextEditorEvent;
    
    import mx.binding.utils.BindingUtils;
    import mx.binding.utils.ChangeWatcher;
    import mx.controls.Image;
    import mx.controls.TextArea;
    import mx.core.IVisualElement;
    import mx.events.FlexEvent;
    import mx.events.PropertyChangeEvent;
    
    import spark.components.Button;
    import spark.components.Group;
    import spark.components.VGroup;
    
    import uk.co.itrainconsulting.common.CommonDefaults;
    import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
    import uk.co.itrainconsulting.common.model.mediaObjects.TextMedia;
    import uk.co.itrainconsulting.common.utils.Common;
    import uk.co.itrainconsulting.contentbuilder.control.events.CopyPasteEvent;
    import uk.co.itrainconsulting.contentbuilder.view.baseComponents.DotedFrame;

    public class SimpleResizableText extends Group implements IModelAware {

        private var _cornerObject:IVisualElement;
        private var _textEditor:InPlaceTextEditor;
        private var _textEditorContainer:VGroup;
        private var _dottedFrame:DotedFrame;

		private var _model:TextMedia;
		
        private var _modelTextW:ChangeWatcher;
		private var _editable:Boolean;

        [Embed('assets/icons/advTextIcon.svg')]
        private var advTextIcon:Class;

        public function SimpleResizableText(model:TextMedia, editable:Boolean = true) {
            super();
            _model=model;
			_editable = editable;
			if (_model)
            	applyBindingsToTheModel();
            this.addEventListener(MouseEvent.CLICK, onMouseClick);
        }

        public function get model():MediaObject {
            return _model;
        }
		
		public function set frameVisible(value:Boolean):void {
			_dottedFrame.visible = value;
		}
		
		public function get frameVisible():Boolean {
			return _dottedFrame.visible;
		}

        override protected function createChildren():void {
            super.createChildren();
            if (!_dottedFrame) {
                _dottedFrame=new DotedFrame();
				frameVisible = false;
                this.addElement(_dottedFrame);
            }
            if (!_textEditorContainer) {
                _textEditorContainer=new VGroup();
                _textEditorContainer.percentWidth=100;
                _textEditorContainer.percentHeight=100;
                _textEditorContainer.clipAndEnableScrolling=true;
				if (_editable) {
					_textEditorContainer.paddingBottom = CommonDefaults.TEXT_OBJECT_PADDING;
					_textEditorContainer.paddingLeft = CommonDefaults.TEXT_OBJECT_PADDING;
					_textEditorContainer.paddingRight = CommonDefaults.TEXT_OBJECT_PADDING;
					_textEditorContainer.paddingTop = CommonDefaults.TEXT_OBJECT_PADDING;
				}
                this.addElement(_textEditorContainer);
            }
            if (!_textEditor) {
                _textEditor=new InPlaceTextEditor(true, this);
                _textEditor.percentWidth=100;
                _textEditor.percentHeight=100;
                _textEditor.mouseEnabled=_textEditor.selectable=_textEditor.editable=true;
				_textEditor.addEventListener(InPlaceTextEditorEvent.DELETE_CLICKED, onDeleteItem);
                _textEditorContainer.addElement(_textEditor);
            }
            if (!_cornerObject) {
                _cornerObject=createCornerObject();
            }
            bindChildren();
        }
		
		private function onDeleteItem(e:Event):void {
			var ke:KeyboardEvent=new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.DELETE);
			dispatchEvent(ke);
		}
		
		override public function set width(value:Number):void {
			var result:Number = value;
			if (_editable) 
				result += 2*CommonDefaults.TEXT_OBJECT_PADDING;
			super.width = result;
		}
		
		override public function set height(value:Number):void {
			var result:Number = value;
			if (_editable) 
				result += 2*CommonDefaults.TEXT_OBJECT_PADDING;
			super.height = result;
		}
		
		override public function set x(value:Number):void {
			var result:Number = value;
			if (_editable) 
				result -= CommonDefaults.TEXT_OBJECT_PADDING;
			super.x = result;
		}
		
		override public function set y(value:Number):void {
			var result:Number = value;
			if (_editable) 
				result -= CommonDefaults.TEXT_OBJECT_PADDING;
			super.y = result;
		}

        private function createCornerObject():IVisualElement {
            var btn:Button=new Button;
            btn.label='AT';
            btn.bottom=-30;
            btn.left=0;
            btn.width=30;
            btn.height=30;
            btn.enabled=false;
            btn.alpha=.7;
            btn.setStyle('fontSize', 8);
            return btn;
        }


        private function onMouseClick(me:MouseEvent):void {
            me.stopImmediatePropagation();
        }

        private function applyBindingsToTheModel():void {
            BindingUtils.bindProperty(this, "x", _model, "x");
            BindingUtils.bindProperty(this, "y", _model, "y");
            BindingUtils.bindProperty(this, "width", _model, "width");
            BindingUtils.bindProperty(this, "height", _model, "height");
            BindingUtils.bindProperty(this, "rotation", _model, "rotation");
            BindingUtils.bindSetter(onUseHandCursorChange, _model, "useHandCursor");
        }

        private function unbindTextEditorText():void {
            _textEditor.removeEventListener(InPlaceTextEditorEvent.TEXT_CHANGES, onTextChange);
        }

        private function bindTextEditorText():void {
            unbindTextEditorText();
            _textEditor.addEventListener(InPlaceTextEditorEvent.TEXT_CHANGES, onTextChange);
        }

        private function unbindModelText():void {
            if (_modelTextW)
                _modelTextW.unwatch();
        }

        private function bindModelText():void {
            unbindModelText();
            _modelTextW=BindingUtils.bindSetter(onModelTextChange, _model, "htmlText");
        }

        private function bindChildren():void {
            bindTextEditorText();
            bindModelText();
            BindingUtils.bindSetter(onCurrentTextLayerChange, _model, "currentLayerInd");
            BindingUtils.bindSetter(onAdvTextModeChange, _model, "advTextMode");
        }


        private function onUseHandCursorChange(value:Boolean):void {
            buttonMode=useHandCursor=value;
        }

        private function onModelTextChange(value:String):void {
            if (_textEditor) {
                var htmlText:String=toHTMLText(_textEditor.textFlow);
                if (htmlText != value) {
                    unbindTextEditorText();
                    _textEditor.textFlow=toTextFlow(value);
                    bindTextEditorText();
                }
            }
        }

        private function onTextChange(o:Object):void {
            var htmlText:String=toHTMLText(_textEditor.textFlow);
            if (htmlText != _model.htmlText) {
                if (_model.advTextMode) {
                    _model.textChain.source.splice(_model.currentLayerInd, 1, htmlText);
                    _model.textChain.refresh();
                }
                _model.htmlText=htmlText;
            }
        }

        private function onAdvTextModeChange(value:Boolean):void {
            if (_cornerObject) {
                if (value && !this.contains(_cornerObject as Button)) {
                    this.addElement(_cornerObject);
                } else if (this.contains(_cornerObject as Button)) {
                    this.removeElement(_cornerObject);
                }
            }
        }

        private function toHTMLText(tf:TextFlow):String {
            if (tf)
                return TextConverter.export(tf, TextConverter.TEXT_FIELD_HTML_FORMAT, ConversionType.STRING_TYPE) as String;
            return null;
        }

        private function toTextFlow(html:String):TextFlow {
            if (html)
                return TextConverter.importToFlow(html, TextConverter.TEXT_FIELD_HTML_FORMAT);
            return null;
        }

        private function onCurrentTextLayerChange(value:int):void {
            if (value > -1) {
                unbindTextEditorText();
                _textEditor.textFlow=toTextFlow(_model.textChain.getItemAt(value) as String);
                bindTextEditorText();
            }
        }

        public function clearSelection():void {
			frameVisible = false;
        }
    }

}
