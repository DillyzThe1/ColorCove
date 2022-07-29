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
	public static var blurThingEnabled:Bool;

	public var oldCamFilters:Array<BitmapFilter>;

	public var blurFilter:BlurFilter;

	public static var blurTween:FlxTween;

	override public function create()
	{
		super.create();

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
	}

	public var onEndBlurOut:() -> Void;

	public function tweenOutBlur()
	{
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
	}

	public function endBlurEffects()
	{
		if (blurTween != null)
			blurTween.cancel();

		if (blurThingEnabled)
			CCUtil.setCameraFilters(FlxG.camera, oldCamFilters != null ? oldCamFilters : []);
	}
}
