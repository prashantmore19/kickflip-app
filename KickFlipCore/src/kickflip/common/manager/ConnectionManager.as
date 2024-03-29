package kickflip.common.manager
{
	import com.greensock.TweenLite;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import kickflip.app.AppGlobal;
	import kickflip.app.control.Alert;
	
	import org.osflash.signals.Signal;

	public class ConnectionManager
	{
		private var netConn:NetConnection;
		private var stream:NetStream;
		public var onSuccess:Signal = new Signal();
		
		public function ConnectionManager()
		{
			netConn = new NetConnection();
			netConn.client = this;
			trace("ConnectionManager["+ AppGlobal.MEDIA_SERVER_RMTP +"]");
			netConn.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netConn.connect(AppGlobal.MEDIA_SERVER_RMTP);
		}
		
		public function netStatusHandler(evt:NetStatusEvent):void
		{
			trace("ConnectionManager.evt.info.code["+ evt.info.code +"]");
			switch(evt.info.code)
			{
				case "NetConnection.Connect.Success":
				{
					showSuccess();
					break;
				}
				case "NetConnection.Connect.Failed":
				{
					var msg:String = "";
					for each (var key:String in evt.info) 
					{
						msg += key +":"+ evt.info[key] +"\r";
					}
					displayError(msg);
					break;
				}
				case "NetStream.Play.StreamNotFound":
				{
					displayError("NetStream.Play.StreamNotFound\rStreamName: "+ AppGlobal.DEFAULT_STREAM_NAME);
					break;
				}
			}
		}
		
		private function displayError(msg:String):void
		{
			trace("[FAILED] "+ msg);
			Alert.show("["+ AppGlobal.MEDIA_SERVER_RMTP +"]\r"+ msg);
		}
		
		private function showSuccess():void
		{
			var alert:Alert = Alert.show("Connected");
			new TweenLite(alert, 1.5, {
				onComplete:function():void
				{
					if(alert != null)
						alert.panelHide();
					ready();
				}
			}); 
		}
		
		private function ready():void
		{
			stream = new NetStream(netConn);
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			onSuccess.dispatch();
		}
		
		private function asyncErrorHandler(evt:AsyncErrorEvent):void
		{
			trace("[ASYNC_ERROR]"+ evt.error.message);
		}
		
		public function get CurrentNetStream():NetStream
		{
			return stream;
		}
		
		public function setClientId(id:int):void
		{
			trace("[setClientId].id["+ id +"]");
		}
		
		public function clientConnected(id:int):void
		{
			trace("[clientConnected].id["+ id +"]");
		}
	}
}