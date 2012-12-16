package {
	import org.flixel.*;
	import States.*;
	
	[SWF(width = "1080", height = "540", backgroundColor = "#000000")]
	[Frame(factoryClass = "Preloader")]
	
	public class Main extends FlxGame
	{
		public function Main()
		{
			super(1080,540,Start,1);
		}
	}
}