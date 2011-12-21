package uk.co.itrainconsulting.contentbuilder.model
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.DynamicEvent;
	
	import uk.co.itrainconsulting.contentbuilder.model.fileupload.FileReferenceWrapper;
	import uk.co.itrainconsulting.contentbuilder.model.fileupload.events.FileUploadEvent;

	[Bindable]
	public class UploadBean
	{
		public static var ATTACHMENT_UPLOAD_URL:String="";
		public static var REPOSITORY_UPLOAD_URL:String="";
		public static var PAGE_ID:String="";
		
		public static const REMOVE_FILE_FROM_QUEUE:String = "UploadBeanRemoveFileFromQueue";
		public static const UPLOAD_COMPLETE:String = "UploadBeanUploadComplete";

		public var uploadQueue:ArrayCollection=new ArrayCollection();
		public var isUploading:Boolean=false;
		public var totalSizeToUpload:Number=0;
		public var sentSize:Number=0;
		
		[Dispatcher] public var dispatcher:IEventDispatcher;

		[Mediate(event="UploadBeanRemoveFileFromQueue")]
		public function onRemoveFromQueue(de:DynamicEvent):void {
			var frw:FileReferenceWrapper = de.fileReferenceWrapper as FileReferenceWrapper;
			var removeIndex:int = uploadQueue.getItemIndex(frw);
			if (removeIndex >= 0) {
				if (frw.isUploading) {
					frw.stopUploading();
				}
				uploadQueue.removeItemAt(removeIndex);
			}
		}
		
		[Mediate(event="flashVarsReady")]
		public function setStatics(de:DynamicEvent):void
		{
			var o:Object = de.flashvars;
			try
			{
				ATTACHMENT_UPLOAD_URL = o.uploadAttachmentURL;
				REPOSITORY_UPLOAD_URL = o.uploadAssetsURL;
				PAGE_ID = o.pageId;
			}
			catch(e:Error){}		
		}
		
		public function addToUpload(files:ArrayCollection, priority:FileReferenceWrapper=null):void
		{ //of FileReferenceWrapper
			if (files.length)
			{
				updateUploadSize(files);
				if (priority)
				{
					files.removeItemAt(files.getItemIndex(priority));
					var insertIndex:int=uploadQueue.length == 0 ? 0 : 1;
					uploadQueue.addItemAt(priority, insertIndex);
				}
				uploadQueue.addAll(files);
				startUploading();
			}
		}

		private function updateUploadSize(files:ArrayCollection):void
		{
			for each (var frw:FileReferenceWrapper in files) {
				totalSizeToUpload += frw.size;
			}
		}

		private function startUploading():void
		{
			if (!isUploading)
			{
				if (uploadQueue.length)
				{
					unlistenForUserApproval();
					var _currentlyUploading:FileReferenceWrapper=uploadQueue.getItemAt(0) as FileReferenceWrapper;
					listenForUploadChange(_currentlyUploading);
					isUploading=true;
					_currentlyUploading.upload();
				}
				else
				{
					sentSize=totalSizeToUpload=0;
				}
			}
		}
		
		private function listenForUploadChange(frw:FileReferenceWrapper):void {
			frw.addEventListener(FileUploadEvent.UPLOADING_COMPLETE, onFileUploadComplete);
		}
		
		private function unlistenForUploadChange(frw:FileReferenceWrapper):void {
			frw.removeEventListener(FileUploadEvent.UPLOADING_COMPLETE, onFileUploadComplete);
		}

		private function onFileUploadComplete(e:FileUploadEvent):void
		{
			isUploading=false;
			var frw:FileReferenceWrapper = e.target as FileReferenceWrapper;
			uploadQueue.removeItemAt(uploadQueue.getItemIndex(frw));
			sentSize += frw.size;
			unlistenForUploadChange(frw);
			if (uploadQueue.length) {
				listenForUserApproval();
			} else {
				dispatcher.dispatchEvent(new Event(UPLOAD_COMPLETE, true));
			}
		}

		private function listenForUserApproval():void
		{
			FlexGlobals.topLevelApplication.systemManager.addEventListener(MouseEvent.CLICK, onUserApproval, true);
			FlexGlobals.topLevelApplication.systemManager.addEventListener(KeyboardEvent.KEY_DOWN, onUserApproval, true);
		}

		private function unlistenForUserApproval():void
		{
			FlexGlobals.topLevelApplication.systemManager.removeEventListener(MouseEvent.CLICK, onUserApproval, true);
			FlexGlobals.topLevelApplication.systemManager.removeEventListener(KeyboardEvent.KEY_DOWN, onUserApproval, true);
		}

		private function onUserApproval(e:Event):void
		{
			startUploading();
		}
	}
}