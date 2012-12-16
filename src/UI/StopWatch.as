package UI
{
	import org.flixel.*;
	import mx.utils.*;
	
	public class StopWatch extends FlxGroupXY
	{
		[Embed(source = "../../Content/Font/DigitalDreamFat.ttf", fontFamily="DigitalDream", embedAsCFF="false")] 	
		public var stopWatch:String;
		
		[Embed(source = "../../Content/Images/stopWatch.png")] 	
		public static var stopWatchImage:Class;
		
		private var _stopWatchText:FlxText; 
		private var _stopWatchTimer:FlxTimer;
		
		public function StopWatch() 
		{
			_stopWatchText = new FlxText(25, 50, 100);
			_stopWatchText.setFormat("DigitalDream", 16, 0x000000);
			add(new FlxSprite(0, 0).loadGraphic(stopWatchImage, false, false, 144, 132));
			add(_stopWatchText);
			
			_stopWatchTimer = new FlxTimer();
			_stopWatchTimer.start(3 * 60);
		}		
		
		override public function update():void 
		{
			var timeLeft:int = Math.round(_stopWatchTimer.timeLeft * 100);
			var deciSeconds:int = timeLeft % 100;
			timeLeft = (timeLeft - deciSeconds) / 100;
			var seconds:int = timeLeft % 60;
			timeLeft = (timeLeft - seconds) / 60;
			var minutes:int = timeLeft;
			
			_stopWatchText.text = StringUtil.substitute("{0}:{1}:{2}",
				minutes,
				seconds,
				deciSeconds);
			
			super.update();
		}
	}

}