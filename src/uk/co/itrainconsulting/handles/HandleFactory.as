package uk.co.itrainconsulting.handles
{
	import mx.core.IFactory;
	
	public class HandleFactory implements IFactory
	{
		public function newInstance():*
		{
			return new SpriteHandle();
		}
	}
}