package uk.co.itrainconsulting.common.utils
{
	public class UploadObject
	{
		public var model:Object;
		public var propertyName:String;
		
		public function UploadObject(model:Object, propertyName:String)
		{
			this.model = model;
			this.propertyName = propertyName;
		}
		
		public function updateModel(value:Object):Boolean {
			if (model && propertyName && model.hasOwnProperty(propertyName)) {
				model[propertyName] = value;
				return true;
			} else {
				return false;
			}
		}
	}
}