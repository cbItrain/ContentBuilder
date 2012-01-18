package uk.co.itrainconsulting.common.model
{
	[RemoteClass]
	public class EnumObjectType extends EnumClass
	{
		public static const NONE:EnumObjectType = new EnumObjectType(0);
		public static const IMAGE:EnumObjectType = new EnumObjectType(1);
		public static const TEXT:EnumObjectType = new EnumObjectType(2);
		public static const SHAPE:EnumObjectType = new EnumObjectType(3);
		public static const AUDIO:EnumObjectType = new EnumObjectType(4);
		public static const VIDEO:EnumObjectType = new EnumObjectType(5);
		public static const BUTTON:EnumObjectType = new EnumObjectType(6);
		public static const SLIDE:EnumObjectType = new EnumObjectType(7);
		public static const TEMPLATE:EnumObjectType = new EnumObjectType(8);
		
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