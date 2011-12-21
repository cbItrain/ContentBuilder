package uk.co.itrainconsulting.contentbuilder.model
{
	import uk.co.itrainconsulting.common.model.EnumClass;

	[RemoteClass]
	public class EnumBGType extends EnumClass
	{
		public static var DEFAULT:EnumBGType = new EnumBGType(0);
		public static var IMAGE:EnumBGType = new EnumBGType(1);
		public static var GRADIENT:EnumBGType = new EnumBGType(2);
		
		public function EnumBGType(ordinal:int = 0)
		{
			switch (ordinal) {
				case 0: name = "DEFAULT"; break;
				case 1: name = "IMAGE"; break;
				case 2: name = "GRADIENT"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [DEFAULT, IMAGE, GRADIENT];
		}
	}
}