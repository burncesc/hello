package core
{
	
	import components.AlertDialog;
	import components.Gallery;
	
	import core.event.KioskEvent;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.utils.ObjectProxy;
	
	public class Manager extends EventDispatcher
	{
		private static var instance:Manager = new Manager();
		
		public function Manager():void {
			if(instance) {
				throw new Error("It is a Singleton and can only be accessed through Singleton.getInstance()");
			}
//			Security.loadPolicyFile('http://vulappid.net16.net/crossdomain.xml');
			init();
		}
		
		public static function getInstance():Manager {
			return instance;
		}
		
		//=====================================================================================================================================================
		
		[Bindable] public var mainApp:simplekiosk;
		[Bindable] public var appData:ArrayCollection;
		[Bindable] public var activeData:Data;
		[Bindable] public var isOnline:Boolean;
		[Bindable] public var appSettings:AppSettings;
		public var gallery:Gallery;
		private var idleTimer:Timer;
		
		[Bindable] public var fontsizemultiplier:Number = 2;
		
		private function init():void {
			appSettings = new AppSettings();
		}
		
		public function initManager(mainApp:simplekiosk):void {
			this.mainApp = mainApp;
			manageIdleTimer();
			getLocalData();
			//Service.SERVICE_HOST = "http://pumarwijaya.com/bpkp/";
			Service.SERVICE_HOST = "http://127.0.0.1/bpkp/";
			grabData();
//			Service.ping(function(o:Object):void {
//				if(String(o).indexOf("success")>-1) {
//					isOnline = true;
//				} else {
//					isOnline = false;
//				}
//				initData();
//			});
		}
		
		private var localDataSO:SharedObject;
		private function getLocalData():void {
			localDataSO = SharedObject.getLocal("simplekiosk_local_data");
//			localDataSO.clear();
			if(localDataSO.data.localData!=null) {
				appSettings.video = localDataSO.data.localData.video;
				appSettings.videoIdleTime = localDataSO.data.localData.videoIdleTime;
				setNewIdleTimer(appSettings.videoIdleTime);
			} else {
				appSettings.video = '';
				appSettings.videoIdleTime = 3000;
			}
		}
		public function setLocalData(video:String,videoIdleTime:Number):void {
			setNewIdleTimer(videoIdleTime);
			
			var o:Object = new ObjectProxy();
			o.video = video;
			o.videoIdleTime = videoIdleTime;
			
			localDataSO.data.localData = o;
		}
		
		private function initData():void {
			if(isOnline) {
				//grab new data
				grabData();
			} else {
				//use local data
				useLocalData();
			}
//			useDummyDatas();
		}
		
		[Bindable] public var isError:Boolean;
		public function grabData():void {
			Service.getdata(function(o:String):void {
				try {
					var temp:Object = JSON.parse(o);
					
					//app settings
//					appSettings = new AppSettings();
					appSettings.bg = Service.SERVICE_HOST + temp.app_settings.background_url;
					//appSettings.video = Service.SERVICE_HOST + temp.app_settings.video_url;
					appSettings.password = temp.app_settings.password;
					
					//app content
					var arr:Array = temp.app_content as Array;
					
					appData = new ArrayCollection();
					for(var i:int=0;i<arr.length;i++) {
						appData.addItem(new Data(arr[i].title));
						appData[i].content = new ArrayCollection();
						for(var j:int=0;j<arr[i].content.length;j++) {
							if(arr[i].content[j].type==ContentItem.TYPE_IMAGE || arr[i].content[j].type==ContentItem.TYPE_GALLERY) {
								for(var k:int=0;k<arr[i].content[j].contentArray.length;k++) {
									arr[i].content[j].contentArray[k] = Service.SERVICE_HOST + arr[i].content[j].contentArray[k];
								}
							}
							appData[i].content.addItem(new ContentItem(arr[i].content[j].subtitle,arr[i].content[j].type,arr[i].content[j].text,new ArrayCollection(arr[i].content[j].contentArray)));
						}
					}
					activeData = appData[0];
					isError = false;
				} catch(e:Error) {
					isError = true;
					AlertDialog.showAlertPopup(mainApp,"Server unreachable or JSON file error",AlertDialog.ANIM_DROP);
				}
			});
		}
		
		private function useLocalData():void {
			
		}
		
		private function useDummyDatas():void {
			this.appData = new ArrayCollection();
			appData.addItem(new Data(
				"profil",
				new ArrayCollection( [
					new ContentItem("profil kami","profil text bla bla bla ..."),
					new ContentItem("Kontak","alamat")
				] )
			));
			appData.addItem(new Data(
				"Visi",
				new ArrayCollection( [new ContentItem("Visi kami","visi text bla bla bla ...")] )
			));
			appData.addItem(new Data(
				"Misi",
				new ArrayCollection( [new ContentItem("Misi kami","misi text bla bla bla ...")] )
			));
			
			this.activeData = appData[0];
		}
		
		private function manageIdleTimer():void {
			idleTimer = new Timer(3000,1);
			
			idleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function showVideo(e:TimerEvent):void {
				mainApp.videoDisplay.play();
				mainApp.videoDisplay.visible = true;
			});
			mainApp.addEventListener(MouseEvent.MOUSE_MOVE, function onMouseMove(e:MouseEvent):void {
				mainApp.videoDisplay.visible = false;
				mainApp.videoDisplay.stop();
				idleTimer.reset();
				idleTimer.start();
			});
			mainApp.videoDisplay.addEventListener(MouseEvent.MOUSE_MOVE, function onVideoClick(e:MouseEvent):void {
				mainApp.videoDisplay.visible = false;
				mainApp.videoDisplay.stop();
				idleTimer.reset();
				idleTimer.start();
			});
			idleTimer.start();
		}
		private function setNewIdleTimer(delay:Number):void {
			idleTimer.delay = delay*1000;
			idleTimer.reset();
			idleTimer.start();
		}
		
	}
}