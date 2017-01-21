package fans;

import flixel.FlxSprite;
import flixel.FlxG;

class DrumFan extends Fan
{
    private var drum:FlxSprite;


    public function new (x:Int = 0, y:Int = 0, type:String = "dramFan")
    {
        super(x, y, type);
        fan.animation.add("idle", [0,1,2,3,4,5,6,7], 8, false);
        fan.animation.add("sleep",[10,11,12,13,14,15,16,17,18,19,18,17,16,15,14,13,12,11,10], 5, false);

        drum = new FlxSprite(x,y);
        drum.loadGraphic("assets/images/"+ type +"Sprite.png", true, 66, 66);
        
    }
}
