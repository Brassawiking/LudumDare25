package Character
{
	import org.flixel.*;
	
	public class ProfessionalCharacter extends Character
	{
		public var follow:Boolean
		private var _player:Character.PlayerCharacter;
		private var _wanderTarget:Number = -10;
		private var _timer:Number = 0;
		private var _id:int;
		
		public static var id:int = 1;
		
		public function ProfessionalCharacter(room:Room, player:PlayerCharacter)
		{
			_id = id;
			id++;
			
			_player = player;
			follow = true;
			//x = player.x;
			super(room);
		}
		
		override public function update():void
		{
			
			if (FlxG.keys.justPressed(getKey())) {
				follow = !follow;
			}
			
			if (_hitPoints > 0)
			{
				if (follow)
				{
					followPlayer();
				}
				else
				{
					wander(false);
				}
				
				if (room.gunFireLeft > 0 && room.gunFireLeft > room.gunFireRight)
				{
					_aiming = true;
					velocity = 0;
					_timer = (_timer + 1) % 10;
					if (_timer == 0 )
					{
						_facingLeft = true;
						fireGun();
					}
					
				}
				else if (room.gunFireRight > 0)
				{
					_aiming = true;
					velocity = 0;
					_timer = (_timer + 1) % 10;
					if (_timer == 0)
					{
						_facingLeft = false;
						fireGun();
					}
				} else {
					_aiming = false;
				}
			}
			super.update();
		}
		
		private function getKey():String {
			switch (_id) {
				case 1: return "ONE";
				case 2: return "TWO";
				case 3: return "THREE";
				case 4: return "FOUR";
				case 5: return "FIVE";
				case 6: return "SIX";
				case 7: return "SEVEN";
				case 8: return "EIGTH";
				case 9: return "NINE";
			}
			return "ZERO";
		}
		
		protected function wander(stayNear:Boolean):void
		{
			if (_wanderTarget > room.width - 110 || Math.abs(x - _wanderTarget) < 3 || _wanderTarget < 0)
			{
				velocity = 0;
				_wanderTarget = Math.random() * room.width;
			}
			if (stayNear && Math.abs(_wanderTarget - _player.x) > 300) {
				velocity = 0;
				_wanderTarget = Math.random() * room.width;
			}
			if (x < _wanderTarget)
			{
				moveRight()
			}
			else
			{
				moveLeft();
			}
		}
		
		private function followPlayer():void
		{
			if (room == _player.room)
			{
				if (Math.abs(_player.velocity) > 1)
				{
					if (x < _player.x - 50)
					{
						moveRight();
					}
					else if (x > _player.x + 50)
					{
						moveLeft();
					}
				}
				else
				{
					wander(true);
				}
			}
			else
			{
				room = _player.room;
				x = _player.x;
				y = _player.y;
			}
		}
	
	}

}