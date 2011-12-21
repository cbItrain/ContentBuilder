package uk.co.itrainconsulting.content.common.model
{
	public interface IExternalInterfaceAwareApplication
	{
		function showSlideAt(index:int):void;
		function showNextSlide():void;
		function showPreviousSlide():void;
		function showFirstSlide():void;
		function showLastSlide():void;
		function getSlidesCount():int;
		function getCurrentSlideIndex():int;
		function getSlidesBasicData():Array;
		function setNewContent(xml:XML, currentSlideIndex:Number = -1):void;
		function changeShowSlideList(show:Boolean):void;
		function loadContent(sendParameters:Object, path:String = null):void;
		function setGaps(top:Number = NaN, right:Number = NaN, bottom:Number = NaN, left:Number = NaN):void;
		function setAllowScaling(value:Boolean):void;
	}
}