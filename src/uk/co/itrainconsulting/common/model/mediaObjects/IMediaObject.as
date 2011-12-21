package uk.co.itrainconsulting.common.model.mediaObjects
{
	[RemoteClass]
	public interface IMediaObject
	{
		function setPos(_x:Number, _y:Number, _w:Number, _h:Number, _r:Number = 0):void;
		function clone():MediaObject;
	}
}