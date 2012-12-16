package Character
{
	import org.flixel.*;
	import States.Start;
	import States.Test;
	import UI.UI;
	
	public class PlayerCharacter extends Character
	{
		
		public function PlayerCharacter(room:Room = null)
		{
			super(room);
		}
		
		override public function update():void
		{
			if (_hitPoints > 0)
			{
				if (FlxG.keys.justPressed("Z") && _contextRoomConnection != null)
				{
					changeRoom(_contextRoomConnection);
				}
				
				if (FlxG.keys.justPressed("Z") && _contextCoverSpot != null)
				{
					if (cover == Cover.NONE)
					{
						cover = _contextCoverSpot.cover;
					}
					else
					{
						cover = Cover.NONE;
					}
				}
				
				_aiming = false;
				if (!_actionActive)
				{
					if (FlxG.keys.A)
					{
						_aiming = true;
					}
				}
				if (_aiming && FlxG.keys.justPressed("S"))
				{
					fireGun();
				}
				
				if (!_actionActive && cover == Cover.NONE && !_aiming)
				{
					if (FlxG.keys.LEFT)
					{
						moveLeft();
					}
					if (FlxG.keys.RIGHT)
					{
						moveRight();
					}
				}
				else if (!_actionActive)
				{
					if (FlxG.keys.LEFT)
					{
						_facingLeft = true;
					}
					if (FlxG.keys.RIGHT)
					{
						_facingLeft = false;
					}
				}
				
				if (FlxG.keys.SPACE && !_actionActive)
				{
					_actionActive = true;
					actionTimer.start(1, 1, function():void
						{
							_actionActive = false;
						});
				}
				updateIcons();

			}
			else {
				FlxG.fade(0xff000000, 1 , function():void {
					FlxG.switchState(new Start());
				});
			}
			
			super.update();
		}
		
		protected function updateIcons():void
		{
			UI.UI.ui_Instance.enterRoomIcon.visible = _contextRoomConnection != null;
			UI.UI.ui_Instance.getCoverIcon.visible = _contextCoverSpot != null && cover == Cover.NONE;
			UI.UI.ui_Instance.leaveCoverIcon.visible = cover != Cover.NONE;
			
			UI.UI.ui_Instance.updateLeftGunBar(room.gunFireLeft);
			UI.UI.ui_Instance.updateRightGunBar(room.gunFireRight);
			UI.UI.ui_Instance.updateMag(_mag);
		}
	}
}