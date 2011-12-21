package uk.co.itrainconsulting.contentbuilder.utils
{
	import uk.co.itrainconsulting.contentbuilder.model.EnumBGType;
	import uk.co.itrainconsulting.contentbuilder.model.EnumImageBGType;

	public class SlideUtils
	{
		public static function getBackgroundType(string:String):EnumBGType {
            if (string) {
                var ordinal:Number=Number(string);
                if (isNaN(ordinal))
                    switch (string.toUpperCase()) {
                        case "DEFAULT":
                            return EnumBGType.DEFAULT;
                        case "IMAGE":
                            return EnumBGType.IMAGE;
                        case "GRADIENT":
                            return EnumBGType.GRADIENT;
                    }
                else
                    return new EnumBGType(ordinal);
            }
            return null;
		}
		
		public static function getBackgroundImageMode(string:String):EnumImageBGType {
			if (string) {
				var ordinal:int=int(string);
				if (isNaN(ordinal))
					switch (string.toUpperCase()) {
						case "REPEAT":
							return EnumImageBGType.REPEAT;
						case "SCALE":
							return EnumImageBGType.SCALE;
					}
				else
					return new EnumImageBGType(ordinal);
			}
			return null;
		}
	}
}