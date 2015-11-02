package core
{
	public class AppSettings
	{
		
		[Bindable] public var bg:String;
		[Bindable] public var video:String;
		[Bindable] public var password:String;
		[Bindable] public var videoIdleTime:Number = 30;
		
		public function AppSettings()
		{
		}
	}
}