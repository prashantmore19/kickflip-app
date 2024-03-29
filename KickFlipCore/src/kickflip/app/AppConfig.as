package kickflip.app
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import kickflip.app.event.ConfigReaderEvent;
	import kickflip.app.setting.reader.ConfigReader;
	import kickflip.app.util.logger.Log;
	
	import org.osflash.signals.Signal;

	public class AppConfig extends EventDispatcher
	{
		public var onReady:Signal = new Signal();
		
		public function AppConfig()
		{
			super();
		}

		public function init():void
		{
			var configReader:ConfigReader = new ConfigReader(AppGlobal.PATH_CONFIG);
			configReader.addEventListener(ConfigReaderEvent.EVENT_XML_PARSED, setConfigData);
			configReader.init();
		}

		private function setConfigData(evt:ConfigReaderEvent):void
		{
			var configReader:ConfigReader = evt.target as ConfigReader;
			configReader.removeEventListener(ConfigReaderEvent.EVENT_XML_PARSED, setConfigData);

			var configData:Object = evt.configData;
			for (var key:String in configData)
			{
				Log.Info("setConfigData["+ key +"]:"+ configData[key]);
				if(Object(AppGlobal).hasOwnProperty(key))
					AppGlobal[key] = configData[key];
			}
			onReady.dispatch();
		}
	}
}