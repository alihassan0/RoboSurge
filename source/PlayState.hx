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
	var sectorsCount = 6;
	var level:TiledLevel;
	var levelNumber:Int = 0;
	var movesCounter:Int = 1;

	var movesCounterText:FlxText;
	var levelNumberText:FlxText;
	
	var levelsGoalData:FlxSprite; 
	var correctPattern:Array<FlxSprite>;

	var backGrounds:Array<FlxBackdrop>;
	var decorations:Array<FlxBackdrop>;

	override public function create():Void
	{
		super.create();
		level = new TiledLevel("assets/levels/test.tmx");
		bgColor = 0xFF555555;


		backGrounds = new Array<FlxBackdrop>();
		decorations = new Array<FlxBackdrop>();
		for (i in 0...8){
			if(i == 0)
				backGrounds.push(new FlxBackdrop("assets/images/backgrounds/9.png", 1, 1, true, false));
			else
				backGrounds.push(new FlxBackdrop("assets/images/backgrounds/8.png", 1, 1, true, false));
			add(backGrounds[i]);
		}
		decorations.push(new FlxBackdrop("assets/images/backgrounds/11.png", 64/114, 1, true, false));
		decorations.push(new FlxBackdrop("assets/images/backgrounds/1.png", 64/85, 1, true, false));
		decorations[0].reset(0 ,54 - 114); 
		decorations[1].reset(0, 615);
		FlxG.state.add(decorations[0]);
		FlxG.state.add(decorations[1]);

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
			crowds[sectorsIndex] = new Crowd(sectorsIndex, level);
			crowds[sectorsIndex].onDoneCallback = onDoneCallback;
		}
		
		add(movesCounterText = new FlxText(0, FlxG.height - 30, 200, "Moves: 0", 24));
		add(levelNumberText = new FlxText(0, 10, FlxG.width, "Level: 1", 24).setFormat(null, 24, 0xFFFFFFFF, "center"));

		add(new FlxText(FlxG.width - 100, FlxG.height - 120, 100, "correct Pattern", 8).setFormat(null, 8, 0xFF000000, "left"));
		correctPattern = new Array<FlxSprite>();
		add(new FlxSprite(FlxG.width - 100, FlxG.height - 100).makeGraphic(100, 100, 0x333333));
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
		
		resetPattern(levelNumber);		
	}

	public function resetPattern(index:Int)
	{
		levelsGoalData.animation.frameIndex = index;
		levelsGoalData.updateFramePixels();

		for (colIndex in 0...8)
			for (rowIndex in 0...8)
				correctPattern[rowIndex*8 + colIndex].color = levelsGoalData.framePixels.getPixel32(colIndex,rowIndex);
	}

    public function onDoneCallback(crowd:Crowd)
	{
		
		startWave(crowds[levelNumber], true);
		trace(levelNumber, sectorsCount);
		if(levelNumber < sectorsCount-1)
			// advanceLevel(1, FlxEase.quadOut, 1);
			haxe.Timer.delay(advanceLevel.bind(.8, FlxEase.quadOut, 1), 3000);
		else
		{
			haxe.Timer.delay(advanceLevel.bind(.8, linear, sectorsCount-1), 1000);
			startFinalWave();
			haxe.Timer.delay(advanceLevel.bind(.1, linear, 0-levelNumber), 0);
		}
	}
    
	public function advanceLevel(duration:Float, ease:Float->Float, numOfLevels:Int = 1)
	{
		trace("WHY!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		duration *= numOfLevels;
		//@TODO : check if this is the last level
		levelNumber += numOfLevels;
		levelNumberText.text = "level: "+ (levelNumber+1);
		resetPattern(levelNumber);
		var tweenType = (numOfLevels < 0)? FlxTween.BACKWARD: FlxTween.ONESHOT; 
			
		for (i in 0...backGrounds.length)
		{
			FlxTween.tween(backGrounds[i], { x: backGrounds[i].x-642*numOfLevels*(1+.1*i)}, duration, {ease: ease, type: tweenType, onComplete: function(tween:FlxTween) {
			}}); 		
		}
		for (i in 0...decorations.length)
		{
			FlxTween.tween(decorations[i], { x: decorations[i].x-642*numOfLevels*(1+.1*i)}, duration, {ease: ease, type: tweenType, onComplete: function(tween:FlxTween) {
			}}); 		
		}

		for (sectorsIndex in 0...sectorsCount)
		{
			slideAlong(crowds[sectorsIndex], duration, ease, numOfLevels);
		}	
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
			delay += 100;
		}
	}
	public function startFinalWave()
	{
		var delay:Int = 0; 
		for (sectorsIndex in 0...sectorsCount)
		{
        	haxe.Timer.delay(startWave.bind(crowds[sectorsIndex], true), delay);
			delay += 100*10;
		}
	}
	public function slideAlong(crowd:Crowd, duration:Float, ease:Float->Float, numOfLevels:Int = 1)
	{
		crowd.slideAlong(duration, ease, numOfLevels);
	}
	
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(Math.random()<.04 && levelNumber < sectorsCount-1)
		{
			var randomFan:Fan = crowds[levelNumber].fans[Math.floor(Math.random()*8)][Math.floor(Math.random()*8)];
			if(randomFan.animation.finished)
				randomFan.playRandomAnimation();
		}
		if(FlxG.keys.justPressed.TAB && levelNumber< sectorsCount -1)
			startWave(crowds[levelNumber],true);
		
		if(FlxG.keys.justPressed.W)
			advanceLevel(1, FlxEase.quadOut, 1);
		
		if(FlxG.keys.justPressed.A)
		{
			haxe.Timer.delay(advanceLevel.bind(.8, linear, sectorsCount-levelNumber-1), 1000);
			startFinalWave();
		}

		
		if(FlxG.keys.justPressed.D)
		{
			haxe.Timer.delay(advanceLevel.bind(.8, linear, 0-levelNumber), 0);
			// startFinalWave();
		}
	}

	public function linear(t:Float):Float
	{
		return t ;
	}
}
