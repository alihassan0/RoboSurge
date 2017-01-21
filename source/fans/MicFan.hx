package fans;

import flixel.FlxSprite;
import flixel.FlxG;

class MicFan extends Fan
{
    private var mic:FlxSprite;

    public function new (x:Int = 0, y:Int = 0, type:String = "micFan")
    {
        super(x, y, type);
        fan.animation.add("idle", [0,1,0,1,0], 1, false);

        mic = new FlxSprite(x,y);
        mic.loadGraphic("assets/images/mic.png", true, 66, 66);
        mic.animation.add("idle", [0,1,2], 4, true);
        var micAnimation = [for (i in 0...4) i];
        micAnimation = micAnimation.concat(micAnimation).concat(micAnimation);
        micAnimation.push(6);
        mic.animation.add("useMic", micAnimation, 12, false);

        FlxG.state.add(mic);
        
        sign.visible = false;
        
    }
    override public function init(x:Float, y:Float, rowIndex:Int, colIndex:Int, type:Int, upsideColor:Int)
    {
        super.init(x, y,  rowIndex, colIndex, type, upsideColor);
        mic.reset(x, y);
        mic.scale.set(1+rowIndex*.1,1+rowIndex*.1);
        mic.updateHitbox();
    }
    override public function playRandomAnimation()
    {
        mic.animation.play("idle");
    }
    public function shoutInMic()
    {
        mic.animation.play("useMic");
    }
    override public function action()
    {
		shoutInMic();
    }
}
