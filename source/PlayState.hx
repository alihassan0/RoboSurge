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

	var fansSectors:Array<Array<Array<Fan>>>;
	var fans:Array<Array<Fan>>;
	var sectorsCount = 5;
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

		levelsGoalData = new FlxSprite();
		levelsGoalData.loadGraphic("assets/levels/levelsGoalData.png", true, 8, 8);
		levelsGoalData.useFramePixels;

		
		fansSectors = new Array<Array<Array<Fan>>>();

		for (sectorsIndex in 0...sectorsCount)
		{
			fansSectors[sectorsIndex] = new Array<Array<Fan>>();
			fans = fansSectors[sectorsIndex];
			for (colIndex in 0...fansInCol)
			{
				fans[colIndex] = new Array<Fan>();
				for (rowIndex in 0...fansInRow)
				{
					if(Math.random()<.3)
						fans[colIndex].push(new DrumFan());
					else if(Math.random()<.7)
						fans[colIndex].push(new NormalFan());
					else
						fans[colIndex].push(new MicFan());
				}
			}
		}
		fans = fansSectors[levelNumber];

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
		
		setupCrowd(fans);
		
	}
	public function checkGoalState():Bool
	{
		for (i in 0...fans.length)
			for (j in 0...fans[i].length)
				if(!fans[i][j].isUpside){
					return false;
				}
				
		return true;
	}
	public function advanceLevel()
	{
		//@TODO : check if this is the last level
		levelNumber ++;
		levelNumberText.text = "level: "+ (levelNumber+1);
		slideAlong();
		// setupCrowd();
		
	}
	public function onSwitchCallback(fan:Fan)
	{
		if(checkGoalState())
			startWave(false);
			
			// advanceLevel();
	}
	public function setupCrowd(fans:Array<Array<Fan>>)
	{
		var tileMap = level.levelsArray[levelNumber];
		levelsGoalData.animation.frameIndex = levelNumber;
		levelsGoalData.updateFramePixels();


		// var s:String = "\n";

		// for (i in 0...8)
		// {
		// 	for (j in 0...8)
		// 	{
		// 		s += tileMap.getTile(j, i)+" ";
		// 	}
		// 	s+="\n";
		// }
		// trace(s);
		var newColor:Int = 0;
		for (colIndex in 0...tileMap.heightInTiles)
		{
			for (rowIndex in 0...tileMap.widthInTiles)
			{
				horizontalSapcing = 64 + 64*.1*rowIndex;
				offsetX = 384 - (8*64)*.1*.5 *rowIndex;
				var offsetX2 = 320 - (10*64)*.1*.5 *rowIndex;
				newColor = levelsGoalData.framePixels.getPixel32(colIndex,rowIndex);

				fans[colIndex][rowIndex].init(offsetX + colIndex*horizontalSapcing, offsetY + rowIndex*verticalSapcing,
									rowIndex, colIndex, tileMap.getTile(colIndex, rowIndex), newColor);
				fans[colIndex][rowIndex].onSwitchCallback = onSwitchCallback;
				fans[colIndex][rowIndex].addOnDownFunc(onDown.bind(_,fans[colIndex][rowIndex]));
				correctPattern[rowIndex*tileMap.widthInTiles + colIndex].color = newColor;

				if(colIndex == 0)
				{
					var backGround = backGrounds[rowIndex];

					backGround.reset(offsetX2,16+ offsetY + rowIndex*verticalSapcing);
					backGround.scale.set(1+rowIndex*.1,1+rowIndex*.1);
					// add(new FlxSprite(320,50,"assets/images/9.png"));
				}
		
				// verticalSapcing = 64 + rowIndex*64*.2;
				// offsetY = 40 - rowIndex*64*.1;
			}
		}
	}

    public function onDown(sprite:FlxSprite, fan:Fan)
	{
		if(fan.type == "dramFan")			
			startRipple(fan);

		fan.action();
		
		if(movesCounter > 0)
		{
			movesCounter --;
			movesCounterText.text = "Moves: "+ movesCounter;
		}
		else
			trace("GameOver");
			// startNextLevel();
        trace("clicked @", fan.colIndex, fan.rowIndex);
	}
    
	public function startWave(once:Bool)
	{
		var delay:Int = 0; 
		for (i in 0...fans.length)
		{
			for (j in 0...fans[i].length)
			{
        		haxe.Timer.delay(fans[i][j].showCard.bind(once), delay);
			}
			delay += 50;
		}
	}
	public function slideAlong()
	{
		//move 
		for (i in 0...backGrounds.length)
		{
			FlxTween.tween(backGrounds[i], { x: backGrounds[i].x-642*(1+.1*i)}, 1, {ease: FlxEase.quadOut, type: FlxTween.ONESHOT, onComplete: function(tween:FlxTween) {
			}}); 
				
		}
		
		for (colIndex in 0...fansInCol)
		{
			for (rowIndex in 0...fansInRow)
			{
				fans[colIndex][rowIndex].slide();
			}
		}

	}
	public function inBound(x:Int, y:Int)
	{
		return x>= 0 && y >= 0 && x <8 && y <8;
	}
	public function getFanAt(rowIndex:Int, colIndex:Int)
	{
		trace(rowIndex, colIndex);
		return fans[rowIndex][colIndex];
	}
	public function startRipple(fan:Fan)
	{
		var delay:Int = 0; 
		var positions = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,0],[0,1],[1,-1],[1,0],[1,1]];
		var x, y, currentFan;
		for (i in 0...positions.length)
		{
			x = positions[i][0]+fan.colIndex;
			y = positions[i][1]+fan.rowIndex;
			trace(x, y, inBound(x, y), getFanAt(x,y).type);
			if(inBound(x, y))
			{
				currentFan = getFanAt(x,y);
				if(currentFan.type == "fan")
        			haxe.Timer.delay(currentFan.switchCard, delay);
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(Math.random()<.04)
		{
			var randomFan:Fan = fans[Math.floor(Math.random()*8)][Math.floor(Math.random()*8)];
			if(randomFan.animation.finished)
				randomFan.playRandomAnimation();
		}
		if(FlxG.keys.justPressed.TAB)
			startWave(true);
		
		if(FlxG.keys.justPressed.W)
			advanceLevel();
	}
}
