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
	var movesArray:Array<Int>;
	var movesCounterText:FlxText;
	var levelNumberText:FlxText;
	
	var levelsGoalData:FlxSprite; 
	var correctPattern:Array<FlxSprite>;

	var backGrounds:Array<FlxBackdrop>;
	var decorations:Array<FlxBackdrop>;

	var font:String = "assets/digit.ttf";

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
		decorations.push(new FlxBackdrop("assets/images/backgrounds/grass.jpg", 64/520, 1, true, false));
		decorations[0].reset(0 ,54 - 114); 
		decorations[1].reset(0, 615);
		decorations[2].reset(0, 615);
		FlxG.state.add(decorations[0]);
		FlxG.state.add(decorations[2]);
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
			crowds[sectorsIndex].decreaseMoves = decreaseMoves;
		}
		
		add(movesCounterText = new FlxText(0, FlxG.height - 50, 400, "Actions Left: 1"));
		movesCounterText.setFormat(font, 48, 0xFFFF0000, "left", FlxTextBorderStyle.SHADOW, 0xFF000000);
		movesCounterText.borderSize = 2;
		add(new FlxSprite(FlxG.width/2 -100 , 0).makeGraphic(200,40, 0xFF000000));
		add(levelNumberText = new FlxText(0, 0, FlxG.width, "Level: 1", 48).setFormat(font, 48, 0xFFFF0000, "center"));

		var correctPatternText:FlxText;
		add(correctPatternText = new FlxText(FlxG.width - 110, FlxG.height - 105, 100, "Target", 8));
		correctPatternText.setFormat(font, 24, 0xFFFFFFFF, "left", FlxTextBorderStyle.SHADOW, 0xFF000000);
		correctPatternText.borderSize = 4;
		correctPattern = new Array<FlxSprite>();
		add(new FlxSprite(FlxG.width - 100, FlxG.height - 80).makeGraphic(80, 80, 0xFF000000));
		for (i in 0...fansInRow*fansInCol)
		{
			var sign:FlxSprite = new FlxSprite(FlxG.width - 100 + i%fansInRow *10,
												FlxG.height - 80 + Math.floor(i/fansInRow )* 10);
			sign.makeGraphic(8,8);
			correctPattern.push(sign);
			add(sign);
		}
		
		for (sectorsIndex in 0...sectorsCount){
			crowds[sectorsIndex].setupCrowd(level, levelsGoalData, correctPattern);
			crowds[sectorsIndex].deactivate();

		}
		

		resetPattern(levelNumber);		
		movesArray = [1, 2, 5, 4, 3, 4];
		crowds[levelNumber].activate();
	}

	public function decreaseMoves():Bool
	{
		movesCounter--;
		if(crowds[levelNumber].checkGoalState())
		{
			onDoneCallback(crowds[levelNumber]);
		}
		else if(movesCounter < 0)
		{
			movesCounter = movesArray[levelNumber];
			crowds[levelNumber].reset(level);
			FlxG.camera.shake(.01);
			return false;
		}
		movesCounterText.text = "Actions Left: "+ (movesCounter);
		return true;
	}
	public function resetPattern(index:Int)
	{
		levelsGoalData.animation.frameIndex = index;
		levelsGoalData.updateFramePixels();

		for (colIndex in 0...8)
			for (rowIndex in 0...8)
			{
				var color = levelsGoalData.framePixels.getPixel32(colIndex,rowIndex);
				trace(color == 0xFFFFFFFF);

				correctPattern[rowIndex*8 + colIndex].color = 0xFFFF0000;
				if(color == 0xFFFFFFFF)
					correctPattern[rowIndex*8 + colIndex].alpha = .15;
				else 
					correctPattern[rowIndex*8 + colIndex].alpha = 1;

			}
	}

    public function onDoneCallback(crowd:Crowd)
	{
		startWave(crowds[levelNumber], true);
		
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
		duration *= numOfLevels;
		//@TODO : check if this is the last level
		levelNumber += numOfLevels;
		movesCounter = movesArray[levelNumber];

		levelNumberText.text = "level: "+ (levelNumber+1);
		movesCounterText.text = "Actions Left: "+ (movesCounter);
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
		if(levelNumber> 1)
			crowds[levelNumber-1].deactivate();
		crowds[levelNumber].activate();
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
        haxe.Timer.delay(goToGameOverState, delay);
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

	public function goToGameOverState()
	{
		FlxG.camera.fade(0xFF000000, .33, false, function()
		{
			FlxG.switchState(new InfoState());
		});
	}
	public function linear(t:Float):Float
	{
		return t ;
	}
}
