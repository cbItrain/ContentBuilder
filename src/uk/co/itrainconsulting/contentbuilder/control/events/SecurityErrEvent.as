package uk.co.itrainconsulting.contentbuilder.control.events
{
	import flash.events.Event;
	
	public class SecurityErrEvent extends Event
	{
		public static const SECURITY_ERR:String = "securityErrSecurityErrEvent";
		
		public function SecurityErrEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}