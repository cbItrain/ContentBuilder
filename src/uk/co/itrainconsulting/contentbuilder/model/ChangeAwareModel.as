package uk.co.itrainconsulting.contentbuilder.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.events.PropertyChangeEvent;
	
	[RemoteClass]
	public class ChangeAwareModel extends EventDispatcher
	{
		
		public static var changeHandler:Function;
		
		protected var _watchEnabled:Boolean = true;
		
		public function ChangeAwareModel(target:IEventDispatcher=null)
		{
			super(target);
			listenForChange();
		}
		
		public function disableWatch():void {
			unlistenForChange();
			_watchEnabled = false;
		}
		
		public function enableWatch():void {
			_watchEnabled = true;
			listenForChange();
		}
		
		public function listenForChange():void {
			if (_watchEnabled) {
				unlistenForChange();
				this.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
			}
		}
		
		public function unlistenForChange():void {
			if (_watchEnabled)
				this.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
		}
		
		private function onPropertyChange(e:PropertyChangeEvent):void {
			if (changeHandler != null)
				changeHandler(e);
		}
	}
}