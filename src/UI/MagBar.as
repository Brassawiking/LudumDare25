package UI
{
	import org.flixel.FlxSprite;
	public class MagBar extends FlxGroupXY
	{
		public var numberOfMags:int;
		
		public function MagBar(_numberOfMags:int) 
		{
			numberOfMags = _numberOfMags;
			for (var i:int = 0; i < numberOfMags; i++)
			{
				add(new FlxSprite(40 * i, 0));
			}
		}
		
	}

}