package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import flixel.util.FlxColor;

class GameOverState extends FlxState
{
	override public function create():Void
	{
		super.create();
		bgColor = 0xFFFFFFFF;
		add(new FlxSprite(FlxG.width/2-340,-20,"assets/images/end.png"));
		add(new FlxText(0,FlxG.height-300, 300, "Press SPACE to replay").setFormat(null,48,0xFFFF0000 ,"center"));
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if(FlxG.keys.justPressed.SPACE)
		{
			FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
			{
				FlxG.switchState(new MenuState());
			});
		}
	}
}
