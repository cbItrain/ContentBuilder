package uk.co.itrainconsulting.contentbuilder.model.fileupload
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import uk.co.itrainconsulting.contentbuilder.model.UploadBean;
	import uk.co.itrainconsulting.contentbuilder.model.fileupload.events.FileUploadEvent;
	import uk.co.itrainconsulting.contentbuilder.view.baseComponents.FileUploader;

	public class FileReferenceWrapper extends EventDispatcher
	{
		private var _fileReference:FileReference;
		private var _fileUploader:MultipartUrlLoader;
		
		[Bindable]
		public var loaded:Boolean = false;
		
		[Bindable]
		public var uploaded:Boolean = false;
		
		[Bindable]
		public var isUploading:Boolean = false;
		
		[Bindable]
		public var isAttachment:Boolean = false;
		
		public function FileReferenceWrapper(fileReference:FileReference)
		{
			_fileReference = fileReference;
			
			_fileReference.addEventListener(Event.OPEN, onOpenEvent);
			_fileReference.addEventListener(Event.COMPLETE, onCompleteEvent);
			_fileReference.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			_fileUploader = new MultipartUrlLoader();
			_fileUploader.addEventListener(Event.COMPLETE, onUploadComplete);
			_fileUploader.addEventListener(Event.OPEN, onOpenEvent);
			_fileUploader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_fileUploader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		public function get name():String {
			if (_fileReference)
				return _fileReference.name;
			return "";
		}
		
		public function get size():uint {
			if (_fileReference)
				return _fileReference.size;
			return 0;
		}
		
		public function get type():String {
			if (_fileReference)
				return _fileReference.type;
			return "";
		}
		
		public function get bytesTotal():uint {
			return size;
		}
		
		public function get dataAsByteArray():ByteArray {
			if (_fileReference)
				return _fileReference.data;
			return null;
		}
		
		public function get fileReference():FileReference {
			return _fileReference;
		}
		
		public function upload():void {
			_fileReference.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			_fileUploader.removeEventListener(ProgressEvent.PROGRESS, onUploadingProgress);
			_fileUploader.addEventListener(ProgressEvent.PROGRESS, onUploadingProgress);
			_fileUploader.multipartUpload(getVectorData(), isAttachment ? UploadBean.ATTACHMENT_UPLOAD_URL : UploadBean.REPOSITORY_UPLOAD_URL);
			isUploading = true;
		}
		
		
		public function load():void {
			_fileReference.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			_fileUploader.removeEventListener(ProgressEvent.PROGRESS, onUploadingProgress);
			_fileReference.addEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			_fileReference.load();
		}
		
		public function stopUploading():void {
			_fileUploader.close();
		}
		
		private function getVectorData():Vector.<FormContent> {
			var vector:Vector.<FormContent> = new Vector.<FormContent>();
			vector.push(FormContent.createFromVariable("attachment_type","PAGE_HIDDEN"));
			vector.push(FormContent.createFromVariable("attach_to",UploadBean.PAGE_ID));
			var fileFormContent:FormContent = FormContent.createFromVariableAndByteArray("document_name",_fileReference.data);
			fileFormContent.contentType = "image/png";
			fileFormContent.fileName = name;
			vector.push(fileFormContent);
			return vector;
		}
		
		
		private function onLoadingProgress(e:ProgressEvent):void {
			//dispatchEvent(new FileUploadEvent(FileUploadEvent.LOADING_PROGRESS, e.bytesLoaded));
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false, false, e.bytesLoaded, e.bytesTotal));
		}
		
		private function onUploadingProgress(e:ProgressEvent):void {
			//dispatchEvent(new FileUploadEvent(FileUploadEvent.UPLOADING_PROGRESS, e.bytesLoaded));
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false, false, e.bytesLoaded, e.bytesTotal));
		}
		
		private function onOpenEvent(e:Event):void {
			if (e.target == this)
				dispatchEvent(new FileUploadEvent(FileUploadEvent.LOADING_STARTED));
			else if (e.target == _fileUploader)
				dispatchEvent(new FileUploadEvent(FileUploadEvent.UPLOADING_STARTED));
		}
		
		private function onCompleteEvent(e:Event):void {
			if (!loaded) {
				loaded = true;
				dispatchEvent(new FileUploadEvent(FileUploadEvent.LOADING_COMPLETE));
			}
		}
		
		private function onUploadComplete(e:Event):void {
			uploaded = true;
			isUploading = false;
			dispatchEvent(new FileUploadEvent(FileUploadEvent.UPLOADING_COMPLETE, _fileUploader.data));
		}
		
		private function onError(e:Event):void {
			trace(e);
		}
	}
}