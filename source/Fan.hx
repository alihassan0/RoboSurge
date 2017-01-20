package;

import flixel.FlxSprite;
import flixel.FlxG;

class Fan extends FlxSprite
{
    private var fan:FlxSprite;
    private var sign:FlxSprite;
    public function new (x:Int, y:Int, rowIndex:Int, colIndex:Int)
    {
        super(x, y);
        loadGraphic("assets/images/stand.png");

        fan = new FlxSprite(x,y,"assets/images/fan.png");
        sign = new FlxSprite(x,y,"assets/images/sign.png");
        
        FlxG.state.add(this);
        FlxG.state.add(fan);
        FlxG.state.add(sign);
    }
}