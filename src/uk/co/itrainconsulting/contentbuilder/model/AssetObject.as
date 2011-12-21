package uk.co.itrainconsulting.contentbuilder.model
{
	import uk.co.itrainconsulting.contentbuilder.model.fileupload.FileReferenceWrapper;
	import uk.co.itrainconsulting.contentbuilder.utils.AssetUtils;
	import uk.co.itrainconsulting.common.model.EnumObjectType;

	[Bindable]
	public class AssetObject
	{
		public var name:String;
		public var url:String;
		public var type:EnumObjectType
		public var isAttachment:Boolean = false;
		
		private var _fileReferenceW:FileReferenceWrapper;
		
		public function AssetObject(url:String, name:String)
		{
			this.name = name;
			this.url = url;
			this.type = AssetUtils.getTypeFromURL(url);
		}
		
		public static function parseXML(xml:XML):AssetObject {
			var result:AssetObject = new AssetObject(xml.@url, xml.@filename);
			return result;
		}
		
		public function set fileReferenceW(value:FileReferenceWrapper):void {
			_fileReferenceW = value;
			if (value) {
				this.type = AssetUtils.getTypeFromURL(value.type);
			}
		}
		
		public function get fileReferenceW():FileReferenceWrapper {
			return _fileReferenceW;
		}
	}
}