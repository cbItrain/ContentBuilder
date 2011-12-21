package uk.co.itrainconsulting.contentbuilder.model
{
	import flash.external.ExternalInterface;

	public class WrapperDispatcher
	{
		private var _fnName:String;
		private var itWorks:Boolean;
		
		public function WrapperDispatcher(name:String)
		{
			_fnName = name;
		}
		
		public function testFunction():Boolean
		{
			dispatchEvent("__TESTING__");
			return true;
		}

		
		public function dispatchEvent(name:String, ... params):Boolean
		{
			if (ExternalInterface.available && _fnName)
			{
				ExternalInterface.call(_fnName, name, params);
				return true;
			}
			return false;			
		}
		
		protected function callbackFn(... params):Object
		{
			return null;
		}
		
		public static function create(name:String):WrapperDispatcher
		{
			return new WrapperDispatcher(name);
		}
	}
}