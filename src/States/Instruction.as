package States 
{
	import org.flixel.*;
	public class Instruction extends FlxState
	{
		[Embed(source = "../../Content/Images/instructionScreen.png")] 	
		public static var instructionScreen:Class;
		
		override public function create():void 
		{ 
			add(new FlxSprite(0, 0, instructionScreen));
		}
		
		override public function update():void
		{
			if (FlxG.mouse.justPressed() || FlxG.keys.any()) {
				FlxG.switchState(new Test());	
			}
		}
	}
}