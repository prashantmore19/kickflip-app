package flippub.flip.manager
{
	import com.greensock.TweenLite;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	
	import flippub.app.AppGlobal;
	import flippub.app.control.Alert;
	
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
			netConn.objectEncoding = ObjectEncoding.AMF0;
			trace("ServerSync["+ AppGlobal.MEDIA_SERVER_RMTP +"]");
			netConn.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netConn.connect(AppGlobal.MEDIA_SERVER_RMTP);
		}

		public function netStatusHandler(evt:NetStatusEvent):void
		{
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
					trace("[FAILED] "+ msg);
					Alert.show("["+ AppGlobal.MEDIA_SERVER_RMTP +"]\r"+ msg);
					break;
				}
			}
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
			//stream.play("media");

			onSuccess.dispatch();
		}

		public function getStream():NetStream
		{
			return stream;
		}

	}
}