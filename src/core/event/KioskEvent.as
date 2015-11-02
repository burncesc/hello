package core.event
{
	import flash.events.Event;

	public class KioskEvent extends Event
	{
		
		public static const CONNECTED:String = "connected";
		public static const UPDATE_GALLERY_ACTIVE_THUMB:String = "update gallery active thumb";
		
		public static const OPEN_APP:String = "open app";
		
		public var params:Object;
		
		public function KioskEvent(type:String, params:Object=null):void {
			super(type);
			this.params = params;
		}
		
	}
}