package uk.co.itrainconsulting.common.utils
{
	import uk.co.itrainconsulting.common.model.EnumShapeType;

	public class ShapeUtils
	{
		public static function getShapeType(string:String):EnumShapeType {
			if (string) {
				var ordinal:Number=Number(string);
				if (isNaN(ordinal))
					switch (string.toUpperCase()) {
						case "SHAPE_TYPE_LINE":
							return EnumShapeType.LINE;
						case "SHAPE_TYPE_CIRCLE":
							return EnumShapeType.CIRCLE;
						case "SHAPE_TYPE_RECTANGLE":
							return EnumShapeType.RECTANGLE;
					}
				else
					return new EnumShapeType(ordinal);
			}
			return null;
		}
	}
}