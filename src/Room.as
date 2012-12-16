package  
{
	import org.flixel.*;
	import Spots.CoverSpot;
	public class Room extends FlxGroupXY 
	{
		public var width:int;
		public var roomY:int;
		
		public var westDoor:RoomConnection;
		public var eastDoor:RoomConnection;
		public var doors:Array;	
		
		public var coverSpots:Array;
		public var lootSpots:Array;
		public var getawaySpots:Array;
		
		public var gunFireLeft:Number = 0;
		public var gunFireRight:Number = 0;
		
		private var _eastBlock:FlxSprite;
		private var _westBlock:FlxSprite;
		
		public var isTakenByCops:Boolean;
		
		public static var numberOfRooms:int;
		public static var copRate:Number = 0.3;
		
		public function Room(_width:int, image:Class) 
		{
			doors = new Array();
			coverSpots = new Array();
			lootSpots = new Array();
			getawaySpots = new Array();
			
			width = _width;
			roomY = (FlxG.height + 10) * numberOfRooms;
			if (image != null) {
				add(new FlxSprite(0, 0).loadGraphic(image, false, false, width, FlxG.height));	
			} else {
				add(new FlxSprite(0, 0).makeGraphic(width, FlxG.height, 0xffdddd00));
				var floorSize:int = 135;
				add(new FlxSprite(0, FlxG.height - floorSize).makeGraphic(width, floorSize, 0xffaaaa00));
			}
			
			var doorSize:int = 10;
			_westBlock = new FlxSprite(0, 0).makeGraphic(doorSize, FlxG.height, 0xff333333);
			_eastBlock = new FlxSprite(width-doorSize, 0).makeGraphic(doorSize, FlxG.height, 0xff333333);
			add(_westBlock);
			add(_eastBlock);
			
			numberOfRooms++;
		}
		
		override public function update():void
		{
			y = roomY;
			_westBlock.visible = westDoor == null;
			_eastBlock.visible = eastDoor == null;
			super.update();
			
			if (gunFireLeft > 80 || gunFireRight > 80) {
				isTakenByCops = true;
			} else {
				isTakenByCops = false;
			}
			
			if (isTakenByCops) {
				if (eastDoor != null) {
					if (eastDoor.entryX < eastDoor.room.width / 2) {
						eastDoor.room.gunFireLeft = Math.min(eastDoor.room.gunFireLeft + copRate, 150);
					}
					else {
						eastDoor.room.gunFireRight = Math.min(eastDoor.room.gunFireRight + copRate, 150);
					}
				}
				
				if (westDoor != null) {
					if (westDoor.entryX < westDoor.room.width / 2) {
						westDoor.room.gunFireLeft = Math.min(westDoor.room.gunFireLeft + copRate, 150);
					}
					else {
						westDoor.room.gunFireRight = Math.min(westDoor.room.gunFireRight + copRate, 150);
					}
				}
				for (var i:int = 0; i < doors.length ; i++) {
					if (doors[i].roomConnection.entryX < doors[i].roomConnection.room.width / 2) {
						doors[i].roomConnection.room.gunFireLeft = Math.min(doors[i].roomConnection.room.gunFireLeft + copRate, 150);
					}
					else {
						doors[i].roomConnection.room.gunFireRight = Math.min(doors[i].roomConnection.room.gunFireRight + copRate, 150);
					}
				}				
			}
			
		}
		
		public function addDoor(door:ContextRoomConnection):void
		{
			add(door);
			doors.push(door);
		}
		
		public function addCoverSpot(coverSpot:CoverSpot):void
		{
			add(coverSpot);
			coverSpots.push(coverSpot);
		}
		
		public function addLoot(postion:int):void
		{
			var loot:FlxSprite = new FlxSprite(postion, FlxG.height / 4).makeGraphic(50, 50, 0xff00ff00);
			add(loot);
			lootSpots.push(loot);
		}
		
		public function addGetaway(postion:int):void
		{
			var getaway:FlxSprite = new FlxSprite(postion, 0).makeGraphic(250, FlxG.height, 0xff00ff00);
			add(getaway);
			getawaySpots.push(getaway);		
		}
		
	}
}