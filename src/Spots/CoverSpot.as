package Spots 
{
	import org.flixel.*;

	public class CoverSpot extends FlxSprite
	{
		public var cover:int;
		
		public function CoverSpot(x:int, _cover:int)
		{
			super(x, FlxG.height/2);
			cover = _cover;
			
			makeGraphic(50, FlxG.height/4, 0xff0000ff);
		}
		
	}

}