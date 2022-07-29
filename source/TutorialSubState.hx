package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

// rehashed from optionssubstate
class TutorialSubState extends BlurryFlxSubState
{
	public var bruhCam:FlxCamera;

	var newPopup:TutorialPopupBG;

	var helperText:FlxText;
	var bindText:FlxText;

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
		newPopup = new TutorialPopupBG(FlxG.width / 2 - 235, FlxG.height / 2 - 250);
		// newPopup.screenCenter();

		var textScale = 1.25;
		helperText = new FlxText(newPopup.x + 15, newPopup.y + 185, 400,
			'Hey!\n\nYou\'re trying to dance, but this grayscale impostor is ruining the fun!\nStop \'em with your mouse!\n\nHit any key to start.\n',
			Std.int(16 * textScale), true);
		helperText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);

		bindText = new FlxText(newPopup.x - 85, 665, 0,
			'Controls: ${FlxG.onMobile ? 'Tap' : 'Click'} grayscale enemies for points & ${FlxG.onMobile ? 'hold to exit to main menu.' : 'hit ENTER to pause'}.',
			Std.int(16 * textScale), true);
		bindText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.fromRGB(185, 185, 185, 255), FlxTextAlign.CENTER,
			FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);

		var oldY = newPopup.y;
		newPopup.y = 0;
		var oldY2 = helperText.y;
		helperText.y = 45;
		helperText.alpha = 0;
		var oldY3 = bindText.y;
		bindText.y = 800;
		bindText.alpha = 0;

		newPopup.cameras = helperText.cameras = popupBG.cameras = bindText.cameras = [bruhCam];
		FlxTween.tween(newPopup, {y: oldY}, 1.5, {ease: FlxEase.bounceOut});
		FlxTween.tween(helperText, {alpha: 1, y: oldY2}, 1, {ease: FlxEase.bounceOut, startDelay: 1});
		FlxTween.tween(bindText, {alpha: 0.85, y: oldY3}, 1.75, {ease: FlxEase.cubeInOut, startDelay: 2.5});
		add(newPopup);
		add(helperText);
		add(bindText);
	}

	public var stopSpammingNerd:Bool = false;

	override public function update(e:Float)
	{
		super.update(e);
		if (!stopSpammingNerd
			&& !FlxG.keys.justPressed.MINUS
			&& !FlxG.keys.justPressed.PLUS
			&& #if debug !FlxG.keys.justPressed.BACKSLASH
			&& #end (FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed))
		{
			// "please stop spamming it's gonna break the game!!" 🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓
			stopSpammingNerd = true;
			onEndBlurOut = function()
			{
				endBlurEffects();
				FlxG.cameras.remove(bruhCam);
				PlayState.instance.canGenerate(true, true);
			};
			tweenOutBlur();
			FlxTween.tween(bruhCam, {alpha: 0}, 0.65, {ease: FlxEase.cubeOut});
		}
	}
}
