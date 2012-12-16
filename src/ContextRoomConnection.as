package  
{
	import org.flixel.*;
	public class ContextRoomConnection extends FlxSprite
	{
		public var roomConnection:RoomConnection;
		public function ContextRoomConnection(x:int, _roomConnection:RoomConnection) 
		{
			super(x, FlxG.height / 4)
			makeGraphic(100, FlxG.height / 2, 0xFF987654);
			
			roomConnection = _roomConnection;
		}
		
	}

}