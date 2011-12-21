package uk.co.itrainconsulting.common.utils
{
	import uk.co.itrainconsulting.common.model.EnumObjectType;

	public class MediaUtils
	{
		public static function getMediaType(string:String):EnumObjectType {
			if (string) {
				var ordinal:Number=Number(string);
				if (isNaN(ordinal))
					switch (string.toUpperCase()) {
						case "IMAGE_TYPE":
							return EnumObjectType.IMAGE;
						case "TEXT_TYPE":
							return EnumObjectType.TEXT;
						case "VIDEO_TYPE":
							return EnumObjectType.VIDEO;
						case "AUDIO_TYPE":
							return EnumObjectType.AUDIO;
						case "SHAPE_TYPE":
							return EnumObjectType.SHAPE;
						case "BUTTON_TYPE":
							return EnumObjectType.BUTTON;
					}
				else
					return new EnumObjectType(ordinal);
			}
			return null;
		}
	}
}