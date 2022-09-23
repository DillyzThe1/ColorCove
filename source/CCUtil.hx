package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxShader;
import flixel.util.typeLimit.OneOfThree;
import lime.app.Application;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;

typedef CCFilter = OneOfThree<BitmapFilter, ShaderFilter, FlxShader>;

class CCUtil
{
	private static var camFilterMap:Map<FlxCamera, Array<CCFilter>> = new Map<FlxCamera, Array<CCFilter>>();

	public static var INTEGER_MIN:Int = -2147483648;
	public static var INTEGER_MAX:Int = 2147483647;

	public static function setCameraFilters(cam:FlxCamera, filters:Array<CCFilter>)
	{
		camFilterMap.set(cam, filters);

		var newFilters:Array<BitmapFilter> = [];
		for (i in filters)
			if (Std.isOfType(i, FlxShader))
				newFilters.push(shaderToBmpFilter(cast(i, FlxShader)));
			else
				newFilters.push(i);

		cam.setFilters(newFilters);
	}

	public static function getCameraFilters(cam:FlxCamera)
	{
		if (camFilterMap.exists(cam))
			return camFilterMap.get(cam);

		return new Array<CCFilter>();
	}

	public static function shaderToBmpFilter(shader:FlxShader)
	{
		return new ShaderFilter(shader);
	}

	public static function smallestIntInArray(baseArray:Array<Int>)
	{
		var smallestNumb:Int = INTEGER_MAX;
		for (i in baseArray)
			if (i < smallestNumb)
				smallestNumb = i;
		return smallestNumb;
	}

	public static function getRenderedResolution():Array<Int>
	{
		// get the current window size
		var screwYouHaxeflixel:Array<Int> = [Application.current.window.width, Application.current.window.height];
		// get what's causing the window size; we need a unit of measurement
		var baseItAroundThis:Int = smallestIntInArray(screwYouHaxeflixel);
		// find if it's the width or height. this is important.
		var isWidthBased:Bool = baseItAroundThis == screwYouHaxeflixel[0];
		// we need to divide the resolutioin into units, and then multiply into the other variable
		var divAndMult:Array<Float> = isWidthBased ? [16, 9] : [9, 16];

		// get the base unit and make the other variable out of it
		var baseUnit:Float = baseItAroundThis / divAndMult[0];
		var newThing:Int = Std.int(baseUnit * divAndMult[1]);

		// return the resolution of the rendered canvas
		return isWidthBased ? [baseItAroundThis, newThing] : [newThing, baseItAroundThis];
	}

	public static function intsToFloats(oldList:Array<Int>):Array<Float>
	{
		var retArray:Array<Float> = [];

		for (i in oldList)
			retArray.push(i);

		return retArray;
	}

	#if mobile
	public static function touchingSprite(thespr:FlxSprite, ?offset:FlxPoint, ?withCamera:Bool = true):Bool
	{
		return touchOverlaps(thespr.x, thespr.y, Std.int(thespr.width), Std.int(thespr.height), offset, withCamera);
	}

	public static function touchOverlaps(x:Float = 1, y:Float = 1, ?width:Int = 1, ?height:Int = 1, ?offset:FlxPoint, ?withCamera:Bool = true):Bool
	{
		if (offset == null)
			offset = new FlxPoint(0, 0);
		if (FlxG.touches.getFirst() != null)
		{
			var theVoicesTouchWav:Array<FlxTouch> = FlxG.touches.list;
			for (i in 0...theVoicesTouchWav.length)
				if (theVoicesTouchWav[i].justPressed)
					for (xx in 0...width)
						for (yy in 0...height)
							if (Std.int(theVoicesTouchWav[i].justPressedPosition.x + offset.x + (withCamera ? FlxG.camera.x : 0)) == Std.int(xx + x)
								&& Std.int(theVoicesTouchWav[i].justPressedPosition.y + offset.y + (withCamera ? FlxG.camera.y : 0)) == Std.int(yy + y))
								return true;
		}
		return false;
	}

	public static function justTouchedScreen():Bool
	{
		if (FlxG.touches.getFirst() != null)
		{
			var theVoicesTouchWav:Array<FlxTouch> = FlxG.touches.list;
			for (i in 0...theVoicesTouchWav.length)
				if (theVoicesTouchWav[i].justPressed)
					return true;
		}
		return false;
	}

	public static function touchingScreen():Bool
	{
		if (FlxG.touches.getFirst() != null)
		{
			var theVoicesTouchWav:Array<FlxTouch> = FlxG.touches.list;
			for (i in 0...theVoicesTouchWav.length)
				if (theVoicesTouchWav[i].pressed)
					return true;
		}
		return false;
	}

	public static function getTouchPoint():FlxPoint
	{
		if (FlxG.touches.getFirst() != null)
		{
			var theVoicesTouchWav:Array<FlxTouch> = FlxG.touches.list;
			for (i in 0...theVoicesTouchWav.length)
				if (theVoicesTouchWav[i].justPressed)
					return theVoicesTouchWav[i].justPressedPosition;
		}
		return new FlxPoint(0, 0);
	}
	#end
}
