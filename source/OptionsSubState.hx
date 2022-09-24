package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.input.android.FlxAndroidKey;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class OptionsSubState extends BlurryFlxSubState
{
	public var bruhCam:FlxCamera;

	var newPopup:OptionsPopup;

	var stopSpammingNerd:Bool = false;

	override public function create()
	{
		bruhCam = new FlxCamera();
		bruhCam.bgColor.alpha = 0;
		super.create();
		FlxG.cameras.add(bruhCam, false);
		var popupBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		popupBG.alpha = 0;
		add(popupBG);
		FlxTween.tween(popupBG, {alpha: 0.5}, 0.75, {ease: FlxEase.quadIn});
		newPopup = new OptionsPopup(0, 0);
		newPopup.screenCenter();
		var oldY = newPopup.y;
		newPopup.y = 0;
		newPopup.cameras = popupBG.cameras = [bruhCam];
		FlxTween.tween(newPopup, {y: oldY}, 1.5, {ease: FlxEase.bounceOut});
		add(newPopup);
		newPopup.exitFunc = function()
		{
			// "please stop spamming it's gonna break the game!!" 🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓
			stopSpammingNerd = true;
			onEndBlurOut = function()
			{
				endBlurEffects();
				ClientSettings.setData();
				#if BLUR_ENABLED
				BlurryFlxSubState.blurThingEnabled = ClientSettings.getBoolByString('pausemenublur', true);
				#end
				FlxG.cameras.remove(bruhCam);
				// FlxG.switchState(new MenuState());
				newPopup.destroy();
				MenuState.instance.restoreButtons();
				MenuState.instance.closeSubState();
				trace('boowomp 2');

				#if android
				FlxG.android.preventDefaultKeys = [];
				#end
			};
			FlxTween.tween(bruhCam, {alpha: 0}, 0.65, {ease: FlxEase.cubeOut});
			tweenOutBlur();
			trace('boowomp');
		};

		#if android
		FlxG.android.preventDefaultKeys = [FlxAndroidKey.BACK];
		#end
	}

	override public function update(e:Float)
	{
		super.update(e);
		if (#if mobile FlxG.android.anyJustPressed([FlxAndroidKey.BACK]) #else FlxG.keys.justPressed.ESCAPE #end && !stopSpammingNerd)
			newPopup.exitFunc();
	}
}
