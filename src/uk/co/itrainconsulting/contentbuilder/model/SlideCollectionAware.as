package uk.co.itrainconsulting.contentbuilder.model
{
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;

	[Bindable]
	public class SlideCollectionAware extends ChangeAwareModel
	{
		protected var _slides:ArrayCollection;
		
		public function SlideCollectionAware()
		{
			unlistenForChange();
			
			_slides = new ArrayCollection();
			
			listenForChange();
		}
		
		override public function listenForChange():void {
			super.listenForChange();
			if (_slides && _watchEnabled)
				_slides.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChangeEvent);
		}
		
		override public function unlistenForChange():void {
			super.unlistenForChange();
			if (_slides && _watchEnabled)
				_slides.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChangeEvent);
		}
		
		private function onCollectionChangeEvent(e:CollectionEvent):void {
			if (changeHandler != null)
				changeHandler(e);
		}
	}
}