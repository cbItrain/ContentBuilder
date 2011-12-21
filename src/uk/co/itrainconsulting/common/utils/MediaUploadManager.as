package uk.co.itrainconsulting.common.utils
{
	import flash.net.FileReference;
	import flash.utils.Dictionary;
	
	import uk.co.itrainconsulting.common.model.mediaObjects.ImageMedia;
	import uk.co.itrainconsulting.common.model.mediaObjects.MediaObject;
	import uk.co.itrainconsulting.contentbuilder.model.fileupload.FileReferenceWrapper;
	import uk.co.itrainconsulting.contentbuilder.model.fileupload.events.FileUploadEvent;

	public class MediaUploadManager
	{

		private static const _mapFrUo:Dictionary=new Dictionary(); // key = frw value = UploadObject 
		private static const _mapModelFr:Dictionary=new Dictionary();

		public static function manageMedia(frw:FileReferenceWrapper, model:Object, propertyName:String = "url"):void
		{
			unlistenFRW(frw);
			cleanPreviousFRW(model);
			var uo:UploadObject = new UploadObject(model, propertyName);
			_mapFrUo[frw]=uo;
			_mapModelFr[model]=frw;
			listenFRW(frw);
			uo.updateModel(frw.dataAsByteArray);
		}
		
		public static function switchModel(oldModel:Object, newModel:Object, propertyName:String = null):Boolean {
			var frw:Object = _mapModelFr[oldModel];
			if (frw) {
				var uo:UploadObject = _mapFrUo[frw];
				if (uo) {
					uo.model = newModel;
					if (propertyName)
						uo.propertyName = propertyName;
					return true;
				}
			}
			return false;
		}
		
		private static function cleanPreviousFRW(model:Object):void {
			var frw:Object = _mapModelFr[model];
			if (frw)
				unlistenFRW(frw as FileReferenceWrapper);
		}

		private static function listenFRW(frw:FileReferenceWrapper):void
		{
			if (frw)
			{
				frw.addEventListener(FileUploadEvent.LOADING_COMPLETE, onLoadComplete);
				frw.addEventListener(FileUploadEvent.UPLOADING_COMPLETE, onUploadComplete);
			}
		}

		private static function unlistenFRW(frw:FileReferenceWrapper):void
		{
			if (frw)
			{
				frw.removeEventListener(FileUploadEvent.LOADING_COMPLETE, onLoadComplete);
				frw.removeEventListener(FileUploadEvent.UPLOADING_COMPLETE, onUploadComplete);
			}
		}

		private static function onLoadComplete(e:FileUploadEvent):void
		{
			var frw:FileReferenceWrapper=e.target as FileReferenceWrapper;
			var uo:UploadObject=_mapFrUo[frw];
			uo.updateModel(frw.dataAsByteArray);
		}

		private static function onUploadComplete(e:FileUploadEvent):void
		{
			var uo:UploadObject=_mapFrUo[e.target];
			uo.updateModel(e.data);
			_mapFrUo[e.target] = null;
			_mapModelFr[uo.model] = null;
		}
	}
}