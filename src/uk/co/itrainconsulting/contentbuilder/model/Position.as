package uk.co.itrainconsulting.contentbuilder.model
{
	import flash.geom.Point;
	
	public class Position extends Point
	{
		public var rotation:Number;
		
		public function Position(x:Number=0, y:Number=0, rotation:Number=0)
		{
			super(x, y);
			this.rotation = rotation;
		}
		
		override public function clone():Point {
			return new Position(this.x, this.y, this.rotation);
		}
	}
}