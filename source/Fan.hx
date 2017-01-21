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


    public function new (x:Int, y:Int, rowIndex:Int, colIndex:Int, type:Int, upsideColor:Int)
    {
        super(x, y);
        loadGraphic("assets/images/stand.png");
        isUpside = type == 2;
        // trace(rowIndex, colIndex, type, isUpside);


        this.rowIndex = rowIndex;
        this.colIndex = colIndex;
        this.upsideColor = upsideColor;
        

        fan = new FlxSprite(x,y,"assets/images/fan.png");
        sign = new FlxSprite(x,y,"assets/images/sign.png");
        sign.loadGraphic("assets/images/sign.png", false, 0, 0, true);

        FlxG.state.add(this);
        FlxG.state.add(fan);
        FlxG.state.add(sign);

        setupSignColors();
    }
    public function updateSignColor()
    {
        // isUpside = !isUpside;
        
        if(isUpside)
            sign.pixels = upsideImage.clone();
        else
            sign.pixels = downsideImage.clone();

    }
    public function setupSignColors()
    {
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
        var newScale:Int = Math.floor(-1*sign.scale.x);
        trace(newScale);
       FlxTween.tween(sign.scale, { x: 0}, 1, { startDelay: Math.random()*.1, ease: FlxEase.quadOut, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
            isUpside = !isUpside;
            updateSignColor();
            FlxTween.tween(sign.scale, { x: newScale}, 1, { startDelay: Math.random()*.1, ease: FlxEase.quadOut, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
                //btngan
            }});
        } }); 
    }
    // public function switchCard()
    // {
    //     // var newScale:Int = Math.floor(-1*sign.scale.x);
    //     // trace(newScale);
    //    FlxTween.tween(sign.scale, { x: -1*sign.scale.x}, 1, { startDelay: Math.random()*.1, ease: FlxEase.quadOut, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
    //         isUpside = !isUpside;
    //         updateSignColor();
    //         FlxTween.tween(sign.scale, { x: newScale}, 1, { startDelay: Math.random()*.1, ease: FlxEase.quadOut, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
    //             //btngan
    //         }});
    //     } }); 
    // }
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