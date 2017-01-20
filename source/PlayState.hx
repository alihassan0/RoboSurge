package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.input.mouse.FlxMouseEventManager;

class PlayState extends FlxState
{
	var fansInRow:Int = 8; 
	var fansInCol:Int = 8; 
	var horizontalSapcing:Int = 64;
	var verticalSapcing:Int = 64;
	var offsetX:Int = 20;
	var offsetY:Int = 20;
	var fans:Array<Array<Fan>>;
	override public function create():Void
	{
		super.create();


		fans = new Array<Array<Fan>>();
		for (colIndex in 0...fansInCol)
		{
			fans[colIndex] = new Array<Fan>();
			for (rowIndex in 0...fansInRow)
			{
				fans[colIndex].push(new Fan(offsetX + colIndex*verticalSapcing, offsetY + rowIndex*horizontalSapcing,
									rowIndex, colIndex));
				FlxMouseEventManager.add(fans[colIndex][rowIndex], onDown, null, null, null);
			}
		}
	}


    public function onDown(sprite:FlxSprite)
	{
        var fan:Fan = cast sprite;
        trace("clicked @", fan.colIndex, fan.rowIndex);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
