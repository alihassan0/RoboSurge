package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.input.mouse.FlxMouseEventManager;
import fans.*;

class PlayState extends FlxState
{
	var fansInRow:Int = 8; 
	var fansInCol:Int = 8; 
	var horizontalSapcing:Float = 64;
	var verticalSapcing:Float = 64;
	var offsetX:Float = 384;
	var offsetY:Float = 40;


	var fans:Array<Array<Fan>>;
	var level:TiledLevel;
	var levelNumber:Int = 0;
	var movesCounter:Int = 1;

	var movesCounterText:FlxText;
	var levelNumberText:FlxText;
	
	var levelsGoalData:FlxSprite; 
	var correctPattern:Array<FlxSprite>;

	override public function create():Void
	{
		super.create();

		level = new TiledLevel("assets/levels/test.tmx");
		bgColor = 0xFF555555;

		levelsGoalData = new FlxSprite();
		levelsGoalData.loadGraphic("assets/levels/levelsGoalData.png", true, 8, 8);
		levelsGoalData.useFramePixels;


		fans = new Array<Array<Fan>>();
		for (colIndex in 0...fansInCol)
		{
			fans[colIndex] = new Array<Fan>();
			for (rowIndex in 0...fansInRow)
			{
				if(Math.random()<.5)
					fans[colIndex].push(new DrumFan());
				else
					fans[colIndex].push(new NormalFan());
			}
		}

		add(movesCounterText = new FlxText(0, FlxG.height - 30, 200, "Moves: 0", 24));
		add(levelNumberText = new FlxText(0, 10, FlxG.width, "Level: 0", 24).setFormat(null, 24, 0xFFFFFFFF, "center"));

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
		
		setupCrowd();
		
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
		levelNumberText.text = "Moves: "+ levelNumber+1;
		
		trace("you won");
		setupCrowd();
		
	}
	public function onSwitchCallback(fan:Fan)
	{
		if(checkGoalState())
			startWave();
			
			// advanceLevel();
	}
	public function setupCrowd()
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
				newColor = levelsGoalData.framePixels.getPixel32(colIndex,rowIndex);

				fans[colIndex][rowIndex].init(offsetX + colIndex*horizontalSapcing, offsetY + rowIndex*verticalSapcing,
									rowIndex, colIndex, tileMap.getTile(colIndex, rowIndex), newColor);
				fans[colIndex][rowIndex].onSwitchCallback = onSwitchCallback;
				fans[colIndex][rowIndex].addOnDownFunc(onDown.bind(_,fans[colIndex][rowIndex]));
				correctPattern[rowIndex*tileMap.widthInTiles + colIndex].color = newColor;
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
    
	public function startWave()
	{
		var delay:Int = 0; 
		for (i in 0...fans.length)
		{
			for (j in 0...fans[i].length)
			{
        		haxe.Timer.delay(fans[i][j].showCard, delay);
			}
			delay += 50;
		}
	}
	public function inBound(x:Int, y:Int)
	{
		return x>= 0 && y >= 0 && x <8 && y <8;
	}
	public function getFanAt(rowIndex:Int, colIndex:Int)
	{
		return fans[rowIndex][colIndex];
	}
	public function startRipple(fan:Fan)
	{
		var delay:Int = 0; 
		var positions = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,0],[0,1],[1,-1],[1,0],[1,1]];
		trace("startRipplestartRipplestartRipplestartRipple");
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
	}
}
