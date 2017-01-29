package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import flixel.util.FlxColor;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		add(new FlxSprite(0,0,"assets/images/mainMinue.png"));
	}
	override public function update(elapsed:Float):Void
	{
		if(FlxG.keys.justPressed.ANY)
		{
			trace("why not working!!");
			FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
			{
				FlxG.switchState(new InfoState());
			});
		}
		super.update(elapsed);
	}
}
