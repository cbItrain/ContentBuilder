package uk.co.itrainconsulting.contentbuilder.view.skins
{
	import spark.primitives.RectangularDropShadow;
	import spark.skins.spark.VideoPlayerSkin;
	
	public class CustomVideoPlayerSkin extends VideoPlayerSkin
	{
		override public function CustomVideoPlayerSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (!dropShadow)
				dropShadow = new RectangularDropShadow();
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}