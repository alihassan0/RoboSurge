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
	var horizontalSapcing:Int = 64;
	var verticalSapcing:Int = 64;
	var offsetX:Int = 20;
	var offsetY:Int = 20;


	var fans:Array<Array<Fan>>;
	var level:TiledLevel;
	var levelNumber:Int = 0;
	
	var levelsGoalData:FlxSprite; 

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
		setupCrowd();

		
		// startWave();
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
		
		trace("you won");
		setupCrowd();
		
	}
	public function onSwitchCallback(fan:Fan)
	{
		if(checkGoalState())
			advanceLevel();
	}
	public function setupCrowd()
	{
		var tileMap = level.levelsArray[levelNumber];
		levelsGoalData.animation.frameIndex = levelNumber;
		levelsGoalData.updateFramePixels();

		trace(level.levelsArray.length);

		var s:String = "\n";

		for (i in 0...8)
		{
			for (j in 0...8)
			{
				s += tileMap.getTile(j, i)+" ";
			}
			s+="\n";
		}
		trace(s);

        FlxG.bitmapLog.add(levelsGoalData.framePixels);
		
		for (colIndex in 0...tileMap.heightInTiles)
		{
			for (rowIndex in 0...tileMap.widthInTiles)
			{
				fans[colIndex][rowIndex].init(offsetX + colIndex*verticalSapcing, offsetY + rowIndex*horizontalSapcing,
									rowIndex, colIndex, tileMap.getTile(colIndex, rowIndex), 
									levelsGoalData.framePixels.getPixel32(colIndex,rowIndex));
				fans[colIndex][rowIndex].onSwitchCallback = onSwitchCallback;
				fans[colIndex][rowIndex].addOnDownFunc(onDown.bind(_,fans[colIndex][rowIndex]));
			}
		}
	}

    public function onDown(sprite:FlxSprite, fan:Fan)
	{
		fan.switchCard();
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
