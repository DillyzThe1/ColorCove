package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;

class BlurryFlxSubState extends FlxSubState
{
	#if BLUR_ENABLED
	public static var blurThingEnabled:Bool;

	public var oldCamFilters:Array<BitmapFilter>;

	public var blurFilter:BlurFilter;

	public static var blurTween:FlxTween;
	#end

	public var onEndBlurOut:() -> Void;

	override public function create()
	{
		super.create();

		#if BLUR_ENABLED
		if (FlxG.onMobile)
			blurThingEnabled = false;
		if (blurThingEnabled)
		{
			oldCamFilters = CCUtil.getCameraFilters(FlxG.camera);
			var newCamFilters:Array<BitmapFilter> = oldCamFilters.copy();
			blurFilter = new BlurFilter();
			newCamFilters.push(blurFilter);
			CCUtil.setCameraFilters(FlxG.camera, newCamFilters);

			blurFilter.blurX = blurFilter.blurY = 0;
			blurTween = FlxTween.tween(blurFilter, {blurX: 2, blurY: 2}, 1.5, {ease: FlxEase.cubeInOut});
		}
		#end
	}

	public function tweenOutBlur()
	{
		#if BLUR_ENABLED
		if (!blurThingEnabled || blurFilter == null)
		{
			var the:FlxTimer = new FlxTimer();
			the.start(0.75, function(time:FlxTimer)
			{
				if (onEndBlurOut != null)
					onEndBlurOut();
			}, 1);
			return;
		}

		if (blurTween != null)
		{
			blurTween.cancel();
		}
		blurTween = FlxTween.tween(blurFilter, {blurX: 0, blurY: 0}, 0.75, {
			ease: FlxEase.cubeInOut,
			onComplete: function(t:FlxTween)
			{
				if (onEndBlurOut != null)
					onEndBlurOut();
			}
		});
		#else
		new FlxTimer().start(0.75, function(time:FlxTimer)
		{
			if (onEndBlurOut != null)
				onEndBlurOut();
		}, 1);
		#end
	}

	public function endBlurEffects()
	{
		#if BLUR_ENABLED
		if (blurTween != null)
			blurTween.cancel();

		if (blurThingEnabled)
			CCUtil.setCameraFilters(FlxG.camera, oldCamFilters != null ? oldCamFilters : []);
		#end
	}
}
