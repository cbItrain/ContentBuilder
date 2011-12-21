package uk.co.itrainconsulting.contentbuilder.utils
{
	import flash.net.FileFilter;
	
	import uk.co.itrainconsulting.contentbuilder.model.Constants;
	import uk.co.itrainconsulting.common.model.EnumObjectType;

	public class AssetUtils
	{
		public static const imageExt:Array = ['.JPG', '.JPEG', '.BMP', '.PNG', '.SWF'];
		public static const audioExt:Array = ['.MP3'];
		public static const videoExt:Array = ['.FLV'];
		
		public static function getTypeFromURL(url:String):EnumObjectType {
			if (url && url.length >= 4) {
				var ext:String = url.substr(url.length - 4, 4).toUpperCase();
				if (imageExt.indexOf(ext) > -1)
					return EnumObjectType.IMAGE;
				else if (audioExt.indexOf(ext) > -1)
					return EnumObjectType.AUDIO;
				else if (videoExt.indexOf(ext) > -1)
					return EnumObjectType.VIDEO;
				else
					return null;
			}
			return null;
		}
		
		public static function getFileFilters(description:String, typesAsStrings:Array):FileFilter {
			var extString:String = "";
			for each (var tas:String in typesAsStrings) {
				extString += "*"+tas+";"
			}
			if (extString.length)
				extString = extString.substr(0, extString.length - 1);
			return new FileFilter(description, extString);
		}
	}
}