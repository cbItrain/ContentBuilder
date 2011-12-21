package uk.co.itrainconsulting.common.utils
{
	import flash.utils.ByteArray;
	
	import mx.controls.Image;

	public class LocalImageLoaderItem
	{
		public var data:ByteArray;
		public var image:Image;
		
		public function LocalImageLoaderItem(data:ByteArray, image:Image) {
			this.data = data;
			this.image = image;
		}
	}
}