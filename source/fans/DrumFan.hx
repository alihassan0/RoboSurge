package fans;

import flixel.FlxSprite;
import flixel.FlxG;

class DrumFan extends Fan
{
    private var drum:FlxSprite;

    public function new (x:Int = 0, y:Int = 0, type:String = "dramFan")
    {
        super(x, y, type);
        fan.animation.add("idle", [0,1,0,1,0], 1, false);

        drum = new FlxSprite(x,y);
        drum.loadGraphic("assets/images/dramSprite.png", true, 66, 66);
        drum.animation.add("idle", [0,1,2,3], 3, true);
        
        FlxG.state.add(drum);
        
        sign.visible = false;
        
    }
    override public function init(x:Float, y:Float, rowIndex:Int, colIndex:Int, type:Int, upsideColor:Int)
    {
        super.init(x, y,  rowIndex, colIndex, type, upsideColor);
        drum.reset(x, y);
        drum.scale.set(1+rowIndex*.1,1+rowIndex*.1);
        drum.updateHitbox();
        
    }
    override public function playRandomAnimation()
    {
        drum.animation.play("idle");
    }
}
