package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.input.mouse.FlxMouseEventManager;

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
				fans[colIndex].push(new Fan());
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
				trace(rowIndex, colIndex , offsetX, horizontalSapcing);
				correctPattern[rowIndex*tileMap.widthInTiles + colIndex].color = newColor;
				// verticalSapcing = 64 + rowIndex*64*.2;
				// offsetY = 40 - rowIndex*64*.1;
			}
		}
	}

    public function onDown(sprite:FlxSprite, fan:Fan)
	{
		fan.switchCard();
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

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
