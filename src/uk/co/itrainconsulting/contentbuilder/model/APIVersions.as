package uk.co.itrainconsulting.contentbuilder.model
{
	public final class APIVersions
	{
		public static const ZERO_POINT_ONE:String = "0.1";
		public static const ZERO_POINT_TWO:String = "0.2";
		
		public static function isValid(value:String):Boolean
		{
			return value == ZERO_POINT_ONE || value == ZERO_POINT_TWO;
		}
		
		public static function get defaultVersion():String
		{
			return ZERO_POINT_ONE;
		}
	}
}