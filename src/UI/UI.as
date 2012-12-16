package UI
{
	import org.flixel.*;
	public class UI extends FlxGroup
	{
		public var enterRoomIcon:FlxSprite;
		public var getCoverIcon:FlxSprite;
		public var leaveCoverIcon:FlxSprite;
		
		public var gunFireLeftBar:FlxSprite;
		public var gunFireRightBar:FlxSprite;
		
		public var _upperUI:FlxGroupXY;
		public var _lowerUI:FlxGroupXY;
		
		private var _magBar:MagBar;
		
		public static var ui_Instance:UI;
		public function UI() 
		{
			_upperUI = new FlxGroupXY();
			_lowerUI = new FlxGroupXY();
			
			var letterBoxheight:Number = 50;			
			_upperUI.add(new FlxSprite(0, 0).makeGraphic(FlxG.width, letterBoxheight, 0xff000000));
			_lowerUI.add(new FlxSprite(0, 0).makeGraphic(FlxG.width, letterBoxheight, 0xff000000));
			
			var stopWatch:StopWatch = new StopWatch();
			stopWatch.x = FlxG.width-150;
			stopWatch.y = 10;
			_upperUI.add(stopWatch);
			
			_magBar = new MagBar(7);
			_magBar.x = 400;
			//_lowerUI.add(_magBar);
			
			enterRoomIcon = new FlxSprite(0, 0);
			getCoverIcon = new FlxSprite(40, 0);
			leaveCoverIcon = new FlxSprite(80, 0);
			
			_lowerUI.add(enterRoomIcon);
			_lowerUI.add(getCoverIcon);
			_lowerUI.add(leaveCoverIcon);
			
			_lowerUI.y = FlxG.height - letterBoxheight;
			
			gunFireLeftBar = new FlxSprite(5, FlxG.height / 4).makeGraphic(10, FlxG.height / 2, 0xffffffff)
			gunFireRightBar = new FlxSprite(FlxG.width-15, FlxG.height / 4).makeGraphic(10, FlxG.height / 2, 0xffffffff)
			add(gunFireLeftBar);
			add(gunFireRightBar);
			
			add(_upperUI);
			add(_lowerUI);
			
			setAll("scrollFactor", new FlxPoint(0,0));			
		}
		
		public function updateMag(mag:Number):void
		{
			if (mag < _magBar.numberOfMags) {
				_magBar.numberOfMags--;
				var magSprite:FlxBasic = _magBar.getFirstAlive();
				if (magSprite != null) {
					magSprite.kill();
				}	
			}
		}
		
		public function updateLeftGunBar(danger:Number):void
		{
			updateGunFireBar(danger / 100, gunFireLeftBar);
		}
		
		public function updateRightGunBar(danger:Number):void
		{
			updateGunFireBar(danger / 100, gunFireRightBar);
		}
		
		private function updateGunFireBar(percentage:Number, bar:FlxSprite):void
		{
			if (percentage < 0) {
				percentage = 0;
			}
			if (bar.scale != null) {
				bar.scale.y = percentage;
			}
			var newPercentage:Number;
			if (percentage < 0.5) {
				newPercentage = percentage / 0.5;
				var green:uint = (255 * (1 - newPercentage)) << 8
				var yellow:uint = ((255 * newPercentage) << 16) + ((255 * newPercentage) << 8);
				bar.color = green + yellow;
			}
			else {
				newPercentage = (percentage-0.5) / 0.5;
				var yellow2:uint = ((255 * (1 - newPercentage)) << 16) + ((255 * (1 - newPercentage)) << 8);
				var red:uint = (255 * newPercentage) << 16
				bar.color = yellow2 + red;
			}
		}		
	}
}