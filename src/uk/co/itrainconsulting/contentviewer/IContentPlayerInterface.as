package uk.co.itrainconsulting.contentviewer
{
	import flash.events.IEventDispatcher;
	
	import org.swizframework.core.ISwiz;
	import org.swizframework.core.mxml.Swiz;
	
	import uk.co.itrainconsulting.content.common.model.IExternalInterfaceAwareApplication;
	
	public interface IContentPlayerInterface extends IEventDispatcher, IExternalInterfaceAwareApplication
	{
		function getSwiz():Swiz;
		function get contentProperties():Object;
		function set contentProperties(value:Object):void;
	}
}