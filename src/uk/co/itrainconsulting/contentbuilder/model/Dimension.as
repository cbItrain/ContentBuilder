package uk.co.itrainconsulting.contentbuilder.model
{
	public class Dimension
	{
		public var width:Number;
		public var height:Number;
		
		public function Dimension(width:Number = 0.0, height:Number = 0.0)
		{
			this.width = width;
			this.height = height;
		}
		
		public function clone():Dimension {
			return new Dimension(this.width, this.height);
		}
	}
}