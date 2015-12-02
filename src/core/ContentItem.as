package core
{
	import mx.collections.ArrayCollection;

	public class ContentItem
	{
		
		public static var TYPE_TEXT:String = "";
		public static var TYPE_IMAGE:String = "image";
		public static var TYPE_GALLERY:String = "gallery";
		public static var TYPE_NUMBERING:String = "numbering";
		public static var TYPE_BULLET:String = "bullet";
		public static var TYPE_FEEDBACK:String = "feedback";
		public static var TYPE_INFO:String = "info";
		
		[Bindable] public var subtitle:String;
		[Bindable] public var type:String;
		[Bindable] public var text:String;
		[Bindable] public var contentArray:ArrayCollection;
		
		public function ContentItem(subtitle:String='',type:String='text',text:String='',contentArray:ArrayCollection=null):void {
			this.subtitle = subtitle;
			this.type = type;
			this.text = text;
			this.contentArray = contentArray;
		}
	}
}