package
{
	import net.flashpunk.*;
	
	[SWF(width = "640", height = "480", backgroundColor="#000000")]
	public class Main extends Engine
	{
		public static const url:String = "http://www.draknek.org/dance/";
		
		public function Main () 
		{
			super(640, 480, 60, true);
		}
		
		public override function init (): void
		{
			sitelock("draknek.org");
			
			var params:Object = FP.stage.loaderInfo.parameters;
			
			if (params.data) {
				var data:Object = {
					name: params.name,
					creator: params.creator,
					data: Base64.decode(params.data),
					serverID: params.serverID
				};
				
				FP.world = new DinoScreen(data);
			} else {
				FP.world = new Menu;
			}
			
			super.init();
			
			//FP.console.enable();
		}
		
		public function sitelock (allowed:*):Boolean
		{
			var url:String = FP.stage.loaderInfo.url;
			var startCheck:int = url.indexOf('://' ) + 3;
			
			if (url.substr(0, startCheck) == 'file://') return true;
			
			var domainLen:int = url.indexOf('/', startCheck) - startCheck;
			var host:String = url.substr(startCheck, domainLen);
			
			if (allowed is String) allowed = [allowed];
			for each (var d:String in allowed)
			{
				if (host.substr(-d.length, d.length) == d) return true;
			}
			
			parent.removeChild(this);
			throw new Error("Error: this game is sitelocked");
			
			return false;
		}
	}
}

