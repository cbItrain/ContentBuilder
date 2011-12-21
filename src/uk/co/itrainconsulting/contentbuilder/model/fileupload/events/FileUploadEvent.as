package uk.co.itrainconsulting.contentbuilder.model.fileupload.events
{
	import flash.events.Event;
	
	public class FileUploadEvent extends Event
	{
		public static const LOADING_COMPLETE:String = "FileUploadEventLoadingComplete";
		public static const UPLOADING_COMPLETE:String = "FileUploadEventUploadComplete";
		public static const LOADING_STARTED:String = "FileUploadEventLoadingStarted";
		public static const UPLOADING_STARTED:String = "FileUploadEventUploadingStarted";
		public static const UPLOADING_PROGRESS:String = "FileUploadEventUploadingProgress";
		public static const LOADING_PROGRESS:String = "FileUploadEventLoadingProgress";
		
		public var data:Object;
		
		public function FileUploadEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}