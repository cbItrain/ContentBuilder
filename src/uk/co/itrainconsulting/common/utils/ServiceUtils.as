package uk.co.itrainconsulting.common.utils
{
	import flash.events.Event;
	
	import mx.rpc.events.FaultEvent;

	public class ServiceUtils
	{
		public static function buildFaultParameters(fe:FaultEvent, errorWhileLoading:Boolean):Object {
			var description:String;
			if (errorWhileLoading && (fe.statusCode == 0 || fe.statusCode == 200)) {
				description="Data Corrupted.";
			} else if (fe.statusCode < 400) {
				description="Problem connecting to the Server.";
			} else if (fe.statusCode < 500) {
				description="Could not "+(errorWhileLoading ? "retrieve" : "send")+" data. Not found.";
			} else if (fe.statusCode < 600) {
				description="Server error when "+(errorWhileLoading ? "getting" : "sending")+" data.";
			} else {
				description="Uknown error";
			}
			return {content: fe.fault.content, technical: fe.fault.message, description: description};
		}
	}
}