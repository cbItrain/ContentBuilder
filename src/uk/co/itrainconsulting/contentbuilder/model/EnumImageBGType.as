package uk.co.itrainconsulting.contentbuilder.model
{
	import uk.co.itrainconsulting.common.model.EnumClass;

	[RemoteClass]
	public class EnumImageBGType extends EnumClass
	{
		public static var REPEAT:EnumImageBGType = new EnumImageBGType(0);
		public static var SCALE:EnumImageBGType = new EnumImageBGType(1);
		
		public function EnumImageBGType(ordinal:int = 0)
		{
			switch (ordinal) {
				case 0: name = "REPEAT"; break;
				case 1: name = "SCALE"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [REPEAT, SCALE];
		}
	}
}