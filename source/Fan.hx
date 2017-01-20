package;

import flixel.FlxSprite;
import flixel.FlxG;

class Fan extends FlxSprite
{
    public function new (x:Int, y:Int, rowIndex:Int, colIndex:Int)
    {
        super(x, y);
        makeGraphic(32,32,0xFF00FFFF);
        FlxG.state.add(this);
    }
}