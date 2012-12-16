package Rooms 
{
	import org.flixel.FlxTimer;

	public class EntranceRoom extends Room
	{
		[Embed(source = "../../Content/Images/Rooms/entrance-2.png")] 	
		public static var entrenceRoomEastBG:Class;		
		
		[Embed(source = "../../Content/Images/Rooms/entrance.png")] 	
		public static var entrenceRoomWestBG:Class;
		
		public function EntranceRoom(east:Boolean) 
		{
			var bg:Class = entrenceRoomWestBG;
			if (east) {
				bg = entrenceRoomEastBG;
			}
			super(4320, bg);

			new FlxTimer().start(5, 999, function():void {
				if (east) {
					gunFireRight = 100;	
				} else {
					gunFireLeft = 100;
				}
				
			});
		}
		
	}

}