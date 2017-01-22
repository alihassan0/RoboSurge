package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import flixel.util.FlxColor;

class InfoState extends FlxState
{
	override public function create():Void
	{
		super.create();
		add(new FlxSprite(0,0,"assets/images/mainMinue.png"));

		
		
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if(FlxG.keys.justPressed.W)
		{
			FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
			{
				FlxG.switchState(new PlayState());
			});
		}
	}
}
