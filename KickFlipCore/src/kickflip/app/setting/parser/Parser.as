package kickflip.app.setting.parser
{
	import flash.events.EventDispatcher;
	
	import kickflip.app.util.Util;
	
	public class Parser
	{
		public function Parser()
		{
		}

		protected function evalData(value:Object, type:String):Object
		{
			type = type.toLowerCase();
			if(type=="boolean"){
				if(value=="true"||value=="1") return true; else return false;
			}
			if(type=="number"){
				return Number(value);
			}
			if(type=="uint"){
				return uint(value);
			}
			if(type=="string"){
				return value;
			}
			if(type=="date"){
				return Util.stringToDate(value.toString());
			}
			if(type=="array"){
				return String(value).split(",");
			}
			return value;
		}
	}
}