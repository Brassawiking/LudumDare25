package States 
{
	import org.flixel.*;
	public class Start extends FlxState
	{
		[Embed(source = "../../Content/Images/startScreen.png")] 	
		public static var startScreen:Class;
		
		override public function create():void 
		{ 
			FlxG.playMusic(Test.simpleSong);
			add(new FlxSprite(0, 0, startScreen));
		}
		
		override public function update():void
		{
			if (FlxG.mouse.justPressed()) {
				FlxG.switchState(new Instruction());	
			}
		}
	}
}