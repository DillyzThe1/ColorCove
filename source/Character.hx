package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.display.ShaderParameter;
import shaders.PhilShader;
#if !DISABLE_NICHOLAS_SHADER
import shaders.NicholasShader.NicholasHintEffect;
import shaders.NicholasShader;
#end

class Character extends CCSprite
{
	public var finishFunc:(instance:Character, phil:Bool) -> Void;

	#if SHADERS_ENABLED
	public var philShader:PhilShader;
	#if !DISABLE_NICHOLAS_SHADER
	public var nicholasShader:NicholasHintEffect;
	#end
	#end
	override public function new(?x:Float = 0, ?y:Float = 0)
	{
		super(0, y, 'Characters');
		addAnimIndices('idle0', 'Nicholas Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(0, 0));
		addAnimIndices('idle1', 'Nicholas Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(0, 0));
		addAnim('death', 'Nicholas zDead', false, new FlxPoint(7, 60));
		addAnimIndices('idle0-alt', 'Phil Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(0, 0));
		addAnimIndices('idle1-alt', 'Phil Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(0, 0));
		addAnim('death-alt', 'Phil Vanishes', false, new FlxPoint(359, 61));

		animation.finishCallback = function(anim:String)
		{
			if (anim == 'death-alt')
				alpha = 0;
		};
		#if SHADERS_ENABLED
		doPhilShader = ClientSettings.getBoolByString('philwarningshader', true);
		#end
	}

	override public function destroy()
	{
		#if SHADERS_ENABLED
		philShader = null;
		#end
		super.destroy();
	}

	private var danceCount:Int = 0;

	public function funnyDance(?change:Bool = true)
	{
		if (philDied)
			return;
		playAnim('idle${danceCount}${phil ? '-alt' : ''}', true);
		if (change)
			danceCount = danceCount == 0 ? 1 : 0;
	}

	public var phil:Bool = false;
	public var philDied:Bool = false;
	#if SHADERS_ENABLED
	public var doPhilShader:Bool = false;
	#end

	public var speed:Float = 0;

	public function snapFloat(num:Float, min:Float, max:Float)
	{
		if (num < min)
			return min;
		if (num > max)
			return max;
		return num;
	}

	// public var walkTween:FlxTween;
	var theStartX:Float = 0;
	var theEndX:Float = 0;

	public function resetGuy(startX:Float, endX:Float, y:Float, diff:Float)
	{
		setPosition(startX, y);

		alpha = 1;

		phil = FlxG.random.bool(snapFloat(diff * 25, 5, 30));
		philDied = false;

		var rand = FlxG.random.int(5, 15);
		speed = 20 - rand;

		// playAnim(phil ? 'idle-alt' : 'idle', true);

		theStartX = startX;
		theEndX = endX;

		funnyDance(false);

		#if SHADERS_ENABLED
		if (phil) // phil)
		{
			if (doPhilShader)
			{
				if (philShader == null)
					philShader = new PhilShader();
				this.shader = philShader;
			}
			else
				this.shader = null;
			// setShaderFloat(philShader.elapsedTime, 0);
			// setShaderFloat(philShader.philShaderRNG, FlxG.random.float());
		}
		else
			#if !DISABLE_NICHOLAS_SHADER
			{
				if (ClientSettings.getBoolByString('nicholashintshader', true))
				{
					if (nicholasShader == null)
						nicholasShader = new NicholasHintEffect(this);
					this.shader = nicholasShader.shader;
				}
				else
					this.shader = null;
				// setShaderFloat(philShader.elapsedTime, 0);
				// setShaderFloat(philShader.philShaderRNG, FlxG.random.float());
			}
			#else
			this.shader = null;
			#end
		#end

		/*walkTween = FlxTween.tween(this, {x: endX}, snapFloat(((rand / 10) * 12.5) - diff / 50, 2.5, 10) - (phil ? 0.5 : 0.05), {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween)
			{
				kill();

				if (finishFunc != null)
					finishFunc(this, phil);
			}
		});*/
	}

	#if SHADERS_ENABLED
	public function setShaderFloat(sp:ShaderParameter<Float>, value:Float)
	{
		if (sp.value == null)
			sp.value = [value];
		else
			sp.value[0] = value;
	}

	public function getShaderFloat(sp:ShaderParameter<Float>):Float
	{
		if (sp.value == null)
			return 0;
		else
			return sp.value[0];
	}
	#end

	override public function update(e:Float)
	{
		super.update(e);
		if (this.alive && x <= theEndX)
		{
			kill();
			if (finishFunc != null)
				finishFunc(this, phil);
		}
		else
			x -= speed * e * 45;
	}

	#if SHADERS_ENABLED
	public function shaderUpdate(e:Float, cam:FlxCamera, camFollow:FlxObject)
	{
		if (philShader != null && phil)
		{
			var intendedVal:Float = 100 - (Math.abs((x / (theEndX - theStartX)) * 100) - 20);
			setShaderFloat(philShader.philProgress, intendedVal);
			setShaderFloat(philShader.elapsedTime, getShaderFloat(philShader.elapsedTime) + e);

			#if (debug && desktop)
			if (FlxG.keys.justPressed.P && phil)
				trace('PHIL PROGRESS: ${getShaderFloat(philShader.philProgress)}, INTENDED PROGRESS: $intendedVal');
			#end
		}

		#if !DISABLE_NICHOLAS_SHADER
		if (nicholasShader != null && !phil)
			nicholasShader.updateStuff(cam, camFollow);
		#end
	}
	#end
}
