package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.input.mouse.FlxMouseEventManager;
import fans.*;
import flixel.addons.display.FlxBackdrop;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class PlayState extends FlxState
{
	var fansInRow:Int = 8; 
	var fansInCol:Int = 8; 
	var horizontalSapcing:Float = 64;
	var verticalSapcing:Float = 64;
	var offsetX:Float = 384;
	var offsetY:Float = 40;

	var crowds:Array<Crowd>;
	var crowd:Crowd;
	var sectorsCount = 3;
	var level:TiledLevel;
	var levelNumber:Int = 0;
	var movesCounter:Int = 1;

	var movesCounterText:FlxText;
	var levelNumberText:FlxText;
	
	var levelsGoalData:FlxSprite; 
	var correctPattern:Array<FlxSprite>;

	var backGrounds:Array<FlxBackdrop>;

	override public function create():Void
	{
		super.create();
		level = new TiledLevel("assets/levels/test.tmx");
		bgColor = 0xFF555555;


		backGrounds = new Array<FlxBackdrop>();
		for (i in 0...8){
			if(i == 0)
				backGrounds.push(new FlxBackdrop("assets/images/backgrounds/9.png", 1, 1, true, false));
			else
				backGrounds.push(new FlxBackdrop("assets/images/backgrounds/8.png", 1, 1, true, false));
			add(backGrounds[i]);
		}
		
		for (rowIndex in 0...8)
		{
			horizontalSapcing = 64 + 64*.1*rowIndex;
			var offsetX2 = 320 - (642)*.1*.5 *rowIndex;
			var backGround = backGrounds[rowIndex];
			backGround.reset(offsetX2,16+ offsetY + rowIndex*verticalSapcing);
			backGround.scale.set(1+rowIndex*.1,1+rowIndex*.1);
		}
		
		levelsGoalData = new FlxSprite();
		levelsGoalData.loadGraphic("assets/levels/levelsGoalData.png", true, 8, 8);
		levelsGoalData.useFramePixels;

		
		crowds = new Array<Crowd>();

		for (sectorsIndex in 0...sectorsCount)
		{
			crowds[sectorsIndex] = new Crowd(sectorsIndex);
			crowds[sectorsIndex].onDoneCallback = onDoneCallback;
			
		}
		
		add(movesCounterText = new FlxText(0, FlxG.height - 30, 200, "Moves: 0", 24));
		add(levelNumberText = new FlxText(0, 10, FlxG.width, "Level: 1", 24).setFormat(null, 24, 0xFFFFFFFF, "center"));

		add(new FlxText(FlxG.width - 100, FlxG.height - 120, 100, "correct Pattern", 8).setFormat(null, 8, 0xFF000000, "left"));
		correctPattern = new Array<FlxSprite>();
		for (i in 0...fansInRow*fansInCol)
		{
			var sign:FlxSprite = new FlxSprite(FlxG.width - 100 + i%fansInRow *10,
												FlxG.height - 100 + Math.floor(i/fansInRow )* 10);
			sign.makeGraphic(8,8);
			correctPattern.push(sign);
			add(sign);
		}
		
		for (sectorsIndex in 0...sectorsCount)
			crowds[sectorsIndex].setupCrowd(level, levelsGoalData, correctPattern);
		

		
	}
	

    public function onDoneCallback(crowd:Crowd)
	{
		startWave(crowds[levelNumber], false);
	}
	

    
    
	public function startWave(crowd:Crowd,once:Bool)
	{
		var delay:Int = 0; 
		for (i in 0...crowd.fans.length)
		{
			for (j in 0...crowd.fans[i].length)
			{
        		haxe.Timer.delay(crowd.fans[i][j].showCard.bind(once), delay);
			}
			delay += 50;
		}
	}
	public function advanceLevel(duration:Float, ease:Float->Float, numOfLevels:Int = 1)
	{
		//@TODO : check if this is the last level
		levelNumber ++;
		levelNumberText.text = "level: "+ (levelNumber+1);

		for (i in 0...backGrounds.length)
		{
			FlxTween.tween(backGrounds[i], { x: backGrounds[i].x-642*numOfLevels*(1+.1*i)}, duration, {ease: ease, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
			}}); 		
		}

		for (sectorsIndex in 0...sectorsCount)
		{
			slideAlong(crowds[sectorsIndex], duration, ease, numOfLevels);
		}	
	}

	public function startFinalWave()
	{
		var delay:Int = 0; 
		for (sectorsIndex in 0...sectorsCount)
		{
        	haxe.Timer.delay(startWave.bind(crowds[sectorsIndex], false), delay);
			delay += 50*8;
		}
	}
	public function slideAlong(crowd:Crowd, duration:Float, ease:Float->Float, numOfLevels:Int = 1)
	{
		crowd.slideAlong(duration, ease, numOfLevels);
	}
	
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(Math.random()<.04)
		{
			var randomFan:Fan = crowds[levelNumber].fans[Math.floor(Math.random()*8)][Math.floor(Math.random()*8)];
			if(randomFan.animation.finished)
				randomFan.playRandomAnimation();
		}
		if(FlxG.keys.justPressed.TAB)
			startWave(crowds[levelNumber],true);
		
		if(FlxG.keys.justPressed.W)
			advanceLevel(1, FlxEase.quadOut, 1);
		
		if(FlxG.keys.justPressed.A)
		{
			advanceLevel(2.5, linear, 2);
			startFinalWave();
		}

		// if(FlxG.keys.justPressed.W)
	}

	public function linear(t:Float):Float
	{
		return t ;
	}
}
