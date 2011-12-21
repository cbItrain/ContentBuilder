package uk.co.itrainconsulting.common.model
{
	[RemoteClass]
	public class EnumShapeType extends EnumClass
	{
		public static var LINE:EnumShapeType = new EnumShapeType(0);
		public static var CIRCLE:EnumShapeType = new EnumShapeType(1);
		public static var RECTANGLE:EnumShapeType = new EnumShapeType(2);
		
		public function EnumShapeType(ordinal:int = 0)
		{
			switch (ordinal) {
				case 0: name = "LINE"; break;
				case 1: name = "CIRCLE"; break;
				case 2: name = "RECTANGLE"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [LINE, CIRCLE, RECTANGLE];
		}
	}
}