package uk.co.itrainconsulting.common.utils
{
	import flash.system.ApplicationDomain;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.utils.URLUtil;

	public class DomainUtils
	{
		public static function isURLFromOutside(url:String):Boolean {
			var o:Object = FlexGlobals.topLevelApplication;
			var i:Object = FlexGlobals.topLevelApplication.loaderInfo;
			if (url)
				return URLUtil.getServerName(FlexGlobals.topLevelApplication.loaderInfo.url) != URLUtil.getServerName(url);
			else
				return false;
		}
	}
}