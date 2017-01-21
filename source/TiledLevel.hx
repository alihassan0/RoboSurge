package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxTileFrames;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledTile;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.tile.FlxTileSpecial;

import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import haxe.io.Path;



/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/levels/";
	
	

	private var processedImage:FlxTileFrames;

	public var levelsArray:Array<FlxTilemap>;

	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		levelsArray = new Array<FlxTilemap>();
		// FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);
		
		var tilemap:FlxTilemap = new FlxTilemap();
			
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE) continue;
			if (!layer.visible) continue;
			
			var tileLayer:TiledTileLayer = cast layer;
			
			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == "tileset")
				{
					tileSet = ts;
					break;
				}
			}
			
			if (tileSet == null)
				throw "Tileset '" + tileSet.name + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";
				
			var imagePath 		= new Path(tileSet.imageSource);
			var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			processedImage = FlxTileFrames.fromBitmapAddSpacesAndBorders(processedPath, FlxPoint.weak(32, 32), new FlxPoint(0, 0), new FlxPoint(2, 2));
			

			
			//dirty hack to avoid repeading loading the map
			var tileArray = tileLayer.tileArray;

			
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedImage,
				tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);
			
			levelsArray.push(tilemap);
		}

	}


	// public function loadObjects()
	// {
	// 	var layer:TiledObjectLayer;
	// 	for (layer in layers)
	// 	{
	// 		if (layer.type != TiledLayerType.OBJECT)
	// 			continue;
	// 		var objectLayer:TiledObjectLayer = cast layer;
	// 		//objects layer
	// 		if (layer.name == "Objects")
	// 		{
	// 			for (o in objectLayer.objects)
	// 			{
	// 				loadObject(o, objectLayer, objectsLayer);
	// 			}
	// 		}
	// 	}
	// }
	
	// private function loadObject(o:TiledObject, g:TiledObjectLayer, group:FlxGroup)
	// {
	// 	var x:Int = o.x;
	// 	var y:Int = o.y;
		
	// 	// objects in tiled are aligned bottom-left (top-left in flixel)
	// 	if (o.gid != -1)
	// 		y -= g.map.getGidOwner(o.gid).tileHeight;


	// 	switch (o.type.toLowerCase())
	// 	{
	// 		case "wind-mill":
	// 			var mill:WindMill = new WindMill(x, y);
	// 			minimap.follow(mill,0xFF0000FF, mill.minimapDot);
	// 		// default:attack
	// 		// 	coins.add(new Coin(x,y));
	// 	}
	// }
	
}

