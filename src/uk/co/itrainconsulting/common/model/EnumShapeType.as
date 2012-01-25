package uk.co.itrainconsulting.common.model
{
	[RemoteClass]
	public class EnumShapeType extends EnumClass
	{
		public static const LINE:EnumShapeType = new EnumShapeType(0);
		public static const CIRCLE:EnumShapeType = new EnumShapeType(1);
		public static const RECTANGLE:EnumShapeType = new EnumShapeType(2);
		
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