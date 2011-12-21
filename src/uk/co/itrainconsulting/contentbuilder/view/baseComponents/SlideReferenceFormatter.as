package uk.co.itrainconsulting.contentbuilder.view.baseComponents
{
	public class SlideReferenceFormatter
	{
		public function SlideReferenceFormatter(){}
		
		public static function slideReferenceToString(value:int):String {
			var result:String = "";
			switch (value) {
				case -1:  return "";
				case -10: result += "FIRST"; break;
				case -20: result += "LAST"; break;
				case -11: result += "PREVIOUS"; break;
				case -12: result += "NEXT"; break;
				default : 	result += (value + 1).toString();
					if (value == 0)
						result += "st";
					else if (value == 1)
						result += "nd";
					else if (value == 2)
						result += "rd";
					else
						result += "th";
			}
			return result;
		}
	}
}