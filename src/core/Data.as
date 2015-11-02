package core
{
	import mx.collections.ArrayCollection;

	public class Data
	{
		
		[Bindable] public var title:String;
		[Bindable] public var content:ArrayCollection;
		
		public function Data(title:String='',content:ArrayCollection=null):void{
			this.title = title;
			this.content = content;
		}
	}
}