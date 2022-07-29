package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

using StringTools;

typedef BuildingType =
{
	var name:String;
	var frameIndex:Int;
}

class BuildingScroll extends FlxSpriteGroup
{
	public var buildingList:Array<FlxSprite> = [];

	public var buildingNames:Array<BuildingType> = [
		{name: "Floppa Store", frameIndex: 0},
		{name: "The Place", frameIndex: 1},
		{name: "Fred's Bakery", frameIndex: 2},
		{name: "Pets Untied", frameIndex: 3},
		// {name: "Lazer's Tag Closed", frameIndex: 4},
		{name: "Lazer's Tag", frameIndex: 5}
	];

	var lazersTagClosed:BuildingType = {name: "Lazer's Tag Closed", frameIndex: 4};

	public function genBuilding(x:Int)
	{
		var building = new FlxSprite(x);
		building.frames = Paths.getSparrowAtlas('Buildings');
		// for (i in 0...buildingNames.length)
		//	building.animation.addByIndices(buildingNames[i].name, 'Building Frames', [buildingNames[i].frameIndex], '', 24, true, false, false);
		building.antialiasing = ClientSettings.getBoolByString('antialiasing', true);
		add(building);
		buildingList.push(building);

		var intendedBuilding:String = buildingNames[(buildingList.length - 1) % buildingNames.length].name;
		// if (intendedBuilding.startsWith("Lazer's Tag"))
		// {
		//	intendedBuilding = FlxG.random.int(0, 10) > 7 ? "Lazer's Tag" : "Lazer's Tag Closed";
		// }
		swapBuilding(buildingList.length - 1, intendedBuilding);

		building.x -= 375;
		building.y -= 55;
	}

	public function swapBuilding(building:Int, ?overrideBuilding:String = '')
	{
		for (i in buildingNames)
		{
			if (i.name.toLowerCase() == overrideBuilding.toLowerCase())
			{
				var buildingData:BuildingType = i;
				if (i.name.toLowerCase() == 'lazer\'s tag' && FlxG.random.bool(25))
					buildingData = lazersTagClosed;

				buildingList[building].animation.addByIndices(buildingData.name, 'Building Frames', [buildingData.frameIndex], '', 24, true, false, false);
				buildingList[building].animation.play(buildingData.name, true);
				return;
			}
		}
		buildingList[building].animation.play(FlxG.random.getObject(buildingNames).name, true);
	}

	// 492px apart
	override public function new(x:Int, y:Int, buildingCount:Int)
	{
		super(x, y);

		for (i in 0...buildingCount)
			genBuilding(i * 492);
	}
}
