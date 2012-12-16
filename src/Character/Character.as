package Character
{
	import org.flixel.*;
	import Spots.CoverSpot;
	
	public class Character extends FlxGroupXY
	{
		[Embed(source = "../../Content/Images/professionalSprite.png")] 	
		public static var professionalSprite:Class;
		
		[Embed(source = "../../Content/Sound/gun.mp3")] 	
		public static var gunSound:Class;
		
		public var room:Room;
		public var actionTimer:FlxTimer;
		public var cover:int;
		
		public var _aiming:Boolean;
		public var _facingLeft:Boolean;
		public var _firedGun:Boolean;
		public var _reloading:Boolean;
		
		protected var _sprite:FlxSprite;
		protected var _actionBar:FlxSprite;
		protected var _width:int;
		
		protected var _contextRoomConnection:RoomConnection
		protected var _contextCoverSpot:CoverSpot
		
		protected var _actionActive:Boolean = false;
		
		public var velocity:Number = 0;
		private var _maxVelocity:Number = 10;
		private var _acceleration:Number = 0.8;
		private var _friction:Number = 0.5;
		
		private var _gunDamage:Number = 7;
		protected var _baseAmmo:Number = 30;
		protected var _ammo:Number = _baseAmmo;
		protected var _mag:Number = 7000;
		
		protected var _hitPoints:Number = 50;
		
		public function Character(_room:Room = null)
		{
			room = _room;
			
			_width = 100;
			_sprite = new FlxSprite(0, 0).loadGraphic(professionalSprite, true, true, 100, 250, false);
			_sprite.addAnimation("idle", [0]);
			_sprite.addAnimation("aiming", [4]);
			_sprite.addAnimation("fireGun", [4,5,6,7], 30, false);
			_sprite.addAnimation("running", [8,9], 5, true);
			_sprite.addAnimation("cover", [12]);
			_sprite.addAnimation("reloading", [12]);
			
			_sprite.addAnimationCallback(gunCallback);
			
			_actionBar = new FlxSprite(0, 0).makeGraphic(100, 5, 0xffff0000);
			var characterName:FlxText = new FlxText(0, 250, 100, "Vincent");
			
			add(_sprite);
			add(_actionBar);
			add(characterName);
			
			actionTimer = new FlxTimer();
			y = 200 + room.roomY;
		}
		
		private function gunCallback(name:String, frameNumber:uint, frameIndex:uint ):void
		{
			if (name == "fireGun" && frameIndex == 7)
			{
				_firedGun = false;
			}
		}
		
		override public function update():void
		{
			getContextRoomConnection();
			getContextCoverSpot();
			
			_actionBar.scale.x = actionTimer.progress;
			
			updateCoverScale();
			updateVelocity();
			if (cover == Cover.NONE && !_aiming)
			{
				updatePosition();
			}
			
			updateHitpoints();
			updateAnimation();
			super.update();
		}
		
		protected function updateAnimation():void
		{
			if (_firedGun) {
				_sprite.play("fireGun");
			} else {
				if (Math.abs(velocity) > 0) {
					_sprite.play("running");
				}
				else {
					_sprite.play("idle");
				}
				if (cover != Cover.NONE) {
					_sprite.play("cover")
				}
				if (_aiming) {
					_sprite.play("aiming");
				}
				if (_reloading) {
					_sprite.play("reloading");
				}
			}
		}
		
		protected function getContextRoomConnection():void
		{
			for (var i:int = 0; i < room.doors.length; i++)
			{
				if (_sprite.overlaps(room.doors[i]))
				{
					_contextRoomConnection = room.doors[i].roomConnection;
					return;
				}
			}
			_contextRoomConnection = null;
		}
		
		protected function getContextCoverSpot():void
		{
			for (var i:int = 0; i < room.coverSpots.length; i++)
			{
				if (_sprite.overlaps(room.coverSpots[i]))
				{
					_contextCoverSpot = room.coverSpots[i];
					return;
				}
			}
			_contextCoverSpot = null;
		}
		
		protected function moveLeft():void
		{
			_facingLeft = true;
			velocity = Math.max(velocity - _acceleration, -_maxVelocity);
		}
		
		protected function moveRight():void
		{
			_facingLeft = false;
			velocity = Math.min(velocity + _acceleration, _maxVelocity);
		}
		
		protected function changeRoom(roomConnection:RoomConnection):void
		{
			room = roomConnection.room;
			x = roomConnection.entryX;
			y = room.roomY + 200;
		}
		
		private function updatePosition():void
		{
			x += velocity;
			if (x < 0)
			{
				if (room.westDoor == null)
				{
					x = 0;
				}
				else
				{
					changeRoom(room.westDoor);
				}
			}
			if (x > room.width - _width)
			{
				if (room.eastDoor == null)
				{
					x = room.width - _width;
				}
				else
				{
					changeRoom(room.eastDoor);
				}
			}
		}
		
		private function updateVelocity():void
		{
			if (velocity > 0)
			{
				velocity = Math.max(velocity - _friction, 0);
			}
			else
			{
				velocity = Math.min(velocity + _friction, 0);
			}
			if (_reloading) {
				velocity = 0;
			}
		}

		private function updateCoverScale():void
		{
			var faceDir:int = 1;
			if (_facingLeft) {
				faceDir = -1;
			}
			if (cover == Cover.FAR_LEFT || cover == Cover.FAR_RIGHT)
			{
				_sprite.scale.x = 0.8 * faceDir; 
				_sprite.scale.y = 0.8;
			}
			else if (cover == Cover.NEAR_LEFT || cover == Cover.NEAR_RIGHT)
			{
				_sprite.scale.x = 1.2 * faceDir; 
				_sprite.scale.y = 1.2;
			}
			else
			{
				_sprite.scale.x = 1.0 * faceDir; 
				_sprite.scale.y = 1.0;
			}
		}
		
		private function updateHitpoints():void 
		{
			var coverLeft:Number = 40;
			if (cover == Cover.NEAR_LEFT || cover == Cover.FAR_LEFT)
			{
				coverLeft = 80;
			}
			var coverRight:Number = 40;
			if (cover == Cover.NEAR_RIGHT || cover == Cover.FAR_RIGHT)
			{
				coverRight = 80;
			}
			var shotFromLeft:Boolean = Math.max(room.gunFireLeft - coverLeft, 0) / 10 > Math.random() * 100;
			var shotFromRight:Boolean = Math.max(room.gunFireRight - coverRight, 0) / 10 > Math.random() * 100;
			
			if (shotFromLeft || shotFromRight)
			{
				_sprite.color = 0xff0000;
				_hitPoints--;
				FlxG.play(gunSound);
			}
			else
			{
				_sprite.color = 0xffFFFF;
			}
		}
		
		protected function fireGun():void
		{
			if (_ammo == 0)
			{
				if (_mag > 0)
				{
					_actionActive = true;
					_mag--;
					_reloading = true;
					actionTimer.start(2, 1, function():void
						{
							_ammo = _baseAmmo;
							_actionActive = false;
							_reloading = false;
						});
				}
			}
			else {
				_firedGun = true;
				FlxG.play(gunSound);
				if (_facingLeft)
				{
					room.gunFireLeft = room.gunFireLeft - _gunDamage;
					if (room.gunFireLeft < 0) {
						room.gunFireLeft -= 100;
					}
					_ammo--;
				}
				else
				{
					room.gunFireRight = room.gunFireRight - _gunDamage;
					if (room.gunFireRight < 0) {
						room.gunFireRight -= 100;
					}
					_ammo--;
				}
			}
		}
	}

}