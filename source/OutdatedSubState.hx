package;

import Paths.HiddenPaths;
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
import flixel.util.FlxTimer;
import lime.utils.Assets;

class OutdatedSubState extends BlurryFlxSubState
{
	var warningText:FlxText;

	public static var versionLink:String = 'https://raw.githubusercontent.com/DillyzThe1/ColorCove/master/colorCove.versionDownload';

	public static var curBuildNum:Int = 0;
	public static var curBuildVers:String = '0.6.2b';
	public static var curBuildName:String = 'Visually Appealing Bugfix: Android Fork';

	public static var publicBuildNum:Int = curBuildNum;
	public static var publicBuildVers:String = curBuildVers;
	public static var publicBuildName:String = curBuildName;

	var mouseTimer:Float = 0;

	public var exitFunc:() -> Void;

	var bruhCam:FlxCamera;

	public static function updateBuild()
	{
		curBuildNum = Std.parseInt(Assets.getText(HiddenPaths.txt('buildNum')));
		trace(curBuildNum);
	}

	override public function create()
	{
		super.create();

		bruhCam = new FlxCamera();
		bruhCam.bgColor.alpha = 0;
		FlxG.cameras.add(bruhCam, false);

		var popupBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		popupBG.alpha = 0;
		FlxTween.tween(popupBG, {alpha: 0.5}, 0.75, {ease: FlxEase.quadIn});

		var textScale = 2;
		warningText = new FlxText(20, 20 + (20 * textScale) * 2, 0, 'w', Std.int(16 * textScale), true);
		warningText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		warningText.antialiasing = ClientSettings.getBoolByString('antialiasing', true);

		if (curBuildNum == 0)
			warningText.text = 'Warning!\n\n'
				+ 'Your build of the game is currently null or invalid.\nDid you recompile without build.bat?\n\n'
				+ 'If this is a mistake, please submit an issue immediantly.\n\n';
		else
		{
			warningText.text = 'Warning!\n\n'
				+ 'You\'re running the $curBuildName on $curBuildVers (build $curBuildNum)!\n'
				+ 'The current public build is the $publicBuildName on $publicBuildVers (build $publicBuildNum)!\n' #if desktop
			+
			(curBuildNum < publicBuildNum ? 'Please consider updating your game!\n\n' : 'Please be aware that these changes aren\'t final!\n(Also, please report any bugs on the github page.)\n\n')
			#else
			+ 'Please download a desktop release!\n\n'
			#end
			+ 'https://www.github.com/DillyzThe1/ColorCove/releases/latest/\n\n';
		}
		warningText.text += '(${FlxG.onMobile ? 'Tap to ignore.' /*'Hold to ignore, Tap to download.'*/ : 'ESCAPE to ignore, ENTER to ${#if desktop 'update' #else 'download' #end}, C to view Changelog, and I to report bugs.'})\n';
		warningText.screenCenter();

		popupBG.cameras = warningText.cameras = [bruhCam];

		add(popupBG);
		add(warningText);

		exitFunc = function()
		{
			// "please stop spamming it's gonna break the game!!" 🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓
			stopSpammingNerd = true;
			onEndBlurOut = function()
			{
				endBlurEffects();
				FlxG.cameras.remove(bruhCam);
				// FlxG.switchState(new MenuState());
				MenuState.instance.closeSubState();
			};
			FlxTween.tween(bruhCam, {alpha: 0}, 0.65, {ease: FlxEase.cubeOut});
			tweenOutBlur();
		};

		#if mobile
		new FlxTimer().start(2.5, function(t:FlxTimer)
		{
			exitFunc();
		}, 1);
		#end
	}

	var stopSpammingNerd:Bool = false;

	override public function update(e:Float)
	{
		super.update(e);

		if (stopSpammingNerd)
			return;

		#if !mobile
		if (FlxG.keys.justPressed.ESCAPE)
			exitFunc();
		else if (FlxG.keys.justPressed.ENTER)
			FlxG.openURL('https://www.github.com/DillyzThe1/ColorCove/releases/latest/');
		else if (FlxG.keys.justPressed.C)
			FlxG.openURL('https://www.github.com/DillyzThe1/ColorCove/blob/main/Changelog.md');
		else if (FlxG.keys.justPressed.I)
			FlxG.openURL('https://github.com/DillyzThe1/ColorCove/issues/new/choose/');
		#end

		// this condition is for html5, otherwise, it'd have a compilation flag all around it
		if (FlxG.onMobile)
			if (#if mobile CCUtil.justTouchedScreen() #else FlxG.mouse.justPressed #end)
			{
				exitFunc();
			}
		/*if (FlxG.mouse.pressed)
			{
				mouseTimer += e;
				if (mouseTimer >= 2.5)
				{
					mouseTimer = 0;
					FlxG.openURL('https://www.github.com/DillyzThe1/ColorCove/releases/latest/');
				}
			}
			else
			{
				if (mouseTimer > 0.1)
					exitFunc();
				mouseTimer = 0;
		}*/
	}
}
