package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;

class BlurryFlxSubState extends FlxSubState
{
	public var blurThingEnabled:Bool;
	public var oldCamFilters:Array<BitmapFilter>;

	public var blurFilter:BlurFilter;

	public var blurTween:FlxTween;

	override public function create()
	{
		super.create();

		blurThingEnabled = ClientSettings.getBoolByString('pausemenublur', true);
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
			CCUtil.setCameraFilters(FlxG.camera, oldCamFilters);
	}
}
