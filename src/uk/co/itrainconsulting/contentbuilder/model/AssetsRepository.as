package uk.co.itrainconsulting.contentbuilder.model
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	import mx.collections.ArrayCollection;
	import mx.events.DynamicEvent;
	import mx.utils.URLUtil;
	
	import org.swizframework.processors.DispatcherProcessor;
	
	import uk.co.itrainconsulting.contentbuilder.model.fileupload.FileReferenceWrapper;
	import uk.co.itrainconsulting.contentbuilder.model.fileupload.events.FileUploadEvent;

	[Bindable]
	public class AssetsRepository
	{
		public static const ASSETS_RETRIEVED:String="AssetsRepositoryAssetsRetrieved";
		public static const UPLOADING_URL:String = "uploading";
		public static const ASSETS_UPDATED:String="AssetsRepostioryAssetsUpdated";

		public var assets:ArrayCollection=new ArrayCollection();

		private var _addFileReferenceList:FileReferenceList=new FileReferenceList();
		private var _loadQueue:ArrayCollection=new ArrayCollection();
		private var _uploadQueue:ArrayCollection=new ArrayCollection();
		private var _addingAttachment:Boolean = false;
		
		[Inject]
		public var uploader:UploadBean;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;

		public function AssetsRepository()
		{
			_addFileReferenceList.addEventListener(Event.SELECT, onFileSelection);
		}

		[Mediate(event="AssetsRepositoryAssetsRetrieved")]
		public function onAssetsRetrieval(de:DynamicEvent):void
		{
			var xml:XML=de.xml;
			var assetsXMLList:XMLList=xml.asset;
			var ao:AssetObject;
			var isAttachment:Boolean = de.isAttachment;
			for each (var xmlAsset:XML in assetsXMLList)
			{
				ao=AssetObject.parseXML(xmlAsset);
				ao.isAttachment = isAttachment;
				updateRepository(ao);
			}
			if (assets.filterFunction != null)
				assets.refresh();
			dispatcher.dispatchEvent(new Event(ASSETS_UPDATED, true));
		}

		private function updateRepository(asset:AssetObject):void
		{
			var air:AssetObject;
			for (var i:int = 0; i < assets.source.length; i++) {
				air = assets.source[i] as AssetObject;
				if (air.url == asset.url) {
					assets.source.splice(i,1,asset);
					return;
				}
			}
			assets.source.push(asset);
		}

		public function addToAssets(frws:ArrayCollection):void
		{
			var ao:AssetObject;
			for each (var frw:FileReferenceWrapper in frws)
			{
				ao=new AssetObject(UPLOADING_URL, frw.name);
				ao.fileReferenceW=frw;
				ao.isAttachment = _addingAttachment;
				assets.addItemAt(ao, 0);
			}
			assets.refresh();
		}
		
		private function onFileSelection(e:Event):void
		{
			var toAdd:ArrayCollection=new ArrayCollection();
			var fileReferenceWrapper:FileReferenceWrapper;
			for each (var fr:FileReference in _addFileReferenceList.fileList)
			{
				fileReferenceWrapper=new FileReferenceWrapper(fr);
				fileReferenceWrapper.isAttachment = _addingAttachment;
				toAdd.addItem(fileReferenceWrapper);
			}
			var uniqueToAdd:ArrayCollection = getUniqueFRW(toAdd);
			_loadQueue.addAll(uniqueToAdd);
			_uploadQueue.addAll(uniqueToAdd);
			addToAssets(uniqueToAdd);
			for each (var frw:FileReferenceWrapper in uniqueToAdd)
			{
				frw.addEventListener(FileUploadEvent.LOADING_COMPLETE, onFileLoadingComplete);
				frw.load();
			}
		}
		
		[Mediate(event="UploadBeanRemoveFileFromQueue")]
		public function onRemoveFromQueue(de:DynamicEvent):void {
			var frw:FileReferenceWrapper = de.fileReferenceWrapper as FileReferenceWrapper;
			var asset:AssetObject = getAssetObjectByFRW(frw);
			assets.source.splice(assets.source.indexOf(asset), 1);
			assets.refresh();
			var removeIndex:int = _uploadQueue.getItemIndex(frw);
			if (removeIndex >= 0)
				_uploadQueue.removeItemAt(removeIndex);
		}
		
		private function getUniqueFRW(collection:ArrayCollection):ArrayCollection {//of FileReferenceWrapper
			var result:ArrayCollection = new ArrayCollection(collection.source);
			for each (var frw:FileReferenceWrapper in collection) // FileReferenceWrapper
			{
				for each (var ao:AssetObject in assets) // AssetObject
				{
					if (assetsEqual(ao, frw))
					{
						result.removeItemAt(result.getItemIndex(frw));
						break;
					}
				}
			}
			return result;
		}
		
		private function assetsEqual(a:Object, b:Object):Boolean {
			if (a is AssetObject && b is AssetObject)
				return (a as AssetObject).url == (b as AssetObject).url;
			else {
				var frwa:FileReferenceWrapper;
				var frwb:FileReferenceWrapper;
				if (a is FileReferenceWrapper)
					frwa = a as FileReferenceWrapper;
				else
					frwa = (a as AssetObject).fileReferenceW;
				if (b is FileReferenceWrapper)
					frwb = b as FileReferenceWrapper;
				else
					frwb = (b as AssetObject).fileReferenceW;
				if (frwa && frwb)
					return frwa.name == frwb.name && frwa.size == frwb.size; // add creator and date comparison
				else
					return false;
			}
		}

		private function onFileLoadingComplete(e:FileUploadEvent):void
		{
			var frw:FileReferenceWrapper=e.target as FileReferenceWrapper;
			frw.removeEventListener(FileUploadEvent.LOADING_COMPLETE, onFileLoadingComplete);
			_loadQueue.removeItemAt(_loadQueue.getItemIndex(frw));
		}

		public function selectFiles(fileTypes:Array=null, attachments:Boolean = false):void
		{
			_addingAttachment = attachments;
			var frl:FileReferenceList=new FileReferenceList();
			clearFileReferenceList(_addFileReferenceList);
			_addFileReferenceList.browse(fileTypes);
		}

		private function clearFileReferenceList(frl:FileReferenceList):void
		{
			if (frl.fileList)
			{
				while (frl.fileList.length)
					frl.fileList.pop();
			}
		}
		
		private function getAssetObjectByFRW(frw:FileReferenceWrapper):AssetObject {
			var asset:AssetObject;
			for each (var ao:AssetObject in assets.source) {
				if (ao.fileReferenceW == frw) {
					asset = ao;
					break;
				}
			}
			return asset;
		}
		
		private function onUploadComplete(ev:FileUploadEvent):void
		{
			var frw:FileReferenceWrapper = ev.target as FileReferenceWrapper;
			var asset:AssetObject = getAssetObjectByFRW(frw);
			if (asset) {
				asset.fileReferenceW=null;
				asset.url = ev.data as String;
			}
			frw.removeEventListener(FileUploadEvent.UPLOADING_COMPLETE, onUploadComplete);
		}
		
		private function listenForUploadCompletion():void {
			for each (var frw:FileReferenceWrapper in _uploadQueue) {
				frw.addEventListener(FileUploadEvent.UPLOADING_COMPLETE, onUploadComplete);
			}
		}

		public function startUploading(selectedAsset:AssetObject = null):void {
			var frw:FileReferenceWrapper;
			if (selectedAsset)
				frw = selectedAsset.fileReferenceW;
			listenForUploadCompletion();
			uploader.addToUpload(_uploadQueue, frw);	
			clear();
		}
		
		public function clear():void
		{
			clearFileReferenceList(_addFileReferenceList);
			_loadQueue.removeAll();
			_uploadQueue.removeAll();
		}
	}
}