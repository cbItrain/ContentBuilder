package uk.co.itrainconsulting.common.model
{
	[RemoteClass]
	public class EnumObjectType extends EnumClass
	{
		public static var NONE:EnumObjectType = new EnumObjectType(0);
		public static var IMAGE:EnumObjectType = new EnumObjectType(1);
		public static var TEXT:EnumObjectType = new EnumObjectType(2);
		public static var SHAPE:EnumObjectType = new EnumObjectType(3);
		public static var AUDIO:EnumObjectType = new EnumObjectType(4);
		public static var VIDEO:EnumObjectType = new EnumObjectType(5);
		public static var BUTTON:EnumObjectType = new EnumObjectType(6);
		public static var SLIDE:EnumObjectType = new EnumObjectType(7);
		public static var TEMPLATE:EnumObjectType = new EnumObjectType(8);
		
		public function EnumObjectType(ordinal:int = 0)
		{
			switch (ordinal) {
				case 0: name = "NONE"; break;
				case 1: name = "IMAGE"; break;
				case 2: name = "TEXT"; break;
				case 3: name = "SHAPE"; break;
				case 4: name = "AUDIO"; break;
				case 5: name = "VIDEO"; break;
				case 6: name = "BUTTON"; break;
				case 7: name = "SLIDE"; break;
				case 8: name = "TEMPLATE"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [NONE, IMAGE, TEXT, SHAPE, AUDIO, VIDEO, BUTTON, SLIDE, TEMPLATE];
		}
	}
}