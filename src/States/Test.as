package States
{
	import org.flixel.*;
	import Rooms.EntranceRoom;
	import Spots.CoverSpot;
	import UI.*;
	import Character.*;
	
	public class Test extends FlxState
	{
		[Embed(source = "../../Content/Music/simpleSong.mp3")] 	
		public static var simpleSong:Class;
		
		private var _cameraPosition:FlxPoint
		private var _cameraTarget:FlxPoint

		private var _stopWatchText:FlxText;
		private var _stopWatchTimer:FlxTimer;
		
		private var _testPlayer:PlayerCharacter;
		
		public var coverSpots:FlxGroupXY;
		
		override public function create():void
		{
			FlxG.bgColor = 0xff2b2825;
			Room.numberOfRooms = 0;
			UI.UI.ui_Instance = new UI.UI();
			ProfessionalCharacter.id = 1;
			
			var mainLayer:FlxGroup = new FlxGroup();
			var uiLayer:FlxGroup = new UI();
			
			generateLevel(mainLayer);
			
			
			add(mainLayer);
			add(UI.UI.ui_Instance);
			
			_stopWatchTimer = new FlxTimer().start(3 * 60);
			_cameraPosition = new FlxPoint();
			
		}
		
		override public function update():void
		{

			var offset:Number = 100;
			if (_testPlayer._facingLeft) {
				offset *= -1;
			}
			_cameraTarget = new FlxPoint(_testPlayer.x + offset, _testPlayer.room.roomY+FlxG.height/2);
			
			if (Math.abs(_cameraTarget.y - _cameraPosition.y) < 5) {
				_cameraPosition.x = _cameraPosition.x + (_cameraTarget.x - _cameraPosition.x) * 0.1;
				_cameraPosition.y = _cameraPosition.y + (_cameraTarget.y - _cameraPosition.y) * 0.1;
			} else {
				_cameraPosition = _cameraTarget;
			}
			
			FlxG.camera.focusOn(_cameraPosition);
			super.update();

		}
		
		private function generateLevel(mainLayer:FlxGroup):void {
			//create city spawning
			//create outsides
			var entrance1:EntranceRoom = new EntranceRoom(true);
			var entrance2:EntranceRoom = new EntranceRoom(false);
			

			var corridor1:Room = new Room(1800, null);
			var corridor2:Room = new Room(1500, null);
			
			var room1:Room = new Room(500, null);
			var room2:Room = new Room(500, null);
			
			
			
			
			mainLayer.add(entrance1);
			mainLayer.add(entrance2);
			
			mainLayer.add(corridor1);
			mainLayer.add(corridor2);
			
			mainLayer.add(room1);
			mainLayer.add(room2);
			
			
			entrance1.westDoor = new RoomConnection(corridor1, corridor2.width - 110);

			corridor1.eastDoor = new RoomConnection(entrance1, 10);
			corridor1.addDoor(new ContextRoomConnection(550, new RoomConnection(room1, 150)));
			room1.addDoor(new ContextRoomConnection(150, new RoomConnection(corridor1, 550)));			
			corridor1.westDoor = new RoomConnection(corridor2, corridor2.width - 110);
			
			corridor2.eastDoor = new RoomConnection(corridor1, 10);
			corridor2.addDoor(new ContextRoomConnection(250, new RoomConnection(room2, 150)));
			room2.addDoor(new ContextRoomConnection(150, new RoomConnection(corridor2, 250)));			
			corridor2.westDoor = new RoomConnection(entrance2, entrance2.width - 110);
			
			entrance2.eastDoor = new RoomConnection(corridor2, 10);

			corridor1.addCoverSpot(new CoverSpot(300, Cover.FAR_LEFT));
			corridor1.addCoverSpot(new CoverSpot(1000, Cover.FAR_RIGHT));
			corridor2.addCoverSpot(new CoverSpot(600, Cover.FAR_LEFT));
			corridor2.addCoverSpot(new CoverSpot(1000, Cover.FAR_RIGHT));
			
			
			//entrance1.addGetaway(650);
			//entrance2.addGetaway(entrance2.width-650-250);
			
			_testPlayer = new PlayerCharacter(entrance1);
			_testPlayer.x = 450;
			
			mainLayer.add(new Character.ProfessionalCharacter(entrance1, _testPlayer));
			mainLayer.add(new Character.ProfessionalCharacter(entrance1, _testPlayer));
			mainLayer.add(new Character.ProfessionalCharacter(entrance1, _testPlayer));
			mainLayer.add(_testPlayer);
			
		}
		
	}
}