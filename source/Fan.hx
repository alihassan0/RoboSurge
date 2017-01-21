package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;

import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flash.display.BitmapData;

class Fan extends FlxSprite
{
    private var fan:FlxSprite;
    private var sign:FlxSprite;
    
    public var rowIndex:Int;
    public var colIndex:Int;

    public var isUpside:Bool;

    public var upsideImage:BitmapData;
    public var upsideColor:Int = 0xFFFF00FF;
    
    public var downsideImage:BitmapData;
    public var downSideColor:Int = 0xFF4DFD78;

    public var onSwitchCallback:Fan->Void;
    public var type:String;


    public function new (x:Int = 0, y:Int = 0, ?type:String = "fan")
    {
        super(x, y);
        loadGraphic("assets/images/stand.png");
        this.type = type;

        fan = new FlxSprite(x,y);
        fan.loadGraphic("assets/images/"+ type +"Sprite.png", true, 66, 66);
        sign = new FlxSprite(x,y,"assets/images/sign.png");
        sign.loadGraphic("assets/images/sign.png", false, 0, 0, true);

        FlxG.state.add(this);
        FlxG.state.add(fan);
        FlxG.state.add(sign);

    }
    public function play(anim:String)
    {
        fan.animation.play(anim);
    }
    public function init(x:Float, y:Float, rowIndex:Int, colIndex:Int, type:Int, upsideColor:Int)
    {
        reset(x, y);
        fan.reset(x, y);
        sign.reset(x, y);
        
        this.isUpside = type == 2;
        this.rowIndex = rowIndex;
        this.colIndex = colIndex;
        this.upsideColor = upsideColor;

        this.scale.set(1+rowIndex*.1,1+rowIndex*.1);
        this.updateHitbox();
        fan.scale.set(1+rowIndex*.1,1+rowIndex*.1);
        fan.updateHitbox();
        sign.scale.set(1+rowIndex*.1,1+rowIndex*.1);
        sign.updateHitbox();

        setupSignColors();
        FlxG.bitmapLog.add(upsideImage);
        FlxG.bitmapLog.add(downsideImage);
		
        updateSignColor();
    }
    public function updateSignColor()
    {
        // isUpside = !isUpside;
        sign.pixels.dispose();

        if(isUpside)
            sign.pixels = upsideImage.clone();
        else
            sign.pixels = downsideImage.clone();
    }
    public function playRandomAnimation()
    {
        
    }
    public function action()
    {
		
    }
    public function setupSignColors()
    {
        sign.loadGraphic("assets/images/sign.png", false, 0, 0, true);

        if(upsideImage != null)
            upsideImage.dispose();

        if(downsideImage != null)
            downsideImage.dispose();

        upsideImage = sign.pixels.clone();
        downsideImage = sign.pixels.clone();
        
        for (i in 0 ... upsideImage.width) 
		{
			for (j in 0 ... upsideImage.height)
			{
                if(upsideImage.getPixel32(i,j) == 0xFFFDD14D)
				{
					upsideImage.setPixel32(i,j,upsideColor);
                    downsideImage.setPixel32(i,j,downSideColor);
				}
			}
		}
        updateSignColor();
    }
    public function switchCard()
    {
        var newScale:Float = -1*sign.scale.x;

        FlxTween.tween(sign.scale, { x: 0}, 1, { startDelay: Math.random()*.1, ease: FlxEase.sineInOut, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
            isUpside = !isUpside;
            updateSignColor();
            FlxTween.tween(sign.scale, { x: newScale}, 1, { startDelay: Math.random()*.1, ease: FlxEase.sineInOut, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
                if(onSwitchCallback != null)
                    onSwitchCallback(this);
            }});
        }}); 
    }

    public function showCard(once:Bool)
    {
        var tweenType = once? FlxTween.ONESHOT : FlxTween.PINGPONG;

        FlxTween.tween(sign, { y: y-50},
			1, { startDelay: Math.random()*.1, ease: FlxEase.sineInOut, type: tweenType, onComplete: function(tween:FlxTween) {
				// if (autoHide) hideLetter(letter);
        } });
        var newScale:Float = 1.5*sign.scale.x;
        FlxTween.tween(sign.scale, { x: newScale, y:2 },
			1, { startDelay: Math.random()*.1, ease: FlxEase.sineInOut, type: tweenType, onComplete: function(tween:FlxTween) {
				if(once)
                    hideCard();
        } });
    }
    public function onHideCallback()
    {

    }
    public function hideCard()
    {
        FlxTween.tween(sign, { y: y},
			1, { startDelay: Math.random()*.1, ease: FlxEase.sineInOut, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
				// if (autoHide) hideLetter(letter);
        } });
        var newScale:Float = (1/1.5)*sign.scale.x;
        FlxTween.tween(sign.scale, { x: newScale, y:1 },
			1, { startDelay: Math.random()*.1, ease: FlxEase.sineInOut, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
				onHideCallback();
        } });
    }
    public function addOnDownFunc(onDown:FlxSprite->Void)
    {
        FlxMouseEventManager.add(this, onDown, null, null, null, false);
        FlxMouseEventManager.add(fan, onDown, null, null, null, false);
        FlxMouseEventManager.add(sign, onDown, null, null, null, false);
    }
}