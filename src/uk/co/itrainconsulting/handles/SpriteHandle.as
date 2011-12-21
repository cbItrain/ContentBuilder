/**
 *  Latest information on this project can be found at http://www.rogue-development.com/objectHandles.html
 *
 *  Copyright (c) 2009 Marc Hughes
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the Software
 *  is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 *  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 *  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 *  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 *  See README for more information.
 *
 **/


/**
 * A handle implementation based on Sprite, primarily for use in Flex 3.
 **/
package uk.co.itrainconsulting.handles {
	import com.objecthandles.HandleDescription;
	import com.objecthandles.HandleRoles;
	import com.objecthandles.IHandle;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	
	import uk.co.itrainconsulting.common.utils.Embeded;

	public class SpriteHandle extends Sprite implements IHandle {
		private static var ROTATE_COLOR:uint=0x09B109;
		private static var RESIZE_COLOR:uint=0xCBEAED;
		private static var HOVER_COLOR:uint=0xC5FFC0;
		private static var HOVER_LINE_COLOR:uint=0x3DFF40;


		private var _descriptor:HandleDescription;
		private var _targetModel:Object;
		protected var isOver:Boolean=false;
		
		private var _dragCursorId:int;
		private var _hoverCursorId:int = -1;
		private var _cursor:Class;

		public function get handleDescriptor():HandleDescription {
			return _descriptor;
		}

		public function set handleDescriptor(value:HandleDescription):void {
			_descriptor=value;
			if (_descriptor) {
				if (HandleRoles.isRotate(_descriptor.role)) {
					_cursor = Embeded.CURSOR_ROTATE;
					this.doubleClickEnabled = true;
					this.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
				} else if (HandleRoles.isMove(_descriptor.role)) {
					_cursor = Embeded.CURSOR_MOVE;
					visible = false;
				} else if (HandleRoles.isResizeDown(_descriptor.role)) {
					if (HandleRoles.isResizeLeft(_descriptor.role)) {
						_cursor = Embeded.CURSOR_RESIZE_45;
					} else if (HandleRoles.isResizeRight(_descriptor.role)) {
						_cursor = Embeded.CURSOR_RESIZE_135;
					} else {
						_cursor = Embeded.CURSOR_RESIZE_90;
					}
				} else if (HandleRoles.isResizeUp(_descriptor.role)) {
					if (HandleRoles.isResizeLeft(_descriptor.role)) {
						_cursor = Embeded.CURSOR_RESIZE_135;
					} else if (HandleRoles.isResizeRight(_descriptor.role)) {
						_cursor = Embeded.CURSOR_RESIZE_45;
					} else {
						_cursor = Embeded.CURSOR_RESIZE_90;
					}
				} else if (HandleRoles.isResizeLeft(_descriptor.role) || HandleRoles.isResizeRight(_descriptor.role)) {
					_cursor = Embeded.CURSOR_RESIZE;
				}
			}
		}

		public function get targetModel():Object {
			return _targetModel;
		}

		public function set targetModel(value:Object):void {
			_targetModel=value;
		}

		public function SpriteHandle() {
			super();
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//redraw();
		}
		
		private function onMouseDown(me:MouseEvent):void {
			if (me.target == this) {
				showDragCursor();
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
			}
		}
		
		private function onMouseUp(me:MouseEvent):void {
			CursorManager.removeCursor(_dragCursorId);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		}

		protected function onRollOut(event:MouseEvent):void {
			isOver=false;
			redraw();
			if (_hoverCursorId != -1) {
				CursorManager.removeCursor(_hoverCursorId);
				_hoverCursorId = -1;
			}
		}

		protected function onRollOver(event:MouseEvent):void {
			isOver=true;
			redraw();
			if (!event.buttonDown) {
				showHoverCursor();
			}
		}
		
		private function showHoverCursor():void {
			_hoverCursorId = CursorManager.setCursor(_cursor, CursorManagerPriority.HIGH, -7, -7);
		}
		
		private function showDragCursor():void {
			_dragCursorId = CursorManager.setCursor(_cursor, CursorManagerPriority.HIGH, -7, -7);
		}

		public function redraw():void {
			graphics.clear();
			if (isOver) {
				graphics.lineStyle(1, 0x3dff40);
				graphics.beginFill(HOVER_COLOR, 1);
			} else {
				graphics.lineStyle(1, 0);
				if (_descriptor.role == HandleRoles.ROTATE)
					graphics.beginFill(ROTATE_COLOR, 1);
				else
					graphics.beginFill(RESIZE_COLOR, 1);
			}
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();

		}
		
		private function onDoubleClick(me:MouseEvent):void {
			if (_targetModel && _targetModel.hasOwnProperty("rotation"))
				_targetModel.rotation = 0.0;
		}

	}
}