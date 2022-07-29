package;

import flixel.FlxG;
import flixel.util.FlxSave;

class ClientSettings
{
	public static var globalSave:FlxSave;

	// old settings system
	/*// Volume
		public static var soundVolume:Float = 1;
		public static var musicVolume:Float = 0.25;

		// Cameras
		public static var cameraMovement:Bool = true;
		public static var camZooming:Float = 1.0;
		public static var camRotation:Float = 1.0;

		// Visuals
		public static var antialiasing:Bool = true;

		// Gameplay
		public static var pauseBGBlur:Bool = true;

		// Shaders
		public static var philWarningShader:Bool = true; */
	// new save maps
	private static var intMap:Map<String, Int>;
	private static var floatMap:Map<String, Float>;
	private static var boolMap:Map<String, Bool>;

	public static function retrieveData()
	{
		if (globalSave == null)
		{
			globalSave = new FlxSave();
			globalSave.bind("CCGlobal");
		}

		checkForNullMaps();

		retrieveIntSaves();
		retrieveFloatSaves();
		retrieveBooleanSaves();
	}

	static function retrieveIntSaves()
	{
		checkForNullMaps();
		if (globalSave.data.intMapSaves_keys != null && globalSave.data.intMapSaves_values != null)
		{
			var keys:Array<String> = globalSave.data.intMapSaves_keys;
			var values:Array<Int> = globalSave.data.intMapSaves_values;

			if (keys.length != values.length)
			{
				trace('Integer data mismatch! Aborting retrievement of int values...');
				return false;
			}

			for (i in 0...keys.length)
				intMap.set(keys[i], values[i]);

			trace('Integer data loaded! Data: ${intMap}');

			return true;
		}

		trace('Integer data MISSING! Aborting retrievement of int values...');

		return false;
	}

	static function retrieveFloatSaves()
	{
		checkForNullMaps();
		if (globalSave.data.floatMapSaves_keys != null && globalSave.data.floatMapSaves_values != null)
		{
			var keys:Array<String> = globalSave.data.floatMapSaves_keys;
			var values:Array<Float> = globalSave.data.floatMapSaves_values;

			if (keys.length != values.length)
			{
				trace('Float data mismatch! Aborting retrievement of float values....');
				return false;
			}

			for (i in 0...keys.length)
				floatMap.set(keys[i], values[i]);

			trace('Float data loaded! Data: ${floatMap}');

			return true;
		}

		trace('Float data MISSING! Aborting retrievement of float values...');

		return false;
	}

	static function retrieveBooleanSaves()
	{
		checkForNullMaps();
		if (globalSave.data.booleanMapSaves_keys != null && globalSave.data.booleanMapSaves_values != null)
		{
			var keys:Array<String> = globalSave.data.booleanMapSaves_keys;
			var values:Array<Bool> = globalSave.data.booleanMapSaves_values;

			if (keys.length != values.length)
			{
				trace('Boolean data mismatch! Aborting retrievement of boolean values....');
				return false;
			}

			for (i in 0...keys.length)
				boolMap.set(keys[i], values[i]);

			trace('Boolean data loaded! Data: ${boolMap}');

			return true;
		}

		trace('Boolean data MISSING! Aborting retrievement of boolean values...');

		return false;
	}

	public static function setData()
	{
		// integer saving
		var intKeys:Array<String> = [];
		var intValues:Array<Int> = [];

		for (i in intMap.keys())
		{
			intKeys.push(i);
			intValues.push(intMap.get(i));
		}

		globalSave.data.intMapSaves_keys = intKeys;
		globalSave.data.intMapSaves_values = intValues;

		// float saving
		var floatKeys:Array<String> = [];
		var floatValues:Array<Float> = [];

		for (i in floatMap.keys())
		{
			floatKeys.push(i);
			floatValues.push(floatMap.get(i));
		}

		globalSave.data.floatMapSaves_keys = floatKeys;
		globalSave.data.floatMapSaves_values = floatValues;

		// bool saving
		var booleanKeys:Array<String> = [];
		var booleanValues:Array<Bool> = [];

		for (i in boolMap.keys())
		{
			booleanKeys.push(i);
			booleanValues.push(boolMap.get(i));
		}

		globalSave.data.booleanMapSaves_keys = booleanKeys;
		globalSave.data.booleanMapSaves_values = booleanValues;

		// push saves
		globalSave.flush();
	}

	public static function wipeData()
	{
		globalSave.data.intMapSaves_keys = null;
		globalSave.data.intMapSaves_values = null;

		globalSave.data.floatMapSaves_keys = null;
		globalSave.data.floatMapSaves_values = null;

		globalSave.data.booleanMapSaves_keys = null;
		globalSave.data.booleanMapSaves_values = null;

		intMap.clear();
		floatMap.clear();
		boolMap.clear();

		// push saves
		globalSave.flush();
	}

	public static function checkForNullMaps()
	{
		if (intMap == null)
			intMap = new Map<String, Int>();
		if (floatMap == null)
			floatMap = new Map<String, Float>();
		if (boolMap == null)
			boolMap = new Map<String, Bool>();
	}

	public static function updateBoolByString(str:String, value:Bool)
	{
		checkForNullMaps();
		trace('$str = $value');

		boolMap.set(str, value);

		if (str == 'autopause')
			FlxG.autoPause = value;
	}

	public static function updateIntByString(str:String, value:Int)
	{
		checkForNullMaps();
		trace('$str = $value');

		intMap.set(str, value);

		if (str == 'musicvolume')
			FlxG.sound.music.volume = value / 100;
	}

	public static function updateFloatByString(str:String, value:Float)
	{
		checkForNullMaps();
		trace('$str = $value');

		floatMap.set(str, value);
	}

	public static function getBoolByString(str:String, ?def:Bool = false)
	{
		checkForNullMaps();
		if (boolMap.exists(str))
			return boolMap.get(str);
		// trace('Failed to return bool save $str! Returning $def instead...');
		return def;
	}

	public static function getIntByString(str:String, ?def:Int = 50)
	{
		checkForNullMaps();
		if (intMap.exists(str))
			return intMap.get(str);
		// trace('Failed to return int save $str! Returning $def instead...');]
		return def;
	}

	public static function getFloatByString(str:String, ?def:Float = 0.5)
	{
		checkForNullMaps();
		if (floatMap.exists(str))
			return floatMap.get(str);
		// trace('Failed to return float save $str! Returning $def instead...');
		return def;
	}
}
