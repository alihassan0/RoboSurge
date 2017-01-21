package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;

import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Fan extends FlxSprite
{
    private var fan:FlxSprite;
    private var sign:FlxSprite;
    
    public var rowIndex:Int;
    public var colIndex:Int;

    public function new (x:Int, y:Int, rowIndex:Int, colIndex:Int)
    {
        super(x, y);
        loadGraphic("assets/images/stand.png");

        this.rowIndex = rowIndex;
        this.colIndex = colIndex;
        
        fan = new FlxSprite(x,y,"assets/images/fan.png");
        sign = new FlxSprite(x,y,"assets/images/sign.png");

        FlxG.state.add(this);
        FlxG.state.add(fan);
        FlxG.state.add(sign);

		
    }
    public function showCard()
    {
        FlxTween.tween(sign, { y: y-50},
			1, { startDelay: Math.random()*.1, ease: FlxEase.quadOut, type: FlxTween.PINGPONG, onComplete: function(tween:FlxTween) {
				// if (autoHide) hideLetter(letter);
        } });
        
        FlxTween.tween(sign.scale, { x: 1.5, y:2 },
			1, { startDelay: Math.random()*.1, ease: FlxEase.quadOut, type: FlxTween.PINGPONG, onComplete: function(tween:FlxTween) {
				// if (autoHide) hideLetter(letter);
        } });
    }
    public function addOnDownFunc(onDown:FlxSprite->Void)
    {
        FlxMouseEventManager.add(this, onDown, null, null, null, false);
        FlxMouseEventManager.add(fan, onDown, null, null, null, false);
        FlxMouseEventManager.add(sign, onDown, null, null, null, false);
    }
}