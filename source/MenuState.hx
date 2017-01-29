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
		var x = FlxG.keys.firstJustPressed();
		if(x != -1)
			trace(x);
		if(FlxG.keys.justPressed.W)
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
