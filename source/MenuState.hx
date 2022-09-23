package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxPoint;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Http;

using CCUtil;

class MenuState extends FlxState
{
	public static var instance:MenuState;

	public var menuTitle:MenuButton;
	public var menuPlay:MenuButton;
	public var menuOptions:MenuButton;

	public var musicBox:SongHandler;

	public var camGame:FlxCamera;

	public static var checkedVersion:Bool = false;

	public var camFollow:FlxObject;
	public var followPoint:FlxPoint;

	private var versText:FlxText;

	private var camHUD:FlxCamera;

	override public function create()
	{
		instance = this;
		super.create();

		ClientSettings.retrieveData();
		camGame = new FlxCamera();
		camGame.zoom = 1;
		FlxG.cameras.reset(camGame);
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 1;
		FlxG.cameras.add(camHUD, false);
		camGame.bgColor = FlxColor.fromString("#99CCFF");

		#if BLUR_ENABLED
		BlurryFlxSubState.blurThingEnabled = ClientSettings.getBoolByString('pausemenublur', true);
		#end
		FlxG.autoPause = ClientSettings.getBoolByString('autopause', true);

		followPoint = new FlxPoint(FlxG.width / 2, FlxG.height / 2);
		camFollow = new FlxObject();
		camGame.follow(camFollow, LOCKON, 0.03 / (FlxG.updateFramerate / 120));

		var menuSky = new FlxSprite(0, 0).loadGraphic(Paths.image('Sky'));
		var menuHill = new FlxSprite(0, 500).loadGraphic(Paths.image('Hill'));
		var signPost = new FlxSprite(0, 137.1).loadGraphic(Paths.image('Sign Post'));

		menuOptions = new MenuButton(0, 493.4, 'options');
		menuPlay = new MenuButton(0, 275.8, 'play');
		menuTitle = new MenuButton(0, 59.5, 'title');
		menuTitle.addAnim('fred 3am', 'sign fred tween', false, new FlxPoint(0, 0));

		musicBox = new SongHandler();
		musicBox.playSong('cove-of-the-colors', 76);
		musicBox.stepFunction = songStep;
		musicBox.beatFunction = songBeat;

		add(menuSky);
		add(menuHill);
		add(signPost);
		add(menuOptions);
		add(menuPlay);
		add(menuTitle);

		signPost.scale.x = 0.65;

		menuSky.screenCenter();
		menuHill.screenCenter(X);
		signPost.screenCenter(X);
		menuOptions.screenCenter(X);
		menuPlay.screenCenter(X);
		menuTitle.screenCenter(X);

		var menuOff = 125;
		menuOptions.x += -menuOff + 165;
		menuPlay.x += -menuOff + 85;
		menuTitle.x += -menuOff;
		signPost.x += 43;

		menuTitle.setOgX();
		menuPlay.setOgX();
		menuOptions.setOgX();

		menuSky.antialiasing = menuHill.antialiasing = signPost.antialiasing = ClientSettings.getBoolByString('antialiasing', true);

		if (fredTrolling >= 10)
		{
			musicBox.playSound('OW MY EARS', 1.25);
			menuTitle.playAnim('fred 3am', true);
		}

		var versstring:String = 'v${OutdatedSubState.curBuildVers} (${OutdatedSubState.curBuildName})';
		if (!checkedVersion)
		{
			checkedVersion = true;

			var dataRequest = new Http(OutdatedSubState.versionLink);
			var dataReturned:Array<String>;

			dataRequest.onData = function(data:String)
			{
				OutdatedSubState.updateBuild();

				trace('Data returned to socket! Data: $data');
				// build num ; build vers ; build name
				dataReturned = data.split(';');
				OutdatedSubState.publicBuildNum = Std.parseInt(dataReturned[0]);
				OutdatedSubState.publicBuildVers = dataReturned[1];
				OutdatedSubState.publicBuildName = dataReturned[2];

				if (OutdatedSubState.curBuildNum != OutdatedSubState.publicBuildNum)
				{
					musicBox.playSound('pause');
					versstring = 'OUTDATED - $versstring';
					#if !mobile
					var ss:OutdatedSubState = new OutdatedSubState();
					ss.exitFunc = function()
					{
						closeSubState();
					};
					openSubState(ss);
					#end
				}
				else
					musicBox.playSound('allow');
				camGame.flash();
			};
			dataRequest.onError = function(data:String)
			{
				trace('No data returned to socket.');
				musicBox.playSound('deny');
			};

			dataRequest.request();
		}

		versText = new FlxText(10, FlxG.height - 10 - 16, 0, versstring, 16, true);
		versText.setFormat(Paths.font('FredokaOne-Regular'), 16, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
		versText.antialiasing = ClientSettings.getBoolByString('antialiasing', true);
		versText.cameras = [camHUD];
		add(versText);
	}

	public var shutup:Bool = false;

	public static var fredTrolling:Int = 0;

	var totalElapsed:Float = 0;

	#if mobile
	var hoveringMenuTitle:Bool = false;
	#end

	override public function update(elapsed:Float)
	{
		totalElapsed += elapsed;
		super.update(elapsed);
		musicBox.update();
		menuPlay.angle = -menuTitle.angle / 2;
		menuOptions.angle = menuTitle.angle / 2;

		camFollow.setPosition(followPoint.x + Math.cos(totalElapsed * 0.325) * 2.5, followPoint.y + Math.sin(totalElapsed * 0.65) * 7.5);

		if (!shutup)
		{
			#if !mobile
			menuPlay.updateSize(FlxG.mouse.overlaps(menuPlay));
			menuOptions.updateSize(FlxG.mouse.overlaps(menuOptions));
			#else
			var bruhSprs:Array<FlxSprite> = [menuTitle, menuPlay, menuOptions];
			for (i in 0...bruhSprs.length)
			{
				hoveringMenuTitle = menuTitle.touchingSprite();
				menuPlay.updateSize(menuPlay.touchingSprite());
				menuOptions.updateSize(menuOptions.touchingSprite());
			}
			#end

			#if !mobile
			if (FlxG.mouse.justPressed)
			#else
			if (FlxG.touches.getFirst() != null)
			{
				var theVoicesTouchWav:Array<FlxTouch> = FlxG.touches.list;
				for (i in 0...theVoicesTouchWav.length)
					if (theVoicesTouchWav[i].justPressed)
			#end
			{
				// musicBox.playSound('kill', 1);
				if (menuPlay.oldHovering #if mobile || menuPlay.touchingSprite() #end)
					doPress(menuPlay);
				else if (menuOptions.oldHovering #if mobile || menuOptions.touchingSprite() #end)
					doPress(menuOptions);
				else if (#if !mobile FlxG.mouse.overlaps(menuTitle) #else hoveringMenuTitle || menuTitle.touchingSprite() #end)
				{
					if (fredTrolling == 10)
					{
						musicBox.playSound('OW MY EARS', 1.25);
						menuTitle.playAnim('fred 3am', true);
						#if !mobile
						FlxG.mouse.load(Paths.image('fred'), 0.1, -25, -25);
						#end
						fredTrolling = 20;
					}
					else if (fredTrolling < 10)
					{
						fredTrolling++;
						musicBox.playSound('le tap', 1);
					}
				}
			}
		#if mobile
		}
		#end
	}

	#if (debug && desktop)
	if (FlxG.keys.justPressed.NINE)
		doPress(null);
	#end
}

public function restoreButtons()
{
	if (!shutup)
		return;
	shutup = false;

	camGame.destroy();
	var oldZoom:Float = camGame.zoom;
	camGame = new FlxCamera();
	camGame.zoom = oldZoom;
	FlxG.cameras.reset(camGame);
	camGame.bgColor = FlxColor.fromString("#99CCFF");
	camGame.follow(camFollow, LOCKON, 0.03 / (FlxG.updateFramerate / 120));

	followPoint.y = FlxG.height / 2;
	FlxTween.tween(camGame, {zoom: 1}, 0.75, {ease: FlxEase.cubeInOut});
	FlxTween.tween(menuTitle, {x: menuTitle.ogX}, 1.25, {ease: FlxEase.cubeOut});
	FlxTween.tween(menuPlay, {x: menuPlay.ogX}, 1.25, {ease: FlxEase.cubeOut});
	FlxTween.tween(menuOptions, {x: menuOptions.ogX}, 1.25, {ease: FlxEase.cubeOut});
	// camGame.flash(FlxColor.WHITE, 0.75, null, true);
}

public function doPress(button:MenuButton)
{
	camGame.flash(FlxColor.WHITE, 1, null, true);
	shutup = true;
	FlxTween.tween(camGame, {zoom: 1.5}, 1.25, {ease: FlxEase.quadInOut});

	FlxTween.tween(menuTitle, {x: FlxG.width + 500}, 0.75, {ease: FlxEase.quadIn});
	if (button != menuPlay)
		FlxTween.tween(menuPlay, {x: -500}, 0.75, {ease: FlxEase.quadIn});
	if (button != menuOptions)
		FlxTween.tween(menuOptions, {x: FlxG.width + 500}, 0.75, {ease: FlxEase.quadIn});

	var sound = musicBox.playSound('allow_alt', 0.75);
	sound.persist = false;

	var the:FlxTimer = new FlxTimer();
	the.start(1.75, function(time:FlxTimer)
	{
		if (button == menuPlay)
			FlxG.switchState(new PlayState());
		else if (button == menuOptions)
		{
			followPoint.y = (FlxG.height / 2) + 375;
			openSubState(new OptionsSubState());
		}
		#if (debug && desktop)
		else
			FlxG.switchState(new OffsetState());
		#end
	}, 1);

	/*sound.onComplete = function()
			{
				if (button == menuPlay)
					FlxG.switchState(new PlayState());
				else if (button == menuOptions)
					FlxG.switchState(new OffsetState());
		};*/
}

public function songStep() {}

public function songBeat()
{
	menuTitle.angle = musicBox.curBeat % 2 == 1 ? 5 : -5;
	FlxTween.tween(menuTitle, {angle: 0}, musicBox.getStepCrochet() / 500, {ease: FlxEase.cubeOut});
}
}
