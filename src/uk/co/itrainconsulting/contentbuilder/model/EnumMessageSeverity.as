package uk.co.itrainconsulting.contentbuilder.model
{
	import uk.co.itrainconsulting.common.model.EnumClass;
	
	public class EnumMessageSeverity extends EnumClass
	{
		public static const NORMAL:EnumMessageSeverity = new EnumMessageSeverity(0);
		public static const MINOR:EnumMessageSeverity = new EnumMessageSeverity(1);
		public static const MAJOR:EnumMessageSeverity = new EnumMessageSeverity(2);
		public static const HINT:EnumMessageSeverity = new EnumMessageSeverity(3);
		
		public function EnumMessageSeverity(ordinal:int)
		{
			super();
			switch (ordinal) {
				case 0: name = "NORMAL"; break;
				case 1: name = "MINOR"; break;
				case 2: name = "MAJOR"; break;
				case 3: name = "HINT"; break;
			}
			this.ordinal = ordinal;
		}
		
		public static function get values():Array {
			return [NORMAL, MINOR, MAJOR, HINT];
		}
	}
}