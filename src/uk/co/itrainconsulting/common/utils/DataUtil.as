package uk.co.itrainconsulting.common.utils
{
	public class DataUtil
	{
		public static function chunkString(string:String, chunkSize:int = 3999):Array{
			var result:Array = [];
			var length:int = string.length;
			var iterations:int = Math.ceil(length/chunkSize);
			for (var i:int = 0; i < iterations; i++){
				result.push(string.substr(i*chunkSize,chunkSize));
			}
			result.push("");
			return result;
		}
		
		public static function parseBoolean(string:String):Boolean {
			return string && string.toUpperCase() == "TRUE"
		}
		
		public static function getAlpha(string:String):Number {
			var result:Number = parseFloat(string);
			return isNaN(result) ? 1.0 : result;
		}
		
		public static function getColor(s:String):uint {
			var number:Number = parseFloat(s);
			return isNaN(number) ? 0 : number;
		}
		
		public static function getGoToSlide(s:String):int {
			var number:Number = parseFloat(s);
			return isNaN(number) ? -1 : number;
		}
	}
}