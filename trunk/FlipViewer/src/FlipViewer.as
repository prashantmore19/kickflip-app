package
{
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import flipviw.app.AppGlobal;
	import flipviw.viw.view.MainView;
	
	[SWF(width='700',height='400', backgroundColor='#ffffff', frameRate='60')]
	public class FlipViewer extends Sprite
	{
		public function FlipViewer()
		{
			if(stage!=null)
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.frameRate = 60;
			}
			init();
			positionWindow();
		}
		
		private function init():void
		{
			var global:AppGlobal = new AppGlobal();
			global.onReady.add(globalReadyHandler);
			global.init(stage);
		}
		
		private function globalReadyHandler():void
		{
			addChild(new MainView());
		}
		
		private function positionWindow():void
		{
			var mainScreen:Screen = Screen.mainScreen;
			var screenBounds:Rectangle = mainScreen.visibleBounds;
			stage.nativeWindow.x = screenBounds.width/2 - AppGlobal.DEFAULT_WIDTH/2;
			stage.nativeWindow.y = screenBounds.height/2 - AppGlobal.DEFAULT_HEIGHT/2;
		}
	}
}