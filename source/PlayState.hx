package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	var fansInRow:Int = 8; 
	var fansInCol:Int = 8; 
	var horizontalSapcing:Int = 70;
	var verticalSapcing:Int = 70;

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
				fans[colIndex].push(new Fan(colIndex*verticalSapcing, rowIndex*horizontalSapcing,
									rowIndex, colIndex));
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
