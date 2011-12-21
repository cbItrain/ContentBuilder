package uk.co.itrainconsulting.contentbuilder.utils
{
	public class StringUtils
	{
		public static function getCountString(count:int, stem:String):String {
			if (count == 1)
				return "1 " + stem;
			else
				return count + " " + stem + (stem.charAt(stem.length - 1) == "s" ? "es" : "s");
		}
	}
}