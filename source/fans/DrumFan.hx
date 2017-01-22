package fans;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


class DrumFan extends Fan
{
    private var drum:FlxSprite;

    public function new (x:Int = 0, y:Int = 0, type:String = "dramFan")
    {
        super(x, y, type);
        sign.visible = false;
        
        drum = new FlxSprite(x,y);
        drum.loadGraphic("assets/images/dramSprite.png", true, 66, 66);
        drum.animation.add("idle", [0,1,2,3], 3, true);
        var drumAnimation = [for (i in 12...24) i];
        drumAnimation = drumAnimation.concat(drumAnimation).concat(drumAnimation);
        drumAnimation.push(12);
        drum.animation.add("playDrums", drumAnimation, 12, false);
        FlxG.state.add(drum);   

        fan.animation.add("idle", [0,1,0,1], 2, true);

        var drumAnimation = [4,5,6,7,4,5,6,7];
        drumAnimation = drumAnimation.concat(drumAnimation).concat(drumAnimation);
        fan.animation.add("playDrums", drumAnimation, 8, false);
        
    }
    override public function showCard(once:Bool)
    {
        sign.visible = true;
        drum.visible = false;
        super.showCard(once);
    }

    override public function onHideCallback()
    {
        sign.visible = false;
        drum.visible = true;
    }
    override public function slide()
    {
        super.slide();
        FlxTween.tween(drum, { x: x-642*(1+.1*rowIndex)}, 1, {ease: FlxEase.quadOut, type: FlxTween.ONESHOT}); 
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
        fan.animation.play("idle");
    }
    public function playDrum()
    {
        drum.animation.play("playDrums");
        fan.animation.play("playDrums");
    }
    override public function action()
    {
		playDrum();
    }
}
