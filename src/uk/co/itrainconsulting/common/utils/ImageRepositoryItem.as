package uk.co.itrainconsulting.common.utils
{
	import mx.controls.Image;
	
	public class ImageRepositoryItem
	{
		public var url:String;
		public var image:Image;
		
		public function ImageRepositoryItem(url:String, image:Image)
		{
			this.url = url;
			this.image = image;
		}
	}
}